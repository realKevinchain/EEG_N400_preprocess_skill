# 01A Phase 4 event and epoch parameter decisions

Prepared: 2026-07-27  
Status: **01A M1-reference candidate branch complete; project-wide reference policy deferred**  
Participant: `01A`  
Locked input: `/Users/kevinchain/Desktop/N400_project/derivatives/01A_preica_icaclean.set`

This phase starts from the locked post-ICA continuous derivative. It does not
authorize overwriting that derivative or changing the ICA rejection mask.

## Evidence labels

- `[BOOK]`: explicitly stated in Luck (2022), with physical PDF page.
- `[DERIVED]`: adaptation from the source plus verified properties of this study.
- `[GENERAL]`: broader practice not established by the book.
- `[DECIDE]`: study-specific choice that is not yet frozen.
- `[UNVERIFIED]`: not yet confirmed in the installed runtime; do not execute as fact.

## Locked-input audit

Read-only inspection of `01A_preica_icaclean.set` on 2026-07-27 confirmed:

| Check | Result |
|---|---|
| Channels | 67 |
| Samples | 910,550 |
| Sampling rate | 250 Hz |
| Continuous records | 1 |
| Events | 602 |
| Sentence events | 300 |
| Target events | 300 |
| Rest markers | `99` × 1; `98` × 1 |
| Each target code | 30 occurrences |
| Target latency order | Strictly increasing |
| EEG reference metadata | `Common` |
| Removed ICA components | `[2 14 23 24 25 32 33 35 36 40 53 60]` |

The `Common` metadata value is consistent with the existing acquisition record
but is not evidence that a final offline reference has already been applied.
Phase 2 established that the online reference was the dedicated acquisition
`REF.` and that M1/M2 are ordinary recorded channels. `[DERIVED]`

## Frozen event-code dictionary

N400 epochs must be locked to the target-word events, not to sentence onset.

| Constraint | SNR | Sentence onset | Target-word onset / time zero |
|---|---|---:|---:|
| HC | −4 dB | 11 | 111 |
| HC | −2 dB | 12 | 112 |
| HC | +4 dB | 13 | 113 |
| HC | +6 dB | 14 | 114 |
| HC | quiet | 15 | 115 |
| LC | −4 dB | 21 | 121 |
| LC | −2 dB | 22 | 122 |
| LC | +4 dB | 23 | 123 |
| LC | +6 dB | 24 | 124 |
| LC | quiet | 25 | 125 |

Codes `99` and `98` are rest markers and are excluded from every N400 bin.
The sentence codes remain useful for trial-pair QC but are not time-locking
events. `[DERIVED]`

## Version-controlled all-trial BinList

The frozen pilot BDF is:

`events/BDF_01A_target_HC_LC_SNR_alltrials.txt`

It contains ten bins, one for each Constraint × SNR cell, with target codes
`111–115` and `121–125` as the dotted/time-locking event. Expected pre-artifact
counts are 30 per bin and 300 total. `[DERIVED]`

Static validation on 2026-07-27 found ten consecutively numbered bins and ten
valid target-only dotted expressions. A direct call to the installed ERPLAB 13
`decodebdf`/`bdf2struct` parser could not start in the Codex execution
environment because the local MATLAB binary exited before evaluating MATLAB
code with `Incompatible processor. This Qt build requires ... neon`. This is a
runtime-launch limitation, not a reported BDF parse error. The BDF must
therefore still pass the parser inside the user's normal MATLAB session before
BINLISTER is allowed to modify a dataset. `[UNVERIFIED]`

The subsequent manual ERPLAB 13 run resolved this gate:

- parser result: `0 wrong bins`;
- EventList events: 602;
- successful trials per bin: `30 30 30 30 30 30 30 30 30 30`;
- binned EventList text export completed;
- `EEG.event` was updated from `EEG.EVENTLIST.eventinfo.code`.

ERPLAB warned that resetting EVENTLIST flags did not also reset an existing
`EEG.event.flag` field. This warning requires a read-only flag comparison before
saving; do not call `update_EEG_event_field.m` unless nonzero/stale EEG-event
flags are actually found.

