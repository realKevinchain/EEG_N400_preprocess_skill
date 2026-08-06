# 01A Phase 2 pre-ICA parameter decisions

Prepared: 2026-07-23  
Status: **approved for the manual 01A GUI pilot on 2026-07-23; final filter choice remains gated by the A/B/C comparison**  
Participant: `01A`  
Canonical input: `/Users/kevinchain/Desktop/N400_project/input_set/01A_imported.set`

This document covers only Phase 2 pre-ICA preparation. It does not authorize ICA training, component removal, final rereferencing, interpolation, EventList/BinList creation, epoching, artifact rejection, averaging, or N400 scoring.

## Evidence and decision rules

- `[BOOK]`: explicitly stated in Luck (2022), with physical PDF page.
- `[DERIVED]`: adaptation from the book plus this dataset's verified properties.
- `[GENERAL]`: broader practice not established by the book.
- `[DECIDE]`: study-specific choice that remains configurable.
- `[UNVERIFIED]`: not yet confirmed; do not execute as fact.

The book's worked values are candidates rather than universal defaults. Filter distortion, reference choice, participant-specific bad channels, and the installed software behavior must be checked before release. `[BOOK]` PDF pp. 124, 143, 195, 364–366.

## Verified Phase 1 inputs

| Item | Verified state | Evidence |
|---|---|---|
| Canonical SET/FDT | Saved, internally consistent; 67 channels, 3,642,200 samples, 1000 Hz, one continuous record | `[DERIVED]` 01A import/alignment audit |
| Events | 602 total; 600 experimental; 300 valid sentence–target pairs; 0 invalid pairs | `[DERIVED]` 01A import/alignment audit |
| Behavior alignment | 300/300 target-word condition codes match in order; `Subject=11` confirmed as `01A` | `[DERIVED]` 01A behavior–EEG audit |
| Channel labels | 67 unique; EEG positions on 64 channels; VEOG, HEOG, TRIGGER lack XYZ | `[DERIVED]` 01A import/alignment audit |
| Coordinate provenance | CURRY manufacturer/template coordinates, not participant digitization | `[DERIVED]`; do not claim individual localization |
| Acquisition reference | Dedicated online `REF.`; M1/M2 are recorded channels, not the online reference | `[DERIVED]` from acquisition audit |
| Line noise | Strong narrow-band 50 Hz peak | `[DERIVED]` from Phase 1 spectral audit |
| Slow drift/DC | Large DC offsets and low-frequency drift observed | `[DERIVED]` from Phase 1 waveform/spectral audit |

## Proposed decision table

