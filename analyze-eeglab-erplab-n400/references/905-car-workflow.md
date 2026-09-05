# 905 CAR six-stage workflow

Version: 905, locked 2026-09-05.

This is the executable contract for every participant. The reference and retained montage differ from archived 902 outputs, so the complete participant pipeline must be rerun under 905; do not continue a 905 stage from a 902 SET file.

## Contents

1. [Channel contract](#channel-contract)
2. [Configuration](#configuration)
3. [Stage 1 — import and audit](#stage-1--import-and-audit)
4. [Stage 2 — Gate A and initial CAR](#stage-2--gate-a-and-initial-car)
5. [Stage 3 — formal filtering](#stage-3--formal-filtering)
6. [Stage 4 — ICA training and cleaning](#stage-4--ica-training-and-cleaning)
7. [Stage 5 — interpolation, universal final CAR, epochs, and Gate D](#stage-5--interpolation-universal-final-car-epochs-and-gate-d)
8. [Stage 6 — behavior, ERP, rejection report, and plots](#stage-6--behavior-erp-rejection-report-and-plots)
9. [Sentence branch](#sentence-branch)
10. [Participant release rule](#participant-release-rule)

## Channel contract

The imported dataset is expected to contain 67 channels:

- 64 acquisition EEG channels, including `M1`, `M2`, `CB1`, and `CB2`;
- `VEOG` and `HEOG`;
- `TRIGGER`.

Identify every channel by label, not by its acquisition index.

Before the initial CAR, permanently remove `M1`, `M2`, `CB1`, and `CB2`. The analysis dataset then contains 63 channels: 60 retained scalp channels plus three auxiliary channels. The four fixed exclusions are never interpolated.

`VEOG`, `HEOG`, and `TRIGGER` are retained but excluded from CAR and ICA. EOG is filtered with EEG. `TRIGGER` is resampled with the dataset but its samples are copied through every filter step unchanged.

Ordinary bad scalp channels are decided separately for each participant at Gate A. They remain in the dataset so their labels and positions are preserved, but are excluded from the initial CAR and ICA. They are replaced by spherical interpolation after ICA.

## Configuration

Copy `scripts/905/config_905_subject_template.m` to a participant-specific config outside the packaged skill, then set the participant, behavior number, project path, absolute 905 skill path, EEGLAB path, and only that participant's reviewed decisions.

Important fields:

```matlab
cfg.fixed_excluded_labels = {'M1','M2','CB1','CB2'};
cfg.bad_channel_candidate_labels = {};
cfg.bad_channel_labels = {};
cfg.reference_mode = 'common_average';
cfg.final_car_for_all = true;
```

Never replace these labels with numeric indices. The runtime resolves labels after each channel operation.

All outputs belong under:

```text
N400_project/result_update/<ID>/905_car/
```

Existing files stop a stage instead of being overwritten.

## Stage 1 — import and audit

Load `input_set/<ID>_imported.set` and verify:

- 67 unique channel labels and finite samples;
- exactly the four fixed-exclusion labels and three auxiliary labels;
- 60 retained scalp channels with finite coordinates;
- 300 target events (`111–115`, `121–125`);
- 300 behavior rows with exact trialwise target-code agreement.

Generate channel QC only for the 60 retained scalp candidates. Generate one-second continuous-segment QC. These are screens, not automatic rejection decisions.

Release Stage 1 only when the channel, event, behavior-alignment, channel-QC, segment-QC, and PASS-log checks succeed.

## Stage 2 — Gate A and initial CAR

Generate the Gate A table from configured candidates, automatic candidates, and normal comparison channels `FZ`, `CZ`, `CPZ`, and `PZ`. The user decides ordinary `bad_channel_labels`.

After Gate A:

1. Permanently remove `M1`, `M2`, `CB1`, and `CB2` by label.
2. Resolve the 60 retained scalp channels and the three auxiliary channels again.
3. Exclude ordinary bad scalp channels and all auxiliary channels from the initial CAR.
4. Compute the common average from the remaining good scalp channels.
5. Apply that reference only to those good scalp channels; leave bad and auxiliary samples unchanged at this stage.

Store the exact labels used in the CAR metadata. Require the good-scalp pointwise mean to be below tolerance and require auxiliary samples and events to remain unchanged.

## Stage 3 — formal filtering

Starting from the initial-CAR continuous dataset:

1. Resample the whole dataset to 250 Hz.
2. Save the resampled `TRIGGER` samples.
3. Filter scalp EEG and EOG, in this order:
   - 0.1-Hz Butterworth high-pass, order 2;
   - 50-Hz ERPLAB PMnotch with `Design='notch'`;
   - 30-Hz Butterworth low-pass, order 8.
4. Confirm the trigger samples are pointwise identical to their post-resample copy.
5. Confirm the mean of the initial-CAR good scalp channels remains near zero.

The explicit 50-Hz notch is retained from the agreed protocol even though the following 30-Hz low-pass makes it redundant in the final analysis band.

## Stage 4 — ICA training and cleaning

ICA uses the retained scalp channels minus Gate A ordinary bad channels. It never includes the four fixed exclusions, EOG, or trigger.

Create a training copy from the formal 0.1–30-Hz, 250-Hz data:

- add the training-only 1-Hz high-pass;
- resample to 100 Hz;
- retain trial start through target word plus 1 second;
- mark complete task segments outside ±100 µV as Gate B candidates.

At Gate B, the user reviews every candidate segment and a reproducible sample of retained segments. Only then may ICA run.

For `m` ICA channels under CAR, require the expected rank `m−1`. Compute the numerical rank and stop if it differs. Run fixed-seed extended Infomax and pass explicit PCA rank when rank is below channel count.

Transfer weights only to the matching formal dataset with identical reference, labels, order, and `icachansind`. At Gate C, the user reviews component maps, spectra, activations, continuous data, and EOG relationships. ICLabel supports but does not make the decision. Remove only the supplied `removed_ics`; zero removals is valid when explicitly reviewed.

## Stage 5 — interpolation, universal final CAR, epochs, and Gate D

Starting from ICA-clean formal data:

1. Spherically interpolate only Gate A ordinary bad scalp channels.
2. Never interpolate `M1`, `M2`, `CB1`, `CB2`, EOG, or trigger.
3. Clear ICA matrices after retaining ICA training and rejection metadata.
4. For every participant, compute a final CAR over all 60 retained scalp channels. Exclude `VEOG`, `HEOG`, and `TRIGGER`.
5. Require the final 60-channel pointwise scalp mean to be near zero and auxiliary samples to remain unchanged.
6. Save the final-CAR continuous checkpoint. This is also the source for sentence analysis.
7. Create the EventList and the locked ten HC/LC × SNR bins; require 30 targets per bin and keep event codes 98/99 out of target bins.
8. Extract one nominal −200 to 800 ms target-word epoch dataset at 250 Hz. The stored last sample may be 796 ms. Apply the mandatory −200 to 0 ms baseline.

At Gate D, pool conditions and inspect all 300 epochs. Simple Voltage Threshold is a candidate screen only. The user manually adds or removes marks, clicks `UPDATE MARKS`, never deletes epochs with `REJECT`, and saves a separate review dataset as `new.set`.

Audit `rejmanual`, `rejmanualE`, `rejthresh`, other reject fields, and event flags in `new.set`. If they disagree, ask the user to reconcile them. Enter one reviewed `artifact_bad_epochs` list, write EEG artifact bit 1, and physically retain all 300 epochs.

## Stage 6 — behavior, ERP, rejection report, and plots

Recheck behavior code and bin alignment for all 300 epochs. Write behavioral errors to bit 2 in the in-memory primary copy.

Create:

- primary ERP: EEG-clean and behavior-correct trials;
- all-clean ERP: every EEG-clean trial regardless of behavioral accuracy.

Write a trial ledger and per-bin table containing original, EEG-artifact, behavior-error, all-clean accepted, and primary accepted counts. Report total EEG-artifact rejection rate and primary exclusion rate. Save and reload both ERPs and require equality of waveform, error, data-quality, time, and trial-count fields.

For both inclusion modes, generate separate `[-20 20]` µV and `[-10 10]` µV target-word figures. Every panel uses the same selected scale, plots negative upward, and displays HC N and LC N. Never autoscale panels.

## Sentence branch

Run only after Stage 6 so the official ledger exists. Read [sentence-analysis.md](sentence-analysis.md), then run S1 and S2. Start from the Stage-5 final-CAR continuous checkpoint and do not rerun ICA, filtering, interpolation, or reference operations.

## Participant release rule

A stage is complete only when its runtime PASS log and required outputs exist. Static validation confirms code structure, not participant data. Never reuse participant-specific Gate A, B, C, or D decisions.