The subsequent EventList/BINLISTER QC passed:

- 602 EventList events and 10 declared bins;
- 30 trials in every bin, 300 target events total;
- zero incorrect code-to-bin assignments;
- events 98 and 99 assigned to no bin;
- all EventList events enabled;
- maximum EventList flag and maximum `EEG.event.flag` both zero;
- dimensions, sampled data, event count/codes/latencies unchanged;
- raw and binned EventList exports present.

The flag warning was therefore informational and
`update_EEG_event_field.m` was not required. The BINLISTER command was present
in history, but the direct command-line EventList creation was not automatically
recorded as `pop_creabasiceventlist`; explicit EventList provenance must be
appended before saving without rerunning the operation.

### Binned continuous derivative save/reload gate

**Status: PASS; `01A_postica_mastref_bins.set/.fdt` is the locked continuous
input for target epoching.**

- Reloaded dimensions: 67 channels, 910,550 samples, 250 Hz.
- EEG events / EventList events: 602 / 602.
- Ten declared bins; 30 trials per bin; 300 target trials total.
- Sampled data difference from the pre-save binned copy: `0 uV`.
- Event types/latencies and channel labels were unchanged.
- EventList and BINLISTER commands were both present in history.
- Final-reference, ICA-rejection, and binning metadata were retained.
- SET/FDT were present; FDT size was exactly 244,027,400 bytes.

Decision: Phase 4 continuous processing and event assignment passed. Use this
locked derivative to create the primary baseline-corrected target epochs and a
separate no-baseline diagnostic copy.

### Target epoch creation and baseline gate

**Status: PASS in memory; save/reload pending.**

- Primary and no-baseline copies: 67 channels, 250 points, 300 epochs.
- Requested window: `−200 to +800 ms`.
- ERPLAB 13 realized samples from `−200 to +796 ms` at 4 ms intervals. The
  upper endpoint is exclusive on this sampling grid; this is expected and does
  not truncate the planned 300–500 ms N400 interval.
- Time zero was present.
- Ten bins retained 30 epochs each; 300 target epochs total.
- Primary `−200 to 0 ms` correction:
  - maximum absolute post-correction baseline mean:
    `6.24022647446e-07 uV`;
  - maximum reconstruction error versus the no-baseline copy minus its
    channel/trial baseline:
    `1.52587890625e-05 uV`.
- Primary/no-baseline dimensions were identical.
- Channel labels were retained and all data values were finite.
- Both histories contained `pop_epochbin`.
- Each EventList assigned 300 target epochs.

Decision: the numerical baseline operation and epoch/bin structure passed.
Save both copies as separate derivatives before artifact detection. The
no-baseline copy is diagnostic and must not replace the primary corrected
dataset.

### Epoch derivatives save/reload gate

**Status: PASS; Phase 4 complete.**

- Locked primary derivative:
  `01A_target_epochs_pre200.set/.fdt`.
- Locked no-baseline diagnostic:
  `01A_target_epochs_nobaseline_diagnostic.set/.fdt`.
- Both reloaded as 67 channels × 250 points × 300 epochs.
- Pointwise data differences after reload: `0 uV` for both.
- Time vectors and channel labels were unchanged.
- Epoch metadata and 300 EventList epoch assignments were retained.
- Each FDT was exactly 20,100,000 bytes, matching
  `67 × 250 × 300 × 4`.

Decision: use `01A_target_epochs_pre200` as the Phase 5 artifact-detection
input. Use the no-baseline derivative only for the continuous-speech pretarget
diagnostic and later sensitivity checks.

The existing project file
`/Users/kevinchain/Desktop/N400_project/events/BDF_HC_LC_SNR.txt` uses sentence
codes `11–15` and `21–25`; it must not be used for target-locked N400 epochs.

## Correct-only and all-trial analysis rule

The study-level rule remains:

