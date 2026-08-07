#!/usr/bin/env python3
"""Convert EPUB books into the English-learning app's local book format."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import posixpath
import re
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
import zipfile
from dataclasses import dataclass
from datetime import date
from html.parser import HTMLParser
from html import escape as html_escape
from pathlib import Path
from typing import Protocol
from urllib.parse import unquote, urlparse
from xml.etree import ElementTree


BLOCK_TAGS = {"p", "div", "li", "blockquote", "pre"}
HEADING_TAGS = {"h1", "h2", "h3", "h4", "h5", "h6"}
SKIP_TAGS = {"script", "style", "svg", "nav", "noscript"}
ABBREVIATIONS = {
    "mr.", "mrs.", "ms.", "dr.", "prof.", "sr.", "jr.", "st.",
    "vs.", "etc.", "e.g.", "i.e.", "a.m.", "p.m.",
}
WORD_RE = re.compile(r"[A-Za-z]+(?:['-][A-Za-z]+)*")
SENTENCE_END_RE = re.compile(r"[.!?]+(?:[\"'”’»)]*)?(?=\s+|$)")
CHINESE_CHAR_RE = re.compile(r"[\u3400-\u4dbf\u4e00-\u9fff]")
FORBIDDEN_TRANSLATION_SCRIPT_RE = re.compile(
    r"[\u0370-\u03ff\u0400-\u04ff\u0590-\u05ff\u0600-\u06ff\u0900-\u097f\u0e00-\u0e7f]"
)
NON_CONTENT_TITLE_RE = re.compile(
    r"^(?:"
    r"preface|foreword|introduction|contents|table of contents|toc|"
    r"title page|copyright(?: page)?|dedication|epigraph|acknowledg(?:e?ments?)|"
    r"(?:translator|editor|author)(?:['’]s)?(?: note| introduction)|"
    r"appendix|appendices|notes?|about the author|bibliography|glossary|index|colophon|"
    r"序言|前言|导言|目录|版权(?:页)?|献词|致谢|译者(?:序|说明)|编者(?:按|说明)|"
    r"附录|注释|作者简介|词汇表|索引|出版信息"
    r")$",
    re.IGNORECASE,
)
NON_CONTENT_TITLE_PREFIX_RE = re.compile(
    r"^(?:conclusion|prologue|postscript|map\b|a note on\b|also translated by\b|"
    r"chronology\b|list of (?:maps|illustrations|figures)\b|"
    r"translator(?:['’]s)? postscript\b)",
    re.IGNORECASE,
)
NON_CONTENT_TITLE_SEARCH_RE = re.compile(r"\b(?:biography|postscript)\b", re.IGNORECASE)
NON_CONTENT_FILENAME_RE = re.compile(
    r"(?:preface|foreword|introduction|contents|toc|title.?page|copyright|"
    r"dedication|epigraph|acknowledg|translator.?s?.?note|editor.?s?.?note|"
    r"appendix|notes?|about.?the.?author|bibliography|glossary|colophon)",
    re.IGNORECASE,
)
NUMERIC_CHAPTER_TITLE_RE = re.compile(
    r"^(?:chapter\s*)?(\d+|[ivxlcdm]+)[.:：-]?$", re.IGNORECASE
)
EMBEDDED_CHAPTER_TITLE_RE = re.compile(
    r"^(?:(?:chapter|part)\s+(?:\d+|[ivxlcdm]+|[a-z]+)(?:\s*[:.：\-–—]\s*|\s+)|"
    r"\d+\s*[:.：\-–—]\s+)[A-Za-z].{1,180}$",
    re.IGNORECASE,
)
EMBEDDED_CHAPTER_MARKER_RE = re.compile(
    r"^(?:chapter|part)\s+(?:\d+|[ivxlcdm]+|[a-z]+)[.:：-]?$",
    re.IGNORECASE,
)
BOOK_REQUIRED_FIELDS = {
    "id",
    "title",
    "chineseTitle",
    "author",
    "coverUrl",
    "description",
    "category",
    "difficulty",
    "totalUnits",
    "wordCount",
    "readerCount",
    "targetVocab",
    "tagLabel",
    "coverBadge",
    "sourceFormat",
    "contentVersion",
}
MAX_BOOK_CHAPTERS = 50
MAX_CHAPTER_PARAGRAPHS = 100
SINGLE_CHAPTER_MAX_PARAGRAPHS = 300


@dataclass
class EpubChapter:
    title: str
    paragraphs: list[str]
    source_path: str


class TextBlockParser(HTMLParser):
    """Extract headings and readable block text from EPUB XHTML."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.blocks: list[tuple[str, str]] = []
        self._active_tag: str | None = None
        self._active_kind: str | None = None
        self._buffer: list[str] = []
        self._skip_depth = 0

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        tag = tag.lower()
        if tag in SKIP_TAGS:
            self._skip_depth += 1
            return
        if self._skip_depth:
            return
        if tag in BLOCK_TAGS or tag in HEADING_TAGS:
            if self._active_tag is not None:
                self._finish_block()
            self._active_tag = tag
            self._active_kind = "heading" if tag in HEADING_TAGS else "paragraph"
            self._buffer = []
        elif self._active_tag is not None and tag == "br":
            self._buffer.append("\n")

    def handle_startendtag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag.lower() == "br" and self._active_tag is not None:
            self._buffer.append("\n")

    def handle_endtag(self, tag: str) -> None:
        tag = tag.lower()
        if tag in SKIP_TAGS and self._skip_depth:
            self._skip_depth -= 1
            return
        if self._skip_depth or tag != self._active_tag:
            return
        self._finish_block()

    def _finish_block(self) -> None:
        text = normalize_text("".join(self._buffer))
        if text:
            self.blocks.append((self._active_kind or "paragraph", text))
        self._active_tag = None
        self._active_kind = None
        self._buffer = []

    def handle_data(self, data: str) -> None:
        if self._skip_depth == 0 and self._active_tag is not None:
            self._buffer.append(data)


def normalize_text(value: str) -> str:
    value = value.replace("\\n", "\n")
    return re.sub(r"\s+", " ", value).strip()


def local_name(tag: str) -> str:
    return tag.rsplit("}", 1)[-1]


def find_child_text(element: ElementTree.Element, name: str) -> str:
    for child in element.iter():
        if local_name(child.tag) == name and child.text:
            return normalize_text(child.text)
    return ""


def sentence_split(text: str) -> list[str]:
    """Split English prose while avoiding common abbreviation false positives."""
    sentences: list[str] = []
    start = 0
    for match in SENTENCE_END_RE.finditer(text):
        end = match.end()
        before = text[:end].rstrip()
        token_match = re.search(r"[A-Za-z.]+$", before)
        token = token_match.group(0).lower() if token_match else ""
        if token in ABBREVIATIONS or (len(token) == 2 and token[1] == "."):
            continue
        part = normalize_text(text[start:end])
        if part:
            sentences.append(part)
            start = end
    tail = normalize_text(text[start:])
    if tail:
        sentences.append(tail)
    return sentences or [normalize_text(text)]


def slugify_title(title: str) -> str:
    value = normalize_text(title)
    value = re.sub(r"[<>:\"/\\|?*]", "", value)
    value = re.sub(r"\s+", "_", value).strip("._")
    if not value:
        raise ValueError("EPUB title is empty after filename normalization")
    return value


def is_non_content_chapter(title: str, source_path: str) -> bool:
    normalized_title = normalize_text(title).strip(" .:：-_")
    if (
        NON_CONTENT_TITLE_RE.fullmatch(normalized_title)
        or NON_CONTENT_TITLE_PREFIX_RE.match(normalized_title)
        or NON_CONTENT_TITLE_SEARCH_RE.search(normalized_title)
    ):
        return True

    filename = Path(source_path).stem
    if re.fullmatch(r"index_split_\d+", filename, re.IGNORECASE) and re.fullmatch(
        r"index split \d+", normalized_title, re.IGNORECASE
    ):
        return True
    return bool(NON_CONTENT_FILENAME_RE.search(filename))


