# Parameter Decision Table

Treat all numerical examples as candidates that require a design rationale. Enter the chosen value, evidence class, and justification in the study decision ledger.

| Decision | Source-informed option | Alternatives / trigger | Classification and citation |
|---|---|---|---|
| Canonical input | Import vendor data, inspect it, then save a `.set` without overwriting raw files | Plugin/options depend on acquisition system | `[DERIVED]` from PDF pp. 21, 301–340; import details are `[DECIDE]` |
| Channel locations | Load verified 3-D positions before interpolation/ICA interpretation | Digitized individual locations vs standard montage | `[BOOK]` PDF pp. 365–366; file is `[DECIDE]` |
| Initial reference | Reference early only if stored data are effectively unreferenced; use a single site in the book's example | Preserve acquisition reference until post-ICA when already referenced | `[BOOK]` PDF p. 365; site is `[DECIDE]` |
| Final reference | Use the convention that best supports comparison within the subfield; inspect multiple references | Average mastoids/P9-P10, average reference, or justified alternative | `[BOOK]` PDF pp. 143, 153, 367; final choice `[DECIDE]` |
| Downsampling | Book lab example records 500 Hz then uses 250 Hz; EEGLAB resampling applies anti-alias filtering | Retain rate for fast components, timing precision, or frequency analysis | `[BOOK]` PDF p. 364; target rate `[DECIDE]` |
| Analysis high-pass | Book lab often uses 0.1 Hz; slower components may require 0.05/0.01 Hz | Higher cutoffs require distortion evaluation and a strong rationale | `[BOOK]` PDF pp. 124, 129, 364–365; cutoff `[DECIDE]` |
| Analysis low-pass | Book clean-data example often uses 30 Hz | 20 Hz/steeper slope for high-frequency noise; less filtering for latency/onset questions | `[BOOK]` PDF pp. 124, 129, 365; cutoff/slope `[DECIDE]` |
| ICA-training filter | Appendix example uses 1–30 Hz, 48 dB/oct on a training copy | Adapt to data and installed filter implementation | `[BOOK]` PDF p. 366; use is `[DECIDE]`, not the final analysis filter |
| ICA-training rate | Appendix example uses 100 Hz to accelerate ICA when recording is long enough | Do not reduce when it leaves insufficient data or conflicts with goals | `[BOOK]` PDF p. 366; `[DECIDE]` |
| Bad channel | Combine visual inspection with impact on the planned score and SME | Book example flags >2 SD from comparison channels, or >1.5 SD for a main channel, as lab heuristics | `[BOOK]` PDF pp. 193–195, 365–366; threshold `[DECIDE]` |
| Interpolation timing | Ordinarily after high-pass filtering and after ICA correction in the appendix workflow | Earlier block-specific interpolation may be justified | `[BOOK]` PDF pp. 364, 367; `[DECIDE]` |
| Epoch | Appendix standard is −200 to +800 ms | Longer prestimulus for time-frequency or trial-stability goals; cover all planned measures | `[BOOK]` PDF p. 368; window `[DECIDE]` |
| Baseline | Ordinarily applied during bin-based epoching; book exercises commonly use prestimulus baseline | Alternative/no baseline requires scientific and overlap rationale | `[BOOK]` PDF pp. 52–54, 368; interval `[DECIDE]` |
| Blink/eye step detector | Appendix starting values: 200-ms window, 10-ms step; 50 µV blink, 32 µV eye movement | Tune after viewing flags and EOG; calibration/population may differ | `[BOOK]` PDF p. 368; values are starting points only |
| General artifact detector | Appendix suggests absolute and moving peak-to-peak together, 150 µV starting point across the epoch | Optimize against false positives/negatives and SME | `[BOOK]` PDF p. 368; threshold `[DECIDE]` |
| Participant rejection | Book lab rule: >25% rejected; sometimes 50% in clinical populations | Study/population-specific preregistered criterion | `[BOOK]` PDF p. 368; criterion must remain `[DECIDE]` |
| N400 condition | Unrelated targets are more negative than related targets in the ERP CORE example | Define semantic contrast and correctness rules from the actual paradigm | `[BOOK]` PDF p. 37; coding `[DECIDE]` |
| N400 window | Worked example scores mean amplitude 300–500 ms | Choose from independent literature/preregistration or unbiased procedure; broader activity may span about 200–600 ms | `[BOOK]` PDF pp. 37, 83; final window `[DECIDE]` |
| N400 electrode/ROI | Worked example starts at CPz, where that dataset's N400 was typically largest | Prespecified centro-parietal ROI, justified cluster, or component-specific site | `[BOOK]` PDF pp. 37, 61, 83; ROI `[DECIDE]` |
| Amplitude score | Fixed-window mean amplitude is transparent and linear | Peak/area/other scores require separate noise, bias, and validity assessment | `[BOOK]` PDF pp. 83–87, 272–300; method `[DECIDE]` |
| Difference wave | ERP CORE example uses unrelated minus related | Set and report subtraction order explicitly | `[BOOK]` PDF p. 37; sign `[DECIDE]` |
| Statistics | Paired test for two within-subject conditions; minimize unnecessary electrode factors | Repeated-measures/mixed models when design requires them | `[BOOK]` PDF pp. 86–90, 299–300; model `[DECIDE]` |

## Decision ledger columns

Use: `decision_id`, `stage`, `parameter`, `chosen_value`, `evidence_class`, `book_pages`, `external_source`, `rationale`, `decided_before_outcomes`, `decision_date`, `analyst`, and `deviation_from_plan`.

