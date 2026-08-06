# 01A Phase 5 artifact-detection pilot log

Started: 2026-07-27  
Status: **complete; locked artifact flags saved/reloaded on both M1-reference epoch derivatives**  
Primary input: `/Users/kevinchain/Desktop/N400_project/derivatives/01A_m1ref_target_epochs_pre200.set`  
No-baseline diagnostic: `/Users/kevinchain/Desktop/N400_project/derivatives/01A_m1ref_target_epochs_nobaseline_diagnostic.set`

## Locked inputs

- 67 channels, 250 samples per epoch, 300 target-locked epochs.
- Realized epoch range: `−200 to +796 ms` at 250 Hz.
- Ten target bins with 30 epochs each.
- Primary correction: mean of `−200 to 0 ms`.
- Current 01A candidate reference: M1 only.
- M1 is retained as a zero-valued reference channel; M2 is retained as a
  diagnostic `M2−M1` channel. Both must be excluded from scalp artifact
  metrics, leaving 62 scalp channels.
- Ocular, muscle, focal channel-noise, and mixed artifact ICs were already
  reviewed and removed in Phase 3.
- VEOG and HEOG were deliberately excluded from ICA subtraction and remain
  uncorrected auxiliary signals.

## Safeguards

1. Do not reject behaviorally incorrect trials during EEG artifact detection.
2. Derive pilot thresholds from pooled trials without inspecting HC–LC N400
   outcomes.
3. Do not reject an epoch solely because the uncorrected VEOG/HEOG contains a
   blink or eye movement; verify whether residual artifact remains in EEG.
4. Apply artifact flags to a new copy of the locked primary epochs.
5. Keep detector types in separate flag bits and reconcile counts by bin.
6. Visually sample both flagged and unflagged trials before locking thresholds.
7. Combine EEG-clean status with behavior `Correct` only after artifact flags
   are frozen.

## Planned gates

1. Quantify HC versus LC activity in the no-baseline `−200 to 0 ms` continuous
   speech interval at an independently selected central/centroparietal ROI and
   across all EEG channels.
2. Quantify pooled epoch-level absolute voltage and moving-window
   peak-to-peak distributions on EEG channels 1:64.
3. Review the highest-ranked candidates without condition labels.
4. Select provisional detector settings and apply them to a reversible copy.
5. Inspect false positives/negatives and condition balance.
6. Save/reload only after detector settings and trial flags are locked.

## No-baseline continuous-speech pretarget diagnostic

**Status: completed before artifact flagging; repeat on EEG-clean trials later.**

Prespecified ROI:

`C5, C3, C1, CZ, C2, C4, C6, CP5, CP3, CP1, CPZ, CP2, CP4, CP6`

The diagnostic used `−200 to <0 ms`, excluding the exact target-onset sample.
All 150 HC and 150 LC epochs were included because artifact flags do not yet
exist.

| Metric | Result |
|---|---:|
| HC mean / median | −1.926421 / −1.353498 uV |
| LC mean / median | −4.529067 / −1.535708 uV |
| LC − HC mean | −2.602647 uV |
| LC − HC median | −0.182211 uV |
| Descriptive difference / SE | −0.888 |
| Largest channelwise difference | −4.886586 uV at FPZ |
| Largest instantaneous ROI difference | −4.175070 uV at −76 ms |

LC − HC ROI means by SNR:

- −4 dB: −1.012800 uV
- −2 dB: −5.191578 uV
- +4 dB: −0.019940 uV
- +6 dB: −3.229619 uV
- quiet: −3.559296 uV

Interpretation: the large disparity between the mean and median differences,
together with a descriptive difference/SE magnitude below 1, indicates that the
uncleaned pooled mean is sensitive to a minority of large-amplitude trials.
This is not evidence for changing the primary baseline before artifact QC. Keep
the conventional pretarget correction, repeat the diagnostic after EEG-clean
trials are identified, and retain the no-baseline sensitivity analysis.

## Condition-blind pooled artifact distribution

**Status: quantitative screen complete; visual review pending.**

The screen used EEG channels 1:64 only. VEOG, HEOG, and TRIGGER were excluded.
The moving-window metric used a 200 ms window and 100 ms step.

