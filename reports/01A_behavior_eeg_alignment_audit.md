# 01A behavior–EEG alignment audit

Audit date: 2026-07-23  
Scope: read-only validation of the canonical imported EEGLAB dataset and 01A behavior CSV.  
Inputs:

- `/Users/kevinchain/Desktop/N400_project/input_set/01A_imported.set`
- `/Users/kevinchain/Desktop/N400_project/input_set/01A_imported.fdt`
- `/Users/kevinchain/Desktop/N400_project/behavior/01A.csv`
- `/Users/kevinchain/Desktop/N400_project/events/BDF_HC_LC_SNR.txt`

No source file was modified.

## Result

**Gate status: PASS.** `[DERIVED]`

- The behavior-derived sequence of 300 target-word condition codes matches the 300 EEG target events exactly, in order.
- Mismatch count: **0/300**.
- The user confirmed on 2026-07-23 that behavior `Subject = 11` is the intended internal identifier for participant `01A`. `[DERIVED]`

## Canonical SET/FDT validation

| Check | Result |
|---|---|
| SET format | MATLAB v5 MAT-file |
| SET name / filename | `01A_imported` / `01A_imported.set` |
| Saved flag | `yes` |
| Referenced data file | `01A_imported.fdt` |
| Sampling rate | 1000 Hz |
| Channels | 67 |
| Samples | 3,642,200 |
| Trials | 1 continuous record |
| Duration | 3,642.199 s |
| FDT byte count | 976,109,600 |
| Expected byte count | 67 × 3,642,200 × 4 = 976,109,600 |
| Import history | `loadcurry(..., 'KeepTriggerChannel', 'True', 'CurryLocations', 'True')` |

All values above are `[DERIVED]` from the saved SET/FDT.

## Channel-location validation

- 67/67 labels are present and unique. `[DERIVED]`
- 64/67 channels have XYZ coordinates. `[DERIVED]`
- The only channels without XYZ are `VEOG`, `HEOG`, and `TRIGGER`, as expected for this import. `[DERIVED]`
- Key indices: `CZ=30`, `CPZ=39`, `PZ=50`, `M1=44`, `M2=45`, `VEOG=65`, `HEOG=66`, `TRIGGER=67`. `[DERIVED]`
- Labels are stored in uppercase in this SET; comparisons should therefore be case-insensitive. `[DERIVED]`

The coordinates remain a manufacturer/template montage and must not be described as participant-specific digitization. `[DERIVED]`

## EEG event validation

| Check | Result |
|---|---|
| Total events | 602 |
| Experimental events | 600 |
| Sentence–target pairs | 300 |
| Invalid sentence–target pairs | 0 |
| Target events | 300 |
| Event latencies ordered | Yes |
| Rest markers | `99` × 1; `98` × 1 |
| Each of the 20 experimental codes | 30 occurrences |

For every experimental pair, `target code = sentence code + 100`. `[DERIVED]`

## Behavior-table validation

| Check | Result |
|---|---|
| Data rows | 300 |
| Columns | 10 |
| Missing cells | 0 |
| Condition values | `HC`, `LC` |
| SNR values | `-4`, `-2`, `4`, `6`, `quiet` |
| Correct values | `0`, `1` |
| HC / LC rows | 150 / 150 |
| Rows per Condition × SNR cell | 30 |
| Correct / incorrect rows | 158 / 142 |
| `Response1.RT` equals `RT` | All rows |
| `T/F` equals `Correct` | All rows |

`Block` is unique and strictly increasing from 11 to 314, with four absent values: 71, 132, 193, and 254. The meaning of these four gaps is not encoded in the available files and is therefore `[UNVERIFIED]`; they were not treated as missing EEG trials.

Behavior `Subject` is `11` on all 300 rows. The user confirmed on 2026-07-23 that it maps to participant label `01A`. `[DERIVED]`

## Target-code mapping used for alignment

| Behavior condition | EEG target code |
|---|---:|
| HC, −4 dB | 111 |
| HC, −2 dB | 112 |
| HC, +4 dB | 113 |
| HC, +6 dB | 114 |
| HC, quiet | 115 |
| LC, −4 dB | 121 |
| LC, −2 dB | 122 |
| LC, +4 dB | 123 |
| LC, +6 dB | 124 |
| LC, quiet | 125 |

This mapping is `[DERIVED]` from the existing sentence-onset BDF plus the verified `target = sentence + 100` event relationship.

## Trialwise alignment outcome

Alignment method:

1. Preserve the 300 behavior rows in file order.
2. Convert each row's `condition` and `snr` to its expected target-word code using the mapping above.
3. Extract EEG event codes 111–115 and 121–125 in latency order.
4. Compare the two 300-element sequences position by position.

| Behavior rows | EEG target events | Exact matches | Mismatches |
|---:|---:|---:|---:|
| 300 | 300 | 300 | 0 |

No mismatch rows exist to report. `[DERIVED]`

## Behavior counts for later Correct-only analysis

These are descriptive counts only; no EEG artifact exclusions have yet been applied.

| Condition | Correct | Total | Accuracy |
|---|---:|---:|---:|
| HC −4 dB | 8 | 30 | 26.7% |
| HC −2 dB | 10 | 30 | 33.3% |
| HC +4 dB | 21 | 30 | 70.0% |
| HC +6 dB | 19 | 30 | 63.3% |
| HC quiet | 29 | 30 | 96.7% |
| LC −4 dB | 5 | 30 | 16.7% |
| LC −2 dB | 4 | 30 | 13.3% |
| LC +4 dB | 16 | 30 | 53.3% |
| LC +6 dB | 23 | 30 | 76.7% |
| LC quiet | 23 | 30 | 76.7% |

The low Correct-only counts in several noisy conditions must be carried forward as a QC concern; final usable counts can only be determined after EEG artifact rejection. `[DERIVED]`

## Gate decision

The user confirmed on 2026-07-23:

> In the behavioral export, `Subject = 11` corresponds to EEG participant `01A`.

The behavior–EEG identity and trialwise condition-code alignment gate therefore passes. `[DERIVED]`

No filtering, rereferencing, resampling, channel rejection, ICA, epoching, artifact rejection, EventList/BinList creation, or averaging was performed.
