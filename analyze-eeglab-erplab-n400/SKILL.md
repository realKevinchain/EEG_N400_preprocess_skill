---
name: analyze-eeglab-erplab-n400
description: Design, implement, audit, and report traceable EEGLAB and ERPLAB ERP pipelines with special support for N400 studies. Use for EEG import and preprocessing, channel locations, referencing, filtering, resampling, bad-channel and artifact handling, ICA, EventList and BinList design, epoching, baseline correction, ERP averaging, data-quality checks, N400 scoring, difference waves, statistics, MATLAB scripting, and methods reporting.
---

# Analyze EEGLAB, ERPLAB, and N400 Data

Build an analysis that is reproducible, version-aware, and tied to explicit source evidence. Never turn the book's worked examples into universal defaults.

## Classify every recommendation

Use these labels in plans, reviews, and reports:

- `[BOOK]`: stated explicitly in Luck's book; cite the PDF physical page.
- `[DERIVED]`: logical adaptation of book guidance; state the inference.
- `[GENERAL]`: broader practice not established by this book; cite an external source when consequential.
- `[DECIDE]`: requires a study-specific, preferably preregistered decision.
- `[UNVERIFIED]`: command, parameter, or claim not confirmed; do not execute it as fact.

## Run the workflow

1. Collect the study design, recording reference, acquisition rate, file format, event-code dictionary, condition contrast, planned amplitude/latency score, participant population, and installed MATLAB/EEGLAB/ERPLAB versions.
2. Read [source-map.md](references/source-map.md) and then only the topic references needed for the request. Use the repository's `knowledge/index.md` to open the cited extracted pages when exact wording matters.
3. Write a decision ledger using [parameter-decisions.md](references/parameter-decisions.md). Leave unresolved choices as `[DECIDE]`; never silently fill them.
4. Follow [sop.md](references/sop.md). Process one representative participant manually in the Classic GUI, inspect each intermediate dataset, and capture the history before scripting a cohort.
5. Use [gui-matlab-crosswalk.md](references/gui-matlab-crosswalk.md) to translate verified GUI actions. Run `help <function>` in the installed version before relying on stored argument lists.
6. Copy `scripts/config_template.m` and edit only the copy. Run `scripts/run_pipeline.m` by stage: `preica`, `train_ica`, then `postica_erp`. Treat component identification as a reviewed human decision between stages.
7. Apply [quality-control.md](references/quality-control.md) at every gate. Stop when event counts, channel geometry, rank, artifact flags, trial counts, SME, or waveform plausibility fail.
8. For N400 work, read [n400-design-scoring-statistics.md](references/n400-design-scoring-statistics.md). Derive time windows and electrode regions from the study's independent evidence, not from the example alone.
9. Copy [methods-report-template.md](assets/methods-report-template.md) and fill every provenance and deviation field. Record current compatibility notes from [version-compatibility.md](references/version-compatibility.md).

Use `assets/parameter-decision-ledger.csv` and `assets/participant-decisions.csv` as machine-readable companion logs.

## Script guardrails

- Start from an EEGLAB `.set` file after importing vendor data interactively; vendor import plugins and options vary.
- Centralize paths, subject IDs, event/BinList files, channels, time windows, thresholds, and component decisions in the config.
- Preserve raw data and save new stage-specific datasets. Never overwrite acquisition files.
- Run the template once per stage. Review ICA maps/time courses and enter component decisions before `postica_erp`.
- Treat the provided code as a verified structural template, not proof that chosen scientific parameters are appropriate.
- If an installed function rejects an argument, stop, inspect its local help and GUI history, and record the version-specific change. Do not guess a replacement.

## Reference routing

- Full staged procedure: [sop.md](references/sop.md)
- Parameter choices and alternatives: [parameter-decisions.md](references/parameter-decisions.md)
- GUI and MATLAB command mapping: [gui-matlab-crosswalk.md](references/gui-matlab-crosswalk.md)
- N400 design, difference waves, scoring, and statistics: [n400-design-scoring-statistics.md](references/n400-design-scoring-statistics.md)
- Per-stage validation: [quality-control.md](references/quality-control.md)
- Book page map and provenance labels: [source-map.md](references/source-map.md)
- Software-era differences: [version-compatibility.md](references/version-compatibility.md)
