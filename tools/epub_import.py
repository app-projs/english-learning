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
import sys
import tempfile
import urllib.error
import urllib.request
import zipfile
from dataclasses import dataclass
from datetime import date
from html.parser import HTMLParser
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
        if self._active_tag is None and (tag in BLOCK_TAGS or tag in HEADING_TAGS):
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


def zip_path(base: str, href: str) -> str:
    href_path = unquote(urlparse(href).path)
    return posixpath.normpath(posixpath.join(posixpath.dirname(base), href_path))


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
            parser = TextBlockParser()
            parser.feed(self.archive.read(path).decode("utf-8", errors="replace"))
            headings = [text for kind, text in parser.blocks if kind == "heading"]
            paragraphs = [text for kind, text in parser.blocks if kind == "paragraph"]
            if not paragraphs:
                continue
            if not chapters and not nav_titles.get(path) and word_count(" ".join(paragraphs)) < 20:
                continue
            title = nav_titles.get(path) or headings[0] if headings else nav_titles.get(path, Path(path).stem.replace("_", " "))
            chapters.append(EpubChapter(title, paragraphs, path))
        if not chapters:
            raise ValueError("No readable chapters found in EPUB spine")
        return chapters

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


class OllamaTranslator:
    def __init__(self, model: str, url: str, glossary: dict[str, str], timeout: int = 1200) -> None:
        self.model = model
        self.url = url.rstrip("/") + "/api/generate"
        self.glossary = glossary
        self.timeout = timeout
        glossary_hash = hashlib.sha256(
            json.dumps(glossary, ensure_ascii=False, sort_keys=True).encode("utf-8")
        ).hexdigest()[:12]
        self.cache_namespace = f"ollama|{model}|literary-v1|{glossary_hash}"

    def _generate(self, prompt: str, temperature: float = 0.2) -> str:
        payload = json.dumps({
            "model": self.model,
            "prompt": prompt,
            "stream": False,
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
                result = json.loads(response.read().decode("utf-8"))
        except urllib.error.URLError as error:
            raise RuntimeError(
                f"Cannot connect to Ollama at {self.url}. Start Ollama and install the selected model."
            ) from error
        except json.JSONDecodeError as error:
            raise RuntimeError("Ollama returned invalid JSON") from error
        if result.get("error"):
            raise RuntimeError(f"Ollama error: {result['error']}")
        response_text = str(result.get("response", "")).strip()
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

术语表：
{glossary_lines}

上下文：
{context or "无额外上下文"}

当前段落：
{text}
"""
        return normalize_text(self._generate(prompt))


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
    def __init__(self, path: Path, namespace: str) -> None:
        self.path = path
        self.namespace = namespace
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
        return self.values.get(self.key(text))

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
    try:
        metadata = reader.metadata()
        book_id = slugify_title(metadata["title"])
        source_chapters = reader.chapters()
        if max_chapters is not None:
            source_chapters = source_chapters[:max_chapters]
        if not dry_run and output_root.joinpath(book_id).exists():
            raise FileExistsError(f"Book output already exists: {output_root / book_id}")

        chapter_docs: list[dict] = []
        chapter_indexes: list[dict] = []
        total_words = 0
        translated_since_save = 0
        for unit_index, chapter in enumerate(source_chapters, start=1):
            paragraphs: list[dict] = []
            chapter_words = 0
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
                    for chunk_index, (text, sentence_count) in enumerate(abridged_chunks):
                        zh = cache.get(text) if cache is not None else ""
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
                for chunk_index, (text, sentence_count) in enumerate(chunks):
                    chapter_words += word_count(text)
                    zh = ""
                    if not dry_run:
                        if translator is None or cache is None:
                            raise RuntimeError("Translator and cache are required outside dry-run")
                        zh = cache.get(text) or ""
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
                "chineseTitle": "",
                "path": chapter_path,
                "wordCount": chapter_words,
                "readTime": read_time(chapter_words),
            })
            chapter_docs.append({
                "id": f"{book_id}_u{unit_index}",
                "bookId": book_id,
                "unitIndex": unit_index,
                "title": chapter.title,
                "chineseTitle": "",
                "paragraphs": paragraphs,
            })

        book_json = {
            "id": book_id,
            "title": metadata["title"],
            "chineseTitle": "",
            "author": metadata["author"],
            "coverUrl": "",
            "description": "",
            "category": "经典名著",
            "difficulty": "中级难度",
            "totalUnits": len(chapter_docs),
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
            return book_id, {"title": metadata["title"], "chapters": len(chapter_docs), "words": total_words}, None

        output_root.mkdir(parents=True, exist_ok=True)
        temporary = Path(tempfile.mkdtemp(prefix=f".{book_id}-", dir=output_root))
        book_dir = temporary / book_id
        write_json(book_dir / "book.json", book_json)
        write_json(book_dir / "chapters.json", chapters_json)
        for index, chapter_doc in enumerate(chapter_docs, start=1):
            write_json(book_dir / "chapters" / f"{index:03d}.json", chapter_doc)
        return book_id, book_json, temporary
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
    chapter_items = chapters.get("chapters")
    if not isinstance(chapter_items, list) or len(chapter_items) != book.get("totalUnits"):
        raise RuntimeError(f"Chapter count mismatch: {book_dir}")
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
        for paragraph in paragraphs:
            if not paragraph.get("en"):
                raise RuntimeError(f"Empty English paragraph: {chapter_path}")
            if not allow_partial and not paragraph.get("zh"):
                raise RuntimeError(f"Empty Chinese paragraph: {chapter_path}")


def move_processed(source: Path, processed_root: Path) -> Path:
    destination_dir = processed_root / date.today().isoformat()
    destination_dir.mkdir(parents=True, exist_ok=True)
    destination = destination_dir / source.name
    if destination.exists():
        raise FileExistsError(f"Processed EPUB already exists: {destination}")
    shutil.move(str(source), str(destination))
    return destination


def load_glossary(path: Path | None) -> dict[str, str]:
    if path is None:
        return {}
    if not path.exists():
        raise FileNotFoundError(f"Glossary file does not exist: {path}")
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict) or not all(isinstance(k, str) and isinstance(v, str) for k, v in data.items()):
        raise ValueError("Glossary must be a JSON object with string keys and values")
    return data


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, default=Path("assets/epub/incoming"))
    parser.add_argument("--output", type=Path, default=Path("assets/data/books"))
    parser.add_argument("--processed", type=Path, default=Path("assets/epub/processed"))
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
        cache = TranslationCache(args.cache, translator.cache_namespace)
        if not 0.2 <= args.abridge_ratio <= 0.7:
            raise ValueError("--abridge-ratio must be between 0.2 and 0.7")
        if args.content_mode == "abridged":
            if not isinstance(translator, OllamaTranslator):
                raise RuntimeError("Abridged mode requires --translator ollama")
            abridger = OllamaChapterAbridger(translator)
            summary_cache = TranslationCache(args.abridged_cache, abridger.cache_namespace)

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
            temporary.joinpath(book_id).replace(final_dir)
            shutil.rmtree(temporary, ignore_errors=True)
            update_catalog(args.output, book_id, str(book_info["title"]))
            cache.save()
            destination = move_processed(epub_path, args.processed)
            print(f"Imported {epub_path.name} -> {final_dir}")
            print(f"Moved original EPUB -> {destination}")
        except Exception as error:  # noqa: BLE001
            if temporary:
                shutil.rmtree(temporary, ignore_errors=True)
            print(f"Failed to import {epub_path}: {error}", file=sys.stderr)
            return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
