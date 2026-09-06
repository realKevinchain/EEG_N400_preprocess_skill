# 905 sentence-onset and word-aligned analysis

This is a separate post-Stage-6 branch. It reuses the same cleaned EEG and trial ledger as the target-word ERP and never changes the six-stage outputs.

Run in order:

```matlab
run('config_905_<ID>.m')
run('phaseS1_sentence_epoch.m')
run('phaseS2_sentence_word_aligned_erp.m')
```

Stage 6 must finish first because S2 reuses its trial ledger verbatim.

## Event relationship

- Sentence starts: `11–15` for HC and `21–25` for LC.
- Target words: start code plus 100, giving `111–115` and `121–125`.
- SNR digit order: `1–5` = `−4`, `−2`, `+4`, `+6`, quiet.

For every trial, compute target latency directly from the corresponding event pair. Require 300 starts, 300 targets, and exact behavior-order agreement.

## S1: sentence-onset epochs

Source: `cfg.final_car_set`, the 905 continuous dataset after ICA cleaning, ordinary bad-channel interpolation, and universal final CAR.

- Epoch relative to sentence onset: `[-200 4000]` ms.
- Baseline once: `[-200 0]` ms relative to sentence onset.
- Write a 300-row target-latency table containing trial, condition, SNR, and target latency.
- Do not reference, filter, interpolate, or run ICA again.

The script must confirm that every target leaves at least 800 ms of post-target coverage inside the sentence epoch.

## S2: align the display to the target word

S2 shifts each trial's display time axis by its measured target latency. It does not change the EEG values and must not call another baseline operation.

- Fixed display: `[-2300 800]` ms relative to target onset.
- Variable edge coverage is expected because sentence lengths differ.
- Average each time point using `mean(...,'omitnan')`; do not crop silently to common overlap.
- Reuse `EEGClean` for all-clean and `PrimaryCorrectClean` for primary inclusion from the official Stage-6 ledger.
- Require accepted counts to match the Stage-6 ledger by row and by bin.

Write a per-trial CSV with artifact bit 1, behavior bit 2, and both inclusion decisions, plus a per-bin summary.

## Figures

Create one PNG and one FIG for each combination of:

- two inclusion modes;
- CZ and the mean of CZ/CP1/CPZ/CP2/P3/PZ/P4;
- five SNR levels.

This gives 20 PNG plus 20 FIG files. Each single-panel figure shows HC, LC, and LC−HC; uses fixed `[-20 20]` µV with negative upward; and displays HC N and LC N. Never autoscale a participant or panel, and do not overlay the target-word ERP in saved sentence figures.

All outputs remain under `result_905_car/<ID>/sentence_epochs/`. The carried-forward sentence algorithm must be runtime-validated anew on 905 final-CAR data; archived 902 outputs are not 905 validation evidence.