| Percentile | Absolute maximum (uV) | Whole-epoch P2P (uV) | Moving-window P2P (uV) |
|---:|---:|---:|---:|
| 50 | 33.52 | 49.45 | 39.52 |
| 75 | 41.81 | 62.68 | 49.56 |
| 90 | 62.77 | 79.00 | 62.84 |
| 95 | 98.55 | 117.46 | 70.03 |
| 97.5 | 113.98 | 135.91 | 78.80 |
| 99 | 181.04 | 194.08 | 82.15 |
| Maximum | 345.26 | 384.06 | 108.39 |

Counts above candidate thresholds:

| Threshold (uV) | Absolute maximum | Moving-window P2P | Either |
|---:|---:|---:|---:|
| 75 | 21 | 10 | 27 |
| 100 | 15 | 1 | 15 |
| 125 | 6 | 0 | 6 |
| 150 | 4 | 0 | 4 |
| 175 | 3 | 0 | 3 |
| 200 | 3 | 0 | 3 |

The four epochs exceeding 150 uV absolute amplitude were 22, 4, 202, and 44.
Their maxima occurred at F8/F6/F6/FPZ and, in each case, near the late epoch
edge (`+764 to +796 ms`). Epochs 135 and 206 were the two closest subthreshold
cases (146.44 and 143.05 uV). No epoch exceeded 150 uV on the 200 ms
moving-window P2P detector.

Interpretation: an absolute-voltage detector is sensitive to a small set of
large slow late-epoch excursions that a moving-window P2P detector does not
capture. These may reflect slow drift, residual frontal/peripheral artifact, or
movement preparation approaching the post-target typing period. Visual review
of spatial extent, EOG synchrony, continuity, and matched controls is required
before rejection.

### EEGLAB viewer compatibility note

The first `pop_eegplot(REVIEW, 1, 1, 1)` review window failed during an
interactive redraw at `eegplot.m:1549`, where the viewer compared its
`eventlatencies` array with the current display limits and encountered
incompatible shapes. The failure occurred only in the temporary epoched subset
created by `pop_select`; no source or derivative was modified or saved. Review
will continue with a display-only copy whose `EEG.event` field is cleared, so
the viewer draws the same EEG/EOG data and epoch boundaries without event
labels. The locked `EPOCHCHK` event and EventList structures remain untouched.

## Sustained late-drift screen

**Status: quantitative screen complete; provisional threshold awaiting
boundary-case visual review.**

To distinguish sustained late movement from short moving-window excursions, a
second condition-blind screen compared each EEG channel's mean over
`700–796 ms` with its mean over `−200 to <0 ms`. The screen used all 300 epochs
and EEG channels 1:64. Two summaries were retained: the largest absolute
channelwise change and the absolute median change across all 64 EEG channels.

| Percentile | Maximum channel change (uV) | Absolute global-median change (uV) |
|---:|---:|---:|
| 50 | 20.18 | 5.59 |
| 75 | 29.77 | 11.30 |
| 90 | 51.19 | 32.95 |
| 95 | 88.76 | 62.68 |
| 97.5 | 110.43 | 80.99 |
| 99 | 167.41 | 145.06 |
| Maximum | 331.71 | 284.93 |

Counts above candidate thresholds:

| Threshold (uV) | Maximum channel change | Global-median change |
|---:|---:|---:|
| 25 | 103 | 38 |
| 50 | 32 | 20 |
| 75 | 18 | 10 |
| 100 | 11 | 5 |
| 125 | 6 | 4 |
| 150 | 3 | 3 |

The top candidates were epochs 22, 4, 202, 44, 135, 206, 247, 64, 121,
140, 103, and 162. The strongest cases affected nearly all EEG channels and
often coincided with large VEOG or HEOG changes. This supports interpreting
them as widespread late movement or residual ocular/body artifact rather than
single-channel noise. EOG activity is corroborative only: because VEOG and
HEOG were deliberately left uncorrected, no epoch will be rejected solely from
an auxiliary-channel excursion.

The provisional sustained-drift rule is an absolute global-median change of at
least 75 uV. A reproducible recalculation using the explicitly defined
`−200 to <0 ms` baseline identified 11/300 epochs (3.7%): 4, 22, 44, 49, 64,
103, 135, 140, 202, 206, and 247. The small difference from the first
screen's count of 10 reflects the explicit exclusion of the time-zero sample;
epoch 49 lies only slightly above the proposed boundary.

