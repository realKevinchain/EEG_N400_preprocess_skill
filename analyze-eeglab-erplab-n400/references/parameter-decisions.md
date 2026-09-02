# Parameter Decision Table

Treat general numerical examples as candidates that require a design rationale. For the executable 902/828update workflow, preserve the locked values below unless a formally documented protocol revision replaces the workflow version.

| Decision | Source-informed option | Alternatives / trigger | Classification and citation |
|---|---|---|---|
| Canonical input | Import vendor data, inspect it, then save a `.set` without overwriting raw files | Plugin/options depend on acquisition system | `[DERIVED]` from PDF pp. 21, 301–340; import details are `[DECIDE]` |
| Channel locations | Load verified 3-D positions before interpolation/ICA interpretation | Digitized individual locations vs standard montage | `[BOOK]` PDF pp. 365–366; file is `[DECIDE]` |
| 828update final reference | Apply the final reference before formal filtering and ICA; use average M1/M2 by default | M1-only or M2-only requires a participant-specific abnormality and written reason | Study protocol `[DECIDE]`; general reference evidence `[BOOK]` PDF pp. 143, 153, 367 |
| 828update downsampling | Resample formal data to 250 Hz before formal filtering | A different rate requires a new workflow version | Locked study decision; contextual support `[BOOK]` PDF p. 364 |
| 902 analysis filter | At 250 Hz apply 0.1-Hz Butterworth HP, 50-Hz ERPLAB PMnotch with `Design='notch'`, then 30-Hz Butterworth LP to EEG/EOG; resample but never filter TRIGGER | The notch is redundant after the 30-Hz LP but remains explicit; any cutoff/order/design change requires a new version | Locked study decision validated on 01B; contextual support `[BOOK]` PDF pp. 124, 129, 364–365 |
| 828update ICA training | Add 1-Hz high-pass, resample to 100 Hz, retain task start through target +1 s, and apply ±100 µV complete-segment review | Change only through a versioned protocol revision | Locked study decision; training-copy rationale `[BOOK]` PDF p. 366 |
| Bad channel | Combine visual inspection with impact on the planned score and SME | Book example flags >2 SD from comparison channels, or >1.5 SD for a main channel, as lab heuristics | `[BOOK]` PDF pp. 193–195, 365–366; threshold `[DECIDE]` |
| 828update interpolation timing | Interpolate confirmed bad scalp channels after ICA cleaning and before EventList/epoching | Never interpolate M1/M2/EOG/TRIGGER | Locked study decision; contextual support `[BOOK]` PDF pp. 364, 367 |
| 828update epoch | Use nominal −200 to +800 ms target-locked epochs | A different window requires a new workflow version | Locked study decision; contextual support `[BOOK]` PDF p. 368 |
| 828update baseline | Apply −200 to 0 ms during the only formal epoch extraction | Do not create an unbaselined formal branch | Locked study decision; contextual support `[BOOK]` PDF pp. 52–54, 368 |
| Blink/eye step detector | Appendix starting values: 200-ms window, 10-ms step; 50 µV blink, 32 µV eye movement | Tune after viewing flags and EOG; calibration/population may differ | `[BOOK]` PDF p. 368; values are starting points only |
| 902 final EEG artifact flag | Use Simple Voltage Threshold only for candidates; condition-blind manual add/remove, `UPDATE MARKS`, separate review copy, reject-field audit, then one reconciled list synchronized as bit 1 | Never click `REJECT`, delete epochs, overwrite the formal epoch set, or blindly union inconsistent fields | Locked 01B-validated procedure; visual review principles `[BOOK]` PDF pp. 196–240, 368 |
| Official ERP display | Fixed `[-20 20]` µV in every panel, negative up, HC/LC N shown | `[-10 10]` only as separately named requested comparison; exploratory if clipped | Locked 902 display standard `[DECIDE]`; 01B clipping check |
| Sentence supplement | S1 `[-200 4000]` with sentence-onset baseline; S2 fixed `[-2300 800]`, no rebaseline, `omitnan`, exact Stage-6 ledger reuse, fixed ±20 µV | Change only once at protocol level, never per participant | Locked 902 study deliverable validated on 01B `[DECIDE]` |
| Participant rejection | Book lab rule: >25% rejected; sometimes 50% in clinical populations | Study/population-specific preregistered criterion | `[BOOK]` PDF p. 368; criterion must remain `[DECIDE]` |
| N400 condition | Unrelated targets are more negative than related targets in the ERP CORE example | Define semantic contrast and correctness rules from the actual paradigm | `[BOOK]` PDF p. 37; coding `[DECIDE]` |
| N400 window | Worked example scores mean amplitude 300–500 ms | Choose from independent literature/preregistration or unbiased procedure; broader activity may span about 200–600 ms | `[BOOK]` PDF pp. 37, 83; final window `[DECIDE]` |
| N400 electrode/ROI | Worked example starts at CPz, where that dataset's N400 was typically largest | Prespecified centro-parietal ROI, justified cluster, or component-specific site | `[BOOK]` PDF pp. 37, 61, 83; ROI `[DECIDE]` |
| Amplitude score | Fixed-window mean amplitude is transparent and linear | Peak/area/other scores require separate noise, bias, and validity assessment | `[BOOK]` PDF pp. 83–87, 272–300; method `[DECIDE]` |
| Difference wave | ERP CORE example uses unrelated minus related | Set and report subtraction order explicitly | `[BOOK]` PDF p. 37; sign `[DECIDE]` |
| Statistics | Paired test for two within-subject conditions; minimize unnecessary electrode factors | Repeated-measures/mixed models when design requires them | `[BOOK]` PDF pp. 86–90, 299–300; model `[DECIDE]` |

## Decision ledger columns

Use: `decision_id`, `stage`, `parameter`, `chosen_value`, `evidence_class`, `book_pages`, `external_source`, `rationale`, `decided_before_outcomes`, `decision_date`, `analyst`, and `deviation_from_plan`.
