# 01A Phase 3 ICA-training pilot log

Started: 2026-07-25  
Completed: 2026-07-27  
Status: **complete; 01A ICA-clean continuous derivative saved, reloaded, QC-passed, and locked**  
Canonical analysis input: `/Users/kevinchain/Desktop/N400_project/derivatives/01A_preica.set`
Locked post-ICA derivative: `/Users/kevinchain/Desktop/N400_project/derivatives/01A_preica_icaclean.set`

## Scope and safeguards

- `01A_preica.set/.fdt` remains the complete analysis dataset and must not be overwritten or time-trimmed.
- ICA optimization is performed only on temporary training copies.
- ICA will use EEG channels 1:64. VEOG, HEOG, and TRIGGER remain available for QC but are excluded from ICA decomposition.
- Incorrect trials are not removed before ICA.
- ICA weights will ultimately be transferred back to the complete `01A_preica` dataset after component review.

## Experiment-timing clarification recorded 2026-07-25

The user confirmed the following experimental procedure:

- Target-word onset is marked by codes `111–115` and `121–125`.
- After target-word onset, a blank screen remains for 1 s.
- Only after that 1 s interval may the participant begin typing the heard target word.
- Typing is an explicitly movement-permitted period; participants may move and relax, so variable EMG is expected.
- Four participant-paced breaks occur across the experiment. Break duration is unrestricted, and large movement/EMG is plausible during these breaks.

Consequences for ICA training:

- Large activity during typing or participant-paced breaks must not automatically be interpreted as channel failure or unexpected recording artifact.
- The full analysis dataset retains these periods.
- The preferred ICA-training strategy is event-defined retention: keep the sentence/listening period through a safety interval after target onset, then exclude the typing/intertrial interval until the next trial begins.
- This strategy also excludes unmarked participant-paced breaks when they occur between trials.
- Ordinary blinks and eye movements inside retained task periods should remain available for ICA to learn ocular components.
- Only extreme nonstationary artifacts inside retained task periods remain candidates for manual removal.
- A target-relative end of `+0.8 s` is the provisional preferred safety boundary because typing is permitted at `+1.0 s`; `+1.0 s` remains a comparison candidate until retained duration and sample sufficiency are quantified.

## Operations completed before the timing clarification

1. Loaded the revalidated `01A_preica` derivative.
2. Applied a 1 Hz half-amplitude, order-8, noncausal Butterworth high-pass to EEG channels 1:64 only, with DC removal and boundary-aware handling.
3. Resampled the ICA-training copy from 250 Hz to 100 Hz.
4. Removed the explicitly marked `99 → 98` interval from the training copy:
   - `99`: 126.110 s
   - `98`: 366.111 s
   - removed samples: 24,001 at 100 Hz
   - post-removal copy: 340,219 samples, 600 experimental events, one `boundary`
5. During exploratory artifact review, a localized extreme transient around 30 s was removed from a separate copy:
   - exploratory copy: `01A_icaopt_hp1_o8_rs100_norest_craprej`
   - post-removal samples: 340,127
   - experimental events retained: 600
   - boundary events: 2

The exploratory `..._craprej` copy is **not** the selected final ICA-training input. The event-defined strategy will restart from `01A_icaopt_hp1_o8_rs100_norest` so that the final training set is reproducible and does not inherit an unnecessary pre-task manual deletion.

## Next gate

Before any further deletion or ICA:

1. Pair every two-digit trial-start code (`11–15`, `21–25`) with its corresponding target code (`111–115`, `121–125`).
2. Quantify retained duration and sample count for target-relative endpoints of `+0.8 s` and `+1.0 s`.
3. Verify 300 valid pairs, no overlap, and adequate samples for a rank-64 ICA.
4. Select and document one endpoint.
5. Create a new event-defined ICA-training copy, then inspect only the retained task periods for extreme nonstationary artifacts.

## 2026-07-25 event-defined retention audit

**Status: PASS; select the full 1 s blank interval with an exclusive `+1.000 s` endpoint.**