All four epochs exceeding ±150 uV (4, 22, 44, and 202) were contained within
the 11 sustained-drift candidates, so the absolute-voltage rule added no
unique epoch at this stage. Cases around the proposed boundary showed no clear
numerical gap: epochs 140 and 49 were just above it (75.159 and 75.659 uV),
whereas 162 and 54 were just below it (73.019 and 72.148 uV). Therefore 75 uV
is not yet a locked cutoff. These boundary cases must be compared visually
before deciding whether the metric and threshold distinguish artifact
reliably. The 200 ms moving-window P2P screen also remains separate and
unlocked. No artifact flag has yet been written.

### Average-mastoid trace interpretation and reference-control gate

During boundary-case review, retained M1 and M2 traces showed prominent
opposite-polarity late shifts. This pattern is expected algebraically after
average-mastoid rereferencing with the reference channels retained:

`M1' = (M1 − M2) / 2` and `M2' = (M2 − M1) / 2 = −M1'`.

Thus the post-reference M1/M2 traces are not independent measurements of the
two original mastoids. Their mean is exactly zero by construction, as already
confirmed in the reference QC, and their mirror-image appearance represents
the original M1–M2 difference. They must not be treated as two separate
artifact channels or used directly to reject epochs.

However, the Phase 2/3 record noted intermittent M2 quality. Noise in either
mastoid can enter every rereferenced EEG channel through the average reference
and can therefore resemble a widespread same-direction late drift. Before the
global-median late-drift rule is accepted, the same candidate epochs must be
checked against the locked pre-reference continuous derivative. This
reference-control gate will determine whether the late shifts were already
present broadly in the EEG or were introduced/amplified by the M1/M2
reference. The 75 uV threshold remains paused, and no flag has been written.

#### Reference-control result

**Status: gate failed for use of the average-mastoid derivative as the final
artifact-screening input.**

The retained-channel identity was exact (`M1' + M2' = 0`). Pre/post-reference
decomposition then reconstructed the observed post-reference global change
with a maximum error of only `2.47836118206e−06 uV`, confirming that the
diagnostic used aligned epochs and the correct reference algebra.

For the strongest apparent post-reference drifts, the original global EEG
median changes were modest, while original M2 changes were extreme. Examples:

| Epoch | Pre-reference global EEG (uV) | Original M1 (uV) | Original M2 (uV) | Mastoid average (uV) | Post-reference global EEG (uV) |
|---:|---:|---:|---:|---:|---:|
| 22 | −13.383 | −67.816 | −529.86 | −298.84 | 285.46 |
| 4 | −9.291 | −59.602 | −313.57 | −186.58 | 177.29 |
| 202 | −20.184 | −60.521 | −293.50 | −177.01 | 156.83 |
| 44 | −4.632 | −22.565 | −254.47 | −138.52 | 133.89 |
| 206 | −10.226 | −44.260 | −199.54 | −121.90 | 111.67 |

The same pattern continued through the threshold-boundary cases. Therefore
the post-reference global-median late-drift metric was primarily detecting
reference contamination, especially from M2, rather than widespread
pre-existing EEG artifact. The provisional 75 uV rule is invalidated and must
not be used to reject trials.

Artifact flagging is paused and the Phase 4 final-reference decision is
reopened. All existing average-mastoid continuous and epoched derivatives are
preserved as diagnostic provenance and must not be overwritten. The next gate
is a condition-blind, all-epoch comparison of original M1, original M2, and
candidate alternative-reference behavior from the locked pre-reference
source.

#### All-epoch alternative-reference comparison

**Status: M1-only reference approved for a new 01A candidate derivative;
project-level reference policy not yet frozen.**

The comparison used the 62 scalp channels after excluding retained M1 and M2.
The predicted average-mastoid result reconstructed the observed scalp-only
result with a maximum error of `3.33219765025e−06 uV`.

