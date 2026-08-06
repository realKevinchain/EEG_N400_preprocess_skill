# Data Quality Control Checklist

Check every item for every participant unless explicitly marked cohort-level. Store results in a tabular log, not only in prose.

## Import and provenance

- [ ] Raw files are unchanged and checksummed or otherwise immutable.
- [ ] Import plugin, options, file units, acquisition system, reference, sampling rate, and versions are recorded.
- [ ] Duration, channel count/order, event count, and block boundaries match acquisition/behavioral records.
- [ ] Stimulus latency correction is based on measured hardware delay; shifted event codes and direction were reviewed.

## Channels, locations, reference, filter, and resampling

- [ ] Every EEG label matches the intended coordinate; missing/duplicate coordinates are resolved.
- [ ] Reference state before and after each re-reference is recorded.
- [ ] Non-EEG channels excluded from reference/interpolation are documented.
- [ ] Filter design, half-amplitude cutoffs, order/slope, direction/causality, channels, and DC removal are recorded.
- [ ] Before/after waveform, spectrum, and impulse-response checks show acceptable distortion.
- [ ] Resampling target is compatible with timing/frequency goals and anti-aliasing is confirmed.

## Visual EEG and bad channels

- [ ] Continuous EEG viewed at short and long time scales.
- [ ] Bad channels supported by visual evidence and impact on the planned measure/SME.
- [ ] Intermittent bad periods distinguished from globally bad channels.
- [ ] Bad, ignored, reference, EOG, and analysis channels saved per participant.
- [ ] Interpolation result compared with neighboring channels and key-channel ERP.

## ICA

- [ ] Training copy, training filter/rate, excluded channels, removed segments, usable duration, algorithm, and options recorded.
- [ ] Data rank checked after reference/interpolation/channel removal.
- [ ] Channel order and `icachansind` match between training and weight-transfer data.
- [ ] Component scalp maps, time courses, spectra, and EOG relationships reviewed.
- [ ] Removed components and rationale saved per participant.
- [ ] Before/after EEG and corrected/uncorrected EOG compared; residual ocular activity and lost brain activity assessed.

## EventList and BinList

- [ ] Boundary codes, string/numeric event conversion, and enable flags inspected.
- [ ] Representative event sequences manually traced for every bin.
- [ ] Expected and observed event/bin counts reconciled with behavior.
- [ ] Correct/incorrect response rules and timing windows validated.
- [ ] BDF/BinList file is version controlled and exported EventList retained.

## Epoch, baseline, and artifacts

- [ ] ERPLAB bin-based epochs used when required by downstream ERPLAB functions.
- [ ] Epoch bounds, time zero, baseline interval, and edge/boundary handling verified.
- [ ] Separate artifact flags used for separate artifact types.
- [ ] Flagged and unflagged trials visually sampled; false positives/negatives assessed.
- [ ] Accepted/rejected/invalid trials logged by participant and bin.
- [ ] Rejection rates and artifacts checked for condition confounds.
- [ ] Participant exclusion follows a criterion fixed before outcome inspection.

## Average, N400 score, and statistics

- [ ] Prestimulus baselines and early physiologically impossible differences inspected.
- [ ] Single-participant waveforms, grand averages, difference waves, and scalp distributions are plausible.
- [ ] aSME/SME inspected for the planned N400 window and ROI, not only default windows.
- [ ] Difference-wave subtraction order and polarity are explicit.
- [ ] Score window/ROI overlaid on every participant waveform.
- [ ] Score table subject/bin/channel ordering matches ERP files and descriptive statistics.
- [ ] Statistical means reproduce the grand-average pattern; exact equality checked for fixed-window mean amplitude.
- [ ] Multiplicity, missing data, exclusions, effect estimates, uncertainty, and deviations are reported.

## Cohort release gate

- [ ] Pilot manual and scripted datasets agree for one participant.
- [ ] Rerunning from unchanged inputs/config produces the same files or numerical scores.
- [ ] Logs contain software paths/versions, config snapshot, BDF, subject decisions, errors, and completion status.
- [ ] No placeholder paths, empty condition codes, or unresolved `[DECIDE]` values remain.