- Dataset audited: `01A_icaopt_hp1_o8_rs100_norest`.
- Target events found: 300.
- Valid adjacent trial-start/target pairs: 300/300.
- Trial-start to target delay: 0.915–2.749 s; median 1.584 s.
- Target `+0.8 s` candidate: 72,229 samples, 722.29 s (12.04 min), 1,128.6 samples per rank, no interval overlap.
- Target `+1.0 s` audit candidate: 78,229 samples, 782.29 s (13.04 min), 1,222.3 samples per rank, no interval overlap.
- The `+1.0 s` candidate is preferred because it preserves the experiment's complete instructed blank interval and provides more data for a rank-64 ICA.
- Operationally, the retained samples will satisfy `sample time < target onset + 1.000 s`; at 100 Hz this retains samples through approximately `+0.99 s` and excludes the time at which typing becomes permissible.
- The three longest remaining post-target gaps were 71.390, 69.798, and 56.658 s. Together with the already removed 240.001 s `99 → 98` interval, they are consistent with the user's report of four participant-paced breaks. Event-defined retention excludes these long gaps without requiring all breaks to have dedicated marker codes.
- Other long post-target gaps are plausibly variable typing/intertrial intervals and are also excluded from the ICA-training copy, but retained unchanged in `01A_preica`.

The next operation will retain 300 nonoverlapping trial-start-to-target-plus-blank segments from the `..._norest` copy. No further operation will use the exploratory `..._craprej` copy.

## 2026-07-25 event-defined training-copy creation

**Status: PASS for retained-task artifact inspection.**

- Created in memory as `01A_icaopt_hp1_o8_rs100_taskwin1s`.
- Channels: 67 retained for QC; ICA input remains restricted to EEG channels 1:64.
- Samples: 78,471 at 100 Hz (784.71 s; 13.08 min).
- Trial-start events retained: 300.
- Target events retained: 300.
- `99` and `98` events retained: 0.
- Boundary events: 301, reflecting the concatenation of 300 retained segments plus boundary bookkeeping inherited/created during selection.
- Estimated EEG rank: 64.
- Samples/rank²: 19.16.
- The 600 non-boundary experimental events remain complete. Boundary events are discontinuity bookkeeping and do not represent additional trials.

The next gate is a trial-structured, read-only extreme-artifact screen restricted to the 300 retained task windows. Typing, relaxation, and participant-paced break periods are no longer present in this training copy.

## 2026-07-25 retained-task artifact gate

**Status: PASS; no further time deletion is justified before ICA.**

- The trial-wise robust screen covered all 300 retained task windows.
- The largest candidate was trial 246: frontal maximum at FP1, robust score 28.458, peak-to-peak 194.21 µV, with five channels above 20 MAD.
- The highest-ranked candidates were overwhelmingly frontal (FP1, FP2, or FPZ), with peak-to-peak amplitudes mostly 134–194 µV. This pattern is consistent with ordinary blink/eye-movement activity that should remain in the ICA training data.
- Visual inspection of trial 246 at approximately 644.5–648.5 s confirmed a frontally maximal waveform synchronized with VEOG/HEOG, while central and posterior channels remained stable. It was classified as ocular activity and retained.
- A representative nonfrontal candidate around 484–489 s was inspected on the FC/C/CP page. The waveform was continuous, moderate in amplitude, and spatially coherent, without a focal electrode jump, sustained local high-frequency burst, clipping, or broad nonstationary disturbance.
- The green `boundary` markers visible in the concatenated training copy denote joins between retained task segments and are not artifacts.
- The previously observed 1,000–2,800 µV movement/typing/break activity is absent because those periods were excluded by the event-defined retention rule.

Decision: retain all 78,471 samples in `01A_icaopt_hp1_o8_rs100_taskwin1s`. The next gate is to save and reload this exact training copy, verify its structure, and only then run ICA on channels 1:64.

## 2026-07-25 saved ICA-training derivative and reload QC

**Status: PASS; `01A_icatrain.set/.fdt` is the locked ICA-training input.**

