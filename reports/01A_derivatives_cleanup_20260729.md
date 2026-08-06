# 01A derivatives cleanup

Date: 2026-07-29

## Outcome

- `derivatives/` reduced from approximately 1.8 GB to 1.0 GB.
- 18 superseded or reproducible files totaling approximately 811 MB were
  moved to the recoverable macOS Trash folder
  `~/.Trash/N400_project_cleanup_20260729/`.
- Nothing was permanently erased.

## Reorganized outputs

- Final EventList exports:
  `events/eventlists/01A/`
- Derived trial ledger:
  `derivatives/tables/01A/`
- Final analysis ERP files:
  `derivatives/erp/01A/`
- Raw behavior CSV files remain in:
  `behavior/`

## Files moved to Trash

### Superseded ICA training checkpoint

- `01A_icatrain.set/.fdt`

The retained `01A_icatrain_ica.set/.fdt` contains the same training data plus
the fitted ICA solution.

### Superseded M1-reference checkpoints

- `01A_postica_m1ref.set/.fdt`
- `01A_m1ref_target_epochs_pre200.set/.fdt`
- `01A_m1ref_target_epochs_nobaseline_diagnostic.set/.fdt`

The retained binned continuous dataset has byte-identical signal data to the
reference-only continuous checkpoint. The retained artifact-flagged epoch
datasets have byte-identical signal data to the corresponding unflagged
epochs plus the final synchronized artifact metadata.

### Abandoned average-mastoid diagnostic branch

- `01A_postica_mastref.set/.fdt`
- `01A_postica_mastref_bins.set/.fdt`
- `01A_postica_mastref_eventlist.txt`
- `01A_postica_mastref_eventlist_binned.txt`
- `01A_target_epochs_pre200.set/.fdt`
- `01A_target_epochs_nobaseline_diagnostic.set/.fdt`

This branch was superseded by the approved 01A M1-reference branch after the
M2 reference-quality diagnostic. Its decision evidence remains documented
in the project reports.

## Retained reconstruction chain

1. `01A_preica.set/.fdt`
2. `01A_icatrain_ica.set/.fdt`
3. `01A_preica_icaweights.set/.fdt`
4. `01A_preica_icaclean.set/.fdt`
5. `01A_postica_m1ref_bins.set/.fdt`
6. `01A_m1ref_target_epochs_artifactflagged.set/.fdt`
7. `01A_m1ref_target_epochs_nobaseline_artifactflagged.set/.fdt`
8. primary and sensitivity ERP files under `derivatives/erp/01A/`

## Post-move QC

- All seven retained EEGLAB datasets have matching `.set/.fdt` pairs.
- The final artifact-flagged primary dataset was fully loaded; all 300 epochs
  were present and all samples were finite.
- Both moved ERP files were reloaded from `derivatives/erp/01A/`.
- Primary accepted trials remained
  `8 10 21 18 28 4 4 16 23 22`.
- Sensitivity accepted trials remained
  `29 30 30 29 29 29 30 30 30 29`.
- MATLAB Code Analyzer reported zero messages for all updated systematic and
  01A Phase 6 scripts.