| ID | Parameter | Proposed pilot handling | Status | Rationale and evidence | Required QC / release condition |
|---|---|---|---|---|---|
| P2-01 | Input dataset | Load `01A_imported.set`; never overwrite it | **Confirmed** | Canonical import and FDT dimensions passed. `[DERIVED]` | Output must use a new stage-specific name |
| P2-02 | Channel locations | Retain the 64 CURRY XYZ coordinates already stored in the SET; do **not** reload XML/DAT in the pre-ICA script | **Confirmed** | Reloading risks changing a montage that already passed geometry review. `[DERIVED]`; locations before ICA are supported by `[BOOK]` PDF p. 365 | Recheck 67 unique labels, 64 XYZ coordinates, and CPZ/CZ/PZ/M1/M2 indices after processing |
| P2-03 | Analysis EEG group | Treat channels 1–64 as EEG electrodes, including M1/M2; exclude VEOG, HEOG, and TRIGGER from the EEG group | **Approved 2026-07-23** | Matches the verified import structure. `[DERIVED]` | Confirm the 64-label list in MATLAB before execution |
| P2-04 | Channels to filter | Filter the 64 EEG channels plus VEOG and HEOG; never filter TRIGGER | **Approved 2026-07-23** | The book recommends filtering EEG/EOG but notes that auxiliary signals may require different handling. `[BOOK]` PDF pp. 364–365 | Confirm channel selection is exactly 1–66 and event timing is unchanged |
| P2-05 | EOG derivation | Preserve VEOG and HEOG unchanged; do not create duplicate bipolar channels; retain both for ocular-artifact assessment but exclude them from later ICA training | **Confirmed** | The acquisition XML identifies VEOG as hardware channel `BP 1` and HEOG as `BP 2`, both with `TYPE=1`. The user confirmed that VEOG used electrodes above and below the participant's left eye, and HEOG used electrodes approximately one finger-width lateral to the left and right eyes. `[DERIVED]` The positive-minus-negative orientation remains `[UNVERIFIED]`. The book says to skip bipolar creation when bipolar EOG already exists. `[BOOK]` PDF p. 365 | Confirm that both channels show plausible blink/vertical-eye-movement and horizontal-eye-movement activity; record polarity if the amplifier lead assignment can be recovered |
| P2-06 | Initial rereference | Do not rereference in Phase 2 | **Confirmed** | Data were acquired with a usable dedicated reference; the book says to defer rereferencing when data were already referenced during recording. `[BOOK]` PDF p. 365; acquisition state `[DERIVED]` | `EEG.ref` and channel data must show no unintended rereference |
| P2-07 | Final reference | Defer until post-ICA; compare average mastoids (M1/M2) with 64-EEG average reference before the study-level choice | **Deferred** `[DECIDE]` | Language ERP studies commonly use average mastoids; the book also recommends viewing multiple references and matching the subfield. `[BOOK]` PDF pp. 143, 153 | No final-reference operation in pre-ICA; later decision must state whether M1/M2 enter an average reference |
| P2-08 | Resampling | 1000 → **250 Hz** with EEGLAB `pop_resample` defaults | **Approved 2026-07-23** | The book's example uses 250 Hz and notes EEGLAB anti-alias filtering. `[BOOK]` PDF p. 364. N400 fixed-window mean scoring does not require 1000 Hz temporal resolution. `[DERIVED]` | Verify anti-alias filtering, event count/type preservation, latency rounding, duration, and 4 ms sample interval |
| P2-09 | Analysis high-pass | **0.1 Hz half-amplitude**, noncausal Butterworth, effective order 2 / 12 dB/oct; remove DC before filtering | **Selected 2026-07-24** | The source recommends continuous high-pass filtering, DC removal, and warns against >0.1 Hz without strong justification. `[BOOK]` PDF pp. 124, 129, 364–365; GUI impulse/waveform QC passed. `[DERIVED]` | Reconfirm settings and history in the final derivative |
| P2-10 | Analysis low-pass / 50 Hz | **Candidate B selected:** separate 30 Hz half-amplitude Butterworth low-pass, noncausal, effective order 8 / 48 dB/oct, after the order-2 high-pass | **Selected 2026-07-24** | B attenuated absolute 50 Hz power by 42.175 dB versus the unfiltered 250 Hz copy, placed 50 Hz 11.705 dB below 10–20 Hz, retained wider bandwidth than C, and showed no consequential ringing in matched views. `[DERIVED]` | Reproduce as two separate filter calls and pass final dataset QC |
| P2-11 | Separate notch/CleanLine | Do not apply | **Confirmed unnecessary for pilot 2026-07-24** | After candidate B, 50 Hz was 11.705 dB below 10–20 Hz despite a narrow residual peak. Additional line-noise filtering is not justified. `[DERIVED]` | Stop and reassess only if later subject-level QC contradicts the pilot evidence |
| P2-12 | Filter boundaries | Use continuous-data filtering with DC removal on the high-pass call and boundary-aware handling on both calls; current SET has no `boundary` events | **Confirmed 2026-07-24** | Filtering continuous EEG minimizes epoch-edge artifacts. `[BOOK]` PDF p. 124; GUI calls verified. `[DERIVED]` | Confirm no events are lost or reordered and inspect beginning/end transients |
| P2-13 | Bad-channel identification | Manual review at short and long scales; record globally bad channels and intermittent bad periods separately; exclude reviewed global bad channels from later ICA but do not interpolate in Phase 2 | **Pilot inspection complete 2026-07-24** | No global bad channel was found; M2 remains an intermittent review channel. `[DERIVED]`; method supported by `[BOOK]` PDF pp. 185–195, 365–366 | Reconfirm on the final derivative and retain the observation in participant QC |
| P2-14 | Rest and breaks | Keep all data in the pre-ICA analysis dataset; do not delete 99/98 periods in Phase 2 | **Confirmed** | Break/extreme-segment deletion belongs on the later ICA-training copy so analysis trial accounting remains intact. `[BOOK]` PDF pp. 366–367 | Event count remains 602; rest events remain present |
| P2-15 | Rank | Record rank after the chosen resampling/filtering steps and again after any later channel exclusion/reference operation | **Confirmed 2026-07-24: rank 64 for EEG channels 1:64** | ICA channel count must not exceed effective rank. `[DERIVED]` from `[BOOK]` PDF pp. 241–271, 366–367 | Recompute if later ICA-training exclusions or references change the channel matrix |
| P2-16 | Output | Save a new dataset as `/Users/kevinchain/Desktop/N400_project/derivatives/01A_preica.set` | **Completed and reloaded 2026-07-24** | Stage-specific saving preserves the canonical input. `[BOOK]` PDF p. 365 | Reloaded SET/FDT passed byte-size, dimensions, data, event, location, and history reconciliation |
| P2-17 | Runtime compatibility | Execute manually in Classic EEGLAB/ERPLAB first; capture GUI-generated history and local help | **Completed for Phase 2 pilot 2026-07-24** | ERPLAB 13 carries a MATLAB 2025a+ compatibility warning, while this machine uses MATLAB R2026a. `[GENERAL]` version record | No unexpected runtime warning or incompatibility affected the completed operations |

