---
name: analyze-eeglab-erplab-n400
description: Run, audit, troubleshoot, and document the locked 828update six-stage EEGLAB/ERPLAB N400 preprocessing workflow. Use for N400 EEG import audits, M1/M2 rereferencing before filtering, 0.1–30 Hz filtering at 250 Hz, rank-controlled ICA, post-ICA interpolation and binning, −200 to 0 ms baseline-corrected epochs, manual artifact flags, behavior linkage, ERP averaging, QC, or MATLAB script review.
---

# Analyze EEGLAB/ERPLAB N400 with the 828update Workflow

Treat 828update as the default executable workflow. Keep general textbook guidance separate from the study-locked implementation, and never silently substitute another ordering or parameter set.

## Use the locked six stages

Run stages in this order:

1. Audit imported EEG and trialwise behavior alignment.
2. Review M1/M2 and bad-channel candidates, then apply the final reference.
3. Resample to 250 Hz and filter EEG/EOG at 0.1–30 Hz; never filter TRIGGER.
4. Create the 1-Hz/100-Hz ICA training copy, review ±100 µV task segments, compute numerical rank, run extended Infomax with explicit PCA when needed, transfer weights, and remove only reviewed ICs.
5. Interpolate confirmed bad scalp channels, create EventList and 10 bins, extract one −200 to 800 ms epoch set with mandatory −200 to 0 ms baseline, and write reviewed EEG artifacts to bit 1 without deleting trials.
6. Write behavior errors to bit 2 in memory, create primary correct-clean and all-clean ERPs, reload-verify them, and generate CZ/centroparietal QC plots.

Read [n400-six-stage-828update.md](references/n400-six-stage-828update.md) before running or changing a stage. It defines the commands, gates, filenames, outputs, and PASS criteria.

## Prepare a participant

1. Copy `scripts/828update/config_828_subject_template.m` to `config_828_<ID>.m` in the same directory.
2. Replace the project and EEGLAB TODO paths.
3. Enter the participant ID and only reviewed participant-specific decisions.
4. Reload the config before every stage or gate helper.
5. Write outputs only to `N400_project/result_update/<ID>/`.

Use `scripts/828update/config_828_01B.m` only as a pilot example. T7/T8 are candidates, not automatically confirmed bad channels, and old ICA or epoch decisions must not be copied.

## Respect the four manual gates

- Gate A: set `reference_review_complete=true` only after reviewing M1, M2, all bad-channel candidates, and normal comparisons.
- Gate B: set `run_ica=true` only after reviewing every ±100 µV rejected task segment and the fixed retained sample.
- Gate C: set `ica_review_complete=true` only after reviewing maps, spectra, activations, continuous data, and EOG relationships. A reviewed zero-component decision is valid.
- Gate D: set `artifact_review_complete=true` only after condition-blind review of all epochs and entry of the unified `artifact_bad_epochs` list.

Never claim a stage passed unless its runtime PASS log exists. Static validation is not runtime validation.

## Preserve locked decisions

- Reference before filtering and ICA; average M1/M2 by default, with documented single-side exceptions only.
- Formal data: 0.1–30 Hz, 250 Hz, bidirectional Butterworth.
- ICA training: additional 1 Hz high-pass, 100 Hz, task start through target +1 s, ±100 µV complete-segment rule.
- Epoch: nominal −200 to 800 ms with mandatory −200 to 0 ms baseline.
- Artifact bit 1: unified reviewed EEG artifact decision.
- Behavior bit 2: incorrect response.
- Preserve all 300 physical epochs; use flags for averaging.
- Do not create an unbaselined formal epoch branch.
- Do not write to legacy `derivatives/` or `no-ica/` roots.

## Validate before release

Run:

```bash
python3 scripts/828update/validate_828_static.py
```

Run MATLAB Code Analyzer on all `.m` files, then complete a real participant pilot through every gate. Confirm reference residuals, EOG/TRIGGER protection, ICA rank, 10×30 bins, 300 baseline-corrected epochs, bit synchronization, and ERP save/reload equality.

## Route supporting questions

- Locked commands and outputs: [n400-six-stage-828update.md](references/n400-six-stage-828update.md)
- Short phase contract: [sop.md](references/sop.md)
- Per-stage release checks: [quality-control.md](references/quality-control.md)
- Parameter provenance and alternatives: [parameter-decisions.md](references/parameter-decisions.md)
- GUI/MATLAB mapping: [gui-matlab-crosswalk.md](references/gui-matlab-crosswalk.md)
- N400 scoring and statistics: [n400-design-scoring-statistics.md](references/n400-design-scoring-statistics.md)
- Book evidence map: [source-map.md](references/source-map.md)
- Version-specific cautions: [version-compatibility.md](references/version-compatibility.md)

Use `[BOOK]`, `[DERIVED]`, `[GENERAL]`, `[DECIDE]`, and `[UNVERIFIED]` labels when discussing evidence. When the locked 828update implementation differs from a general alternative, state the difference rather than changing the pipeline silently.
