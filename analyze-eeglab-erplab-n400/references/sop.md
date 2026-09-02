# 902 / 828update Six-Stage SOP

Use this as the short execution contract. Read `n400-six-stage-828update.md` for complete commands, filenames, GUI instructions, and failure handling.

## Stage 1: import and alignment audit

1. Import vendor data interactively and save `input_set/<ID>_imported.set/.fdt`.
2. Preserve 67 channels: EEG 1–64 including M1/M2, VEOG 65, HEOG 66, TRIGGER 67.
3. Verify unique labels, EEG coordinates, finite samples, continuous waveform quality, and trigger integrity.
4. Require 300 target events and exact trialwise behavior-code agreement.
5. Generate channel and one-second segment QC; do not reject automatically.

**Release:** 67 channels, 300 targets, 300 behavior rows, and 300/300 alignment.

## Stage 2: reference gate and final rereference

1. Generate Gate A QC for M1, M2, configured candidates, and automatic candidates.
2. Review candidates with FZ/CZ/CPZ/PZ comparisons.
3. Record scalp `bad_channels`; never include M1/M2/EOG/TRIGGER.
4. Use average M1/M2 by default. Require a written reason for M1-only or M2-only reference.
5. Rereference EEG 1–64 only; leave VEOG, HEOG, and TRIGGER unchanged.
6. Record bad channels now but do not interpolate them.

**Release:** reference residual within tolerance, auxiliary channels unchanged, events unchanged, and Gate A logged.

## Stage 3: formal filtering

1. Load the rereferenced continuous dataset.
2. Resample to 250 Hz.
3. Apply to EEG/EOG only, in order: bidirectional Butterworth 0.1-Hz high-pass, 50-Hz ERPLAB `PMnotch` with `Design='notch'`, then bidirectional Butterworth 30-Hz low-pass.
4. Preserve the resampled TRIGGER without filtering.
5. Compare before/after waveforms, spectra, edges, M1/M2, EOG, and key centroparietal channels.

**Release:** 250 Hz, 300 targets, finite data, preserved labels, reference residual, and unchanged post-resample TRIGGER.

## Stage 4: rank-controlled ICA

1. Exclude confirmed bad scalp channels from ICA; exclude the zero reference channel for single-side reference.
2. Create a 1-Hz/100-Hz training copy from formal data.
3. Retain each task start through target +1 s and apply the ±100 µV complete-segment rule.
4. At Gate B, review every rejected segment and the fixed retained sample.
5. Compute full numerical rank. Require the rank predicted by the reference and channel set.
6. Run fixed-seed extended Infomax; pass explicit PCA rank when rank is below channel count.
7. Transfer weights only to the matching reference/channel/order formal dataset.
8. At Gate C, use ICLabel only as decision support and remove only manually reviewed components.

**Release:** rank and channels recorded, training decisions reproduced, IC decisions documented, and ICA-clean data reload correctly.

## Stage 5: interpolation, bins, baseline epochs, and bit 1

1. Interpolate only Gate A bad scalp channels after ICA.
2. Clear invalid ICA matrices while retaining training and rejection metadata.
3. Create EventList and the locked HC/LC × five-SNR bins.
4. Require 30 targets per bin and exclude codes 98/99 from target bins.
5. Extract one nominal −200 to 800 ms epoch dataset and apply −200 to 0 ms baseline.
6. Do not create an unbaselined formal epoch dataset.
7. At Gate D, review all 300 pooled epochs without condition labels. Simple Voltage Threshold is only a candidate screen.
8. Manually add/remove marks, click `UPDATE MARKS`, never `REJECT`, and save a separate `<ID>_gateD_manual_review.set` without overwriting the formal epoch file.
9. Audit `rejmanual`, `rejmanualE`, `rejthresh`, related reject fields, and event flags. Reconcile ambiguity with the user and enter one unified `artifact_bad_epochs` list.
10. Synchronize reviewed EEG artifact bit 1 across reject, epoch, event, and EVENTLIST structures without deleting trials.

**Release:** 10×30 bins, 300 physical epochs, baseline mean near zero, synchronized bit 1, and reload equality.

## Stage 6: behavior, ERP, and QC

1. Recheck trialwise behavior code and bin alignment.
2. Write behavior error bit 2 in the primary in-memory copy.
3. Average primary ERP from correct and EEG-clean trials.
4. Average all-clean ERP from every EEG-clean trial.
5. Write trial ledger and per-bin original/artifact/behavior/accepted counts.
6. Save and reload both ERPs; require exact bindata, SEM/binerror, dataquality, time, and count equality.
7. Generate CZ and CZ/CP1/CPZ/CP2/P3/PZ/P4 plots with LC−HC, fixed `[-20 20]` µV, negative up, and HC/LC N in every panel.

**Release:** both ERPs reload exactly, counts match the ledger, plots exist, and the runtime PASS log exists.

## Post-Stage-6 sentence deliverable

1. Run S1 from the post-ICA interpolated continuous data: sentence onset `[-200 4000]` ms, sentence-onset baseline `[-200 0]` ms.
2. Run S2 without re-baselining: shift only the display axis to target onset and use fixed `[-2300 800]` ms.
3. Reuse the Stage-6 trial ledger exactly and average variable edges with `omitnan`.
4. Save 20 PNG and 20 FIG files under `sentence_epochs/`: 2 modes × 2 sites × 5 SNR, fixed ±20 µV, negative up, with HC/LC N.

**Release:** ledger rows and bin counts match Stage 6, the complete 40-file plot set passes figure-property checks, and no six-stage output was modified.

The 01B configuration is a pilot audit record only. Re-run Gates A–D for each participant; never copy 01B channel, IC, or epoch numbers.
