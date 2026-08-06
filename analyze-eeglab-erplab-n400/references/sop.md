# Phased Analysis SOP

## Contents

1. Gate 0: study contract
2. Phase 1: import and audit
3. Phase 2: pre-ICA preparation
4. Phase 3: ICA training and application
5. Phase 4: post-ICA processing and events
6. Phase 5: epoching and artifact detection
7. Phase 6: averaging and N400 scoring
8. Phase 7: statistics and reporting

## Gate 0: study contract

Record before touching data:

- hypotheses, conditions, time-locking events, response rules, and exclusion criteria;
- acquisition reference/ground, sampling rate, channel montage, EOG channels, display/audio latency measurements;
- planned N400 contrast direction, scoring method, time window, channels/ROI, baseline, and statistical model;
- allowable participant-specific choices and how they will be logged;
- installed MATLAB, EEGLAB, ERPLAB, and plugin versions.

Mark unresolved choices `[DECIDE]`. Do not substitute the book's N400 demonstration parameters.

## Phase 1: import and audit

1. Preserve vendor files read-only and import through the appropriate EEGLAB plugin.
2. Save a canonical `.set` file with a new name; record the plugin and import options.
3. Inspect channel count/order, units, sampling rate, duration, reference state, event types/latencies, boundaries, and block joins.
4. Plot continuous EEG at short and long scales and inspect spectra.
5. Verify trigger counts and timing against the behavioral log. Measure and correct hardware stimulus delays only from empirical timing evidence.

**Gate:** stop if duration, event counts, reference state, channel labels, or units are unresolved. `[BOOK]` PDF pp. 21–24, 38–41, 364.

## Phase 2: pre-ICA preparation

1. Add verified 3-D channel locations and confirm label-to-coordinate matches.
2. Apply only planned resampling and filtering. Confirm anti-aliasing and inspect filter response/impulse response.
3. Create bipolar EOG channels if needed while retaining the original monopolar EOG channels for ICA assessment.
4. Apply an initial single-site reference only if the acquisition system stored effectively unreferenced data; otherwise defer the final reference.
5. Inspect short and long windows; mark channels to exclude from ICA. Do not interpolate them yet in the book's example workflow.
6. Save a pre-ICA dataset and participant decision record.

**Gate:** compare before/after spectra and waveforms; confirm locations and data rank; verify no unintended channels were filtered or re-referenced. `[BOOK]` PDF pp. 124, 365–366.

## Phase 3: ICA training and application

1. Make an ICA-training copy of the pre-ICA dataset.
2. Apply the declared training-only filter/resampling choices; remove breaks and extreme, nonrepresentative discontinuities while retaining ordinary ocular artifacts for ICA to learn.
3. Exclude bipolar EOG and identified bad channels from ICA training as planned.
4. Confirm effective rank and enough usable data; run ICA with recorded algorithm/options.
5. Inspect scalp maps, component activations, spectra, and relationships with EOG. Record components and rationale; do not remove components automatically solely from a label.
6. Transfer weights to the matching pre-ICA dataset and remove only reviewed artifactual components.
7. Compare uncorrected and corrected EEG/EOG; verify brain-like activity was not removed.

**Gate:** stop if channel order, reference/rank, or `icachansind` differs between training and target data. `[BOOK]` PDF pp. 241–271, 366–368. `[GENERAL]` Also inspect installed EEGLAB ICA documentation.

## Phase 4: post-ICA processing and events

1. Apply the final planned reference.
2. Interpolate reviewed bad channels, excluding non-EEG channels from interpolation.
3. Verify bipolar corrected and uncorrected EOG channels as appropriate.
4. Create EventList; inspect boundaries, event codes, enable flags, and latency differences.
5. Run BINLISTER using a version-controlled BDF/BinList file. Export and inspect the resulting EventList and per-bin counts.

**Gate:** manually trace representative event sequences for every bin; confirm no condition is defined by an unintended response, boundary, or timing rule. `[BOOK]` PDF pp. 45–51, 160–168, 367.

## Phase 5: epoching and artifact detection

1. Use ERPLAB bin-based epoch extraction when the pipeline relies on ERPLAB bins.
2. Apply the preregistered epoch and baseline. Inspect edge events and confirm time zero.
3. Start artifact detection with declared starting values, then iteratively inspect flagged/unflagged epochs and tune only under the documented rule.
4. Use separate flags for distinct artifact types. Preserve counts by participant, bin, and type.
5. Check that rejection does not create condition-specific trial loss or sensory/behavioral confounds.

**Gate:** inspect continuous and epoched data, flag distributions, accepted/rejected counts, and condition balance. `[BOOK]` PDF pp. 52–57, 196–240, 368.

## Phase 6: averaging and N400 scoring

1. Average accepted epochs, exclude boundary/invalid epochs, and compute data-quality metrics.
2. Inspect single-participant ERPs before the grand average: prestimulus stability, plausibility, channel neighborhoods, trial counts, and aSME for the planned score window.
3. Create the prespecified condition difference and confirm its sign convention.
4. Score every participant using the same algorithm/window/ROI. Visually overlay each score window on each waveform.
5. Compare descriptive means with grand averages; exact equality is expected for linear fixed-window mean scores, not for nonlinear peak scores.

**Gate:** stop for unexpected polarity, implausible timing, noisy key channels, bin reversal, or score/window mismatch. `[BOOK]` PDF pp. 58–66, 83–90, 272–300.

## Phase 7: statistics and reporting

1. Use the smallest model that directly tests the hypothesis; avoid gratuitous electrode factors and multiplicity.
2. Verify column/bin ordering against descriptive statistics and grand averages.
3. Report effect estimates, uncertainty, exact exclusions, retained trials, data quality, all preprocessing parameters, deviations, and software versions.
4. Archive config, BDF/BinList, participant decision table, scripts, logs, and outputs with checksums when possible.

**Gate:** independently reproduce scores from saved ERP structures and reconcile them with the report. `[BOOK]` PDF pp. 86–90, 97, 299–300, 340.