def deterministic_chinese_title(title: str) -> str:
    match = NUMERIC_CHAPTER_TITLE_RE.fullmatch(normalize_text(title))
    return f"第{match.group(1)}章" if match else ""


def embedded_chapter_title(text: str) -> str:
    """Return a chapter heading found inside a large EPUB XHTML document."""
    title = normalize_text(text).strip(" .:：-_–—")
    if EMBEDDED_CHAPTER_TITLE_RE.fullmatch(title):
        return title
    return ""


def zip_path(base: str, href: str) -> str:
    href_path = unquote(urlparse(href).path)
    return posixpath.normpath(posixpath.join(posixpath.dirname(base), href_path))


def generate_book_cover(
    output_path: Path,
    title: str,
    chinese_title: str,
    author: str,
) -> None:
    """Generate a readable local fallback cover when an EPUB has no cover asset."""
    safe_title = html_escape(title)
    safe_chinese_title = html_escape(chinese_title)
    safe_author = html_escape(author)
    svg = f"""<svg xmlns="http://www.w3.org/2000/svg" width="900" height="1350" viewBox="0 0 900 1350">
  <defs>
    <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#172554"/>
      <stop offset=".58" stop-color="#7c3f5d"/>
      <stop offset="1" stop-color="#e49a68"/>
    </linearGradient>
    <linearGradient id="rock" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#a99b89"/>
      <stop offset=".5" stop-color="#5c5b64"/>
      <stop offset="1" stop-color="#252b3c"/>
    </linearGradient>
    <linearGradient id="mist" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0" stop-color="#f6e8d5" stop-opacity="0"/>
      <stop offset=".5" stop-color="#f6e8d5" stop-opacity=".42"/>
      <stop offset="1" stop-color="#f6e8d5" stop-opacity="0"/>
    </linearGradient>
  </defs>
  <rect width="900" height="1350" fill="url(#sky)"/>
  <circle cx="710" cy="485" r="118" fill="#ffdca8" opacity=".72"/>
  <path d="M0 710 L130 565 L240 650 L350 430 L455 600 L580 380 L900 690 L900 1350 L0 1350 Z" fill="#303c57" opacity=".72"/>
  <path d="M0 825 C170 700 260 730 362 620 C470 505 575 495 676 595 C740 658 816 690 900 670 L900 1350 L0 1350 Z" fill="url(#rock)"/>
  <path d="M170 860 C236 739 309 647 397 589 C493 526 596 520 677 602 C741 667 753 776 708 889 C671 983 590 1041 484 1045 C353 1050 225 986 170 860 Z" fill="#6f6b70" opacity=".74"/>
  <path d="M273 772 C323 719 380 714 431 754 M525 751 C578 704 635 717 679 772" fill="none" stroke="#282b38" stroke-width="18" stroke-linecap="round"/>
  <path d="M291 790 C331 812 377 812 418 790 M543 789 C586 811 632 810 669 789" fill="none" stroke="#d3b99e" stroke-width="7" stroke-linecap="round" opacity=".65"/>
  <path d="M485 758 C474 844 457 899 425 942 C451 960 487 966 524 948" fill="none" stroke="#30323d" stroke-width="17" stroke-linecap="round"/>
  <path d="M327 1000 C414 1040 533 1045 632 978" fill="none" stroke="#292b37" stroke-width="18" stroke-linecap="round"/>
  <path d="M0 978 C222 900 446 1018 900 902 L900 1045 C550 1108 270 1002 0 1088 Z" fill="url(#mist)"/>
  <path d="M0 1115 C250 1060 460 1150 900 1058 L900 1350 L0 1350 Z" fill="#131b2f"/>
  <circle cx="665" cy="1120" r="6" fill="#f7d9a8"/><circle cx="685" cy="1112" r="4" fill="#f7d9a8"/>
  <text x="64" y="112" fill="#fff7ed" font-family="Georgia, serif" font-size="29" letter-spacing="5">A LITERARY CLASSIC</text>
  <text x="64" y="190" fill="#fff7ed" font-family="Georgia, serif" font-size="48" font-weight="bold">{safe_title}</text>
  <text x="64" y="246" fill="#ffe4c7" font-family="sans-serif" font-size="35">{safe_chinese_title}</text>
  <text x="64" y="1275" fill="#e8d8c5" font-family="sans-serif" font-size="28">{safe_author}</text>
</svg>"""
    svg_path = output_path.with_suffix(".svg")
    svg_path.write_text(svg, encoding="utf-8")
    try:
        subprocess.run(
            ["magick", str(svg_path), "-strip", "-quality", "90", str(output_path)],
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError as error:
        raise RuntimeError(
            "EPUB does not contain a cover image and ImageMagick is not installed; "
            "install ImageMagick or provide an EPUB with a cover image."
        ) from error
    except subprocess.CalledProcessError as error:
        detail = normalize_text(error.stderr or error.stdout or "")
        raise RuntimeError(f"Could not generate fallback book cover: {detail}") from error
    finally:
        svg_path.unlink(missing_ok=True)


class EpubReader:
    def __init__(self, epub_path: Path) -> None:
        self.epub_path = epub_path
        self.archive = zipfile.ZipFile(epub_path)
        self.opf_path, self.opf_root = self._read_opf()

    def _read_opf(self) -> tuple[str, ElementTree.Element]:
        container = ElementTree.fromstring(self.archive.read("META-INF/container.xml"))
        rootfile = next(
            (node for node in container.iter() if local_name(node.tag) == "rootfile"),
            None,
        )
        if rootfile is None or not rootfile.attrib.get("full-path"):
            raise ValueError("EPUB does not contain a valid OPF rootfile")
        path = unquote(rootfile.attrib["full-path"])
        return path, ElementTree.fromstring(self.archive.read(path))

    def metadata(self) -> dict[str, str]:
        metadata = next(
            (node for node in self.opf_root if local_name(node.tag) == "metadata"),
            self.opf_root,
        )
        title = find_child_text(metadata, "title")
        author = find_child_text(metadata, "creator") or "Unknown"
        language = find_child_text(metadata, "language") or "en"
        if not title:
            raise ValueError("EPUB metadata does not contain a title")
        return {"title": title, "author": author, "language": language}

    def chapters(self) -> list[EpubChapter]:
        manifest = next(
            (node for node in self.opf_root if local_name(node.tag) == "manifest"),
            None,
        )
        spine = next(
            (node for node in self.opf_root if local_name(node.tag) == "spine"),
            None,
        )
        if manifest is None or spine is None:
            raise ValueError("EPUB is missing manifest or spine")

        items = {
            item.attrib["id"]: item.attrib
            for item in manifest
            if item.attrib.get("id") and item.attrib.get("href")
        }
        nav_titles = self._read_ncx_titles(manifest)
        chapters: list[EpubChapter] = []
        for itemref in spine:
            item = items.get(itemref.attrib.get("idref", ""))
            if not item or "nav" in item.get("properties", "").split():
                continue
            media_type = item.get("media-type", "")
            if media_type not in {"application/xhtml+xml", "text/html"}:
                continue
            path = zip_path(self.opf_path, item["href"])
            if path not in self.archive.namelist():
                continue
            filename = Path(path).name.lower()
            if filename in {"titlepage.xhtml", "titlepage.html", "cover.xhtml", "cover.html"}:
                continue
            source_html = self.archive.read(path).decode("utf-8", errors="replace")
            parser = TextBlockParser()
            parser.feed(source_html)
            headings = [text for kind, text in parser.blocks if kind == "heading"]
            paragraphs = [text for kind, text in parser.blocks if kind == "paragraph"]
            if not paragraphs:
                continue
            if not chapters and not nav_titles.get(path) and word_count(" ".join(paragraphs)) < 20:
                continue
            embedded = self._split_internal_toc_chapters(path, source_html, parser.blocks)
            embedded = embedded or self._split_embedded_chapters(path, parser.blocks)
            if embedded:
                for chapter in embedded:
                    if is_non_content_chapter(chapter.title, path):
                        print(
                            f"Skipping non-content section: {chapter.title} ({path})",
                            flush=True,
                        )
                        continue
                    chapters.append(chapter)
                continue

            title = nav_titles.get(path) or (headings[0] if headings else Path(path).stem.replace("_", " "))
            if (
                re.fullmatch(r".+\s+split\s+\d+", title, re.IGNORECASE)
                and len(paragraphs) <= 5
            ):
                print(f"Skipping EPUB split title page: {title} ({path})", flush=True)
                continue
            if is_non_content_chapter(title, path):
                print(f"Skipping non-content section: {title} ({path})", flush=True)
                continue
            chapters.append(EpubChapter(title, paragraphs, path))
        if not chapters:
            raise ValueError("No readable chapters found in EPUB spine")
        return chapters

    def _split_internal_toc_chapters(
        self,
        source_path: str,
        source_html: str,
        blocks: list[tuple[str, str]],
    ) -> list[EpubChapter]:
        """Use same-file TOC anchors when chapter headings are plain paragraphs."""
        toc_titles: list[str] = []
        for _target, inner_html in re.findall(
            r'<a[^>]+href=["\']#([^"\']+)["\'][^>]*>(.*?)</a>',
            source_html,
            re.IGNORECASE | re.DOTALL,
        ):
            parser = TextBlockParser()
            parser.feed(f"<p>{inner_html}</p>")
            title = normalize_text(" ".join(text for _kind, text in parser.blocks))
            if title and title not in toc_titles:
                toc_titles.append(title)

        if len(toc_titles) < 2:
            return []

        boundaries: list[tuple[int, str]] = []
        search_from = 0
        for title in toc_titles:
            normalized_title = title.casefold()
            match_index = next(
                (
                    index
                    for index in range(search_from, len(blocks))
                    if blocks[index][1].casefold() == normalized_title
                ),
                None,
            )
            if match_index is None:
                continue
            boundaries.append((match_index, blocks[match_index][1]))
            search_from = match_index + 1

        if len(boundaries) < 2:
            return []

        chapters: list[EpubChapter] = []
        for boundary_index, (start, title) in enumerate(boundaries):
            end = boundaries[boundary_index + 1][0] if boundary_index + 1 < len(boundaries) else len(blocks)
            paragraphs = [
                text
                for kind, text in blocks[start + 1:end]
                if kind == "paragraph" and text
            ]
            if paragraphs:
                chapters.append(EpubChapter(title, paragraphs, source_path))
        return chapters

    def _split_embedded_chapters(
        self,
        source_path: str,
        blocks: list[tuple[str, str]],
    ) -> list[EpubChapter]:
        """Split collection XHTML files whose many chapters share one spine item."""
        boundaries = [
            (index, embedded_chapter_title(text) or text)
            for index, (_kind, text) in enumerate(blocks)
            if embedded_chapter_title(text) or EMBEDDED_CHAPTER_MARKER_RE.fullmatch(normalize_text(text))
        ]
        if not boundaries:
            return []

        first_chapter_occurrences = [
            index
            for index, (_boundary_index, title) in enumerate(boundaries)
            if re.match(r"^1\s*[.:：-]", title)
        ]
        if len(first_chapter_occurrences) > 1:
            boundaries = boundaries[first_chapter_occurrences[-1]:]

        chapters: list[EpubChapter] = []
        for boundary_index, (start, title) in enumerate(boundaries):
            end = boundaries[boundary_index + 1][0] if boundary_index + 1 < len(boundaries) else len(blocks)
            if EMBEDDED_CHAPTER_MARKER_RE.fullmatch(normalize_text(title)) and start + 1 < end:
                title = f"{title} {blocks[start + 1][1]}"
                content_start = start + 2
            else:
                content_start = start + 1
            paragraphs = [
                text
                for kind, text in blocks[content_start:end]
                if kind == "paragraph" and text
            ]
            if paragraphs:
                chapters.append(EpubChapter(title, paragraphs, source_path))
        return chapters

    def cover_asset(self) -> tuple[bytes, str] | None:
        metadata = next(
            (node for node in self.opf_root if local_name(node.tag) == "metadata"),
            self.opf_root,
        )
        cover_id = next(
            (
                node.attrib.get("content")
                for node in metadata.iter()
                if local_name(node.tag) == "meta" and node.attrib.get("name") == "cover"
            ),
            None,
        )
        manifest = next(
            (node for node in self.opf_root if local_name(node.tag) == "manifest"),
            None,
        )
        if manifest is None:
            return None
        cover_item = next(
            (
                item.attrib
                for item in manifest
                if item.attrib.get("id") == cover_id
                or "cover-image" in item.attrib.get("properties", "").split()
            ),
            None,
        )
        if cover_item is None:
            return None
        media_type = cover_item.get("media-type", "")
        if not media_type.startswith("image/"):
            return None
        cover_path = zip_path(self.opf_path, cover_item.get("href", ""))
        if cover_path not in self.archive.namelist():
            return None
        extension = {
            "image/jpeg": ".jpg",
            "image/png": ".png",
            "image/webp": ".webp",
        }.get(media_type, "." + media_type.split("/", 1)[1])
        return self.archive.read(cover_path), extension

    def _read_ncx_titles(self, manifest: ElementTree.Element) -> dict[str, str]:
        ncx_item = next(
            (
                item for item in manifest
                if item.attrib.get("media-type") == "application/x-dtbncx+xml"
            ),
            None,
        )
        if ncx_item is None:
            return {}
        ncx_path = zip_path(self.opf_path, ncx_item.attrib["href"])
        if ncx_path not in self.archive.namelist():
            return {}
        root = ElementTree.fromstring(self.archive.read(ncx_path))
        titles: dict[str, str] = {}
        for nav_point in root.iter():
            if local_name(nav_point.tag) != "navPoint":
                continue
            label = next(
                (node.text for node in nav_point.iter() if local_name(node.tag) == "text" and node.text),
                "",
            )
            content = next(
                (node.attrib.get("src") for node in nav_point.iter() if local_name(node.tag) == "content"),
                None,
            )
            if label and content:
                titles[zip_path(ncx_path, content.split("#", 1)[0])] = normalize_text(label)
        return titles

    def close(self) -> None:
        self.archive.close()


class TranslationProvider(Protocol):
    cache_namespace: str

    def translate(self, text: str, context: str = "") -> str:
        ...

    def translate_title(self, text: str) -> str:
        ...

    def translate_book_title(self, text: str) -> str:
        ...

    def generate_book_metadata(
        self,
        title: str,
        author: str,
        chapter_count: int,
        word_count: int,
    ) -> dict[str, str]:
        ...


class ArgosTranslator:
    def __init__(self) -> None:
        self.cache_namespace = "argos-en-zh"
        try:
            from argostranslate import translate
        except ImportError as error:
            raise RuntimeError(
                "Argos Translate is not installed. Install it with "
                "'python -m pip install argostranslate' and install an en->zh model."
            ) from error
        languages = translate.get_installed_languages()
        source = next((item for item in languages if item.code == "en"), None)
        target = next((item for item in languages if item.code == "zh"), None)
        if source is None or target is None:
            raise RuntimeError("Argos en->zh language model is not installed")
        self.translation = source.get_translation(target)
        if self.translation is None:
            raise RuntimeError("Argos does not have an en->zh translation model")

    def translate(self, text: str, context: str = "") -> str:
        return normalize_text(self.translation.translate(text))

    def translate_title(self, text: str) -> str:
        deterministic_title = deterministic_chinese_title(text)
        if deterministic_title:
            return deterministic_title
        return self.translate(text)

    def translate_book_title(self, text: str) -> str:
        return self.translate(text)


    def generate_book_metadata(
        self,
        title: str,
        author: str,
        chapter_count: int,
        word_count: int,
    ) -> dict[str, str]:
        chinese_title = self.translate_book_title(title)
        return default_book_metadata(chinese_title, chapter_count, word_count)


class OllamaTranslator:
    def __init__(self, model: str, url: str, glossary: dict[str, str], timeout: int = 1200) -> None:
        self.model = model
        self.url = url.rstrip("/") + "/api/generate"
        self.glossary = glossary
        self.timeout = timeout
        glossary_hash = hashlib.sha256(
            json.dumps(glossary, ensure_ascii=False, sort_keys=True).encode("utf-8")
        ).hexdigest()[:12]
        self.cache_namespace = f"ollama|{model}|literary-v2|{glossary_hash}"

    def _generate(self, prompt: str, temperature: float = 0.2) -> str:
        payload = json.dumps({
            "model": self.model,
            "prompt": prompt,
            "stream": True,
            "think": False,
            "options": {"temperature": temperature, "top_p": 0.9},
        }).encode("utf-8")
        request = urllib.request.Request(
            self.url,
            data=payload,
            headers={"Content-Type": "application/json"},
            method="POST",
        )
        try:
            with urllib.request.urlopen(request, timeout=self.timeout) as response:
                response_parts: list[str] = []
                chunk_count = 0
                print("  Ollama streaming", end="", flush=True)
                for line in response:
                    if not line.strip():
                        continue
                    result = json.loads(line.decode("utf-8"))
                    if result.get("error"):
                        raise RuntimeError(f"Ollama error: {result['error']}")
                    response_parts.append(str(result.get("response", "")))
                    chunk_count += 1
                    if chunk_count % 10 == 0:
                        print(".", end="", flush=True)
                print(flush=True)
        except urllib.error.URLError as error:
            raise RuntimeError(
                f"Cannot connect to Ollama at {self.url}. Start Ollama and install the selected model."
            ) from error
        except json.JSONDecodeError as error:
            raise RuntimeError("Ollama returned invalid JSON") from error
        response_text = "".join(response_parts).strip()
        if not response_text:
            raise RuntimeError("Ollama returned an empty response")
        return response_text

    def translate(self, text: str, context: str = "") -> str:
        glossary_lines = "\n".join(
            f"- {source} = {target}" for source, target in self.glossary.items()
        ) or "- 没有额外术语表，依据上下文翻译。"
        prompt = f"""你是一名英文文学作品翻译者。

请把“当前段落”翻译成自然、准确、通顺的中文。

要求：
1. 根据上下文翻译习语和文学表达，不要逐词直译；
2. 对话使用自然的中文表达；
3. 叙述动词按语境翻译，例如 ejaculated 可译为“脱口而出”“喊道”或“惊叫道”；
4. 注意 pretty、well、business 等词可能带有反讽或语气，不要机械翻译为“漂亮”“好”“生意”；
5. 人名、地名和专有名词遵守术语表，并保持前后一致；
6. 不遗漏信息，不增加解释；
7. 只输出中文译文，不输出分析、说明、引号或 Markdown。
8. 文章标题能识别出就翻译，识别不了的，按照匹配规则显示，第1章节、第n章节。

术语表：
{glossary_lines}

上下文：
{context or "无额外上下文"}

当前段落：
{text}
"""
        retry_instruction = """

上一次输出存在格式污染。请重新翻译：只能输出中文译文，不能出现西里尔文、泰文、阿拉伯文或英文单词，不要输出解释。
        """
        last_error = "unknown validation error"
        last_candidate = ""
        for attempt in range(2):
            candidate = normalize_text(self._generate(prompt + (retry_instruction if attempt else "")))
            last_candidate = candidate
            validation_error = self._validate_translation(candidate)
            if validation_error is None:
                return candidate
            last_error = validation_error
            print(
                f"Warning: rejected contaminated translation (attempt {attempt + 1}/2): {validation_error}",
                file=sys.stderr,
            )
        sanitized = self._sanitize_translation(last_candidate)
        if CHINESE_CHAR_RE.search(sanitized):
            print(
                "Warning: removed contaminated script from translation after retries.",
                file=sys.stderr,
            )
            return sanitized
        raise RuntimeError(f"Translation output validation failed after 2 attempts: {last_error}")

    def translate_book_title(self, text: str) -> str:
        deterministic_title = deterministic_chinese_title(text)
        if deterministic_title:
            return deterministic_title
        glossary_lines = "\n".join(
            f"- {source} = {target}" for source, target in self.glossary.items()
        ) or "- 没有额外术语表，依据上下文翻译。"
        prompt = f"""你是一名熟悉世界文学出版物的专业书名译者。

请将下面的英文书名翻译成中国读者最常用、最公认的中文书名。

要求：
1. 先判断它是否是已有公认中文译名的经典作品；如果是，优先使用通行书名；
2. 不要逐词直译，不要为了“看起来准确”创造生硬的新译名；
3. 结合作者、作品类型和文学语境判断专名含义；
4. 如果存在多个译名，选择出版物和中国读者最常用的那个；
5. 如果书名包含“系列名、全集、卷号、冒号或斜杠分隔的多部作品”，先分别判断每个组成部分的通行译名，再组合成完整书名；
6. 保留原书名中的卷号、冒号和斜杠结构，不要遗漏斜杠后的任何作品；
7. 只输出最终中文书名，不输出分析、说明、引号或 Markdown；

术语表：
{glossary_lines}

英文书名：
{text}
"""
        candidate = ""
        for attempt in range(2):
            retry_prompt = ""
            if attempt:
                retry_prompt = f"""

请审核上一版候选译名：
{candidate}

如果存在逐词直译、生硬译名、遗漏斜杠分隔作品或卷号问题，请重新按通行出版译名改写；保留原有斜杠数量，只输出最终中文书名。
"""
            candidate = normalize_text(
                self._generate(prompt + retry_prompt)
            )
            if (
                self._validate_translation(candidate) is None
                and self._validate_book_title_structure(text, candidate) is None
            ):
                return candidate
        raise RuntimeError("Book title translation did not return valid Chinese")

    @staticmethod
    def _validate_book_title_structure(source: str, candidate: str) -> str | None:
        if source.count("/") != candidate.count("/"):
            return "composite title lost slash-separated works"
        return None

    def translate_title(self, text: str) -> str:
        deterministic_title = deterministic_chinese_title(text)
        if deterministic_title:
            return deterministic_title
        prompt = f"""请将下面的英文章节标题翻译成自然、简洁的中文章节标题。

要求：只输出中文标题，不输出解释、引号或 Markdown；保留章节编号和专有名词。

章节标题：
{text}
"""
        for attempt in range(2):
            candidate = normalize_text(
                self._generate(prompt + ("\n只输出最终中文章节标题。" if attempt else ""))
            )
            if self._validate_translation(candidate) is None:
                return candidate
        raise RuntimeError("Chapter title translation did not return valid Chinese")

    def generate_book_metadata(
        self,
        title: str,
        author: str,
        chapter_count: int,
        word_count: int,
    ) -> dict[str, str]:
        prompt = f"""你是一名英文文学作品编辑。请为下面的书籍生成应用元数据。

书名：{title}
作者：{author}
章节数：{chapter_count}
英文词数：{word_count}

只输出一个 JSON 对象，不要 Markdown 或解释，字段必须完整：
{{
  "chineseTitle": "中文书名",
  "description": "100 到 180 字的中文简介，只介绍作品和主要情节",
  "category": "分类",
  "difficulty": "例如：中级难度",
  "readerCount": "例如：10万+人在读",
  "targetVocab": "例如：1500-4000词",
  "tagLabel": "短标签",
  "coverBadge": "例如：精读 · 经典名著"
}}
"""
        candidate = normalize_text(self._generate(prompt, temperature=0.1))
        candidate = re.sub(r"^```(?:json)?|```$", "", candidate, flags=re.IGNORECASE).strip()
        try:
            result = json.loads(candidate)
        except json.JSONDecodeError as error:
            raise RuntimeError("Book metadata response was not valid JSON") from error
        if not isinstance(result, dict):
            raise RuntimeError("Book metadata response was not an object")
        required = {
            "chineseTitle", "description", "category", "difficulty",
            "readerCount", "targetVocab", "tagLabel", "coverBadge",
        }
        if not required.issubset(result) or any(
            not isinstance(result[key], str) or not normalize_text(result[key])
            for key in required
        ):
            raise RuntimeError("Book metadata response is incomplete")
        if not CHINESE_CHAR_RE.search(result["chineseTitle"] + result["description"]):
            raise RuntimeError("Book metadata response is not Chinese")
        return {key: normalize_text(result[key]) for key in required}

    @staticmethod
    def _sanitize_translation(value: str) -> str:
        return normalize_text(FORBIDDEN_TRANSLATION_SCRIPT_RE.sub("", value))

    @staticmethod
    def _validate_translation(value: str) -> str | None:
        if not value:
            return "empty output"
        if not CHINESE_CHAR_RE.search(value):
            return "no Chinese characters"
        if FORBIDDEN_TRANSLATION_SCRIPT_RE.search(value):
            return "contains a non-Chinese script"
        return None


class OllamaChapterAbridger:
    def __init__(self, translator: OllamaTranslator) -> None:
        self.translator = translator
        self.cache_namespace = f"abridged|{translator.cache_namespace}"

    def abridge(self, chapter: EpubChapter, ratio: float) -> str:
        sections: list[list[str]] = []
        current: list[str] = []
        current_words = 0
        for paragraph in chapter.paragraphs:
            paragraph_words = word_count(paragraph)
            if current and current_words + paragraph_words > 450:
                sections.append(current)
                current = []
                current_words = 0
            current.append(paragraph)
            current_words += paragraph_words
        if current:
            sections.append(current)
        return "\n\n".join(
            self._abridge_section(chapter.title, section, ratio)
            for section in sections
        )

    def _abridge_section(self, title: str, paragraphs: list[str], ratio: float) -> str:
        source = "\n\n".join(paragraphs)
        source_words = word_count(source)
        target_min = max(80, int(source_words * ratio * 0.9))
        target_max = max(target_min + 40, int(source_words * ratio * 1.1))
        prompt = f"""你是一名英文文学作品编辑。

请用自己的英文改写下面章节，生成保留叙事细节的精简版正文，而不是一段简单摘要。

要求：
1. 保留人物、冲突、关键事件、人物互动和事件顺序，让读者理解本章如何展开；
2. 删除重复描写、次要环境描写和不影响情节的细节，但不要只写结论；
3. 只能使用当前输入片段明确写出的事实；不推断、不补充、不编造原文没有的会议、动机、关系或结果；不确定的细节直接省略；
4. 输出长度以约 {target_min} 到 {target_max} 个英文词作为参考，优先保证章节确实缩减且主线完整，不要为了严格凑比例牺牲情节；
5. 分成若干自然英文段落，每段约 3 到 6 句；
6. 用自己的语言重写，不连续复制原文超过 5 个英文单词；
7. 保持人物姓名的英文拼写；
8. 只输出精简版英文正文，不输出标题、分析或 Markdown。

章节标题：
{title}

章节原文（仅用于理解，不要复述原句）：
{source}
"""
        return self.translator._generate(prompt, temperature=0.0)


class TranslationCache:
    def __init__(self, path: Path, namespace: str, fallback_namespaces: tuple[str, ...] = ()) -> None:
        self.path = path
        self.namespace = namespace
        self.fallback_namespaces = fallback_namespaces
        self.values: dict[str, str] = {}
        if path.exists():
            try:
                data = json.loads(path.read_text(encoding="utf-8"))
                if isinstance(data, dict):
                    self.values = {str(k): str(v) for k, v in data.items()}
            except (OSError, json.JSONDecodeError):
                print(f"Warning: ignoring invalid translation cache: {path}", file=sys.stderr)

    def key(self, text: str) -> str:
        return hashlib.sha256(
            f"{self.namespace}|{text}".encode("utf-8")
        ).hexdigest()

    def get(self, text: str) -> str | None:
        value = self.values.get(self.key(text))
        if value is not None:
            return value
        for namespace in self.fallback_namespaces:
            value = self.values.get(
                hashlib.sha256(f"{namespace}|{text}".encode("utf-8")).hexdigest()
            )
            if value is not None:
                return value
        return None

    def put(self, text: str, translation: str) -> None:
        self.values[self.key(text)] = translation

    def save(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.path.write_text(
            json.dumps(self.values, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )


def chunk_paragraphs(paragraph: str) -> list[tuple[str, int]]:
    sentences = sentence_split(paragraph)
    return [
        (" ".join(sentences[index:index + 3]), len(sentences[index:index + 3]))
        for index in range(0, len(sentences), 3)
    ]


def word_count(text: str) -> int:
    return len(WORD_RE.findall(text))


def read_time(words: int) -> int:
    return max(1, math.ceil(words / 140))


def default_book_metadata(chinese_title: str, chapter_count: int, word_count: int) -> dict[str, str]:
    if word_count >= 50000:
        target_vocab = "2500-6000词"
        difficulty = "高级难度"
    elif word_count >= 25000:
        target_vocab = "1800-4800词"
        difficulty = "中/高级难度"
    else:
        target_vocab = "1200-3500词"
        difficulty = "中级难度"
    return {
        "chineseTitle": chinese_title or "经典名著",
        "description": (
            f"《{chinese_title or '本书'}》是一部经典文学作品，收录全书约 {chapter_count} 个章节，"
            "展现了鲜明的人物、丰富的情节和值得细读的英语表达。"
        ),
        "category": "经典名著",
        "difficulty": difficulty,
        "readerCount": "10万+人在读",
        "targetVocab": target_vocab,
        "tagLabel": "经典名著",
        "coverBadge": "精读 · 经典名著",
    }


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(value, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def load_catalog(path: Path) -> dict:
    if not path.exists():
        return {"version": 1, "books": []}
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as error:
        raise RuntimeError(f"Invalid catalog JSON: {path}") from error
    if not isinstance(data, dict) or not isinstance(data.get("books", []), list):
        raise RuntimeError(f"Invalid catalog structure: {path}")
    return data


def build_book(
    epub_path: Path,
    output_root: Path,
    cache: TranslationCache | None,
    summary_cache: TranslationCache | None,
    translator: TranslationProvider | None,
    abridger: OllamaChapterAbridger | None,
    content_mode: str,
    abridge_ratio: float,
    max_chapters: int | None,
    allow_partial: bool,
    dry_run: bool,
) -> tuple[str, dict, Path | None]:
    reader = EpubReader(epub_path)
    temporary: Path | None = None
    try:
        metadata = reader.metadata()
        book_id = slugify_title(metadata["title"])
        source_chapters = reader.chapters()
        if max_chapters is not None:
            source_chapters = source_chapters[:min(max_chapters, MAX_BOOK_CHAPTERS)]
        else:
            source_chapters = source_chapters[:MAX_BOOK_CHAPTERS]
        chapter_paragraph_limit = (
            SINGLE_CHAPTER_MAX_PARAGRAPHS
            if len(source_chapters) == 1
            else MAX_CHAPTER_PARAGRAPHS
        )
        if not dry_run and output_root.joinpath(book_id).exists():
            raise FileExistsError(f"Book output already exists: {output_root / book_id}")

        print(
            f"Processing {epub_path.name}: {len(source_chapters)} chapters",
            flush=True,
        )
        if not dry_run:
            output_root.mkdir(parents=True, exist_ok=True)
            temporary = Path(tempfile.mkdtemp(prefix=f".{book_id}-", dir=output_root))
            (temporary / book_id / "chapters").mkdir(parents=True, exist_ok=True)
        chapter_indexes: list[dict] = []
        total_words = 0
        translated_since_save = 0
        for source_index, chapter in enumerate(source_chapters, start=1):
            # Only chapters that pass the generated-paragraph limit receive an output index.
            unit_index = len(chapter_indexes) + 1
            print(
                f"Chapter {source_index}/{len(source_chapters)}: {chapter.title}",
                flush=True,
            )
            paragraphs: list[dict] = []
            chapter_words = 0
            chinese_title = ""
            if not dry_run:
                if translator is None or cache is None:
                    raise RuntimeError("Translator and cache are required outside dry-run")
                title_cache_key = f"chapter-title:{chapter.title}"
                chinese_title = cache.get(title_cache_key) or ""
                if not chinese_title:
                    chinese_title = translator.translate_title(chapter.title)
                    cache.put(title_cache_key, chinese_title)
                    cache.save()
            if content_mode == "abridged":
                if dry_run:
                    chapter_words = sum(word_count(item) for item in chapter.paragraphs)
                elif summary_cache is None or translator is None or abridger is None:
                    raise RuntimeError("Abridged mode requires Ollama and both caches")
                else:
                    source_text = "\n\n".join(chapter.paragraphs)
                    summary_en = summary_cache.get(source_text) or ""
                    if not summary_en:
                        summary_en = abridger.abridge(chapter, abridge_ratio)
                        summary_cache.put(source_text, summary_en)
                        summary_cache.save()
                    abridged_paragraphs = [
                        normalize_text(item)
                        for item in re.split(r"\n{2,}", summary_en)
                        if normalize_text(item)
                    ]
                    abridged_chunks = [
                        item
                        for source_paragraph in abridged_paragraphs
                        for item in chunk_paragraphs(source_paragraph)
                    ]
                    if len(abridged_chunks) > chapter_paragraph_limit:
                        print(
                            f"Truncating chapter to {chapter_paragraph_limit} generated paragraphs: "
                            f"{chapter.title}",
                            flush=True,
                        )
                        abridged_chunks = abridged_chunks[:chapter_paragraph_limit]
                    for chunk_index, (text, sentence_count) in enumerate(abridged_chunks):
                        print(
                            f"  Processing paragraph {chunk_index + 1}/{len(abridged_chunks)}",
                            flush=True,
                        )
                        zh = cache.get(text) if cache is not None else ""
                        if zh and isinstance(translator, OllamaTranslator):
                            if translator._validate_translation(zh) is not None:
                                sanitized = translator._sanitize_translation(zh)
                                zh = sanitized if CHINESE_CHAR_RE.search(sanitized) else ""
                                if zh and cache is not None:
                                    cache.put(text, zh)
                                    cache.save()
                        if not zh:
                            zh = translator.translate(text, f"章节：{chapter.title}")
                            if cache is not None:
                                cache.put(text, zh)
                                cache.save()
                        chapter_words += word_count(text)
                        paragraphs.append({
                            "id": f"p{len(paragraphs) + 1:03d}",
                            "sentenceCount": sentence_count,
                            "en": text,
                            "zh": zh,
                        })
            else:
                chunks = [
                    item
                    for source_paragraph in chapter.paragraphs
                    for item in chunk_paragraphs(source_paragraph)
                ]
                if len(chunks) > chapter_paragraph_limit:
                    print(
                        f"Truncating chapter to {chapter_paragraph_limit} generated paragraphs: "
                        f"{chapter.title}",
                        flush=True,
                    )
                    chunks = chunks[:chapter_paragraph_limit]
                for chunk_index, (text, sentence_count) in enumerate(chunks):
                    print(
                        f"  Processing paragraph {chunk_index + 1}/{len(chunks)}",
                        flush=True,
                    )
                    chapter_words += word_count(text)
                    zh = ""
                    if not dry_run:
                        if translator is None or cache is None:
                            raise RuntimeError("Translator and cache are required outside dry-run")
                        zh = cache.get(text) or ""
                        if isinstance(translator, OllamaTranslator):
                            if translator._validate_translation(zh) is not None:
                                sanitized = translator._sanitize_translation(zh)
                                zh = sanitized if CHINESE_CHAR_RE.search(sanitized) else ""
                                if zh:
                                    cache.put(text, zh)
                                    cache.save()
                        if not zh:
                            try:
                                context_parts = [f"章节：{chapter.title}"]
                                if chunk_index > 0:
                                    context_parts.append(f"前文：{chunks[chunk_index - 1][0]}")
                                if chunk_index + 1 < len(chunks):
                                    context_parts.append(f"后文：{chunks[chunk_index + 1][0]}")
                                zh = translator.translate(text, "\n".join(context_parts))
                                cache.put(text, zh)
                                translated_since_save += 1
                                if translated_since_save >= 25:
                                    cache.save()
                                    translated_since_save = 0
                                    print(
                                        f"Translated {book_id} unit {unit_index}, "
                                        f"paragraph {len(paragraphs) + 1}/{len(chunks)}"
                                    )
                            except Exception as error:  # noqa: BLE001
                                if not allow_partial:
                                    raise RuntimeError(
                                        f"Translation failed in {book_id} unit {unit_index}: {error}"
                                    ) from error
                                print(
                                    f"Warning: translation failed in {book_id} unit {unit_index}: {error}",
                                    file=sys.stderr,
                                )
                    paragraphs.append({
                        "id": f"p{len(paragraphs) + 1:03d}",
                        "sentenceCount": sentence_count,
                        "en": text,
                        "zh": zh,
                    })
            total_words += chapter_words
            chapter_path = f"chapters/{unit_index:03d}.json"
            chapter_indexes.append({
                "unitIndex": unit_index,
                "title": chapter.title,
                "chineseTitle": chinese_title,
                "path": chapter_path,
                "wordCount": chapter_words,
                "readTime": read_time(chapter_words),
            })
            chapter_doc = {
                "id": f"{book_id}_u{unit_index}",
                "bookId": book_id,
                "unitIndex": unit_index,
                "title": chapter.title,
                "chineseTitle": chinese_title,
                "paragraphs": paragraphs,
            }
            if not dry_run:
                assert temporary is not None
                write_json(temporary / book_id / chapter_path, chapter_doc)
                print(f"  Saved {chapter_path}", flush=True)

        book_metadata = default_book_metadata(
            "",
            len(chapter_indexes),
            total_words,
        )
        cover_url = ""
        if not dry_run:
            if translator is None or cache is None or temporary is None:
                raise RuntimeError("Translator, cache, and output directory are required")
            metadata_cache_key = (
                f"book-metadata:{metadata['title']}|{metadata['author']}|"
                f"{len(chapter_indexes)}|{total_words}"
            )
            cached_metadata = cache.get(metadata_cache_key)
            if cached_metadata:
                try:
                    decoded_metadata = json.loads(cached_metadata)
                    if isinstance(decoded_metadata, dict):
                        book_metadata.update({
                            key: str(value)
                            for key, value in decoded_metadata.items()
                            if key in book_metadata and normalize_text(str(value))
                        })
                except json.JSONDecodeError:
                    cached_metadata = None
            if not cached_metadata or any(
                not normalize_text(book_metadata.get(key, ""))
                for key in (
                    "chineseTitle", "description", "category", "difficulty",
                    "readerCount", "targetVocab", "tagLabel", "coverBadge",
                )
            ):
                try:
                    book_metadata = translator.generate_book_metadata(
                        metadata["title"],
                        metadata["author"],
                        len(chapter_indexes),
                        total_words,
                    )
                except Exception as error:  # noqa: BLE001
                    print(
                        f"Warning: book metadata generation failed, using defaults: {error}",
                        file=sys.stderr,
                    )
                    book_metadata = default_book_metadata(
                        deterministic_chinese_title(metadata["title"]),
                        len(chapter_indexes),
                        total_words,
                    )
                cache.put(metadata_cache_key, json.dumps(book_metadata, ensure_ascii=False))
                cache.save()

            book_title_cache_key = f"book-title:{metadata['title']}"
            translated_book_title = cache.get(book_title_cache_key) or ""
            if not translated_book_title:
                translated_book_title = translator.translate_book_title(metadata["title"])
                cache.put(book_title_cache_key, translated_book_title)
                cache.save()
            book_metadata["chineseTitle"] = translated_book_title

            cover = reader.cover_asset()
            if cover is None:
                cover_filename = "cover.jpg"
                write_path = temporary / book_id / cover_filename
                print("  EPUB has no embedded cover; generating a local cover", flush=True)
                generate_book_cover(
                    write_path,
                    metadata["title"],
                    book_metadata.get("chineseTitle", ""),
                    metadata["author"],
                )
            else:
                cover_bytes, cover_extension = cover
                cover_filename = f"cover{cover_extension}"
                write_path = temporary / book_id / cover_filename
                write_path.write_bytes(cover_bytes)
            cover_url = f"assets/data/books/{book_id}/{cover_filename}"

        book_json = {
            "id": book_id,
            "title": metadata["title"],
            **book_metadata,
            "author": metadata["author"],
            "coverUrl": cover_url,
            "totalUnits": len(chapter_indexes),
            "wordCount": total_words,
            "sourceFormat": "epub",
            "contentVersion": 1,
        }
        chapters_json = {
            "bookId": book_id,
            "version": 1,
            "chapters": chapter_indexes,
        }
        if dry_run:
            return book_id, {"title": metadata["title"], "chapters": len(chapter_indexes), "words": total_words}, None

        assert temporary is not None
        book_dir = temporary / book_id
        write_json(book_dir / "book.json", book_json)
        write_json(book_dir / "chapters.json", chapters_json)
        return book_id, book_json, temporary
    except Exception:
        if temporary:
            print(
                f"Generated content was preserved at: {temporary}",
                file=sys.stderr,
            )
        raise
    finally:
        reader.close()


def update_catalog(output_root: Path, book_id: str, title: str) -> None:
    path = output_root / "catalog.json"
    catalog = load_catalog(path)
    books = [book for book in catalog["books"] if book.get("id") != book_id]
    books.append({
        "id": book_id,
        "title": title,
        "path": book_id,
        "manifest": f"{book_id}/book.json",
    })
    books.sort(key=lambda item: str(item.get("title", "")).lower())
    catalog["books"] = books
    write_json(path, catalog)


def validate_book_output(book_dir: Path, allow_partial: bool = False) -> None:
    book_path = book_dir / "book.json"
    chapters_path = book_dir / "chapters.json"
    if not book_path.is_file() or not chapters_path.is_file():
        raise RuntimeError(f"Generated book manifests are incomplete: {book_dir}")
    book = json.loads(book_path.read_text(encoding="utf-8"))
    chapters = json.loads(chapters_path.read_text(encoding="utf-8"))
    missing_book_fields = BOOK_REQUIRED_FIELDS - set(book)
    if missing_book_fields:
        raise RuntimeError(
            f"Book metadata is incomplete, missing fields: {sorted(missing_book_fields)}"
        )
    for field in (
        "chineseTitle", "coverUrl", "description", "readerCount",
        "targetVocab", "tagLabel", "coverBadge",
    ):
        if not normalize_text(str(book.get(field, ""))):
            raise RuntimeError(f"Book metadata field is empty: {field}")
    cover_reference = Path(str(book["coverUrl"]))
    cover_candidates = [
        cover_reference if cover_reference.is_absolute() else Path.cwd() / cover_reference,
        book_dir / cover_reference.name,
    ]
    cover_path = next((path for path in cover_candidates if path.is_file()), None)
    if cover_path is None:
        raise RuntimeError(
            f"Book cover file is missing: {cover_candidates[0]} "
            f"(checked temporary output: {cover_candidates[1]})"
        )
    chapter_items = chapters.get("chapters")
    if not isinstance(chapter_items, list) or len(chapter_items) != book.get("totalUnits"):
        raise RuntimeError(f"Chapter count mismatch: {book_dir}")
    if len(chapter_items) > MAX_BOOK_CHAPTERS:
        raise RuntimeError(f"Book has more than {MAX_BOOK_CHAPTERS} chapters: {book_dir}")
    chapter_paragraph_limit = (
        SINGLE_CHAPTER_MAX_PARAGRAPHS
        if book.get("totalUnits") == 1
        else MAX_CHAPTER_PARAGRAPHS
    )
    for expected_index, item in enumerate(chapter_items, start=1):
        if item.get("unitIndex") != expected_index:
            raise RuntimeError(f"Chapter index is not continuous: {book_dir}")
        chapter_path = book_dir / item.get("path", "")
        if not chapter_path.is_file():
            raise RuntimeError(f"Missing chapter file: {chapter_path}")
        chapter = json.loads(chapter_path.read_text(encoding="utf-8"))
        paragraphs = chapter.get("paragraphs")
        if not isinstance(paragraphs, list) or not paragraphs:
            raise RuntimeError(f"Chapter has no paragraphs: {chapter_path}")
        if len(paragraphs) > chapter_paragraph_limit:
            raise RuntimeError(
                f"Chapter has more than {chapter_paragraph_limit} paragraphs: {chapter_path}"
            )
        for paragraph in paragraphs:
            if not paragraph.get("en"):
                raise RuntimeError(f"Empty English paragraph: {chapter_path}")
            if not allow_partial and not paragraph.get("zh"):
                raise RuntimeError(f"Empty Chinese paragraph: {chapter_path}")
        indexed_title = item.get("chineseTitle")
        document_title = chapter.get("chineseTitle")
        if not indexed_title:
            raise RuntimeError(f"Missing Chinese chapter title in chapters.json: {chapter_path}")
        if not document_title:
            raise RuntimeError(f"Missing Chinese chapter title in chapter JSON: {chapter_path}")
        if document_title != indexed_title:
            print(
                f"Warning: Chinese chapter title differs between index and document "
                f"({indexed_title!r} != {document_title!r}): {chapter_path}",
                file=sys.stderr,
            )


def move_processed(source: Path, processed_root: Path) -> Path:
    destination_dir = processed_root / date.today().isoformat()
    destination_dir.mkdir(parents=True, exist_ok=True)
    destination = destination_dir / source.name
    if destination.exists():
        raise FileExistsError(f"Processed EPUB already exists: {destination}")
    shutil.move(str(source), str(destination))
    return destination


def promote_book_output(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    last_error: PermissionError | None = None
    for _ in range(3):
        if destination.exists():
            raise FileExistsError(f"Book output already exists: {destination}")
        try:
            source.replace(destination)
            return
        except PermissionError as error:
            last_error = error
            time.sleep(1)

    if destination.exists():
        raise FileExistsError(f"Book output already exists: {destination}")
    try:
        shutil.copytree(source, destination)
    except Exception as error:  # noqa: BLE001
        shutil.rmtree(destination, ignore_errors=True)
        raise PermissionError(
            f"Could not finalize book output. Windows may be locking a generated file: {destination}"
        ) from (last_error or error)
    shutil.rmtree(source.parent, ignore_errors=True)


def update_pending_translation_record(path: Path, book_id: str, book_title: str = "") -> bool:
    """Mark a completed book and move its row to the end of the book table."""
    if not path.is_file():
        return False

    original = path.read_text(encoding="utf-8")
    def normalize_match(value: str) -> str:
        return re.sub(r"[^a-z0-9]+", "", value.casefold())
    normalized_id = normalize_match(book_id)
    normalized_title = normalize_match(book_title)
    lines = original.splitlines(keepends=True)
    row_index = next(
        (
            index
            for index, line in enumerate(lines)
            if len(line.split("|")) >= 5
            and (
                normalize_match(line.split("|")[3].strip(" `/")) == normalized_id
                or normalize_match(line.split("|")[1].strip()) == normalized_title
                or (
                    normalized_title
                    and normalize_match(line.split("|")[1].strip())
                    and normalize_match(line.split("|")[1].strip()) in normalized_title
                )
            )
        ),
        None,
    )
    if row_index is None:
        return False

    row = lines[row_index]
    newline = "\r\n" if row.endswith("\r\n") else "\n"
    row_without_newline = row.rstrip("\r\n")
    columns = row_without_newline.split("|")
    if len(columns) < 5:
        return False
    columns[-2] = " 已处理 "
    updated_row = "|".join(columns) + newline

    table_end = row_index + 1
    while table_end < len(lines) and lines[table_end].lstrip().startswith("|"):
        table_end += 1

    lines.pop(row_index)
    table_end -= 1
    lines.insert(table_end, updated_row)
    updated = "".join(lines)
    if updated == original:
        return False
    path.write_text(updated, encoding="utf-8")
    return True


def load_glossary(path: Path | None) -> dict[str, str]:
    if path is None:
        return {}
    if not path.exists():
        raise FileNotFoundError(f"Glossary file does not exist: {path}")
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict) or not all(isinstance(k, str) and isinstance(v, str) for k, v in data.items()):
        raise ValueError("Glossary must be a JSON object with string keys and values")
    return data


def confirm_skip_existing_book(error: FileExistsError) -> bool:
    prompt = f"{error}. Continue with the next book? [Y/N]: "
    while True:
        try:
            answer = input(prompt).strip().lower()
        except EOFError:
            return False
        if answer in {"y", "yes"}:
            return True
        if answer in {"n", "no"}:
            return False
        print("Please enter Y to continue or N to cancel.")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, default=Path("assets/epub/incoming"))
    parser.add_argument("--output", type=Path, default=Path("assets/data/books"))
    parser.add_argument("--processed", type=Path, default=Path("assets/epub/processed"))
    parser.add_argument(
        "--pending-record",
        type=Path,
        default=Path("assets/epub/pending-translation-books.md"),
        help="完成导入后更新对应书籍状态的 Markdown 文件",
    )
    parser.add_argument("--cache", type=Path, default=Path("assets/epub/translation-cache/cache.json"))
    parser.add_argument("--abridged-cache", type=Path, default=Path("assets/epub/translation-cache/abridged-cache.json"))
    parser.add_argument("--book", type=Path)
    parser.add_argument("--translator", choices=("ollama", "argos"), default="ollama")
    parser.add_argument("--ollama-model", default="qwen2.5:7b")
    parser.add_argument("--ollama-url", default="http://127.0.0.1:11434")
    parser.add_argument("--ollama-timeout", type=int, default=1200)
    parser.add_argument("--glossary", type=Path)
    parser.add_argument("--content-mode", choices=("abridged", "full"), default="abridged")
    parser.add_argument("--abridge-ratio", type=float, default=0.45)
    parser.add_argument("--max-chapters", type=int)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--allow-partial", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.book:
        files = [args.book]
    else:
        files = sorted(args.input.glob("*.epub"))
    if not files:
        print(f"No EPUB files found in {args.input}")
        return 0

    translator: TranslationProvider | None = None
    cache: TranslationCache | None = None
    summary_cache: TranslationCache | None = None
    abridger: OllamaChapterAbridger | None = None
    if not args.dry_run:
        glossary = load_glossary(args.glossary)
        if args.translator == "argos":
            translator = ArgosTranslator()
        else:
            translator = OllamaTranslator(
                args.ollama_model,
                args.ollama_url,
                glossary,
                timeout=args.ollama_timeout,
            )
        legacy_cache_namespace = translator.cache_namespace.replace("|literary-v2|", "|literary-v1|")
        cache = TranslationCache(
            args.cache,
            translator.cache_namespace,
            fallback_namespaces=(legacy_cache_namespace,),
        )
        if not 0.2 <= args.abridge_ratio <= 0.7:
            raise ValueError("--abridge-ratio must be between 0.2 and 0.7")
        if args.content_mode == "abridged":
            if not isinstance(translator, OllamaTranslator):
                raise RuntimeError("Abridged mode requires --translator ollama")
            abridger = OllamaChapterAbridger(translator)
            legacy_summary_namespace = abridger.cache_namespace.replace("literary-v2", "literary-v1")
            summary_cache = TranslationCache(
                args.abridged_cache,
                abridger.cache_namespace,
                fallback_namespaces=(legacy_summary_namespace,),
            )

    for epub_path in files:
        if not epub_path.is_file():
            print(f"Skipping missing EPUB: {epub_path}", file=sys.stderr)
            continue
        temporary: Path | None = None
        try:
            if args.max_chapters is not None and args.max_chapters < 1:
                raise ValueError("--max-chapters must be greater than zero")
            book_id, book_info, temporary = build_book(
                epub_path,
                args.output,
                cache,
                summary_cache,
                translator,
                abridger,
                args.content_mode,
                args.abridge_ratio,
                args.max_chapters,
                args.allow_partial,
                args.dry_run,
            )
            if args.dry_run:
                print(
                    f"DRY-RUN {epub_path.name}: {book_id}, "
                    f"{book_info['chapters']} chapters, {book_info['words']} words"
                )
                continue
            assert temporary is not None and cache is not None
            final_dir = args.output / book_id
            if final_dir.exists():
                raise FileExistsError(f"Book output already exists: {final_dir}")
            validate_book_output(temporary / book_id, args.allow_partial)
            print(f"Finalizing book output -> {final_dir}", flush=True)
            try:
                promote_book_output(temporary / book_id, final_dir)
            except PermissionError as error:
                preserved_path = temporary / book_id
                print(
                    f"Could not finalize the generated book: {error}\n"
                    f"Generated content was preserved at: {preserved_path}\n"
                    "Close programs that may be scanning the folder, then move this directory manually "
                    "or rerun the import.",
                    file=sys.stderr,
                )
                temporary = None
                return 1
            shutil.rmtree(temporary, ignore_errors=True)
            update_catalog(args.output, book_id, str(book_info["title"]))
            cache.save()
            destination = move_processed(epub_path, args.processed)
            try:
                pending_updated = update_pending_translation_record(
                    args.pending_record,
                    book_id,
                    str(book_info["title"]),
                )
                if pending_updated:
                    print(f"Updated pending translation record -> {args.pending_record}")
                else:
                    print(
                        f"Warning: no matching pending translation record for "
                        f"{book_id} ({book_info['title']})",
                        file=sys.stderr,
                    )
            except OSError as error:
                print(
                    f"Warning: could not update pending translation record: {error}",
                    file=sys.stderr,
                )
            print(f"Imported {epub_path.name} -> {final_dir}")
            print(f"Moved original EPUB -> {destination}")
        except FileExistsError as error:
            if temporary:
                print(f"Generated content was preserved at: {temporary}", file=sys.stderr)
            if confirm_skip_existing_book(error):
                print(f"Skipped {epub_path.name}")
                continue
            print("Import canceled.", file=sys.stderr)
            return 1
        except Exception as error:  # noqa: BLE001
            if temporary:
                print(f"Generated content was preserved at: {temporary}", file=sys.stderr)
            print(f"Failed to import {epub_path}: {error}", file=sys.stderr)
            return 1
    print("Import completed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