- Saved and reloaded from `/Users/kevinchain/Desktop/N400_project/derivatives/01A_icatrain.set`.
- Channels: 67; samples: 78,471; sampling rate: 100 Hz; duration: 784.71 s.
- Events: 901 total, comprising 300 trial-start events, 300 target events, and 301 boundary events.
- All 300 trial-start/target pairs remained valid after reload.
- `99` and `98` counts: 0; non-boundary experimental events: 600.
- Channel labels remained unique; EEG coordinate coverage remained 64/64.
- Channels 65:67 remained `VEOG`, `HEOG`, and `TRIGGER`.
- Estimated EEG rank remained 64; all data values were finite; ICA weights were absent.
- The `.set` and `.fdt` files both existed. FDT size was exactly 21,030,228 bytes, matching `67 × 78,471 × 4`.
- Dataset history retained resampling, filtering, and selection operations and contained no `pop_runica`.
- The earlier in-memory unsaved copy was no longer available for a direct pointwise comparison. This does not invalidate the reload gate because structural, event, rank, finite-data, and exact FDT-size checks all passed.

The next gate is ICA parameter confirmation. Planned decomposition: extended Infomax `runica`, EEG channels 1:64 only, no PCA rank reduction, with VEOG/HEOG/TRIGGER excluded.

## 2026-07-26 extended-Infomax training

**Status: training and ICA matrix QC passed; provenance completion and save pending.**

- Input: locked `01A_icatrain` training derivative.
- Random seed: `rng(20260725, 'twister')`.
- Algorithm: extended Infomax `runica`.
- ICA channels: 1:64 only; VEOG, HEOG, and TRIGGER excluded.
- PCA reduction: none; expected decomposition dimension: 64.
- Training completed after 350 steps.
- Final reported weight change: approximately `9e-8`, consistent with the default convergence threshold.
- The output then completed component sorting by projected variance, RMS-microvolt scaling, ICA-activation recomputation, and creation of ALLEEG dataset 14 named `01A_icatrain_ica`.
- No learning-rate blow-up, restart, rank-reduction, numerical warning, or maximum-step termination was reported.

The EEGLAB summary shows ICA weights present. Because the new in-memory dataset inherited the filename `01A_icatrain.set`, it must not be saved with an ordinary overwrite operation. Matrix dimensions, channel indices, finiteness, rank, inverse consistency, and history will be checked before saving under a new filename.

### ICA matrix QC

- `icaweights`, `icasphere`, and `icawinv`: each 64 × 64.
- ICA activations: 64 × 78,471.
- `icachansind`: exactly 1:64, spanning FP1 through CB2.
- Effective unmixing matrix rank: 64.
- Condition number: 33.7331.
- All weight, sphere, and inverse values were finite.
- Left- and right-inverse relative errors: approximately `2.95e-15` and `2.89e-15`.
- Sampled reconstruction relative error: approximately `2.09e-15`.
- No components were marked for rejection.

Decision: the ICA solution is numerically valid and accepted for the pilot.

`EEG.history` did not automatically receive the `pop_runica` command because ICA was launched directly from the MATLAB command line. Before saving, the exact command and random seed will be added to dataset provenance, and the result will be saved under a new filename so that `01A_icatrain.set/.fdt` remains an untouched pre-ICA training derivative.

## 2026-07-26 saved ICA solution and reload QC

**Status: PASS; `01A_icatrain_ica.set/.fdt` is the locked ICA solution.**

- Saved under the new filename `01A_icatrain_ica.set`; the pre-ICA `01A_icatrain.set/.fdt` was not overwritten.
- Reloaded dataset: 67 channels, 78,471 samples, 100 Hz, and 901 events.
- Event structure remained intact: 300 trial starts, 300 targets, 301 boundaries, and no `99`/`98`.
- ICA matrices remained 64 × 64; activations were 64 × 78,471; ICA channels remained exactly 1:64.
- Effective unmixing rank remained 64; condition number remained 33.7331412581.
- All ICA matrices remained finite; inverse-consistency error was approximately `2.94e-15`.
- Dataset history contained both `pop_runica` and the fixed random seed; structured ICA provenance metadata was present.
- No component was marked for rejection.
- FDT size was exactly 21,030,228 bytes.
- Comparison with the pre-reload in-memory solution showed:
  - data difference: 0
  - weight difference: approximately `2.11e-15`
  - sphere difference: 0
  - inverse difference: approximately `2.58e-14`
  - unchanged ICA channel indices, event types, and event latencies

