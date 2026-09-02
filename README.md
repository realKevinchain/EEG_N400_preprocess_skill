# EEG N400 Preprocess Skill — 902

This is the 902 revision of the reproducible EEGLAB/ERPLAB N400 workflow, updated from the completed 01B pilot on 2026-09-02. The official pipeline remains six stages with four human review gates; sentence-onset/word-aligned analysis is a separate post-Stage-6 deliverable.

## Locked standard

```text
1. Import and behavior–EEG audit
2. M1/M2 review and final rereference
3. 250 Hz; EEG/EOG 0.1-Hz HP -> 50-Hz PMnotch -> 30-Hz LP
4. Rank-controlled ICA training, review, and component removal
5. Post-ICA bad-channel interpolation, bins, baseline epochs, artifact bit 1
6. Behavior bit 2, primary/all-clean ERP averaging, reload QC
S. Separate sentence-onset epochs and target-word-aligned display
```

Key rules:

- TRIGGER is resampled but never filtered.
- The 50-Hz ERPLAB call must include `Filter='PMnotch'` and `Design='notch'`.
- Formal epochs are −200 to 800 ms with −200 to 0 ms baseline; there is no unbaselined formal branch.
- Gate D thresholding is a candidate screen only. The user updates marks, saves a separate review copy, and no epoch is physically deleted.
- Artifact decisions use bit 1; behavior errors use bit 2.
- Official target-word and sentence plots use fixed ±20 µV, negative up, and show HC/LC trial N.
- An optional ±10 µV target-word comparison must use separate filenames and is exploratory if it clips.
- Outputs stay under `N400_project/result_update/<ID>/`; sentence outputs stay under that participant's `sentence_epochs/` subfolder.

## Installable skill

The entry point is:

```text
analyze-eeglab-erplab-n400/SKILL.md
```

The self-contained implementation is under:

```text
analyze-eeglab-erplab-n400/scripts/828update/
```

Copy `config_828_subject_template.m` for each participant and enter only that participant's reviewed decisions. `config_828_01B.m` is an audit record, not a decision template: do not copy T7/T8, IC, or epoch numbers from 01B.

## Project-development copies

```text
scripts_updata/
docs/N400 六阶段统一预处理指南_828update.md
```

Legacy `scripts/systematic/`, `derivatives/`, and alternative pipelines remain historical and are not inputs to 902.

## Validation

```bash
python3 scripts_updata/validate_828_static.py
python3 analyze-eeglab-erplab-n400/scripts/828update/validate_828_static.py
```

Also run MATLAB Code Analyzer on all packaged `.m` files and the skill-creator `quick_validate.py`. Static checks do not replace participant runtime PASS logs or human gate decisions.

Runtime requires MATLAB, EEGLAB, ERPLAB, and ICLabel. Raw EEG and behavior files are not bundled; the locked 10-bin BDF is bundled in `assets/`.
