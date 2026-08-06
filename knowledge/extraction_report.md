# Extraction Report

- Source file: `Full.pdf`
- SHA-256: `e17d85155e9d9b8f1bf93beb28bb451d953e61e8f0673758d72139ffd4524197`
- PDF title: Applied Event-Related Potential Data Analysis
- PDF author: Steven J Luck
- PDF pages: 374
- Extraction timestamp (UTC): 2026-07-17T06:01:46.535892+00:00
- Classification: text PDF; OCR not used
- Extraction engines: pdfplumber for readable text; pypdf for page labels, URLs, and metadata
- Character count per page: min 56, median 2487.5, max 5606
- Empty extracted pages: 0
- Chapter Markdown files: 16
- Raw evidence: `raw/pages.jsonl` (374 records)

## Low-text pages

Pages below 100 extracted characters require explicit review. Covers are expected to be sparse. PDF page 327 is an effectively blank source page containing only a LibreTexts page label/URL; adjacent prose continues correctly from PDF page 326 to 328.

| PDF page | Characters | Source label |
|---:|---:|---|
| 1 | 92 | not printed |
| 2 | 91 | not printed |
| 327 | 56 | 11.14.3 |

## Version statements found in the source

These are source-era requirements, not claims about current compatibility: MATLAB 2017a or later, EEGLAB 2022.0 or later, and ERPLAB 9.0 or later (PDF pages 9 and 18-19). The author reports mainly using MATLAB 2017a/2020b, EEGLAB 2020.0, and ERPLAB 8.23 while writing (PDF page 18). Current-version differences must be researched and recorded in the later knowledge-synthesis phase.

## Traceability rules

- Cite PDF physical pages as the stable locator.
- Also retain source page labels and LibreTexts URLs when present.
- Treat `raw/pages.jsonl` and the unchanged `Full.pdf` as the factual evidence layer.
- Treat chapter Markdown as a readable mechanical extraction, not a substitute for visual PDF review.