The tiny matrix differences are ordinary floating-point serialization effects and do not alter the solution. The next operation is to transfer the locked 64-channel spatial decomposition to a new copy of the complete 250 Hz `01A_preica` analysis dataset. Component classification and rejection will be performed only after the transferred full-duration copy passes its own QC.

## 2026-07-26 full-data ICA-weight transfer QC

**Status: PASS; the locked ICA solution was transferred in memory without altering the complete analysis data.**

- Destination dataset: `01A_preica_icaweights`, created from a fresh copy of the complete 250 Hz `01A_preica` dataset.
- ICA source: reloaded locked dataset `01A_icatrain_ica`.
- Destination structure remained 67 channels, 910,550 samples, 250 Hz, and 602 events.
- Pointwise comparison with the original full dataset showed a maximum data difference of 0.
- Event types and latencies were unchanged; the maximum event-latency difference was 0 samples.
- Channel labels were unchanged and the maximum XYZ-coordinate difference was 0.
- Transferred `icaweights`, `icasphere`, and `icawinv` differed from the locked source only at floating-point precision:
  - maximum weight difference: approximately `2.44e-15`
  - maximum sphere difference: 0
  - maximum inverse difference: approximately `2.04e-14`
- ICA matrices remained 64 × 64, ICA activations were recomputed as 64 × 910,550, and `icachansind` remained exactly 1:64.
- Effective ICA matrix rank remained 64.
- Activation relative error was approximately `1.48e-7`, acceptable for recomputation over the full single-precision dataset.
- Structured transfer and training metadata were present, and dataset history documented the transfer.
- No components were marked for rejection.
- The original `99` and `98` rest markers were each retained once in the complete dataset.

Decision: the in-memory transfer passes the gate. Save it under the new filename `01A_preica_icaweights.set` without overwriting `01A_preica.set/.fdt`, then reload and verify the saved derivative before ICLabel or any component rejection.

## 2026-07-26 saved full-data ICA-weight derivative and reload QC

**Status: numerical and structural reload checks PASS; history-text provenance check pending.**

- Saved and reloaded `/Users/kevinchain/Desktop/N400_project/derivatives/01A_preica_icaweights.set/.fdt`.
- Reloaded structure remained 67 channels, 910,550 samples, 250 Hz, and 602 events.
- Maximum data difference was 0 both against the untouched original full dataset and against the pre-reload transferred copy.
- Event types, event latencies, channel labels, and channel XYZ coordinates were unchanged.
- ICA weights, sphere, and inverse remained 64 × 64; activations were 64 × 910,550; ICA channels remained exactly 1:64; matrix rank remained 64.
- Differences from the locked ICA source were limited to floating-point serialization:
  - weights: approximately `8.88e-16`
  - sphere: 0
  - inverse: approximately `1.69e-14`
- Difference from the pre-reload weight matrix was approximately `1.78e-15`.
- Activation relative error remained approximately `1.48e-7`.
- Structured `ica_transfer` and `ica_training` metadata were present.
- No components were marked for rejection.
- Full-data `99` and `98` markers were each retained once.
- SET size: 4,040,512 bytes.
- FDT size: exactly 244,027,400 bytes, matching `67 × 910,550 × 4`.
- The automated text search reported `History documents ICA transfer: 0`, despite the structured transfer metadata being present. The actual history text must be inspected before deciding whether an explicit provenance line needs to be appended and the derivative resaved.

ICLabel and component rejection remain paused until this final provenance-text check is resolved.

### Provenance-text resolution

**Status: PASS; no resave or provenance repair is required.**

- Direct inspection of `EEG.history` found the explicit record:
  `% ICA weights transferred from 01A_icatrain_ica.set; trained using extended Infomax pop_runica on channels 1:64 with rng(20260725, 'twister').`
