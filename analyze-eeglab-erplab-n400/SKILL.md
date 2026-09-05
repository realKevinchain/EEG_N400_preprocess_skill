---
name: analyze-eeglab-erplab-n400
description: Run, audit, troubleshoot, and document the locked 905 EEGLAB/ERPLAB N400 workflow using label-resolved channel handling, permanent M1/M2/CB1/CB2 removal, common-average reference, rank-controlled ICA, non-destructive trial flags, fixed-scale N-labelled target-word ERPs, and the separate sentence analysis.
---

# Analyze EEGLAB/ERPLAB N400 — 905 CAR Standard

Treat 905 as the active study workflow. Keep earlier versions archived and never mix their outputs, reference rules, channel indices, or participant decisions with 905. Read [905-car-workflow.md](references/905-car-workflow.md) before running or changing any stage. For sentence analysis, also read [sentence-analysis.md](references/sentence-analysis.md).

## Preserve the channel and reference contract

- Resolve channels by case-insensitive labels at runtime; never carry numeric channel indices across channel deletion.
- Permanently remove `M1`, `M2`, `CB1`, and `CB2` before the initial reference. Never interpolate them and never include them in ICA or ERP.
- Retain `VEOG`, `HEOG`, and `TRIGGER` as auxiliary channels. Exclude all three from both common-average references and ICA. Filter EOG with EEG; resample but never filter `TRIGGER`.
- Gate A ordinary bad scalp channels are participant-specific. Exclude them from the initial CAR and ICA, then spherically interpolate them only after ICA cleaning.
- Before filtering and ICA, compute the initial CAR from the remaining good scalp channels.
- After ICA cleaning and any interpolation, perform the final CAR over all 60 retained scalp channels for every participant, including participants with no bad-channel interpolation. Clear invalid ICA matrices before the final CAR.

## Run the six stages

1. Audit the 67-channel raw import, the 60-channel retained scalp montage, events, continuous quality, and exact behavior alignment.
2. Complete Gate A, permanently remove the four fixed channels, and apply the initial good-scalp CAR.
3. Resample to 250 Hz; filter EEG/EOG in order with 0.1-Hz high-pass, explicit 50-Hz ERPLAB PMnotch using `Design='notch'`, and 30-Hz low-pass. Protect the trigger.
4. Create the 1-Hz/100-Hz ICA training copy, review ±100 µV candidate segments, require CAR rank `number of ICA channels − 1`, run fixed-seed extended Infomax with explicit PCA rank, transfer weights to the formal data, and remove only reviewed ICs.
5. Interpolate ordinary bad scalp channels, apply the universal final 60-channel CAR, create the EventList and 10 bins, extract one −200 to 800 ms target-word epoch set with −200 to 0 ms baseline, and write reviewed EEG artifacts to bit 1 without deleting epochs.
6. Write behavior errors to bit 2 in memory, create primary correct-clean and all-clean ERPs, report rejection and per-bin retention, reload-verify the ERPs, and create fixed-scale plots.

Use `scripts/905/config_905_subject_template.m` for each participant and write only under `N400_project/result_update/<ID>/905_car/`. Reload the participant config before every stage or gate helper. Never copy a bad-channel list, ICA component list, or rejected-epoch list between participants.

## Keep all four gates human-controlled

- Gate A: show candidate channels with normal scalp comparisons. The user decides `bad_channel_labels`.
- Gate B: show every ±100 µV rejected ICA-training segment plus a fixed retained sample. The user authorizes ICA training.
- Gate C: show component maps, spectra, activations, continuous activity, and EOG relationships. ICLabel is decision support only; the user supplies `removed_ics`.
- Gate D: pool conditions and inspect all 300 baseline-corrected epochs. Simple Voltage Threshold is only a candidate screen. The user manually adds/removes marks, clicks `UPDATE MARKS`, never `REJECT`, and saves the review copy as `new.set`. Audit all reject fields and event flags, reconcile them with the user, then enter one `artifact_bad_epochs` list while retaining all 300 physical epochs.

The assistant may prepare reports and read decisions but must not make a human-gate decision or silently union inconsistent reject fields.

## Lock outputs

- Target-word ERPs: generate separate fixed `[-20 20]` µV and `[-10 10]` µV versions; negative is plotted upward. Never autoscale individual panels.
- Every HC/LC target-word panel must display both accepted trial counts.
- Report total EEG-artifact rejection rate, primary exclusion rate, and original/accepted N for every bin.
- Preserve two ERP inclusion modes: primary correct-clean and all EEG-clean.
- Sentence plots remain fixed at `[-20 20]` µV, negative up, and show HC/LC N.

## Run the sentence branch only after Stage 6

Run `phaseS1_sentence_epoch.m`, then `phaseS2_sentence_word_aligned_erp.m`. Start from the post-ICA, interpolated, final-CAR continuous dataset; never rerun ICA. Reuse the Stage-6 ledger exactly. Keep sentence outputs under the participant's `sentence_epochs/` directory without modifying Stage 1–6 outputs.

## Validate before release

Run:

```bash
python3 scripts/905/validate_905_static.py
```

Run MATLAB Code Analyzer on every packaged `.m` file, then run the skill-creator `quick_validate.py` on this skill directory. Static checks establish the package contract only; claim a participant stage passed only when its runtime PASS log exists.

Use [quality-control.md](references/quality-control.md) for release checks and [locked-parameters.md](references/locked-parameters.md) when reporting or reviewing parameters.