## Low-pass / line-noise comparison protocol

All candidates use the same canonical input and the proposed 0.1 Hz high-pass. They are temporary comparison copies, not final derivatives.

| Candidate | High-pass | Low-pass | ERPLAB effective order | Purpose |
|---|---:|---:|---:|---|
| A: source-standard | 0.1 Hz | 30 Hz | 2 for both edges | Baseline comparison corresponding to approximately 12 dB/oct |
| B: steep low-pass | 0.1 Hz, order 2 | 30 Hz, order 8 | Separate high- and low-pass operations | Preserve 20–30 Hz while more strongly attenuating 50 Hz |
| C: lower low-pass | 0.1 Hz | 20 Hz | 2 for both edges | More gradual but lower-frequency suppression of 50 Hz |

Candidate B cannot be represented by the current template's single band-pass call because the high- and low-pass edges need different orders. The pipeline must not execute Candidate B until separate filter operations are implemented and verified. `[DERIVED]`

The installed ERPLAB 13 source was checked locally:

- `pop_basicfilter` accepts `Filter`, `Design`, `Cutoff`, `Order`, `RemoveDC`, and `Boundary`.
- For Butterworth filtering, ERPLAB's `filter_tf.m` halves the supplied order internally because forward–reverse `filtfilt` doubles the effective order.
- Therefore supplied `Order=2` represents effective order 2, and `Order=8` represents effective order 8. `[DERIVED]` from installed ERPLAB 13 source; still verify the GUI-generated call on this machine.

For each candidate:

1. Plot and save the filter frequency response and impulse response.
2. Compare spectra at representative frontal, central, centro-parietal, mastoid, and EOG channels.
3. Quantify residual 50 Hz power relative to neighboring frequencies.
4. Inspect identical short and long continuous windows before and after filtering.
5. Inspect event-centered averages only as a distortion diagnostic, not for choosing the scientifically favorable result.
6. Prefer the least aggressive candidate that adequately controls line noise without consequential temporal distortion. `[DERIVED]` from `[BOOK]` PDF pp. 124–125, 129.

## Phase 2 manual execution order after approval

1. Load `01A_imported.set` and record software paths/versions.
2. Verify the stored channel locations; do not reload coordinates.
3. Record the verified bipolar EOG status; inspect signal plausibility and document the electrode pairs/polarity if available.
4. Run the three temporary filter comparisons and document QC.
5. Choose and record one analysis filter strategy.
6. Resample/filter the canonical input copy using the approved order and settings.
7. Apply no initial rereference.
8. Inspect short and long windows; record global and intermittent bad-channel findings.
9. Check events, locations, reference state, spectra, waveform distortion, and rank.
10. Save and reload `01A_preica.set` only after every Phase 2 gate item passes.

