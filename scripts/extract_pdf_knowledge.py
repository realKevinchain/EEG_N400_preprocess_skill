#!/usr/bin/env python3
"""Extract the source book into page-traceable Markdown chapter files.

The script deliberately processes one PDF page at a time. It writes the
verbatim pdfplumber extraction to JSONL and assembles readable Markdown files
without sending the complete book through a model context.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import statistics
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

import pdfplumber
from pypdf import PdfReader


@dataclass(frozen=True)
class Part:
    slug: str
    title: str
    first_page: int
    last_page: int


PARTS = (
    Part("00-front-matter", "Front Matter", 1, 13),
    Part("01-first-steps", "1: First Steps", 14, 33),
    Part("02-single-participant-n400", "2: Processing One Participant in the ERP CORE N400 Experiment", 34, 70),
    Part("03-multiple-participant-n400", "3: Processing Multiple Participants in the ERP CORE N400 Experiment", 71, 97),
    Part("04-filtering", "4: Filtering the EEG and ERPs", 98, 129),
    Part("05-referencing-channel-operations", "5: Referencing and Other Channel Operations", 130, 153),
    Part("06-bins-averaging-baseline-data-quality", "6: Bins, Averaging, Baseline Correction, and Data Quality", 154, 184),
    Part("07-eeg-inspection-bad-channels", "7: Inspecting the EEG and Interpolating Bad Channels", 185, 195),
    Part("08-artifact-detection-rejection", "8: Artifact Detection and Rejection", 196, 240),
    Part("09-ica-artifact-correction", "9: Artifact Correction with Independent Component Analysis", 241, 271),
    Part("10-scoring-statistics", "10: Scoring and Statistical Analysis of ERP Amplitudes and Latencies", 272, 300),
    Part("11-scripting", "11: EEGLAB and ERPLAB Scripting", 301, 340),
    Part("12-appendix-eeg-erp-introduction", "12: Appendix 1: A Very Brief Introduction to EEG and ERPs", 341, 345),
    Part("13-appendix-troubleshooting", "13: Appendix 2: Troubleshooting Guide", 346, 363),
    Part("14-appendix-processing-pipeline", "14: Appendix 3: Example Processing Pipeline", 364, 369),
    Part("15-back-matter", "Back Matter", 370, 374),
)

FRONT_ENTRIES = (
    (9, "Hardware and Software Requirements"),
    (10, "Licensing"),
    (11, "Preface"),
    (12, "Acknowledgments"),
    (13, "How to Cite This Book"),
)

BACK_ENTRIES = ((370, "Index"), (371, "Detailed Licensing"))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def page_metadata(text: str) -> tuple[str, str]:
    """Return source page label and LibreTexts URL from the pypdf text."""
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    url_match = re.search(r"https?://socialsci\.libretexts\.org/@go/page/\d+", text)
    url = url_match.group(0) if url_match else ""
    label = ""
    if lines:
        first = lines[0]
        if url and url in first:
            label = first.split(url, 1)[0].strip()
        elif re.fullmatch(r"\d+(?:\.\d+)*", first):
            label = first
    return label, url


def find_title(raw_text: str, source_label: str) -> str | None:
    """Find a section title only when it agrees with the page's source label."""
    lines = [line.strip() for line in raw_text.splitlines() if line.strip()]
    if not source_label or "." not in source_label:
        return None
    pieces = source_label.split(".")
    section_id = ".".join(pieces[:2])
    pattern = re.compile(rf"^{re.escape(section_id)}:\s+")
    for index, line in enumerate(lines[:8]):
        if pattern.match(line):
            title = line
            if title.endswith("-") and index + 1 < len(lines):
                title += lines[index + 1]
            return title
    return None