- primary analysis: behaviorally correct trials that also pass EEG artifact QC;
- sensitivity analysis: all behavioral trials that pass EEG artifact QC.

The EEG event stream contains no correct/incorrect response markers. Correctness
exists in `/Users/kevinchain/Desktop/N400_project/behavior/01A.csv`, whose 300
rows have already been aligned exactly to the 300 ordered target events.
Therefore a response-contingent BINLISTER expression cannot be constructed from
the current EEG events alone. `[DERIVED]`

For the pilot:

1. Use the ten target-only bins to preserve all 300 trials through epoching and
   EEG artifact detection.
2. Export a trial ledger keyed by ordered target event, target code, bin,
   behavior row, and `Correct`.
3. After EEG artifact flags are locked, compute the all-trial sensitivity
   averages from every EEG-clean epoch.
4. Compute the primary Correct-only averages from the subset satisfying both
   `EEG_clean == 1` and `Correct == 1`.
5. Reconcile the final accepted counts against the behavior-only starting
   counts already reported in Phase 1.

Do not recode the only target marker in the locked continuous source. If
correctness codes are later added to a derivative, preserve the original target
code and exact row mapping in structured metadata and in the exported ledger.

## Decision table

| ID | Parameter | Pilot decision/status | Evidence and gate |
|---|---|---|---|
| P4-01 | Input | Use `01A_preica_icaclean.set`; never overwrite it | **Frozen.** Phase 3 reload QC passed. `[DERIVED]` |
| P4-02 | Global bad channels | Initially none | **Reopened 2026-07-28.** Phase 5 pre/post-reference decomposition showed that intermittent M2 late shifts were large enough to contaminate the average-mastoid reference. M2 disposition requires a new condition-blind QC decision. `[DERIVED]` |
| P4-03 | Final reference | Create an M1-only candidate derivative for 01A; preserve the average-mastoid branch as diagnostic provenance | **Approved by user 2026-07-28 for 01A.** The numerical average-mastoid implementation passed, but Phase 5 showed that its largest apparent global late drifts were predominantly propagated from M2. Across all 300 epochs, predicted M1-reference global late change had a 95th percentile of 14.253 uV and maximum of 55.818 uV, versus 62.937 and 286.840 uV for average mastoids. The project-wide reference policy remains explicitly deferred pending mastoid QC in additional participants. `[DERIVED]` `[DECIDE]` |
| P4-04 | Reference exclusions | VEOG, HEOG, and TRIGGER never enter the EEG reference; preserve them unchanged for QC | **Frozen.** `[DERIVED]` |
| P4-05 | EventList | Create from the locked/referenced derivative; boundary numeric `-99`, boundary string `boundary`; export text | **Ready for GUI/runtime verification.** `[BOOK]` PDF pp. 45–47, 367. |
| P4-06 | BinList | Ten target-only all-trial bins in the version-controlled BDF | **Frozen.** Expected count: 30/bin before artifact/correctness filtering. `[DERIVED]` |
| P4-07 | Time zero | Target-word onset codes `111–115`, `121–125` | **Frozen.** Sentence-to-target delays vary 0.915–2.749 s, so sentence-onset locking cannot substitute. `[DERIVED]` |
| P4-08 | Epoch window | `−200 to +800 ms` target-locked | **Frozen 2026-07-27.** It contains the planned N400 interval and the complete no-typing interval after target onset. It matches the book example (PDF pp. 52–54, 368) and a directly relevant continuous-speech-in-noise N400 method. `[BOOK]` `[GENERAL]` |
| P4-09 | Primary baseline | Mean voltage from `−200 to 0 ms` | **Frozen 2026-07-27 with an overlap safeguard.** The user confirmed that this interval contains continuous speech/the preceding word, so it must be described as a *pretarget reference interval*, not a silent baseline. A directly relevant continuous-speech-in-noise N400 study used average mastoids, `−200 to +800 ms` epochs, and the same `−200 to 0 ms` correction. Because contextual speech may differ between HC and LC, retain a no-baseline diagnostic copy and inspect pretarget condition differences. `[GENERAL]` |
| P4-10 | N400 score window | Candidate fixed-window mean, 300–500 ms | **Deferred `[DECIDE]` to Phase 6.** It is the book's worked value, not a universal definition (PDF pp. 83–87). |
| P4-11 | N400 ROI | Prespecified centro-parietal ROI required; CPZ exists | **Open `[DECIDE]`.** Do not select electrodes from the largest observed 01A effect. `[BOOK]` PDF pp. 37, 61, 83. |
| P4-12 | Artifact thresholds | No detector executed in Phase 4 | **Deferred to Phase 5.** Starting values must be tuned by false-positive/false-negative inspection, not copied blindly. `[BOOK]` PDF pp. 196–240, 368. |