| Percentile | Original M1 | Original M2 | Pre-reference scalp | Predicted M1 reference | Predicted M2 reference | Predicted average mastoids |
|---:|---:|---:|---:|---:|---:|---:|
| 50 | 6.624 | 11.319 | 4.214 | 4.008 | 8.796 | 5.794 |
| 75 | 12.057 | 22.370 | 6.877 | 7.126 | 19.016 | 11.536 |
| 90 | 19.498 | 62.441 | 10.556 | 11.098 | 56.025 | 33.209 |
| 95 | 25.689 | 121.750 | 12.700 | 14.253 | 115.390 | 62.937 |
| 97.5 | 31.821 | 162.260 | 15.161 | 24.714 | 150.980 | 81.400 |
| 99 | 55.232 | 273.990 | 20.470 | 37.821 | 261.970 | 145.750 |
| Maximum | 67.816 | 529.860 | 26.529 | 55.818 | 517.860 | 286.840 |

Counts at the most informative thresholds:

| Absolute late-change threshold | Original M1 | Original M2 | Pre-reference scalp | M1 reference | M2 reference | Average mastoids |
|---:|---:|---:|---:|---:|---:|---:|
| 25 uV | 16 | 71 | 2 | 7 | 63 | 38 |
| 50 uV | 4 | 36 | 0 | 2 | 33 | 20 |
| 75 uV | 0 | 22 | 0 | 0 | 22 | 11 |
| 100 uV | 0 | 18 | 0 | 0 | 17 | 5 |
| 150 uV | 0 | 10 | 0 | 0 | 9 | 3 |

The reference-independent M2−M1 late-change difference had a median absolute
value of `8.769 uV`, a 95th percentile of `101.747 uV`, a 99th percentile of
`232.442 uV`, and a maximum of `462.045 uV`. This is a pronounced asymmetric
tail rather than a small number of isolated numerical anomalies.

For 01A, M1-only referencing preserves substantially more usable data and
introduces far less late global displacement than either M2-only or
average-mastoid referencing. Interpolating or numerically repairing M2 is not
justified. The remaining decision is whether M1 will be the common project
reference or a documented participant-specific fallback; mixing references
across participants should not occur implicitly.

On 2026-07-28 the user approved creation of a new M1-only 01A candidate branch
from the locked pre-reference source. This authorization does not permit
overwriting the average-mastoid files and does not establish M1 as the common
reference for other participants.

## M1-reference Phase 5 restart

**Status: pooled 62-scalp-channel distribution complete; condition-blind
visual threshold review pending.**

The renewed screen used the saved/reloaded
`01A_m1ref_target_epochs_pre200.set/.fdt` derivative. Retained M1, retained
diagnostic M2, VEOG, HEOG, and TRIGGER were excluded from numerical scalp
metrics, leaving 62 scalp channels.

| Percentile | Absolute maximum | Whole-epoch P2P | 200 ms moving-window P2P | Maximum-channel late change | Global-median late change |
|---:|---:|---:|---:|---:|---:|
| 50 | 34.901 | 51.138 | 43.733 | 18.570 | 4.008 |
| 75 | 41.971 | 64.269 | 53.972 | 25.348 | 7.126 |
| 90 | 53.273 | 76.372 | 70.400 | 37.714 | 11.098 |
| 95 | 63.525 | 87.868 | 76.945 | 49.639 | 14.253 |
| 97.5 | 77.510 | 97.491 | 84.437 | 68.244 | 24.714 |
| 99 | 85.433 | 109.170 | 91.202 | 76.126 | 37.821 |
| Maximum | 106.680 | 123.290 | 112.250 | 101.390 | 55.818 |

Descriptive threshold counts:

| Threshold | Absolute maximum | Moving-window P2P | Either amplitude rule | Global-median late change |
|---:|---:|---:|---:|---:|
| 50 uV | 38 | 105 | 118 | 2 |
| 75 uV | 10 | 20 | 27 | 0 |
| 100 uV | 1 | 1 | 2 | 0 |
| 125 uV or higher | 0 | 0 | 0 | 0 |

The global-median late maximum fell from approximately `286.84 uV` under
average-mastoid referencing to `55.818 uV` under M1 referencing, and no epoch
reached 75 uV. This confirms that the former widespread late-drift tail was
reference contamination and that the invalidated 75 uV global-drift rule must
not be revived.