## Approval and remaining gates

The user approved on 2026-07-23:

1. 250 Hz as the analysis sampling rate.
2. The A/B/C low-pass comparison protocol.
3. Filtering EEG + VEOG + HEOG while excluding TRIGGER.
4. `/Users/kevinchain/Desktop/N400_project/derivatives/01A_preica.set` as the stage output.

Remaining Phase 2 gates: **none for participant 01A.**

The repository contains only the unchanged reusable `config_template.m`; no participant-specific config copy currently exists to mark as reviewed. Do not set the reusable template's `cfg.decisions.parameters_reviewed` default to `true`. A later participant-specific config may set its copied flag only after carrying forward this approved ledger.

## GUI pilot log

### 2026-07-24 — environment and canonical-load gate

**Status: PASS.** `[DERIVED]`

- EEGLAB: `/Users/kevinchain/Documents/MATLAB/eeglab2026.0.0/eeglab.m`
- ERPLAB filter: `/Users/kevinchain/Documents/MATLAB/eeglab2026.0.0/plugins/erplab-master/pop_functions/pop_basicfilter.m`
- EEGLAB resampling: `/Users/kevinchain/Documents/MATLAB/eeglab2026.0.0/functions/popfunc/pop_resample.m`
- EEGLAB ICA: `/Users/kevinchain/Documents/MATLAB/eeglab2026.0.0/functions/popfunc/pop_runica.m`
- Loaded plugins reported by EEGLAB: ERPLAB 13.00, loadcurry 3.3.2, firfilt 2.8, ICLabel 1.7, clean_rawdata 2.11, dipfit 5.6, and EEG-BIDS 10.5.
- Failure to retrieve internet extension statistics did not prevent local plugin loading. `[DERIVED]`
- Canonical dataset loaded from `input_set/01A_imported.set` with its external FDT.
- GUI summary: 67 channels, 3,642,200 frames, 1 continuous epoch, 602 events, 1000 Hz, 0–3642.199 s, channel locations present, no ICA weights, approximately 1005.7 MB.
- EEGLAB displays `Reference: unknown`. This describes incomplete EEGLAB reference metadata; it does not replace the acquisition evidence showing a dedicated online `REF.`. No rereference will be performed in Phase 2. `[DERIVED]`

### 2026-07-24 — unfiltered short-/long-window visual gate

**Status: PASS with participant-level observations.** `[DERIVED]`

- Raw display without mean removal confirms very large channel DC offsets; display-only mean removal was used for readable inspection and did not modify the data.
- Five-second inspection near 1800 s shows continuous signal at CZ, CPZ, PZ, their neighbors, M1/M2, posterior channels, VEOG, and HEOG; no persistent flatline or saturation was seen.
- Widespread regular 50 Hz activity is visible across EEG/EOG and remains the principal spectral issue.
- A brief multichannel transient occurs near 1804.7 s; it is not evidence for a globally bad channel.
- Sixty-second inspection at approximately 500–560 s, 1770–1830 s, and 3300–3360 s shows no persistent globally bad EEG channel in the reviewed pages.
- M2 shows intermittent slow excursions, especially near 534–538 s and during eye-movement periods around 1817 s, but is stable in the late window. Record M2 as an intermittent review channel, not a global bad channel.
- M1/M2 show relatively prominent high-frequency/line noise. Do not remove them solely for this reason; reassess after the filter comparison and later with ERP/SME evidence.
- VEOG shows repeated blink-like deflections and HEOG shows plausible horizontal-eye-movement deflections, confirming usable bipolar EOG signals.
- Provisional 01A global bad-channel list before ICA: empty.
- No channel, interval, or epoch was selected or rejected during this inspection.

### 2026-07-24 — candidate A resampling gate

**Status: PASS.** `[DERIVED]`