## Continuous-speech baseline safeguard

The user confirmed on 2026-07-27 that the `−200 to 0 ms` interval contains
continuous speech/the word immediately preceding the target. This does not make
the conventional correction unusable, but it changes its interpretation and
requires an explicit sensitivity check.

Primary pilot:

- epoch `−200 to +800 ms` around target onset;
- subtract the mean of `−200 to 0 ms`;
- describe this as a *pretarget reference interval*, not silence.

Diagnostic copy:

- create the same `−200 to +800 ms` target epochs with baseline set to `none`;
- do not use this uncorrected copy as the primary score dataset;
- inspect HC versus LC waveforms throughout `−200 to 0 ms` at the prespecified
  centro-parietal region and across the scalp;
- if a stable condition-dependent pretarget offset is present, report it and
  verify that the post-target HC–LC conclusion is not merely the inverse of the
  baseline difference.

This safeguard follows the book's warning that overlapping activity and
baseline correction can interact (PDF pp. 169–176). A closely matched
continuous-speech-in-noise N400 study used average mastoids, `−200 to +800 ms`
epochs, and `−200 to 0 ms` correction:
https://pmc.ncbi.nlm.nih.gov/articles/PMC12541682/

## Final-reference implementation

The installed EEGLAB 2026 `pop_reref` help confirms that:

- reference channels may be given as `[44 45]`;
- excluded channels may be supplied with `'exclude'`;
- `'refica','remove'` explicitly discards the now-unneeded residual ICA
  decomposition after the already-reviewed component subtraction.

The GUI-equivalent command to verify against `EEG.history` is:

```matlab
EEG = pop_reref(EEG, [44 45], ...
    'exclude', [65 66 67], ...
    'keepref', 'on', ...
    'refica', 'remove');
EEG = eeg_checkset(EEG);
EEG.setname = '01A_postica_mastref';
```

Expected effects:

- channels 1:64 are re-referenced to the M1/M2 mean;
- M1 and M2 remain present as channels 44 and 45;
- `(M1 + M2)/2` is numerically near zero after rereferencing and the expected
  spatial rank of channels 1:64 becomes 63;
- VEOG, HEOG, and TRIGGER remain pointwise unchanged;
- the residual 52-component ICA decomposition is removed, but the locked ICA
  rejection provenance in `EEG.etc.ica_rejection` must remain present;
- samples, events, event latencies, labels, and coordinates remain unchanged.

The first manual call on 2026-07-27 omitted `'keepref','on'`. Because the
installed `pop_reref` defaults to removing the selected reference channels,
that temporary in-memory result lost M1/M2 and failed the dimension/label QC.
It was not saved and was discarded. The operation was restarted from the
locked input with `'keepref','on'`.

The corrected in-memory result passed:

- dimensions, sampling rate, event types/latencies, channel labels, and XYZ
  coordinates unchanged;
- sampled rereference error `0.000106811523438 uV`;
- VEOG/HEOG/TRIGGER maximum difference `0`;
- maximum absolute M1/M2 mean `0 uV`;
- EEG rank `63`;
- ICA matrices removed and ICA-rejection metadata retained.

The only initially failed item was the history-text search: direct command-line
execution did not automatically append the `pop_reref` call to `EEG.history`.
Explicit history and structured final-reference provenance must be added before
saving; the numerical operation must not be repeated.

