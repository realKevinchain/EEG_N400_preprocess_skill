# Cohort preprocessing policy

## Prospective ICA-training voltage rule

Decision date: 2026-07-28  
Applies prospectively: participants after 01A  
Does not retroactively alter: completed 01A processing

The ICA training copy must include a simple voltage threshold of
`-100 to +100 uV` on the 64 ICA-training EEG channels. The standardized
implementation evaluates each complete retained task segment (trial start
through target onset plus 1 second). A segment is excluded from the ICA
training copy if any ICA channel has any sample outside the locked range.

The rule does not delete or alter samples in the 250-Hz analysis dataset.
Every excluded segment and the total retained training sample count must be
reviewed before ICA is authorized. This prospective policy supersedes the
01A pilot's lack of a pre-ICA simple-voltage threshold.