The renewed amplitude distributions instead show a sparse upper tail:
epoch 22 was the only absolute-amplitude case above 100 uV (`106.68 uV` at F8,
712 ms), and epoch 115 was the only 200 ms moving-window case above 100 uV
(`112.25 uV`, with its absolute maximum at PO8, 484 ms). A 50 uV
moving-window rule would flag 105/300 trials and is clearly unsuitable.
Thresholds between 75 and 100 uV remain provisional and require
condition-hidden visual comparison of the 27-trial union plus unflagged
boundary controls. No artifact flag has been written.

The condition-hidden review set contained 27 epochs meeting either 75 uV
amplitude rule, five immediately subthreshold controls, and three ordinary
controls. The moving-window values showed no boundary at 75 uV: the last
included case was 75.51 uV and the five immediately excluded cases ranged
from 72.86 to 74.59 uV. Therefore 75 uV is not defensible as an automatic
cutoff from this distribution.

The two numerically isolated clear-tail cases were epoch 115 (moving-window
P2P 112.25 uV) and epoch 22 (absolute maximum 106.68 uV). Epochs 232 and 66
were the closest moving-window comparators at 95.22 and 93.91 uV, and epoch 4
was the closest absolute-amplitude comparator at 94.70 uV. These five cases
must be localized and visually compared before a provisional 100 uV rule is
accepted. No flag has been written.

### First M1-reference visual review

At a common 100 uV display scale, review epochs 22 and 4 showed widespread
same-direction slow shifts across the scalp together with large late VEOG
changes. These are provisionally classified as clear residual
ocular/body-movement artifacts.

In contrast, epochs 115, 232, and 66 showed predominantly posterior,
spatially graded, regular oscillatory activity without a matching widespread
frontal/EOG morphology. This is consistent with high-amplitude posterior
alpha rather than a nonphysiological step or broadband artifact. In
particular, epoch 115 demonstrates that a 100 uV moving-window P2P rule would
produce a false positive. The moving-window detector is therefore not
accepted at 100 uV and remains disabled pending further review.

After M1 rereferencing, the two visually clear slow-shift cases were also the
only epochs with absolute global-median late change at or above 50 uV:
epoch 22 (`55.818 uV`) and epoch 4 (`50.642 uV`). The next case was epoch 202
at `40.773 uV`. A new 62-scalp-channel late-change threshold of 50 uV is
therefore provisionally plausible, but it is distinct from the invalidated
average-mastoid rule and cannot be locked until epoch 202 and lower controls
are visually compared. No flag has been written.

### Late-global boundary review and cancellation safeguard

The focused comparison included epochs 22, 4, 202, 49, and an ordinary
control. Epochs 22 and 4 again showed the strongest widespread late shifts,
whereas epoch 49 was dominated by posterior rhythmic activity and the control
was unremarkable.

However, the comparison invalidated use of post-reference global late change
as a standalone reference-artifact detector. Epoch 202 had a post-reference
global value of only `40.773 uV`, below the proposed 50 uV line, despite an
original M1 late change of `−60.521 uV`. Its original scalp-global change of
`−20.184 uV` partially cancelled the M1-reference displacement. The same
reference artifact can therefore fall above or below a post-reference
threshold depending on the simultaneous scalp signal.

Consequently, the proposed 50 uV post-reference global rule is not locked.
M1-reference quality must instead be screened directly on the locked
pre-reference epochs, condition-blind, using the original M1 waveform. This
reference-quality screen will be a distinct detector/flag source from scalp
artifact detectors. No flag has been written.

### Direct pre-reference M1 distribution

The original M1 waveform was screened condition-blind over the same 300
target epochs. Metrics were computed on the ERPLAB-matched `−200 to +796 ms`
grid; absolute amplitude was measured after subtracting each epoch's original
M1 `−200 to <0 ms` mean.

| Percentile | Centered absolute maximum | Whole-epoch P2P | 200 ms moving-window P2P | Absolute late change |
|---:|---:|---:|---:|---:|
| 50 | 23.127 | 37.985 | 31.925 | 6.624 |
| 75 | 28.358 | 43.523 | 36.400 | 12.057 |
| 90 | 35.697 | 52.846 | 39.974 | 19.498 |
| 95 | 40.176 | 56.531 | 43.267 | 25.689 |
| 97.5 | 44.492 | 65.006 | 47.192 | 31.821 |
| 99 | 62.568 | 73.410 | 54.054 | 55.232 |
| Maximum | 75.205 | 87.437 | 63.902 | 67.816 |