- The earlier automated result of 0 was a false negative caused by searching for phrases such as `ica transfer` rather than the actual wording `ICA weights transferred`.
- `EEG.etc.ica_transfer` retained the source file, target file, channels 1:64, source and target sampling rates, completion timestamp, and zero XYZ difference.
- `EEG.etc.ica_training` retained the source dataset, algorithm, extended setting, channels, PCA decision, random seed and RNG algorithm, sampling rate, sample count, completion time, and exact command.

Decision: `01A_preica_icaweights.set/.fdt` is the locked, verified full-duration dataset with transferred ICA weights. The next stage is ICLabel classification and manual component review. ICLabel probabilities will be treated as decision support only; no component will be removed automatically.

## 2026-07-26 ICLabel classification

**Status: PASS; classification completed for all components, with no automated rejection.**

- ICLabel classes: Brain, Muscle, Eye, Heart, Line Noise, Channel Noise, and Other.
- Classification matrix: 64 × 7.
- Components classified: 64/64.
- All classification probabilities were finite.
- Maximum probability-row sum error: approximately `1.19e-7`, consistent with ordinary single-precision rounding.
- No automatic artifact threshold, component flagging, or component removal was applied.

The next gate is a read-only ranking of the ICLabel probabilities followed by manual inspection of a small candidate set using scalp maps, spectra, component activity, and the separately recorded VEOG/HEOG channels. ICLabel probabilities alone will not determine rejection.

### ICLabel probability ranking

- Highest-probability class counts:
  - Brain: 26
  - Muscle: 1
  - Eye: 3
  - Heart: 0
  - Line Noise: 0
  - Channel Noise: 13
  - Other: 21
- Clear ICLabel eye candidates:
  - IC 14: Eye 0.99145
  - IC 2: Eye 0.89926
  - IC 32: Eye 0.75089
- Highest channel-noise candidates:
  - IC 60: Channel Noise 0.99846
  - IC 36: Channel Noise 0.98089
  - IC 53: Channel Noise 0.96411
  - IC 40: Channel Noise 0.95321
- IC 33 was the only component whose highest class was Muscle, with probability 0.54929.
- Many later components were assigned Other or Channel Noise, as expected for low-variance residual components in a 64-component decomposition. These labels alone do not justify rejection.
- Forty-three components had at least one non-brain probability of 0.30 or greater, demonstrating that a generic probability threshold would be excessively broad for this dataset.

Decision: do not apply ICLabel threshold rejection. First compute full-duration correlations of every component with the separately recorded VEOG and HEOG channels, then manually review a small evidence-based candidate set.

### Full-duration IC-to-EOG correlation screen

- The three ICLabel eye candidates were also the three strongest IC-to-EOG correlations:
  - IC 2: Eye 0.89926; VEOG `r = 0.68468`; HEOG `r = -0.17006`
  - IC 32: Eye 0.75089; VEOG `r = -0.58441`; HEOG `r = 0.31611`
  - IC 14: Eye 0.99145; VEOG `r = -0.04870`; HEOG `r = -0.55173`
- This convergence identifies IC 2, IC 14, and IC 32 as the first manual ocular-review batch.
- Several additional components showed moderate full-duration EOG correlation despite high Brain probabilities, including IC 58, IC 8, IC 13, IC 3, IC 12, and IC 16.
- These secondary correlations are not sufficient evidence for rejection. They may reflect shared low-frequency activity, reference/common-mode effects, or the inclusion of typing, relaxation, and break periods in the complete dataset used for the correlation screen.
- IC 10, IC 33, IC 25, IC 23, IC 35, and IC 24 remain secondary review candidates because their EOG correlations were moderate and their ICLabel assignments were non-brain or ambiguous.

Decision: manually inspect IC 2, IC 14, and IC 32 first. Do not flag or remove any component until their scalp maps, spectra, time courses, and ICLabel evidence have been reviewed together.

### Manual ocular-component review

**Decision: IC 2, IC 14, and IC 32 are confirmed ocular-artifact components and are provisionally selected for later rejection. No subtraction has yet been performed.**