### Average-mastoid derivative save/reload gate

**Status: numerical save/reload PASS; `01A_postica_mastref.set/.fdt` is now a
preserved diagnostic derivative, not the locked final-reference analysis
input.**

- Reloaded dimensions: 67 channels, 910,550 samples, 250 Hz, 602 events.
- Sampled data difference from the pre-save copy: `0 uV`.
- Event types, event latencies, and channel labels were unchanged.
- EEG rank after reload: 63.
- ICA matrices remained absent.
- ICA-rejection and final-reference structured metadata were retained.
- Reloaded history contained the explicit `pop_reref` provenance.
- SET and FDT were both present.
- FDT size was exactly 244,027,400 bytes, matching
  `67 × 910550 × 4`.

Updated decision: preserve `01A_preica_icaclean.set/.fdt` as the locked
pre-reference source. Preserve all average-mastoid derivatives without
overwriting them, but do not continue final artifact flagging or ERP analysis
from them until the reference decision is resolved. Any alternative reference
must be created from a fresh copy of the locked pre-reference source, never by
rereferencing an already rereferenced derivative.

### M1-only candidate in-memory gate

**Status: PASS on 2026-07-28, including save/reload.**

A fresh copy of `01A_preica_icaclean.set/.fdt` was rereferenced to channel 44
(M1), with channels 65–67 excluded and the selected reference channel
retained. M2 remained present as a diagnostic `M2−M1` channel. The in-memory
result passed:

- dimensions, sampling rate, event count/types/latencies, labels, and
  coordinates unchanged;
- maximum sampled rereference error `4.57763671875e−05 uV`;
- maximum absolute M1 `0 uV`;
- maximum error for `M2' = original M2 − original M1`
  `1.52587890625e−05 uV`;
- VEOG/HEOG/TRIGGER maximum difference `0 uV`;
- sampled EEG rank `63`;
- ICA matrices removed and ICA-rejection metadata retained.

As with the earlier command-line reference call, `EEG.history` did not
automatically contain `pop_reref`. Explicit history and structured
`EEG.etc.final_reference` provenance must be added before saving; the
rereference operation itself must not be repeated.

The explicit history and structured provenance were then added, and the new
derivative was saved as `01A_postica_m1ref.set/.fdt`. Reload QC passed:

- 67 channels, 910,550 samples, 250 Hz, and 602 events;
- sampled data difference `0 uV`;
- event types/latencies and channel labels unchanged;
- maximum absolute reloaded M1 `0 uV`;
- sampled EEG rank `63`;
- ICA matrices remained absent;
- ICA-rejection and final-reference metadata retained;
- history contained `pop_reref`;
- SET/FDT both present;
- FDT size exactly `244,027,400` bytes.

This M1-reference continuous derivative is now the approved 01A candidate
branch for rebuilding EventList/BINLISTER and target epochs. The preserved
average-mastoid branch remains diagnostic only.

### M1-reference EventList/BINLISTER gate

**Status: PASS, including binned continuous save/reload.**

The frozen target-word BDF parsed with zero wrong bins. The M1 branch then
passed:

- 602 EEG events and 602 EVENTLIST events;
- 10 bins with 30 target events per bin and 300 total;
- zero incorrect code-to-bin assignments;
- rest codes 98 and 99 assigned to no bin;
- every EVENTLIST event enabled;
- EVENTLIST and `EEG.event` flags all zero;
- dimensions, sampling rate, sampled data, event count/codes/latencies, and
  channel labels unchanged;
- EventList and BINLISTER both present in history;
- raw and binned EventList text exports present.

During initial EventList creation, ERPLAB found the old `urevent` backup
inconsistent with its rebuilt `EEG.event` structure and removed `urevent`.
Because all 602 primary event codes and latencies were verified unchanged, a
new one-to-one `urevent` backup may be created from the current verified event
structure before saving. The removed stale backup must not be restored.