- The canonical dataset was resampled in memory from 1000 to 250 Hz with EEGLAB `pop_resample` defaults.
- Temporary dataset name: `01A_A_rs250`; it was not saved to disk at this gate.
- Channels: 67 before and after.
- Events: 602 before and after.
- Continuous epochs: 1 before and after.
- Samples: 3,642,200 → 910,550, exactly one quarter of the original count.
- Displayed end time: 3642.199 → 3642.196 s. The 3 ms change is consistent with the new 4 ms sampling grid and is not evidence of lost recording time.
- Channel locations remain present; no ICA weights are present.

### 2026-07-24 — candidate A filter gate

**Status: PASS for creation of the temporary comparison candidate; final filter selection remains pending B/C comparison.** `[DERIVED]`

- Input: in-memory 250 Hz temporary dataset `01A_A_rs250`.
- Output: in-memory temporary dataset `01A_A_0p1_30_o2`; it was not saved to disk at this gate.
- ERPLAB 13 Basic Filter settings: Butterworth band-pass, half-amplitude cutoffs 0.1–30 Hz, noncausal forward–reverse filtering, effective order 2, DC removal enabled, boundary-aware filtering using event code `boundary`, channels 1:66.
- Channel 67 (`TRIGGER`) was excluded from filtering.
- Filtered dataset summary remained 67 channels, 910,550 samples, 1 continuous epoch, 602 events, 250 Hz, 0–3642.196 s, channel locations present, and no ICA weights.
- The unfiltered-data preview showed a very strong narrow 50 Hz peak. Candidate A materially attenuated this peak, but a conspicuous residual peak remained; Candidate A is therefore retained as the gentle baseline and is not yet the final analysis choice.
- The GUI-equivalent ERPLAB command is:

```matlab
EEG = pop_basicfilter(EEG, 1:66, ...
    'Filter', 'bandpass', ...
    'Design', 'butter', ...
    'Cutoff', [0.1 30], ...
    'Order', 2, ...
    'RemoveDC', 'on', ...
    'Boundary', 'boundary', ...
    'History', 'gui');
EEG.setname = '01A_A_0p1_30_o2';
```

- Future GUI pilot instructions must be followed by the equivalent MATLAB command, with arguments checked against the installed local function and, when available, the command generated in `EEG.history`.

### 2026-07-24 — candidate B filter gate

**Status: PASS for creation of the temporary comparison candidate; final filter selection remains pending candidate C and matched waveform QC.** `[DERIVED]`

- Candidate B was created afresh from the unfiltered 250 Hz temporary dataset `01A_A_rs250`, not by cascading another filter onto candidate A.
- First operation: Butterworth high-pass, 0.1 Hz half-amplitude cutoff, noncausal forward–reverse filtering, effective order 2, DC removal enabled, boundary-aware handling using `boundary`, channels 1:66. Temporary intermediate dataset: `01A_B_hp0p1_o2`.
- Second operation: Butterworth low-pass, 30 Hz half-amplitude cutoff, noncausal forward–reverse filtering, effective order 8, DC removal disabled, boundary-aware handling using `boundary`, channels 1:66. Temporary final comparison dataset: `01A_B_0p1o2_30o8`.
- Channel 67 (`TRIGGER`) was excluded from both filter operations.
- The order-8 low-pass displayed a 48 dB/oct roll-off and an approximately 27.10 Hz half-power point.
- Its impulse response was symmetric and showed short-lived ringing around the central impulse, without visible long-duration instability in the 0–1000 ms display. Matched continuous/event-centered waveform inspection is still required before selection.
- The 50 Hz peak in the preview-filtered spectrum was reduced from the dominant unfiltered peak to a small residual near the spectral baseline. Candidate B therefore provides substantially stronger line-noise suppression than candidate A.
- GUI-equivalent ERPLAB commands:

```matlab
EEG = pop_basicfilter(EEG, 1:66, ...
    'Filter', 'highpass', ...
    'Design', 'butter', ...
    'Cutoff', 0.1, ...
    'Order', 2, ...
    'RemoveDC', 'on', ...
    'Boundary', 'boundary', ...
    'History', 'gui');
EEG.setname = '01A_B_hp0p1_o2';

EEG = pop_basicfilter(EEG, 1:66, ...
    'Filter', 'lowpass', ...
    'Design', 'butter', ...
    'Cutoff', 30, ...
    'Order', 8, ...
    'RemoveDC', 'off', ...
    'Boundary', 'boundary', ...
    'History', 'gui');
EEG.setname = '01A_B_0p1o2_30o8';
```

