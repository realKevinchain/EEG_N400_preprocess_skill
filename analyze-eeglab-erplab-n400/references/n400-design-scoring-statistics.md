# N400 Design, Scoring, and Statistics

## What the source example establishes

- `[BOOK]` ERP CORE uses prime–target word pairs and a related/unrelated judgment. Unrelated targets elicit a larger negative-going N400 than related targets (PDF p. 37).
- `[BOOK]` In that dataset, the effect is broadly present around 200–600 ms and typically largest around CPz (PDF pp. 37, 61).
- `[BOOK]` The worked score is fixed-window mean voltage from 300–500 ms at CPz, initially for related and unrelated target bins (PDF pp. 83–85).
- `[BOOK]` The worked difference is unrelated minus related (PDF p. 37).
- `[BOOK]` A paired t test is used for the two-condition within-subject example; descriptive means are checked against the grand average before interpreting inferential results (PDF pp. 86–87).

These statements describe the example, not a universal N400 definition.

## Required study-specific decisions

Mark each `[DECIDE]` and justify it independently of the observed effect:

1. Define semantic context, target event, response/correctness rule, and excluded trial types.
2. Fix condition/bin mapping and subtraction direction.
3. Choose a time window from preregistration, independent literature/data, or an unbiased selection procedure.
4. Choose a channel or ROI from prior evidence and montage availability. Avoid choosing the largest observed effect from the tested sample.
5. Choose amplitude method. Prefer a fixed-window mean when it directly represents the hypothesis; document alternatives.
6. Decide whether the primary test uses condition scores or a difference score. Both can encode the same simple contrast but affect reporting/visualization.
7. Specify participant exclusion, minimum accepted trials, artifact balance, and missing-data handling before outcome inspection.
8. Specify the statistical model, multiplicity control, effect estimate, uncertainty interval, and any covariates.

## Difference waves

- State the formula in words and symbols, for example `unrelated − related`.
- Confirm that a more negative N400 produces the expected negative difference for this order.
- Keep original condition waveforms; a difference wave can isolate the experimental effect but hides their absolute morphology.
- Inspect prestimulus difference and early poststimulus activity for noise, coding errors, overlap, or sensory confounds.
- Use difference waves to reduce unnecessary factors only when scientifically aligned with the hypothesis. `[BOOK]` PDF pp. 37, 90–94, 299–300.

## Amplitude scoring

For fixed-window mean amplitude:

1. Average selected channels within each participant/condition if using an ROI.
2. Average all sampled voltage points whose `ERP.times` fall inside the inclusive window.
3. Retain subject ID, bin label/index, channel labels, time window, baseline, accepted trials, and SME alongside each score.
4. Overlay the score window on each single-participant waveform.

Fixed-window means are linear: the group mean of participant scores should equal the same score from the grand average, modulo weighting/rounding. Use this as a strong QC check. `[BOOK]` PDF pp. 83–87.

Peak amplitude/latency and fractional measures are not interchangeable with mean amplitude. They have different noise sensitivity, bias, and linearity; consult PDF pp. 272–300 and justify them separately.

## Electrode-region choices

- CPz is a source example, not a required site.
- A centro-parietal ROI may improve reliability when justified independently, but its labels must exist in every participant and be fixed before scoring.
- Adding laterality/anterior-posterior electrode factors greatly expands the test family. The book advises minimizing factors unless topographic differences are part of the hypothesis (PDF pp. 88–90, 299–300).
- Report both the reference and ROI because the reference materially changes waveforms and scalp distributions (PDF pp. 130–153).

## Statistical QC and reporting

- Inspect descriptive means before p values and reconcile them with condition/grand-average waveforms.
- For a simple two-condition repeated measure, use a paired analysis, not an independent-samples test.
- Report participant count, exclusions, accepted trials by condition, effect estimate, uncertainty, test statistic, degrees of freedom, exact p value where appropriate, and effect size.
- Report all tested windows/ROIs/models, not only significant results.
- Distinguish confirmatory from exploratory analyses and record deviations from preregistration.