- IC 2:
  - ICLabel Eye probability: 0.89926.
  - VEOG correlation: `r = 0.68468`.
  - Scalp map: broad, symmetric frontopolar maximum characteristic of blinks/vertical eye movement.
  - Activity: repeated large slow transients.
  - Spectrum: strongly low-frequency dominated.
  - Percent scalp-data variance displayed by EEGLAB: 14.5%.
- IC 14:
  - ICLabel Eye probability: 0.99145.
  - HEOG correlation: `r = -0.55173`.
  - Scalp map: strong left-right frontal polarity gradient characteristic of horizontal eye movement.
  - Activity: large slow polarity shifts.
  - Spectrum: strongly low-frequency dominated.
  - Percent scalp-data variance displayed by EEGLAB: 4.4%.
- IC 32:
  - ICLabel Eye probability: 0.75089.
  - VEOG correlation: `r = -0.58441`; HEOG correlation: `r = 0.31611`.
  - Scalp map: bilateral focal frontopolar pattern.
  - Activity: slow ocular-like shifts with superimposed small faster activity.
  - Spectrum: dominant very-low-frequency power.
  - Percent scalp-data variance displayed by EEGLAB: 4.7%.

The ICA polarity signs are arbitrary and do not affect classification. The convergence of scalp distribution, spectral shape, activity time course, ICLabel probabilities, and independent EOG correlations justifies ocular-artifact classification for all three components.

Before creating a rejection mask, the highest channel-noise candidates and the sole ICLabel muscle candidate will be reviewed manually.

### Manual muscle and channel-noise review

**Decision: IC 33 is confirmed as a muscle-artifact component. IC 36, IC 40, IC 53, and IC 60 are confirmed as focal channel-noise components. All five are provisionally selected for later rejection; no component subtraction has yet been performed.**

- IC 33:
  - ICLabel probabilities: Muscle 0.549, Other 0.348, Eye 0.060, Brain 0.015.
  - Scalp map: sharply localized frontal/peripheral pattern rather than a plausible broad dipolar brain field.
  - Spectrum: a broad elevation centered around approximately 18–23 Hz, consistent with residual muscle activity despite the 30 Hz low-pass filter.
  - Activity: persistent irregular faster fluctuations rather than stereotyped ocular slow waves.
  - Percent scalp-data variance displayed by EEGLAB: 1.7%.
- IC 36:
  - ICLabel Channel Noise probability: 0.981.
  - Scalp map: extremely focal posterior hot spot, consistent with a single-channel source.
  - Percent scalp-data variance displayed by EEGLAB: approximately -0.3% (an EEGLAB display statistic, not used as the classification criterion).
- IC 40:
  - ICLabel Channel Noise probability: 0.953.
  - Scalp map: extremely focal right-posterior hot spot.
  - Percent scalp-data variance displayed by EEGLAB: 1.0%.
- IC 53:
  - ICLabel Channel Noise probability: 0.964.
  - Scalp map: extremely focal right-central/posterior hot spot.
  - Percent scalp-data variance displayed by EEGLAB: 0.2%.
- IC 60:
  - ICLabel Channel Noise probability: 0.998.
  - Scalp map: extremely focal frontal-central hot spot.
  - Percent scalp-data variance displayed by EEGLAB: 0.1%.

The four channel-noise decisions are supported primarily by the near-single-electrode scalp maps together with very high ICLabel probabilities. Their spectra are not muscle-like and their small explained variance is consistent with isolated residual channel noise. The current provisional rejection set is therefore `[2 14 32 33 36 40 53 60]`.

Before locking the rejection mask, a final ambiguous non-brain batch (IC 10, IC 23, IC 24, IC 25, and IC 35) will be inspected. Moderate EOG correlation or an Other/Channel Noise ICLabel assignment alone will not be treated as sufficient evidence for removal.

### Final ambiguous-component review

**Decision: retain IC 10. Provisionally reject IC 23, IC 24, IC 25, and IC 35 as non-brain artifact components.**

