# Sentence-Onset / Word-Aligned Supplemental Analysis

Added while processing 01A and runtime-validated as part of the 902 standard
on 01B (2026-09-02). This is the study's default post-Stage-6 **supplemental**
analysis on top of the locked six-stage pipeline — it
does not replace, modify, or get read by any of `phase01`–`phase06`. It lives
entirely under `result_update/<ID>/sentence_epochs/`, separate from the
official `continuous/`, `ica/`, `epochs/`, and `erp/` outputs.

## Contents

1. [Run order](#run-order)
2. [Why this exists](#why-this-exists)
3. [Required event codes](#event-code-scheme-this-depends-on)
4. [Sentence-onset epoch](#phases1_sentence_epochm)
5. [Word-aligned ERP display](#phases2_sentence_word_aligned_erpm)
6. [902 release checks](#902-release-checks)
7. [Official QC plot update](#related-fix-carried-into-the-official-pipeline)

## Run order

Run `phaseS1_sentence_epoch.m` then `phaseS2_sentence_word_aligned_erp.m`.
`phaseS1` requires Stage 5's interpolated continuous dataset. `phaseS2`
additionally requires Stage 6 (`phase06_average_erp.m`) to have produced the
official trial ledger, which it reuses verbatim.

```matlab
run('config_828_<ID>.m')
run('phaseS1_sentence_epoch.m')
run('phaseS2_sentence_word_aligned_erp.m')
```

## Why this exists

The locked pipeline epochs relative to the **target/critical word**
(−200 to 800 ms) for the formal N400 analysis. Sentences vary in length and
in how long before the target word the sentence has been running, so there
is no single fixed epoch that shows "the whole sentence" for every trial the
same way. This supplemental analysis instead epochs relative to **sentence
onset**, and only re-aligns to the target word for *display* purposes,
without touching the underlying data or its baseline.

## Event code scheme this depends on

- Sentence-start codes: `11–15` (HC × 5 SNR levels) and `21–25` (LC × 5 SNR
  levels), same numbering as the locked pipeline's SNR order
  (`-4,-2,+4,+6,quiet` → digits `1..5`).
- Target/keyword codes: sentence-start code **+ 100** (`111–115`, `121–125`),
  identical to the codes the locked pipeline already uses.
- These start codes are the same ones `phase04_ica.m` already uses internally
  to find "trial start through target +1 s" for the ICA training window —
  nothing new was invented here, this analysis just epochs around the same
  markers with a much longer window.

## `phaseS1_sentence_epoch.m`

- **Source data:** `continuous/<ID>_828update_<ref>_postica_interpolated.set`
  — i.e. the fully referenced/filtered/ICA-cleaned/interpolated continuous
  data that Stage 5 already produced, *before* Stage 5's own EventList/bin/
  epoch step. No re-referencing, re-filtering, or re-running ICA.
- **Epoch window:** −200 to 4000 ms relative to sentence onset. Chosen
  because the longest observed sentence-onset-to-target latency in 01A is
  2749 ms and the minimum spacing between one trial's sentence onset and the
  next is 5038 ms, so 4000 ms comfortably covers every trial's target word
  plus roughly 800+ ms of follow-on content, with zero risk of overlapping
  the next trial.
- **Baseline:** −200 to 0 ms relative to **sentence onset** (true
  pre-stimulus silence), applied once here via `pop_rmbase`. This is
  deliberately *not* the target-word baseline the official epoch uses —
  `phaseS2` must not re-baseline on top of this (see below).
- **Per-trial target latency table:** for every trial, the target word's
  latency relative to sentence onset (ms) is computed directly from the
  event codes (not from the experiment program's stimulus log) and written
  to `<ID>_828update_<ref>_sentence_target_latency.csv` (`Trial, Condition,
  SNR, TargetLatency_ms`). The script asserts this table's condition and SNR
  order match the official behavior file before saving, so trial
  numbering is guaranteed to line up 1:1 with the official pipeline's
  `EEGEpoch` numbering used everywhere else (trial ledger, bin summary,
  `artifact_bad_epochs`).
- **Outputs:** `sentence_epochs/<ID>_828update_<ref>_sentence_epochs_baseline_pre200.set/.fdt`,
  the latency CSV, and a short text log.

For 01B, S1 retained all 300 trials and observed target-word latencies of
950–2523 ms, independently confirming that the fixed S1 window covers the
target and the required post-target interval.

## `phaseS2_sentence_word_aligned_erp.m`

- **Does not recompute any baseline.** It only shifts each trial's *time
  axis* by that trial's own `TargetLatency_ms` so the target word lands at a
  common `t=0` for plotting/averaging; the underlying values are exactly what
  `phaseS1` already saved (sentence-onset-baselined). Re-baselining on top of
  that would be wrong for this design — don't add it back in.
- **Fixed display window — `WORD_ALIGNED_DISPLAY_MS = [-2300 800]` —
  constant across every participant, not recomputed per subject.** Do not
  change this per participant; if it ever needs revisiting, change it once
  here and note why. It is intentionally asymmetric because the target word
  sits close to the end of each sentence (little audio follows it):
  - **+800 ms** (post-target) matches the official N400 window and is fully
    covered by every trial (even the latest-target 01A trial still has
    >1200 ms of room left in the phaseS1 epoch after its own target word).
  - **−2300 ms** (pre-target) was chosen from 01A's target-latency
    distribution so that roughly the 95th percentile of trials
    (`target_latency ≈ 2100 ms`, plus the 200 ms pre-sentence baseline) show
    their complete sentence lead-in; only the handful of longest-latency
    trials taper off with missing data at that far edge.
  - Coverage tapers toward the edges by design — sentences differ in length,
    so not every trial has data at every displayed time point. Bins are
    averaged with `mean(...,'omitnan')` over whatever trials do have data at
    each time point rather than being cropped to the common overlap. This
    was an explicit, repeated user decision ("有些时间点没有也是可以的,我们
    就是要看整体的") — do not silently switch back to a coverage-safe
    cropped window without asking.
- **Trial inclusion reuses `phase06_average_erp.m`'s trial ledger verbatim**
  (`EEGClean` for the all-clean set, `PrimaryCorrectClean` for the primary
  set) — it does not re-derive artifact/behavior decisions. This keeps the
  accepted/rejected trial set exactly identical to the official ERPs; the
  per-bin accepted counts must match phase06's log exactly. The 01B runtime
  validation matched all-clean `28 30 29 30 28 29 29 27 29 30` and primary
  `5 9 15 21 25 1 5 6 18 25`.
- **No overlay of the official target-word ERP in the final plots** — an
  earlier draft overlaid it (dashed) for validation and it was explicitly
  removed on request. If you need to sanity-check this analysis against the
  official ERP again, do it as a throwaway comparison script, not by adding
  the overlay back into `phaseS2`'s saved output.
- **Every trial's per-trial inclusion decision is written to a CSV** —
  `<ID>_828update_<ref>_sentence_word_aligned_trial_log.csv`
  (`Trial, Condition, SNR, TargetLatency_ms, ArtifactFlagBit1,
  BehaviorErrorBit2, IncludedAllClean, IncludedPrimary`) — this is the
  record of what was rejected and why, per explicit user request ("把拒绝了
  都需要记录下来").
- **Plot output is one PNG+FIG pair per mode × site × SNR** (20 figure pairs,
  40 files total),
  organized as:

  ```text
  sentence_epochs/word_aligned_plots/
  ├── all_clean/
  │   ├── cz/{-4dB,-2dB,4dB,6dB,quiet}.png(+.fig)
  │   └── roi/{-4dB,-2dB,4dB,6dB,quiet}.png(+.fig)
  └── primary_correct_clean/
      ├── cz/...
      └── roi/...
  ```

  Each figure is a single large panel (not tiled into a small grid — an
  earlier tiled 2×5 layout was rejected as too cramped once the window
  widened) showing HC/LC/LC−HC with the accepted trial count annotated
  directly in the legend, e.g. `HC (N=28)`, `LC (N=24)`. ROI = mean of
  CZ/CP1/CPZ/CP2/P3/PZ/P4, same as the official `plot_828_erp_qc.m`
  convention. Every panel uses the fixed scale `[-20 20]` µV with negative
  plotted upward; participant- or panel-specific autoscaling is forbidden.
- **Bin summary:** `<ID>_828update_<ref>_sentence_word_aligned_bin_summary.csv`
  mirrors phase06's bin summary shape (`Bin, Condition, SNR, Original,
  AllCleanAccepted, PrimaryAccepted`).

## 902 release checks

For each participant, confirm all of the following before calling the
sentence deliverable complete:

- S1 has 300 trials, a sentence-onset `[-200 4000]` ms window, and
  sentence-onset `[-200 0]` ms baseline;
- S2 does not call any baseline operation;
- the trial inclusion CSV matches the Stage-6 ledger row by row and the bin
  counts match exactly;
- the display window is `[-2300 800]` ms and edge averages use `omitnan`;
- exactly 20 PNG and 20 FIG files exist;
- every FIG has one axes, fixed `[-20 20]` µV, negative up, and HC/LC N
  labels. The 01B coverage validation ranged from 18 to 300 trials across
  display samples.

## Related fix carried into the official pipeline

While adding trial counts to this supplemental analysis, the official
`plot_828_erp_qc.m` (used by `phase06_average_erp.m`) was also updated to
annotate each of its 10 small-multiple panels with
`(HC N=<accepted>, LC N=<accepted>)` from `ERP.ntrials.accepted`. This applies
to every participant's official ERP QC figures going forward. The official
target-word scale is also fixed at `[-20 20]` µV, negative up. Any requested
`[-10 10]` comparison must use separate filenames and is exploratory if it
clips; it does not change the sentence plot standard.