### 2026-07-24 — candidate C filter gate

**Status: PASS for creation of the temporary comparison candidate; final filter selection remains pending matched waveform QC.** `[DERIVED]`

- Candidate C was created afresh from the unfiltered 250 Hz temporary dataset `01A_A_rs250`, not by cascading onto candidate A or B.
- ERPLAB 13 Basic Filter settings: Butterworth band-pass, half-amplitude cutoffs 0.1–20 Hz, noncausal forward–reverse filtering, effective order 2, DC removal enabled, boundary-aware handling using event code `boundary`, channels 1:66.
- Temporary comparison dataset: `01A_C_0p1_20_o2`; it was not saved to disk at this gate.
- Channel 67 (`TRIGGER`) was excluded from filtering.
- The displayed roll-off was 12 dB/oct, with approximately 0.20 Hz and 13.00 Hz half-power points.
- The impulse response was symmetric and showed no conspicuous additional ringing or visible long-duration instability in the 0–1000 ms display.
- The 50 Hz preview peak was reduced from the dominant unfiltered value of approximately 3.5 to approximately 0.4: stronger suppression than candidate A but weaker than candidate B.
- Candidate C attenuates useful higher-frequency content earlier than A/B; this trade-off must be considered during matched waveform inspection.
- GUI-equivalent ERPLAB command:

```matlab
EEG = pop_basicfilter(EEG, 1:66, ...
    'Filter', 'bandpass', ...
    'Design', 'butter', ...
    'Cutoff', [0.1 20], ...
    'Order', 2, ...
    'RemoveDC', 'on', ...
    'Boundary', 'boundary', ...
    'History', 'gui');
EEG.setname = '01A_C_0p1_20_o2';
```

### 2026-07-24 — matched A/B/C waveform inspection

**Status: PASS for visual comparison; candidate B is provisionally preferred, pending numerical residual-50-Hz confirmation.** `[DERIVED]`

- No interval or channel was selected or rejected during any comparison view.
- The candidates were compared at the same 1800–1805 s central-to-mastoid page using a 5 s window, 200 µV spacing, and display DC removal disabled.
- Candidate A retained visibly more fine high-frequency activity, particularly at M1 and lateral/posterior channels. Candidate B and C were smoother while retaining the CZ/CPZ slow waveform and the M2 slow excursion near 1803–1804 s.
- The candidates were also compared at 1804–1805 s using a 1 s window and 100 µV spacing. No candidate showed a clear localized overshoot or sustained symmetric ringing in this page; candidate A retained the greatest continuous fine oscillation.
- Eye-movement morphology was compared at 1815–1820 s on the posterior/mastoid/EOG page using a 5 s window, 500 µV spacing, and display DC removal disabled.
- All candidates retained VEOG blink-like transients near 1815.8 and 1819.8 s and the broad HEOG change across approximately 1816–1819 s.
- Candidate B smoothed the VEOG peaks relative to A but did not show a visible train of pre/post-peak oscillations; posterior EEG and M1/M2 remained continuous. No visual evidence sufficient to reject its order-8 low-pass was found.
- Candidate C also retained the ocular transients without conspicuous ringing, but its approximately 13 Hz half-power point sacrifices more 13–30 Hz content while leaving more residual 50 Hz than B.
- On the current visual evidence, B offers the best balance of line-noise suppression and bandwidth retention. Final selection remains gated on an objective 50 Hz-versus-neighbor spectral metric and subsequent event/reference/rank QC.
- GUI-equivalent continuous-data viewer call:

```matlab
pop_eegplot(EEG, 1, 1, 1);
```

  Start time, window length, channel-page position, and spacing were adjusted interactively inside `eegplot` and are not fully encoded by this `pop_eegplot` call.

### 2026-07-24 — residual 50 Hz quantitative gate and final filter selection

**Status: PASS; candidate B selected.** `[DERIVED]`