- IC 10 — retain:
  - ICLabel probabilities: Brain 0.360, Other 0.545, Line Noise 0.055, Eye 0.013.
  - Scalp map: smooth left-frontal field with a broader spatial distribution than the confirmed single-channel components.
  - Spectrum: low-frequency dominated with a broad 18–24 Hz elevation, but no decisive artifact-specific signature.
  - Despite its moderate VEOG correlation (`r = 0.520`), the combined evidence is ambiguous rather than sufficient for rejection. It is therefore retained under the conservative rule.
  - Percent scalp-data variance displayed by EEGLAB: 4.2%.
- IC 23 — reject:
  - ICLabel probabilities: Other 0.686, Muscle 0.107, Eye 0.102, Brain 0.035.
  - Scalp map: distribution concentrated at the superior frontal edge rather than a plausible intracranial dipole.
  - Spectrum: broad elevation around 18–23 Hz.
  - Together with moderate EOG correlation (`|r| = 0.429`), this is most consistent with mixed frontal/cranial muscle or ocular-edge artifact.
  - Percent scalp-data variance displayed by EEGLAB: 2.2%.
- IC 24 — reject:
  - ICLabel probabilities: Other 0.419, Channel Noise 0.237, Muscle 0.157, Brain 0.134.
  - Scalp map: highly localized right-frontal/temporal edge maximum.
  - Activity and spectral evidence are compatible with a mixed focal channel/muscle artifact.
  - Percent scalp-data variance displayed by EEGLAB: 2.5%.
- IC 25 — reject:
  - ICLabel probabilities: Channel Noise 0.506, Line Noise 0.312, Other 0.098, Brain 0.071.
  - Scalp map: sharply focal central-frontal radial pattern rather than a plausible broad dipole.
  - The combined channel-noise and line-noise probabilities are 0.818.
  - Percent scalp-data variance displayed by EEGLAB: approximately -2.7% (display statistic only).
- IC 35 — reject:
  - ICLabel probabilities: Other 0.459, Eye 0.257, Muscle 0.154, Brain 0.049.
  - Scalp map: frontal-edge mixed pattern with bilateral anterior maxima.
  - Spectrum: broad 18–24 Hz elevation; full-duration EOG correlation was also moderate (`|r| = 0.406`).
  - The combined evidence supports mixed ocular/frontal-muscle artifact.
  - Percent scalp-data variance displayed by EEGLAB: 2.2%.

The locked provisional rejection mask after manual review is:

`[2 14 23 24 25 32 33 35 36 40 53 60]`

This represents 12 of 64 components. No component has yet been subtracted from the saved locked full-data file. The next step is to create a reversible in-memory cleaned preview from `01A_preica_icaweights`, inspect it, and perform quantitative invariance checks before saving any cleaned derivative.

### Reversible ICA-clean preview and structural QC

- A reversible in-memory preview was created from locked full-length dataset
  `#17: 01A_preica_icaweights`:
  - preview dataset: `#18: 01A_preica_icaclean_preview`;
  - rejected ICs: `[2 14 23 24 25 32 33 35 36 40 53 60]`;
  - 12 components removed and 52 components retained;
  - the preview has not overwritten the locked source dataset.
- Structural QC passed:
  - channels: `67 -> 67`;
  - samples: `910550 -> 910550`;
  - events: `602 -> 602`;
  - sampling rate: `250.0 -> 250.0 Hz`;
  - event types unchanged: `1`;
  - maximum event-latency difference: `0 samples`;
  - channel labels unchanged: `1`;
  - remaining ICA components: `52`, matching the expected `52`;
  - sampled maximum data change: `2656.69000244 uV`;
  - all preview data finite: `1`;
  - event `99` retained: `1`;
  - event `98` retained: `1`.
- Interpretation:
  - dataset dimensions, events, timing, channel identity, and numerical
    finiteness were preserved;
  - the large sampled data difference is compatible with removal of strong
    ocular/artifact activity, but is not by itself evidence that the
    subtraction is physiologically acceptable;
  - visual before/after waveform QC is therefore required before saving a
    cleaned derivative.

### Auxiliary-channel invariance after ICA subtraction

