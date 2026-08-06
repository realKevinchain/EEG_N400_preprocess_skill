# Source Map

Use PDF physical page numbers as the stable locator. The LibreTexts page labels restart within sections. The full mechanical extraction remains in the repository's `knowledge/chapters/`; `Full.pdf` and `knowledge/raw/pages.jsonl` are the factual evidence layer.

Primary source: Luck, S. J. (2022), *Applied Event-Related Potential Data Analysis*, LibreTexts, [DOI 10.18115/D5QG92](https://doi.org/10.18115/D5QG92), CC BY 4.0. Preserve this attribution when reusing source-derived material.

## Evidence labels

| Label | Meaning | Required handling |
|---|---|---|
| `[BOOK]` | Explicitly stated in the source book | Cite PDF page(s) |
| `[DERIVED]` | Inference or adaptation from the book | Explain the inference and cite supporting pages |
| `[GENERAL]` | External domain practice | Name or cite the external basis |
| `[DECIDE]` | Study-specific researcher choice | Keep configurable and document rationale |
| `[UNVERIFIED]` | Not confirmed in source or installed software | Do not present as established or execute blindly |

## Topic-to-source map

| Topic | Source sections | PDF pages | Extracted file |
|---|---|---:|---|
| Requirements and source-era versions | Hardware requirements; 1.2 | 9, 18–19 | `knowledge/chapters/00-front-matter.md`; `01-first-steps.md` |
| Load and inspect EEG | 1.3–1.5; 2.3 | 21–24, 38–41 | `01-first-steps.md`; `02-single-participant-n400.md` |
| N400 paradigm and expected effect | 2.2 | 37 | `02-single-participant-n400.md` |
| Filtering | 2.4; 4.1–4.14; Appendix 3 | 42–44, 98–129, 364–365 | `02-single-participant-n400.md`; `04-filtering.md`; `14-appendix-processing-pipeline.md` |
| EventList and BinList | 2.5–2.6; 6.3–6.6 | 45–51, 160–168 | `02-single-participant-n400.md`; `06-bins-averaging-baseline-data-quality.md` |
| Epoch and baseline | 2.7; 6.1–6.14; Appendix 3 | 52–54, 154–184, 367–368 | `02-single-participant-n400.md`; `06-bins-averaging-baseline-data-quality.md`; `14-appendix-processing-pipeline.md` |
| Artifact detection and rejection | 2.8; 8.1–8.19; Appendix 3 | 55–57, 196–240, 368 | `02-single-participant-n400.md`; `08-artifact-detection-rejection.md`; `14-appendix-processing-pipeline.md` |
| Averaging and SME/data quality | 2.9–2.10; 6.6–6.7 | 58–66, 167–170 | `02-single-participant-n400.md`; `06-bins-averaging-baseline-data-quality.md` |
| Reference and channel operations | 5.1–5.13 | 130–153 | `05-referencing-channel-operations.md` |
| Bad channels and interpolation | 7.1–7.8; Appendix 3 | 185–195, 365–366 | `07-eeg-inspection-bad-channels.md`; `14-appendix-processing-pipeline.md` |
| ICA artifact correction | 9.1–9.11; Appendix 3 | 241–271, 366–368 | `09-ica-artifact-correction.md`; `14-appendix-processing-pipeline.md` |
| N400 amplitude and statistics | 3.7–3.11 | 83–94 | `03-multiple-participant-n400.md` |
| General scoring and statistics | 10.1–10.12 | 272–300 | `10-scoring-statistics.md` |
| MATLAB scripting and cohort pipeline | 11.1–11.19 | 301–340 | `11-scripting.md` |
| End-to-end example pipeline | Appendix 3 | 364–369 | `14-appendix-processing-pipeline.md` |

## High-value explicit statements

- `[BOOK]` Inspect event information, continuous/epoched waveforms, rejected/accepted counts, and data-quality metrics repeatedly, not only at the end (PDF pp. 70, 97).
- `[BOOK]` The source's worked N400 has a larger negativity for unrelated than related targets, approximately 200–600 ms, maximal around CPz; its scored example uses mean amplitude 300–500 ms at CPz (PDF pp. 37, 83–85).
- `[BOOK]` A worked value is not universal: filter distortion must be assessed, reference should suit the subfield, and measurement windows must be chosen without outcome-driven bias (PDF pp. 124, 143, 299–300).
- `[BOOK]` Use ERPLAB bin-based epoching when subsequent ERPLAB operations depend on bin information (PDF p. 368).
- `[BOOK]` Inspect the EEG at short and long time scales, relate bad-channel decisions to the planned measurement and SME, and retain participant-specific decisions for scripting (PDF pp. 365–366).
- `[BOOK]` ICA training uses a specially prepared copy; review component maps and time courses, transfer weights to the pre-ICA data, then verify the corrected signals (PDF pp. 366–368).
- `[BOOK]` Set exclusion criteria before inspecting outcomes; the book reports lab-specific rejection rules that must not be universalized (PDF p. 368).