def markdown_page(record: dict) -> str:
    label = record["source_page_label"] or "not printed"
    url = record["source_url"]
    url_line = f"- LibreTexts source: {url}\n" if url else "- LibreTexts source: not printed on page\n"
    return (
        f"\n<!-- source_pdf=Full.pdf pdf_page={record['pdf_page']} "
        f"source_page_label={json.dumps(label)} source_url={json.dumps(url)} -->\n\n"
        f"## PDF page {record['pdf_page']}\n\n"
        f"- Source page label: {label}\n"
        f"{url_line}\n"
        f"{record['raw_text'].rstrip()}\n"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("pdf", nargs="?", default="Full.pdf", type=Path)
    parser.add_argument("--output", default=Path("knowledge"), type=Path)
    args = parser.parse_args()

    pdf_path = args.pdf.resolve()
    output = args.output.resolve()
    chapter_dir = output / "chapters"
    raw_dir = output / "raw"
    chapter_dir.mkdir(parents=True, exist_ok=True)
    raw_dir.mkdir(parents=True, exist_ok=True)

    reader = PdfReader(str(pdf_path))
    if len(reader.pages) != PARTS[-1].last_page:
        raise RuntimeError(f"Expected 374 pages, found {len(reader.pages)}; review PARTS before extracting")

    records: list[dict] = []
    with pdfplumber.open(pdf_path) as pdf:
        for page_number, (plumber_page, pypdf_page) in enumerate(zip(pdf.pages, reader.pages), 1):
            raw_text = plumber_page.extract_text(x_tolerance=2, y_tolerance=3) or ""
            pypdf_text = pypdf_page.extract_text() or ""
            label, url = page_metadata(pypdf_text)
            records.append(
                {
                    "pdf_page": page_number,
                    "source_page_label": label,
                    "source_url": url,
                    "char_count": len(raw_text),
                    "raw_text": raw_text,
                }
            )

    raw_path = raw_dir / "pages.jsonl"
    with raw_path.open("w", encoding="utf-8") as handle:
        for record in records:
            handle.write(json.dumps(record, ensure_ascii=False) + "\n")

    for part in PARTS:
        path = chapter_dir / f"{part.slug}.md"
        header = (
            f"# {part.title}\n\n"
            f"> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), "
            f"`Full.pdf`, PDF pages {part.first_page}-{part.last_page}. Text is a mechanical "
            "page-by-page extraction, not a summary. Consult the PDF for figures and layout.\n"
        )
        body = "".join(markdown_page(records[n - 1]) for n in range(part.first_page, part.last_page + 1))
        path.write_text(header + body, encoding="utf-8")

    starts: list[dict] = []
    for part in PARTS[1:15]:
        starts.append({"page": part.first_page, "title": part.title, "part": part})
        for page in range(part.first_page, part.last_page + 1):
            record = records[page - 1]
            title = find_title(record["raw_text"], record["source_page_label"])
            if title:
                starts.append({"page": page, "title": title, "part": part})
    for page, title in FRONT_ENTRIES:
        starts.append({"page": page, "title": title, "part": PARTS[0]})
    for page, title in BACK_ENTRIES:
        starts.append({"page": page, "title": title, "part": PARTS[-1]})

    deduped: list[dict] = []
    seen = set()
    for entry in sorted(starts, key=lambda item: (item["part"].first_page, item["page"], item["title"])):
        key = (entry["page"], entry["title"])
        if key not in seen:
            deduped.append(entry)
            seen.add(key)

    rows = []
    for index, entry in enumerate(deduped):
        part = entry["part"]
        later_same_part = [x["page"] for x in deduped[index + 1 :] if x["part"] == part and x["page"] > entry["page"]]
        end_page = (min(later_same_part) - 1) if later_same_part else part.last_page
        rel_path = f"chapters/{part.slug}.md"
        title = entry["title"].replace("|", "\\|")
        rows.append(f"| {title} | {part.title} | {entry['page']}-{end_page} | `{rel_path}` |")

    index_text = (
        "# Knowledge Index\n\n"
        "This index maps source topics to chapter files and stable PDF physical page numbers. "
        "The LibreTexts page labels restart within each web section, so each extracted page also records "
        "its source label and URL. Page ranges below are PDF pages, inclusive.\n\n"
        "## Chapter map\n\n"
        "| Chapter file | PDF pages |\n|---|---:|\n"
        + "\n".join(f"| [{p.title}](chapters/{p.slug}.md) | {p.first_page}-{p.last_page} |" for p in PARTS)
        + "\n\n## Topic map\n\n"
        "| Topic (source section title) | Book chapter | PDF pages | File path |\n"
        "|---|---|---:|---|\n"
        + "\n".join(rows)
        + "\n"
    )
    (output / "index.md").write_text(index_text, encoding="utf-8")

    counts = [record["char_count"] for record in records]
    low_pages = [record for record in records if record["char_count"] < 100]
    report = (
        "# Extraction Report\n\n"
        f"- Source file: `Full.pdf`\n"
        f"- SHA-256: `{sha256(pdf_path)}`\n"
        f"- PDF title: {reader.metadata.title}\n"
        f"- PDF author: {reader.metadata.author}\n"
        f"- PDF pages: {len(records)}\n"
        f"- Extraction timestamp (UTC): {datetime.now(timezone.utc).isoformat()}\n"
        "- Classification: text PDF; OCR not used\n"
        "- Extraction engines: pdfplumber for readable text; pypdf for page labels, URLs, and metadata\n"
        f"- Character count per page: min {min(counts)}, median {statistics.median(counts)}, max {max(counts)}\n"
        f"- Empty extracted pages: {sum(count == 0 for count in counts)}\n"
        f"- Chapter Markdown files: {len(PARTS)}\n"
        f"- Raw evidence: `raw/pages.jsonl` ({len(records)} records)\n\n"
        "## Low-text pages\n\n"
        "Pages below 100 extracted characters require explicit review. Covers are expected to be sparse. "
        "PDF page 327 is an effectively blank source page containing only a LibreTexts page label/URL; "
        "adjacent prose continues correctly from PDF page 326 to 328.\n\n"
        "| PDF page | Characters | Source label |\n|---:|---:|---|\n"
        + "\n".join(
            f"| {r['pdf_page']} | {r['char_count']} | {r['source_page_label'] or 'not printed'} |" for r in low_pages
        )
        + "\n\n## Version statements found in the source\n\n"
        "These are source-era requirements, not claims about current compatibility: MATLAB 2017a or later, "
        "EEGLAB 2022.0 or later, and ERPLAB 9.0 or later (PDF pages 9 and 18-19). The author reports mainly "
        "using MATLAB 2017a/2020b, EEGLAB 2020.0, and ERPLAB 8.23 while writing (PDF page 18). "
        "Current-version differences must be researched and recorded in the later knowledge-synthesis phase.\n\n"
        "## Traceability rules\n\n"
        "- Cite PDF physical pages as the stable locator.\n"
        "- Also retain source page labels and LibreTexts URLs when present.\n"
        "- Treat `raw/pages.jsonl` and the unchanged `Full.pdf` as the factual evidence layer.\n"
        "- Treat chapter Markdown as a readable mechanical extraction, not a substitute for visual PDF review.\n"
    )
    (output / "extraction_report.md").write_text(report, encoding="utf-8")


if __name__ == "__main__":
    main()