At 50 uV, centered absolute amplitude identified five epochs, moving-window
P2P identified five, and absolute late change identified four. The metrics
were not interchangeable: the moving-window set included epoch 115, whose
posterior rhythmic activity was already judged a likely false positive, while
late change missed epoch 206.

The five centered-absolute M1 candidates were epochs 22 (`75.205 uV`), 202
(`65.348 uV`), 4 (`65.326 uV`), 133 (`59.810 uV`), and 206 (`54.809 uV`).
The closest lower cases were epochs 247 (`48.978 uV`) and 130
(`48.866 uV`). A direct original-M1 centered absolute threshold of 50 uV is
therefore the provisional reference-quality rule. It must be visually checked
against these two boundary cases before locking. No flag has been written.

The direct original-M1 display confirmed that all five candidates showed a
large sustained displacement or terminal excursion in M1 that propagated
into the M1-referenced scalp data. Epoch 247 (`48.978 uV`) was dominated by
regular oscillatory activity without an equally strong sustained reference
shift, epoch 130 (`48.866 uV`) had a different brief/oscillatory morphology,
and the ordinary control was unremarkable.

Decision: lock the 01A reference-quality detector as original pre-reference
M1, centered by its own `−200 to <0 ms` mean, with an absolute maximum of at
least 50 uV over `−200 to +796 ms`. It identifies exactly epochs 4, 22, 133,
202, and 206 (5/300, 1.67%). Store this detector in artifact flag bit 1 and
mark channel 44 as the originating diagnostic channel. This flag represents
reference contamination, not a condition effect. Trial deletion remains
prohibited; the rule will first be written to a reversible primary-epoch copy
and checked across `EEG.reject`, `EEG.epoch`, `EEG.event`, and EVENTLIST.

The rule was applied to a reversible copy using ERPLAB flag bit 1. Epochs 4,
22, 133, 202, and 206 were identical across
`EEG.reject.rejmanual`, M1-specific `rejmanualE`,
zero-time `EEG.epoch.eventflag`, zero-time `EEG.event.flag`, and
`EVENTLIST.eventinfo.flag`. No other channel was marked, no other flag bit was
used, data and event count/types/latencies were unchanged, and all 300 trials
remained present. The structured detector metadata was retained in memory.

Reference-quality flag bit 1 is therefore locked. Subsequent scalp detector
review must rank the remaining 295 epochs so that the known reference failures
do not determine scalp thresholds or create duplicate decisions.

### Remaining scalp upper-tail review

After excluding the five reference-quality failures, the highest remaining
absolute-amplitude epochs were 163, 54, 135, 258, and 232
(`77.51–87.51 uV`). None showed a nonphysiological spike, saturation, isolated
electrode step, or broadband burst at the common 100 uV display scale.

The highest remaining 200 ms moving-window epochs were 115, 232, 66, 164, and
215 (`88.09–112.25 uV`). All showed regular, spatially graded posterior
oscillations consistent with alpha. The moving-window detector would therefore
reject physiologic neural activity even at 100 uV and is disabled for 01A.

An absolute scalp safety line of ±100 uV would identify only epoch 22, already
captured by reference-quality flag bit 1, and would add no unique scalp
artifact. No additional scalp-amplitude flag is written. Before the final
artifact set is frozen, the largest uncorrected VEOG/HEOG excursions must be
reviewed for residual scalp propagation; auxiliary-channel activity alone
will not cause rejection.

### EOG-extreme residual review

The ten largest remaining uncorrected auxiliary excursions had VEOG
whole-epoch P2P values from `202.31` to `299.26 uV`. Despite these large
auxiliary signals, the frontal scalp channels did not show a matching blink
morphology, and the lateral frontal channels did not show a convincing
opposite-polarity saccadic step. Cases with larger scalp values were again
dominated by posterior rhythmic activity rather than ocular propagation.

Decision: ICA subtraction adequately attenuated the ocular projection for
these extrema. No trial is flagged solely from VEOG or HEOG, and no ocular
residual flag is added.

## Locked 01A artifact detector set

The condition-blind detector set is now frozen:

1. Flag bit 1: original pre-reference M1 centered absolute maximum
   `>=50 uV`, epochs 4, 22, 133, 202, and 206.