A new one-to-one `urevent` backup was created from the verified current
`EEG.event` structure. It contained 602 entries, mapped event-to-urevent
indices 1:602 exactly, and preserved event types/latencies, EVENTLIST, and
sampled data unchanged.

The branch was saved as `01A_postica_m1ref_bins.set/.fdt` and reloaded. The
save/reload gate passed:

- 67 channels, 910,550 samples, 250 Hz;
- 602 EEG events and 602 EVENTLIST events;
- sampled data difference `0 uV`;
- event types/latencies, labels, and EVENTLIST retained exactly;
- one-to-one `urevent` mapping retained;
- history contained rereference, EventList, BINLISTER, and `makeur`;
- ICA matrices remained absent;
- reference, ICA-rejection, binning, and urevent-reconstruction metadata
  retained;
- SET/FDT both present;
- FDT size exactly `244,027,400` bytes.

`01A_postica_m1ref_bins.set/.fdt` is now the locked 01A M1-reference
continuous candidate input for rebuilding target epochs.

### M1-reference target epoch gate

**Status: PASS, including both epoch derivative save/reload gates.**

Independent calls to `pop_epochbin` on the locked M1-reference binned
continuous input created the primary `−200 to 0 ms` corrected copy and a
no-baseline diagnostic copy. Both passed:

- 67 channels, 250 points, and 300 epochs;
- realized range `−200 to +796 ms` at 4 ms intervals, with time zero present;
- 30 epochs in each of 10 bins and 300 assigned target epochs;
- primary maximum absolute baseline mean
  `5.51635143804e−07 uV`;
- maximum baseline-correction reconstruction error
  `1.271565759e−05 uV`;
- identical dimensions/times, retained channel labels, and all values finite;
- histories contained `pop_epochbin`;
- reference and binning metadata retained;
- M1 remained exactly `0 uV` in both copies.

`pop_epochbin` did not retain a continuous-style `urevent` structure in either
epoched copy. This is not an event-loss failure: the 300 target mappings were
retained in `EEG.epoch` and `EEG.EVENTLIST.eventinfo.bepoch`. Do not call
`makeur` on these epoched derivatives; retain the ERPLAB epoch/EventList
mapping as created.

The two new derivatives were saved and reloaded:

- primary:
  `01A_m1ref_target_epochs_pre200.set/.fdt`;
- no-baseline diagnostic:
  `01A_m1ref_target_epochs_nobaseline_diagnostic.set/.fdt`.

Both reloaded as 67 channels × 250 points × 300 epochs. Full pointwise data
differences were `0 uV`; times, labels, EVENTLIST, 300 `EEG.epoch` entries,
300 target mappings, epoch/reference/binning/ICA-rejection metadata, and
`pop_epochbin` history were retained. M1 remained exactly zero and `urevent`
remained absent as expected. Each SET/FDT pair was present and each FDT was
exactly `20,100,000` bytes.

Decision: the 01A M1-reference Phase 4 candidate branch is complete. Use the
primary derivative for renewed Phase 5 artifact screening and the no-baseline
derivative only for renewed continuous-speech pretarget diagnostics. Exclude
both retained mastoid channels M1 and M2 from scalp artifact metrics.

## Phase 4 execution gate

1. Load a fresh copy of the locked input and apply the average-mastoid
   rereference exactly once.
2. Verify that VEOG, HEOG, and TRIGGER are unchanged and that dimensions,
   events, labels, coordinates, and ICA-rejection provenance are preserved.
3. Validate the new BDF with the installed ERPLAB 13 parser.
4. Create/export EventList and run BINLISTER on a new in-memory derivative.
5. Verify 30 events in each of the ten bins, 300 total target bins, no `99/98`
   assignment, and representative sentence-target sequences for every bin.
6. Save and reload the continuous binned derivative only after the structural,
   event, auxiliary-channel, and history checks pass.
7. Create the primary baseline-corrected epochs and a separate no-baseline
   diagnostic copy. Artifact detection remains a Phase 5 gate.