- Compared source dataset `#17: 01A_preica_icaweights` with preview dataset
  `#18: 01A_preica_icaclean_preview`.
- Maximum differences:
  - VEOG: `0 uV`
  - HEOG: `0 uV`
  - TRIGGER: `0`
- Channels 65:67 were exactly unchanged, confirming that ICA subtraction was
  restricted to the 64 EEG channels.

### Quantitative frontal ocular attenuation

- Frontal channels:
  `FP1, FPZ, FP2, AF3, AF4, F11, F7, F5, F3, F1, FZ, F2, F4, F6, F8, F12`.

| Center time (s) | Original frontal P2P (uV) | Clean frontal P2P (uV) | Reduction (%) |
|---:|---:|---:|---:|
| 1815.8 | 71.900 | 28.390 | 60.515 |
| 1819.8 | 63.006 | 26.643 | 57.714 |
| 1822.3 | 69.503 | 34.391 | 50.519 |

- Median ocular reduction: `57.71%`.
- Minimum ocular reduction: `50.52%`.
- Interpretation: the selected ICA subtraction produced substantial and
  repeatable attenuation of frontal ocular transients.

### Target-locked N400 preservation QC

- Valid target events: `300/300`.
- Centroparietal target-locked results:
  - original mean, 300–500 ms: `0.2038 uV`
  - clean mean, 300–500 ms: `0.0941 uV`
  - clean minus original: `-0.1097 uV`
  - waveform correlation, 0–800 ms: `0.977374`
  - RMS difference, 0–800 ms: `0.0938 uV`
  - maximum absolute ERP difference: `0.1443 uV`
- Interpretation: target-locked morphology was strongly preserved, with only
  a small mean-amplitude shift. This passed the conservative N400-preservation
  gate for final saving.

### Final save, reload, and lock QC

- Final dataset:
  `/Users/kevinchain/Desktop/N400_project/derivatives/01A_preica_icaclean.set`
- Companion data file: `01A_preica_icaclean.fdt`.
- Reloaded dataset checks:
  - channels: `67`
  - samples: `910550`
  - sampling rate: `250.0 Hz`
  - events: `602`
  - maximum data difference versus pre-reload clean copy: `0 uV`
  - event types unchanged: yes
  - maximum event-latency difference: `0 samples`
  - channel labels unchanged: yes
  - remaining ICA components: `52/52`
  - all data finite: yes
  - ICA-rejection metadata present: yes
  - recorded removed components:
    `[2 14 23 24 25 32 33 35 36 40 53 60]`
  - event `99` retained: yes
  - event `98` retained: yes
  - maximum VEOG/HEOG/TRIGGER differences after reload: `0`
  - SET and FDT files present: yes
  - SET bytes: `4033760`
  - FDT bytes: `244027400`
  - expected FDT bytes: `244027400`
  - FDT size exact: yes
- Decision: `01A_preica_icaclean.set` is the locked official post-ICA cleaned
  continuous derivative for the next phase. Preserve
  `01A_preica_icaweights.set` as the pre-subtraction source.
- Do not reject additional components or rerun ICA without new evidence and a
  documented decision.

### GUI-to-command reproducibility convention

- Every future GUI tutorial must include both the GUI path/settings and the
  equivalent MATLAB/EEGLAB command.
- Equivalent command for the locked ICA subtraction:

```matlab
removedICs = [2 14 23 24 25 32 33 35 36 40 53 60];
EEG = pop_subcomp(EEG, removedICs, 0);
EEG = eeg_checkset(EEG);
```

## Next gate

Before epoching, freeze and verify the event-code dictionary, condition/bin
assignments, target-locking rule, epoch window, and baseline interval. Use
`01A_preica_icaclean.set` as the locked input.
> Prospective policy update (2026-07-28): 01A itself was completed without a
> pre-ICA simple-voltage threshold. Beginning with subsequent participants,
> the standardized training copy uses a condition-blind `-100 to +100 uV`
> threshold on ICA channels 1–64, with whole retained task segments as the
> rejection unit. See `reports/cohort_preprocessing_policy.md`. This note does
> not retroactively change the 01A derivative or its provenance.
