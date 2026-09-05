# 905 locked parameters

| Item | Locked 905 value |
|---|---|
| Raw channel count | 67 |
| Fixed permanent exclusions | M1, M2, CB1, CB2 |
| Final retained scalp montage | 60 channels |
| Auxiliary channels | VEOG, HEOG, TRIGGER |
| Initial reference | CAR of good retained scalp channels; exclude ordinary bad scalp and auxiliary channels |
| Final reference | CAR of all 60 retained scalp channels after ICA cleaning and interpolation; run for every participant |
| Analysis sampling rate | 250 Hz |
| Formal filter order | 0.1-Hz HP → 50-Hz PMnotch (`Design='notch'`) → 30-Hz LP |
| Trigger | Resample; never filter or include in CAR/ICA |
| ICA channels | Good retained scalp only |
| ICA training copy | 1-Hz HP, 100 Hz, trial start through target +1 s |
| ICA training screen | complete task segment outside ±100 µV; Gate B remains manual |
| ICA | extended Infomax, fixed seed, explicit numerical PCA rank; expected CAR rank = channels−1 |
| Ordinary bad channels | Gate A by participant; exclude initial CAR/ICA; spherical interpolation after ICA |
| ICA components | Gate C manual; ICLabel decision support only |
| Target-word epoch | nominal −200 to 800 ms; mandatory −200 to 0 ms baseline |
| Target bins | 10 bins × 30 trials = 300 |
| EEG artifact | bit 1; Gate D manual reconciliation; no physical epoch deletion |
| Behavior error | bit 2 |
| ERP inclusion | primary correct-clean and all EEG-clean |
| Target-word figures | separate fixed ±20 µV and ±10 µV, negative up, HC/LC N in every panel |
| Sentence S1 | −200 to 4000 ms from sentence onset; −200 to 0 ms sentence-onset baseline |
| Sentence S2 | display −2300 to 800 ms from target; no second baseline; `omitnan` at variable edges |
| Sentence figures | fixed ±20 µV, negative up, HC/LC N |
