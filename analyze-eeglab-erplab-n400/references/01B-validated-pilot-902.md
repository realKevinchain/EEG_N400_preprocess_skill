# 01B validated pilot record for the 902 standard

Status: completed and runtime-verified on 2026-09-02. This is an audit record and implementation test, not a source of participant decisions.

## Do not copy these decisions

The following values apply only to participant 01B:

- confirmed bad scalp channels: T7/T8, indices `[26 34]`;
- removed ICs: `[1 4 8 20 31 41 52 56 61]`;
- manual artifact epochs: `[49 52 66 70 98 118 194 203 246 253 292]`.

For every later participant, repeat Gates A–D. T7/T8 return to candidates unless independently confirmed; ICA component numbering is decomposition-specific; epoch decisions must come from that participant's condition-blind review.

## Runtime-verified processing facts

- Stages 1–6 each produced a runtime PASS log.
- Input contained 67 channels, 603 events, and 300 target trials; behavior aligned exactly to all 300 trials.
- The final reference was average M1/M2.
- EEG/EOG were resampled to 250 Hz and filtered in the order 0.1-Hz high-pass, explicit 50-Hz ERPLAB PMnotch with `Design='notch'`, then 30-Hz low-pass. TRIGGER was resampled but unchanged by filtering.
- A targeted diagnostic measured 56.7 dB attenuation at exactly 50.00 Hz. The following 30-Hz low-pass makes the notch redundant in the final band, but 902 retains it explicitly.
- T7/T8 were excluded from ICA and spherically interpolated only after ICA.
- Gate B rejected 19 of 300 task segments under the ±100 µV complete-segment rule. ICA used 62 channels and numerical rank 61.
- Gate C removed 9 of 61 components. IC6 and IC7 were reviewed separately and retained; ICLabel was used only as decision support.
- Gate D's separate review copy was `result_update/01B/epochs/new.set`. The audit found 11 of 300 epochs marked in `EEG.reject.rejmanual` (3.67%); all 300 physical epochs remained present.
- Behavior errors: 163. Primary correct-clean accepted: 130/300. The artifact-or-behavior union excluded 170/300 (56.67%). All-clean accepted: 289/300.
- Primary accepted counts by bins 1–10: `[5 9 15 21 25 1 5 6 18 25]`.
- All-clean accepted counts by bins 1–10: `[28 30 29 30 28 29 29 27 29 30]`.
- Saved and reloaded ERP numerical differences were zero.

## Plot validation

- Official target-word ERP plots used fixed `[-20 20]` µV, negative up, with HC and LC N in every panel.
- A separate `[-10 10]` µV comparison showed clipping in the primary −4 dB panel, where HC N=5 and LC N=1. It remains exploratory; ±20 µV is the official standard.

## Sentence validation

- S1 retained 300 sentence-onset epochs with target latency 950–2523 ms.
- S2 used fixed display `[-2300 800]` ms, preserved the sentence-onset baseline, and averaged variable edge coverage with `omitnan`.
- The sentence trial log matched the official Stage-6 ledger and bin counts exactly.
- Coverage across the display ranged from 18 to 300 trials.
- The complete figure set contained 20 PNG and 20 FIG files: 2 modes × 2 sites × 5 SNR levels. Every FIG was verified as fixed ±20 µV, negative up, with two N-labelled condition traces.

## What 01B established for later participants

The reusable standards are the processing order, gate procedure, field audit, flag semantics, fixed figure scales, N labels, sentence branch isolation, and validation checks. The participant-specific channel, IC, artifact, behavior, and bin values above are never reusable defaults.
