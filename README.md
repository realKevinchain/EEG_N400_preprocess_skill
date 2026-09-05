# EEG N400 preprocessing skill — Codex 905

Active workflow: `analyze-eeglab-erplab-n400/`.

Version 905 changes the study reference contract to common-average reference, permanently excludes M1/M2/CB1/CB2, resolves all channels by label, and applies a final 60-scalp-channel CAR to every participant after ICA cleaning and any ordinary bad-channel interpolation.

Archived 902 materials are stored separately under `N400_project/skills/legacy/EEG_N400_preprocess_skill-codex-902/` and must not be used as 905 stage inputs.
