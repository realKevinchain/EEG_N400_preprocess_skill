# 828update Data Quality Checklist

Store every result in the participant `result_update/<ID>/` QC, table, or log directories. A checked item requires evidence, not only a verbal assertion.

## Stage 1: import and alignment

- [ ] Raw/vendor data remain unchanged.
- [ ] Imported SET has 67 channels with unique locked labels.
- [ ] EEG 1–64 have finite XYZ coordinates and finite samples.
- [ ] M1/M2/EOG/TRIGGER indices and labels are correct.
- [ ] Continuous EEG, spectra, triggers, flatlines, saturation, and discontinuities were inspected.
- [ ] Exactly 300 target codes exist.
- [ ] Behavior and EEG target codes agree trialwise for all 300 trials.
- [ ] Channel QC, segment QC, and phase01 PASS log exist.

## Stage 2: reference

- [ ] M1 and M2 were reviewed with candidate and normal-comparison channels.
- [ ] Confirmed `bad_channels` contain scalp channels only.
- [ ] Average M1/M2 is used, or a single-side exception reason is recorded.
- [ ] EEG 1–64 were rereferenced before filtering and ICA.
- [ ] VEOG, HEOG, and TRIGGER remained pointwise unchanged.
- [ ] Reference residual meets the script tolerance.
- [ ] Events, channel labels, and dimensions remained unchanged.
- [ ] Gate A decision and phase02 PASS log exist.

## Stage 3: filtering

- [ ] Output rate is 250 Hz.
- [ ] EEG/EOG use 0.1–30 Hz bidirectional Butterworth filtering.
- [ ] TRIGGER was resampled but not filtered.
- [ ] Filtering produced no NaN or Inf.
- [ ] Reference residual and 300 target events remain valid.
- [ ] Before/after waveforms, spectra, edges, EOG, M1/M2, CZ/CPZ/PZ were inspected.
- [ ] Filter QC and phase03 PASS log exist.

## Stage 4: ICA

- [ ] Bad scalp channels and the zero single-reference channel are excluded as required.
- [ ] Training copy uses 1-Hz high-pass and 100 Hz.
- [ ] Task windows run from trial start through target +1 s.
- [ ] Every ±100 µV rejected segment and the fixed retained sample were reviewed.
- [ ] Numerical rank equals the reference/channel-set expectation.
- [ ] Explicit PCA rank is used when rank is below ICA channel count.
- [ ] Fixed-seed extended Infomax completed.
- [ ] Training and target reference, channel order, and `icachansind` match.
- [ ] IC maps, activations, spectra, continuous data, and EOG relationships were reviewed.
- [ ] Removed ICs and rationale are recorded; zero removal is explicitly reviewable.
- [ ] Before/after ICA signals were compared.
- [ ] Threshold QC and phase04 PASS log exist.

## Stage 5: interpolation, bins, epochs, and artifacts

- [ ] Only Gate A bad scalp channels were spherically interpolated.
- [ ] M1/M2/EOG/TRIGGER were not interpolated.
- [ ] Invalid ICA matrices were cleared and decision metadata retained.
- [ ] Ten target bins contain exactly 30 trials each.
- [ ] Event codes 98/99 do not enter target bins.
- [ ] One formal epoch dataset contains 300 trials.
- [ ] Epoch window is nominally −200 to 800 ms at 250 Hz.
- [ ] Every epoch uses mandatory −200 to 0 ms baseline.
- [ ] No unbaselined formal epoch branch exists.
- [ ] All 300 epochs were reviewed condition-blind.
- [ ] Unified EEG artifact bit 1 agrees across reject, epoch, event, and EVENTLIST.
- [ ] No trial was physically deleted.
- [ ] Artifact decisions table and phase05 PASS log exist.

## Stage 6: behavior and ERP

- [ ] Behavior target codes and bins re-match all EEG epochs.
- [ ] Bit 1 means EEG artifact only.
- [ ] Bit 2 means behavior error only.
- [ ] Primary acceptance equals EEG-clean and behavior-correct.
- [ ] All-clean acceptance equals EEG-clean regardless of behavior.
- [ ] Ledger and bin summary reconcile every trial and count.
- [ ] Both ERPs include SEM/dataquality information.
- [ ] Saved and reloaded bindata, binerror, dataquality, time, and counts are identical.
- [ ] CZ and centroparietal ROI plots use LC−HC and negative up.
- [ ] Prestimulus baseline, 300–500 ms morphology, late drift, trial balance, and anomalous conditions were reviewed.
- [ ] Phase06 PASS log exists.

## Cohort release

- [ ] One representative participant completed every GUI gate and runtime check.
- [ ] Rerunning unchanged inputs/config does not overwrite outputs.
- [ ] Every participant has the minimum deliverables listed in the full guide.
- [ ] No unresolved TODO paths, reference choices, IC decisions, or artifact decisions remain.
- [ ] No 828update output was written to legacy `derivatives/` or `no-ica/` roots.
