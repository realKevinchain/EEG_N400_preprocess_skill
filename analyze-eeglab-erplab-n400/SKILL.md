---
name: analyze-eeglab-erplab-n400
description: Run, audit, troubleshoot, and document the locked 902/828update EEGLAB-ERPLAB N400 workflow validated on pilot 01B. Use for six-stage preprocessing, four human gates, M1/M2 rereferencing, 0.1-Hz HP plus explicit 50-Hz PMnotch plus 30-Hz LP at 250 Hz, rank-controlled ICA, condition-blind artifact marks, behavior linkage, fixed-scale ERP plots, or the separate sentence-onset/word-aligned analysis.
---

# Analyze EEGLAB/ERPLAB N400 — 902 Standard

Treat 902 as the default executable workflow. It preserves the six official stages and four human gates, and adds the post-Stage-6 sentence deliverable as a separate supplemental branch. Never silently change ordering, parameters, gate decisions, plot scales, or trial inclusion.

Read [n400-six-stage-828update.md](references/n400-six-stage-828update.md) before running or changing a stage. Read [sentence-onset-word-aligned-supplemental.md](references/sentence-onset-word-aligned-supplemental.md) before the sentence analysis.

## Run the six official stages

1. Audit imported EEG and exact trialwise behavior alignment.
2. Review M1/M2 and bad-channel candidates, then apply the final reference.
3. Resample to 250 Hz. Filter EEG/EOG in this explicit order: 0.1-Hz high-pass, 50-Hz ERPLAB PMnotch with `Design='notch'`, then 30-Hz low-pass. Resample TRIGGER but never filter it.
4. Build the 1-Hz/100-Hz ICA training copy, review ±100 µV task segments, compute numerical rank, run extended Infomax with explicit PCA when required, transfer weights, and remove only reviewed ICs.
5. Interpolate confirmed bad scalp channels after ICA, create EventList and 10 bins, extract one −200 to 800 ms epoch set with mandatory −200 to 0 ms baseline, and write reviewed EEG artifacts to bit 1 without deleting trials.
6. Write behavior errors to bit 2 in memory, create primary correct-clean and all-clean ERPs, reload-verify them, and generate fixed-scale target-word ERP plots.

The 50-Hz notch precedes the 30-Hz low-pass. It is scientifically redundant in the final 0.1–30-Hz output but is retained as an explicit locked step. Omitting `Design='notch'` can make ERPLAB's PMnotch silently pass data through. The 01B diagnostic measured 56.7 dB attenuation at exactly 50.00 Hz.

## Prepare each participant independently

1. Copy `scripts/828update/config_828_subject_template.m` to `config_828_<ID>.m`.
2. Replace all TODO paths and re-assert machine-specific paths in the participant file.
3. Enter only decisions reviewed for that participant.
4. Reload the config before every stage or gate helper.
5. Write outputs only to `N400_project/result_update/<ID>/`.

Use `config_828_01B.m` and [01B-validated-pilot-902.md](references/01B-validated-pilot-902.md) only as an audit example. Never copy 01B's T7/T8 decision, IC list, or bad-epoch list to another participant.

## Keep all four gates human-controlled

- Gate A: review M1, M2, every bad-channel candidate, and normal comparison channels before setting `reference_review_complete=true`.
- Gate B: review every ±100 µV candidate task segment and the fixed retained sample before setting `run_ica=true`.
- Gate C: review maps, spectra, activations, continuous data, and EOG relationships before setting `ica_review_complete=true`. ICLabel is decision support, not an automatic verdict. A reviewed zero-component decision is valid.
- Gate D: pool conditions and inspect every formal baseline-corrected epoch. ERPLAB Simple Voltage Threshold is a candidate screen only. Manually add/remove marks, click `UPDATE MARKS`, never `REJECT`, and save a separate `<ID>_gateD_manual_review.set` copy. Audit `EEG.reject.rejmanual`, `rejmanualE`, `rejthresh`, related fields, and event flags; reconcile ambiguity with the user. Enter one reviewed `artifact_bad_epochs` list and keep all 300 physical epochs.

The assistant may prepare diagnostics and read marks, but must not decide a gate or infer a union of inconsistent reject fields without the user's confirmation.

## Lock output figures

- Official single-word ERP plots use one fixed scale of `[-20 20]` µV in every panel, negative plotted upward.
- Every HC/LC panel displays both accepted trial counts: `HC N=...` and `LC N=...`.
- A `[-10 10]` µV comparison may be generated only on request, under a distinct filename/suffix without overwriting the official plot. Treat it as exploratory if any waveform clips.

## Run the separate sentence deliverable after Stage 6

Run `phaseS1_sentence_epoch.m`, then `phaseS2_sentence_word_aligned_erp.m`.

- S1 epochs sentence onset at `[-200 4000]` ms and applies `[-200 0]` ms baseline relative to sentence onset.
- S2 shifts only the display axis to target-word onset; it never re-baselines. Use fixed display `[-2300 800]` ms and `omitnan` edge averaging.
- Reuse the official Stage-6 trial ledger exactly.
- Produce 20 PNG and 20 FIG files: 2 inclusion modes × 2 sites × 5 SNR levels, fixed `[-20 20]` µV, negative up, with HC and LC N in every figure.
- Keep everything under `sentence_epochs/`; never modify or overwrite Phase 01–06 outputs.

## Validate before release

Run:

```bash
python3 scripts/828update/validate_828_static.py
```

Run MATLAB Code Analyzer on every packaged `.m` file and run the skill-creator `quick_validate.py`. Static checks validate the package contract only; never claim a participant stage passed unless its runtime PASS log exists.

## Reference map

- Full locked protocol: [n400-six-stage-828update.md](references/n400-six-stage-828update.md)
- Short stage contract: [sop.md](references/sop.md)
- Release checks: [quality-control.md](references/quality-control.md)
- Parameter provenance: [parameter-decisions.md](references/parameter-decisions.md)
- GUI/MATLAB mapping: [gui-matlab-crosswalk.md](references/gui-matlab-crosswalk.md)
- Sentence branch: [sentence-onset-word-aligned-supplemental.md](references/sentence-onset-word-aligned-supplemental.md)
- Validated 01B pilot record: [01B-validated-pilot-902.md](references/01B-validated-pilot-902.md)
- Environment and known issues: [environment-notes-and-known-issues.md](references/environment-notes-and-known-issues.md)
- N400 scoring/statistics: [n400-design-scoring-statistics.md](references/n400-design-scoring-statistics.md)
- Source map: [source-map.md](references/source-map.md)
- Version cautions: [version-compatibility.md](references/version-compatibility.md)

Use `[BOOK]`, `[DERIVED]`, `[GENERAL]`, `[DECIDE]`, and `[UNVERIFIED]` labels when discussing evidence. State any difference between general guidance and the locked 902 implementation instead of altering the workflow.
