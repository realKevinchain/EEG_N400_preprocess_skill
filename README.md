# EEG N400 Preprocess Skill — 828update

This repository contains a reproducible EEGLAB/ERPLAB N400 preprocessing skill and its project implementation. The current authoritative executable workflow is **828update**.

## Current six-stage workflow

```text
1. Import and behavior–EEG audit
2. M1/M2 review and final rereference
3. 0.1–30 Hz formal filtering at 250 Hz
4. Rank-controlled ICA training, review, and component removal
5. Bad-channel interpolation, EventList/binning, baseline epochs, artifact bit 1
6. Behavior bit 2, primary/all-clean ERP averaging, reload QC
```

Locked implementation details:

- Average M1/M2 reference is preferred; single-side reference requires a written exception.
- Formal data use 0.1–30 Hz bidirectional Butterworth filtering at 250 Hz.
- ICA training uses an additional 1-Hz high-pass, 100 Hz, task start through target +1 s, and reviewed ±100 µV complete-segment exclusion.
- ICA dimensionality is explicitly controlled after rereferencing by numerical-rank validation and PCA when needed.
- Formal epochs use nominal −200 to 800 ms with mandatory −200 to 0 ms baseline.
- There is no unbaselined formal epoch branch.
- EEG artifact decisions use bit 1; behavior errors use bit 2.
- Outputs are isolated under `N400_project/result_update/<ID>/`.

## Use as a Codex skill

The installable skill is in:

```text
analyze-eeglab-erplab-n400/
```

Its entry point is `SKILL.md`. The complete protocol is bundled at:

```text
analyze-eeglab-erplab-n400/references/n400-six-stage-828update.md
```

The self-contained MATLAB implementation is bundled at:

```text
analyze-eeglab-erplab-n400/scripts/828update/
```

Copy `config_828_subject_template.m`, replace its TODO paths, and enter only reviewed participant-specific decisions.

## Project-development copies

The working project copies are:

```text
scripts_updata/
docs/N400 六阶段统一预处理指南_828update.md
```

Legacy `scripts/systematic/`, `derivatives/`, and alternative pipelines remain historical or separate workflows. They are not inputs to 828update.

## Validation

Run the project implementation check:

```bash
python3 scripts_updata/validate_828_static.py
```

Run the packaged-skill implementation check:

```bash
python3 analyze-eeglab-erplab-n400/scripts/828update/validate_828_static.py
```

Then run MATLAB Code Analyzer on all packaged `.m` files. Static checks do not replace a real EEGLAB/ERPLAB participant pilot through all four manual gates.

## Runtime requirements

- MATLAB
- EEGLAB
- ERPLAB
- ICLabel for decision support during manual IC review

Raw/imported EEG and behavior data are not bundled with the skill. The Bin Description File required for the locked 10-bin design is bundled in the skill `assets/` directory.