2. Scalp absolute-amplitude detector: reviewed; no unique flag beyond the
   reference-quality cases.
3. Scalp moving-window P2P detector: disabled because its upper tail consisted
   of posterior alpha false positives.
4. EOG-only detector: prohibited; the largest auxiliary excursions showed no
   convincing residual scalp propagation.

The final artifact set contains 5/300 flagged epochs and retains all 300
epochs in the dataset. Detector thresholds must not be changed after condition
labels are revealed. The next gate is bin-balance reporting and repetition of
the no-baseline pretarget diagnostic on the 295 EEG-clean epochs.

## Post-lock condition balance

Artifact flags were distributed as follows:

| Bin | Condition | Flagged | Clean |
|---:|---|---:|---:|
| 1 | HC −4 dB | 1 | 29 |
| 2 | HC −2 dB | 0 | 30 |
| 3 | HC +4 dB | 0 | 30 |
| 4 | HC +6 dB | 1 | 29 |
| 5 | HC quiet | 1 | 29 |
| 6 | LC −4 dB | 1 | 29 |
| 7 | LC −2 dB | 0 | 30 |
| 8 | LC +4 dB | 0 | 30 |
| 9 | LC +6 dB | 0 | 30 |
| 10 | LC quiet | 1 | 29 |

HC retained 147/150 trials and LC retained 148/150. The five flagged epochs
were 4 (HC +6), 22 (LC −4), 133 (HC −4), 202 (LC quiet), and 206 (HC quiet).
This is acceptably balanced and does not motivate any detector revision.

## Clean-trial no-baseline pretarget diagnostic

The prespecified 14-channel central/centroparietal ROI was complete. After
excluding the five locked artifact epochs:

- HC/LC counts: 147/148;
- clean HC mean/median: `−1.159775/−2.014388 uV`;
- clean LC mean/median: `−0.670531/−0.524236 uV`;
- clean LC−HC mean difference: `0.489244 uV`;
- clean LC−HC median difference: `1.490152 uV`;
- descriptive difference/SE ratio: `0.503`;
- largest channelwise difference: `2.911070 uV` at O2;
- largest instantaneous ROI difference: `2.404200 uV` at `−44 ms`.

The small mean difference, difference/SE ratio below 1, and posterior rather
than prespecified-ROI channel maximum do not indicate a material systematic
pretarget offset. Retain the primary `−200 to 0 ms` correction and preserve
the no-baseline branch for sensitivity analysis. The same five bit-1 flags
must now be propagated by epoch number to both derivatives before saving;
trials remain present rather than being physically deleted.

The five bit-1 flags were propagated to an independent no-baseline copy.
Primary and no-baseline copies matched exactly at
`EEG.reject.rejmanual`, M1-specific `rejmanualE`,
zero-time `EEG.epoch.eventflag`, zero-time `EEG.event.flag`, and EVENTLIST.
No other channel was marked, the flag sets were identical, data were
unchanged, final artifact metadata was present in both, and all 300 epochs
remained. The final save/reload gate is pending.

## Final artifact-flagged derivative save/reload gate

**Status: PASS; Phase 5 complete.**

Final derivatives:

- primary:
  `01A_m1ref_target_epochs_artifactflagged.set/.fdt`;
- no-baseline sensitivity:
  `01A_m1ref_target_epochs_nobaseline_artifactflagged.set/.fdt`.

Both reloaded as 67 channels × 250 points × 300 epochs. Full pointwise data
differences were `0 uV`; times, labels, `EEG.event`, `EEG.epoch`, EVENTLIST,
and `EEG.reject` were retained exactly. Both derivatives retained the correct
five-epoch flag list at the epoch and M1-channel levels, along with artifact,
reference, binning, epoching, and ICA-rejection metadata. Histories documented
the artifact flag operation, M1 remained exactly zero, and epoched `urevent`
remained absent as expected. Each SET/FDT pair was present, and each FDT was
exactly `20,100,000` bytes.

Decision: use the primary artifact-flagged derivative for Phase 6. Keep all
300 epochs in the archived derivative; use ERPLAB's good-trial criterion or an
explicit clean mask to exclude the five flagged epochs during averaging.
Use the no-baseline artifact-flagged derivative only for sensitivity analysis.