- Spectra were calculated on CZ, CPZ, PZ, M1, M2, VEOG, and HEOG using 4 s windows (1000 samples at 250 Hz), 50% overlap, and a 1000-point FFT (0.25 Hz resolution).
- The median 50 Hz peak above the 47–49/51–53 Hz local neighbors was 35.825 dB for A, 20.137 dB for B, and 35.767 dB for C.
- Median absolute 50 Hz spectral values were 26.129 dB for the unfiltered 250 Hz copy, 13.325 dB for A, -16.046 dB for B, and 7.0378 dB for C.
- Absolute 50 Hz attenuation relative to the unfiltered 250 Hz copy was 12.804 dB for A, 42.175 dB for B, and 19.091 dB for C.
- Median 50 Hz power relative to 10–20 Hz was +30.303 dB before filtering, +19.439 dB for A, -11.705 dB for B, and +15.109 dB for C.
- Candidate B therefore provides the strongest absolute line-noise attenuation and places the residual 50 Hz component below the principal 10–20 Hz comparison band, while retaining a wider passband than C.
- The remaining narrow 50 Hz peak in B is not by itself a reason to add notch/CleanLine because its absolute level is already low relative to the retained EEG band.
- Final Phase 2 analysis filter choice: separate 0.1 Hz high-pass order 2 with DC removal, followed by 30 Hz low-pass order 8 without repeated DC removal; both noncausal Butterworth, boundary-aware, channels 1:66.

### 2026-07-24 — candidate B structural and rank gate

**Status: PASS.** `[DERIVED]`

- Dataset: `01A_B_0p1o2_30o8`.
- Dimensions: 67 channels, 910,550 samples, 250 Hz, 602 events.
- All 67 channel labels remain unique; all 64 EEG channels retain finite XYZ coordinates.
- Event types are unchanged from the unfiltered 250 Hz comparison copy; maximum event-latency difference is 0 samples.
- Channel 67 (`TRIGGER`) is bit-identical to the unfiltered 250 Hz comparison copy (maximum difference 0).
- Reference metadata is unchanged.
- The estimated spatial rank of channels 1:64, using 10,000 evenly distributed samples, is 64.
- The planned later ICA training channel count must not exceed 64; VEOG, HEOG, and TRIGGER remain excluded from ICA training.

### 2026-07-24 — filtered recording-edge visual gate

**Status: PASS.** `[DERIVED]`

- Candidate B was inspected at the first and last 5 s using 200 µV spacing, display DC removal disabled, and the same central-to-posterior/mastoid channel page.
- At the recording start, a small number of channels (including P2) showed an onset displacement confined to the first tens of milliseconds. No global, sustained decaying oscillation or multi-second instability was present.
- At the recording end (approximately 3637.2–3642.2 s), channels remained continuous without a global terminal overshoot, decaying oscillation, or instability.
- No interval was selected or rejected. The minor onset observation does not overlap an experimental target trial and does not justify deleting continuous analysis data.
- All pre-save Phase 2 gates have now passed; the next action is to save and reload the approved derivative.

### 2026-07-24 — saved derivative reload gate

**Status: PASS; Phase 2 complete for participant 01A.** `[DERIVED]`

- Saved files:
  - `/Users/kevinchain/Desktop/N400_project/derivatives/01A_preica.set`
  - `/Users/kevinchain/Desktop/N400_project/derivatives/01A_preica.fdt`
- Reloaded dimensions: 67 channels, 910,550 samples, 250 Hz, 602 events.
- All 67 labels remain unique and all 64 EEG channels retain finite XYZ coordinates.
- Event types and latencies are unchanged; maximum event-latency difference is 0 samples.
- The reloaded data are sample-for-sample identical to the pre-save memory copy; maximum difference across all data and maximum Trigger difference are both 0.
- Reloaded EEG-channel rank is 64 and reference metadata is unchanged.
- SET and FDT files both exist. FDT size is exactly 244,027,400 bytes, matching `67 × 910550 × 4`.
- Reloaded history contains `pop_resample` and exactly two `pop_basicfilter` calls, matching the approved two-stage filter.
- Phase 2 output is released for the next ICA-training preparation stage. No rereference, interpolation, epoch rejection, trial deletion, notch, or CleanLine operation was applied.
