# 905 release checklist

## Stage 1

- [ ] Raw/vendor files remain unchanged.
- [ ] Imported SET has 67 unique labels and finite data.
- [ ] M1, M2, CB1, CB2, VEOG, HEOG, and TRIGGER resolve exactly once by label.
- [ ] The 60 retained scalp channels have finite coordinates.
- [ ] Exactly 300 target codes match 300 behavior rows trial by trial.
- [ ] Channel QC, segment QC, and Phase-1 PASS log exist.

## Stage 2

- [ ] Gate A ordinary bad channels were decided by the user for this participant.
- [ ] Bad-channel decisions use labels, not inherited indices.
- [ ] M1, M2, CB1, and CB2 were permanently removed before CAR.
- [ ] The post-removal data contain 60 scalp plus three auxiliary channels.
- [ ] Initial CAR used only good retained scalp channels.
- [ ] Bad scalp, EOG, and trigger were excluded from the initial CAR.
- [ ] Good-scalp CAR residual is within tolerance.
- [ ] Auxiliary samples and events are unchanged.
- [ ] Gate A record and Phase-2 PASS log exist.

## Stage 3

- [ ] Output rate is 250 Hz.
- [ ] EEG/EOG filter order is 0.1-Hz HP, 50-Hz PMnotch with `Design='notch'`, then 30-Hz LP.
- [ ] TRIGGER was resampled but not filtered.
- [ ] Initial good-scalp CAR residual remains within tolerance.
- [ ] All samples are finite and 300 targets remain.
- [ ] Filter QC and Phase-3 PASS log exist.

## Stage 4

- [ ] ICA includes only good retained scalp channels.
- [ ] Fixed exclusions, ordinary bad scalp, EOG, and trigger are absent from ICA.
- [ ] Training data use 1-Hz HP, 100 Hz, and trial-start-through-target+1-s windows.
- [ ] Every ±100 µV candidate and the retained sample were reviewed at Gate B.
- [ ] Numerical rank equals number of ICA channels minus one.
- [ ] Extended Infomax used explicit PCA rank and the fixed seed.
- [ ] Training and formal reference, labels, order, and `icachansind` match.
- [ ] Gate C maps, spectra, activations, continuous data, and EOG relationships were reviewed.
- [ ] Removed ICs came from the user; ICLabel was support only.
- [ ] ICA-clean output reloads exactly and Phase-4 PASS log exists.

## Stage 5

- [ ] Only ordinary Gate A bad scalp channels were interpolated.
- [ ] M1, M2, CB1, and CB2 were not interpolated.
- [ ] ICA matrices were cleared after ICA cleaning/interpolation.
- [ ] Final CAR was executed for this participant even if no interpolation was needed.
- [ ] Final CAR contains all 60 retained scalp channels and excludes all auxiliary channels.
- [ ] Final scalp mean is within tolerance and auxiliary samples are unchanged.
- [ ] Final-CAR continuous checkpoint exists.
- [ ] Ten bins contain 30 original trials each; codes 98/99 do not enter target bins.
- [ ] One formal 300-trial epoch set uses nominal −200 to 800 ms and −200 to 0 ms baseline.
- [ ] Gate D was condition-blind; Simple Voltage Threshold was only a screen.
- [ ] The user clicked `UPDATE MARKS`, never deleted trials with `REJECT`, and saved `new.set`.
- [ ] All reject fields/event flags were audited and one list was reconciled with the user.
- [ ] EEG artifact bit 1 is synchronized and all 300 physical epochs remain.
- [ ] Phase-5 PASS log exists.

## Stage 6

- [ ] Behavior codes and bins rematch all epochs.
- [ ] Bit 1 means EEG artifact; bit 2 means behavior error.
- [ ] Primary acceptance is EEG-clean plus behavior-correct.
- [ ] All-clean acceptance is EEG-clean regardless of behavior.
- [ ] Ledger and per-bin summary reconcile every trial.
- [ ] Total EEG-artifact rejection and primary exclusion rates are reported.
- [ ] Saved/reloaded ERP waveform, error, data-quality, time, and count fields match.
- [ ] Separate fixed ±20 and ±10 target-word figures exist for both inclusion modes.
- [ ] All panels use negative up and show HC N plus LC N.
- [ ] Phase-6 PASS log exists.

## Sentence branch

- [ ] Source is the 905 final-CAR continuous checkpoint.
- [ ] S1 has 300 sentence-onset epochs, −200 to 4000 ms, with −200 to 0 ms baseline.
- [ ] S2 does not rebaseline and displays fixed −2300 to 800 ms.
- [ ] Edge averaging uses `omitnan`.
- [ ] Trial inclusion matches the Stage-6 ledger row by row and by bin.
- [ ] Sentence figures are fixed ±20 µV, negative up, and show HC/LC N.
- [ ] Sentence outputs did not modify Stage 1–6 outputs.

## Cohort

- [ ] Every participant was rerun from raw import under 905; no 902 SET was used as a stage input.
- [ ] No participant-specific gate decision was copied to another participant.
- [ ] All outputs remain isolated under `result_905_car/<ID>/`.
- [ ] No unresolved TODO path or gate remains.
