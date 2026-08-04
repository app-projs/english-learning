"""Rebuild Anne of Green Gables learning excerpts from the public-domain text.

Each chapter receives four distinct source excerpts and a matching Chinese
translation. This keeps the book data reproducible and prevents repeated,
out-of-context filler paragraphs from being introduced during content updates.
"""

from __future__ import annotations

import argparse
import json
import re
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from typing import Any
from urllib.parse import urlencode
from urllib.request import Request, urlopen


BOOK_PATH = Path("assets/data/books/book_anne.json")
SOURCE_URL = "https://www.gutenberg.org/files/45/45-0.txt"
TRANSLATE_URL = "https://translate.googleapis.com/translate_a/single"
CHAPTER_PATTERN = re.compile(r"^CHAPTER [IVXLCDM]+\.\s+.+$", re.MULTILINE)
TARGET_EXCERPT_WORDS = 105
EXCERPTS_PER_CHAPTER = 4


def fetch_text(url: str) -> str:
    request = Request(url, headers={"User-Agent": "Lumina-English-Content-Tool/1.0"})
    with urlopen(request, timeout=30) as response:
        return response.read().decode("utf-8")


def normalize_paragraph(paragraph: str) -> str:
    paragraph = re.sub(r"\s+", " ", paragraph).strip()
    return paragraph.replace("_", "")


def split_chapters(source: str) -> list[list[str]]:
    matches = list(CHAPTER_PATTERN.finditer(source))
    chapters: list[list[str]] = []
    for index, match in enumerate(matches):
        end = matches[index + 1].start() if index + 1 < len(matches) else len(source)
        raw_paragraphs = source[match.end() : end].split("\n\n")
        paragraphs = [
            normalized
            for raw in raw_paragraphs
            if (normalized := normalize_paragraph(raw))
            and len(normalized.split()) >= 12
        ]
        chapters.append(paragraphs)
    return chapters


def build_excerpt(paragraphs: list[str], start: int) -> str:
    excerpt: list[str] = []
    words = 0
    for paragraph in paragraphs[start:]:
        paragraph_words = len(paragraph.split())
        if excerpt and words + paragraph_words > TARGET_EXCERPT_WORDS + 35:
            break
        excerpt.append(paragraph)
        words += paragraph_words
        if words >= TARGET_EXCERPT_WORDS:
            break
    return " ".join(excerpt)


def select_excerpts(paragraphs: list[str]) -> list[str]:
    if len(paragraphs) < EXCERPTS_PER_CHAPTER:
        raise ValueError("A chapter does not have enough source paragraphs.")

    starts = [round(index * len(paragraphs) / EXCERPTS_PER_CHAPTER) for index in range(EXCERPTS_PER_CHAPTER)]
    excerpts: list[str] = []
    for start in starts:
        excerpt = build_excerpt(paragraphs, start)
        while len(excerpt.split()) < 45 and start > 0:
            start -= 1
            excerpt = build_excerpt(paragraphs, start)
        if len(excerpt.split()) < 45:
            raise ValueError("A selected excerpt is too short.")
        excerpts.append(excerpt)
    return excerpts


def translate(text: str) -> str:
    query = urlencode(
        {
            "client": "gtx",
            "sl": "en",
            "tl": "zh-CN",
            "dt": "t",
            "q": text,
        }
    )
    for attempt in range(3):
        try:
            response = json.loads(fetch_text(f"{TRANSLATE_URL}?{query}"))
            return "".join(part[0] for part in response[0]).strip()
        except Exception:
            if attempt == 2:
                raise
            time.sleep(1 + attempt)
    raise RuntimeError("Translation retry loop ended unexpectedly.")


def validate(book: dict[str, Any]) -> int:
    chapters = book["chapters"]
    if len(chapters) != 38 or book["totalUnits"] != len(chapters):
        raise ValueError("The rebuilt book must contain all 38 chapters.")

    seen_english: set[str] = set()
    total_words = 0
    for chapter in chapters:
        paragraphs = chapter["paragraphs"]
        if len(paragraphs) != EXCERPTS_PER_CHAPTER:
            raise ValueError(f"Chapter {chapter['unitIndex']} does not have four excerpts.")
        chapter_words = 0
        for paragraph in paragraphs:
            english = paragraph["en"].strip()
            chinese = paragraph["zh"].strip()
            if not english or not chinese or english in seen_english:
                raise ValueError(f"Chapter {chapter['unitIndex']} has missing or repeated content.")
            seen_english.add(english)
            chapter_words += len(english.split())
        if not 200 <= chapter_words <= 900:
            raise ValueError(
                f"Chapter {chapter['unitIndex']} is outside the word-count range: {chapter_words} words."
            )
        total_words += chapter_words
    return total_words


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, help="Optional local Project Gutenberg text file.")
    args = parser.parse_args()

    source = args.source.read_text(encoding="utf-8") if args.source else fetch_text(SOURCE_URL)
    source_chapters = split_chapters(source)
    if len(source_chapters) != 38:
        raise ValueError(f"Expected 38 source chapters, found {len(source_chapters)}.")

    book = json.loads(BOOK_PATH.read_text(encoding="utf-8"))
    with ThreadPoolExecutor(max_workers=8) as executor:
      for chapter, source_paragraphs in zip(book["chapters"], source_chapters, strict=True):
        excerpts = select_excerpts(source_paragraphs)
        translations = list(executor.map(translate, excerpts))
        chapter["paragraphs"] = [
            {"en": excerpt, "zh": translation}
            for excerpt, translation in zip(excerpts, translations, strict=True)
        ]
        print(f"Rebuilt chapter {chapter['unitIndex']:02d}/38")
        time.sleep(0.05)

    book["wordCount"] = validate(book)
    BOOK_PATH.write_text(
        json.dumps(book, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {BOOK_PATH} with {book['wordCount']} English words.")


if __name__ == "__main__":
    main()
