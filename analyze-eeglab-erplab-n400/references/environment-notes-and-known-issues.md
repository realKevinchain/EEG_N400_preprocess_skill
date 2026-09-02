# Environment Notes and Known Issues (828update collaborator pilot)

Captured 2026-08-31 while running participant 01A end to end for the first
time on this machine. These are infrastructure/scripting issues, not
scientific-parameter changes. Where a fix was already applied to the
`scripts_updata/` files, this doc says so; re-verify the fix is still present
before assuming it.

## Contents

1. [Synchronized config overwrite](#1-the-shared-config-template-gets-silently-overwritten-google-drive-sync)
2. [Curry location import](#2-loadcurry323-cannot-read-digitized-electrode-positions-for-curry-89-files)
3. [Raw filename suffix](#3-raw-acquisition-files-with-a-_副本-copy-suffix-break-curry-import)
4. [ERPLAB folder discovery](#4-init_828_runtimem-had-a-hardcoded-erplab-folder-name)
5. [Interactive ALLEEG initialization](#5-alleeg-undefined-in-an-interactive-session)
6. [MATLAB command pasting](#6-copy-pasting-multi-line-matlab-commands-from-chat-into-the-terminal-is-unreliable)
7. [Three-dimensional indexing](#7-matlab-3-d-array-indexing-always-index-all-three-dimensions)
8. [Mixed-text CSV columns](#8-readtable-mis-detects-a-text-column-that-looks-numeric)
9. [ICLabel Other](#9-iclabels-other-category-is-not-evidence-of-an-artifact-gate-c)
10. [Peripheral channel review](#10-gate-a-elevated-noise-on-peripheraltemporal-channels-is-not-automatically-a-bad-channel)
11. [Human-controlled gates](#11-gates-abcd-are-human-decisions--do-not-make-them-yourself-even-with-matlab-batch-access)
12. [Bad-channel rerun scope](#12-cfgbad_channels-does-not-affect-stage-2-reference-or-stage-3-filter-output)
13. [PMnotch design requirement](#13-erplabs-pmnotch-filter-silently-no-ops-without-designnotch)
14. [Narrowband ICA evidence](#14-a-components-peak-iclabel-category--a-spectral-bump-near-a-suspect-frequency-is-not-enough--check-whether-its-actually-narrowband)
15. [Gate D reject-field audit](#15-gate-d-gui-marks-can-live-in-several-fields--audit-before-copying-epoch-numbers)
16. [Figure release criteria](#16-fixed-figure-scales-and-sentence-output-completeness-are-release-criteria)

## 1. The shared config template gets silently overwritten (Google Drive sync)

The project was run from a Google-Drive-synced folder shared with a
collaborator. Mid-session, `config_828_subject_template.m` was observed to
change from generic `TODO_ABSOLUTE_*` placeholders to another machine's
absolute paths after synchronization.

**Symptom:** `cfg.input_dir`/`cfg.behavior_dir`/`cfg.repo_root` silently
resolve to someone else's filesystem paths, causing `pop_loadset` to fail
with "file not found" pointing at a path that was never set anywhere in the
session.

**Fix already applied:** every participant config (`config_828_01A.m` and
onward) re-asserts `project_root`, `repo_root`, `eeglab_root`, `input_dir`,
`behavior_dir`, and `bdf` explicitly, *after* running the template, instead of
trusting whatever the template currently contains. Copy this same pattern
into every new participant config:

```matlab
run(fullfile(fileparts(mfilename('fullpath')), 'config_828_subject_template.m'));
cfg.subject = '<ID>';
cfg.behavior_subject = <N>;

% Re-asserted because config_828_subject_template.m lives in a Drive-synced
% folder and has been observed to be silently overwritten with a
% collaborator's machine-specific paths.
cfg.project_root = '/absolute/path/to/N400_project';
cfg.eeglab_root = '/absolute/path/to/eeglab';
cfg.input_dir = fullfile(cfg.project_root,'input_set');
cfg.behavior_dir = fullfile(cfg.project_root,'behavior');
```

Then set `repo_root` and `bdf` for the copy being executed:

```matlab
% Project implementation: <repo>/scripts_updata/config_828_<ID>.m
cfg.repo_root = fileparts(fileparts(mfilename('fullpath')));
cfg.bdf = fullfile(cfg.repo_root,'events','BDF_target_HC_LC_SNR_alltrials.txt');

% Installed Skill mirror: <skill>/scripts/828update/config_828_<ID>.m
cfg.repo_root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
cfg.bdf = fullfile(cfg.repo_root,'assets','BDF_target_HC_LC_SNR_alltrials.txt');
```

This is a standing collaboration risk: any synchronized file in
`scripts_updata/` can change during concurrent editing. If a script behaves
unexpectedly, compare it against the expected Git revision before assuming
the bug is in the data.

## 2. `loadcurry3.2.3` cannot read digitized electrode positions for Curry 8/9 files

The bundled plugin at `eeglab2026.0.0/plugins/loadcurry3.2.3` errors on
`pop_loadcurry(..., 'CurryLocations','True')` for `.cdt` (Curry 8/9) files:

```
Error in pop_loadcurry(): The requested filename "..." does not have all
three file components (.dap, .dat, .rs3) created by Curry 6 and 7.
```

That check is only correct for legacy Curry 6/7 files; it misfires for `.cdt`
files in this plugin version. This was the root cause of six non-standard
64-channel-montage electrodes (F11, F12, FT11, FT12, CB1, CB2) lacking finite
XYZ coordinates after import with `'CurryLocations','False'` (the workaround
the original 01A import script, `data/A01_clear.m`, had used).

**Fix already applied:** downloaded `loadcurry3.3.2` from
`https://github.com/mattpontifex/loadcurry` and installed it alongside (not
replacing) the bundled `loadcurry3.2.3` at
`eeglab2026.0.0/plugins/loadcurry3.3.2`. Version 3.3.2 branches correctly on
`.cdt` + `.cdt.dpa`/`.cdt.dpo` and successfully reads real digitized
positions for all 64 channels. Force it onto the path ahead of the bundled
version before importing:

```matlab
addpath(fullfile(cfg.eeglab_root,'plugins','loadcurry3.3.2'));
EEG = pop_loadcurry(currFile,'KeepTriggerChannel','True','CurryLocations','True');
```

Use real digitized positions (`CurryLocations`,`True`) for every future
participant's Stage 1 import rather than the template-based fallback — it is
more accurate and removes the missing-XYZ problem entirely.

## 3. Raw acquisition files with a "_副本" (copy) suffix break Curry import

Some raw files in `raw_data/EEG_raw_data/<ID>_data/` have "_副本" appended
directly after the real extension, e.g. `Acq ....cdt_副本`,
`Acq ....cdt.ceo_副本`, `Acq ....cdt.dpo_副本`. `loadcurry` decides the Curry
file generation from `fileparts(...)`'s extension; with the suffix attached,
the detected "extension" is `.cdt_副本`, not `.cdt`, so the importer takes the
wrong code path and fails.

**Fix pattern:** never rename or delete the original raw files. Make an
APFS clone (`cp -c`, instant and space-efficient on this filesystem) with the
correct trailing extension restored, and import from the clone:

```bash
cp -c "Acq ....cdt_副本" "Acq ....cdt"
cp -c "Acq ....cdt.ceo_副本" "Acq ....cdt.ceo"
cp -c "Acq ....cdt.dpo_副本" "Acq ....cdt.dpo"
```

Check every new participant's raw folder for this pattern before importing.

## 4. `init_828_runtime.m` had a hardcoded ERPLAB folder name

The original line assumed the plugin folder was literally named
`erplab-master`:

```matlab
erplabRoot = fullfile(cfg.eeglab_root,'plugins','erplab-master');
```

On this machine the installed folder is `ERPLAB12.20`, so
`pop_basicfilter`/`pop_epochbin`/`pop_averager`/`pop_loaderp` were not found
and every phase script errored at the `init_828_runtime.m` assert.

**Fix already applied** in `init_828_runtime.m` (search dynamically instead
of hardcoding a name):

```matlab
if exist('pop_basicfilter','file') ~= 2
    pluginsDir = fullfile(cfg.eeglab_root,'plugins');
    pluginEntries = dir(pluginsDir);
    isErplabDir = [pluginEntries.isdir] & ...
        startsWith({pluginEntries.name},'erplab','IgnoreCase',true);
    assert(any(isErplabDir),'No ERPLAB plugin folder found under %s.',pluginsDir);
    erplabNames = {pluginEntries(isErplabDir).name};
    addpath(genpath(fullfile(pluginsDir,erplabNames{1})));
end
```

Any standalone script that calls `pop_loaderp`, `pop_basicfilter`,
`pop_epochbin`, or `pop_averager` **without** first running
`init_828_runtime.m` needs this same guard repeated inline (several
supplemental/plotting helper scripts in this session did), because MATLAB's
`dir()` does not support bash-style character-class globs like
`[Ee][Rr][Pp]...` — use `startsWith(...,'IgnoreCase',true)` on plain
`dir(pluginsDir)` results instead.

## 5. `ALLEEG` undefined in an interactive session

Running only `run('config_828_<ID>.m')` does **not** initialize EEGLAB's
global variables. Typing `pop_loadset` followed by
`[ALLEEG, EEG] = eeg_store(ALLEEG, EEG, 0)` in that state fails with
`函数或变量 'ALLEEG' 无法识别`. Always run bare `eeglab` first in an
interactive session (it opens the main GUI and creates `ALLEEG`/`STUDY`/etc.)
before calling `eeg_store` or any EEGLAB menu-backed function by hand. Batch
scripts avoid this because they call `eeglab('nogui')` explicitly.

## 6. Copy-pasting multi-line MATLAB commands from chat into the terminal is unreliable

Long commands using `...` line continuation (e.g. multi-argument
`pop_loadset(...)` calls) repeatedly got mangled when pasted into the MATLAB
command window from a chat interface, producing "字符向量未正常终止" or
"不支持使用 '=' 运算符" errors that have nothing to do with the underlying
MATLAB logic. Prefer, in order: (1) EEGLAB GUI menus (File → Load existing
dataset, Tools → Classify components using ICLabel, Plot → ...) for anything
interactive/Gate-review related, (2) single-line commands with no `...`
continuation, (3) `cd` into the target folder first so subsequent commands
can use short relative filenames.

## 7. MATLAB 3-D array indexing: always index all three dimensions

`EEG.data` for an epoched dataset is `[nbchan x npts x ntrials]`. Indexing
with only two subscripts, e.g. `EEG.data(chanIdx, sampleRange)` inside a
per-trial loop, does **not** error — MATLAB silently linearizes the trailing
two dimensions and returns data from the wrong (effectively scrambled)
location. This produced a badly wrong grand-average in an early draft of the
sentence word-aligned analysis (per-trial correlation with the correctly
extracted version was still 1.0000, i.e. the bug was purely in the missing
trial subscript, not in timing/latency math). Always write
`EEG.data(chanIdx, sampleRange, trialIdx)` explicitly for any per-trial
extraction loop, and spot-check with a single-trial correlation test against
an independently-extracted reference before trusting a new averaging script.

## 8. `readtable` mis-detects a text column that looks numeric

A CSV column containing `"-4","-2","4","6","quiet"` (SNR labels) gets
auto-detected by plain `readtable(path)` as numeric, silently turning
`"quiet"` into `NaN` and everything else into `double`. Downstream string
comparisons (`LATENCY.SNR == "quiet"`) then fail with "不支持在 double 和
string 之间进行比较". Force the column type explicitly:

```matlab
opts = detectImportOptions(csvPath);
opts = setvartype(opts,{'Condition','SNR'},'string');
T = readtable(csvPath,opts);
```

Apply this to any 828update-generated CSV that mixes numeric-looking SNR
labels with `"quiet"`.

## 9. ICLabel's "Other" category is not evidence of an artifact (Gate C)

`Other` is ICLabel's "doesn't confidently match any of the six defined
categories (including Brain)" bucket — it is expected for a meaningful
fraction of the lower-variance tail of any real ICA decomposition and is
**not** itself grounds for removal. Do not delete a component just because
its top ICLabel label isn't "Brain"; require independent, specific evidence
(scalp map matching a known artifact topography, spectrum shape, **and** the
component's continuous activation timing actually lining up with VEOG/HEOG
or a known artifact source) before removing. Default to keeping a component
when the evidence is ambiguous or inconsistent across a couple of spot-check
time windows — removing real signal is worse than leaving a borderline
component in. See `n400-six-stage-828update.md` §5.7 for the mandatory
multi-evidence rule; this section just records the concrete failure mode
that motivated re-emphasizing it.

## 10. Gate A: elevated noise on peripheral/temporal channels is not automatically a bad channel

Phase 1's automatic bad-channel candidates (elevated SD/robust-z, flat
fraction, line-noise ratio) flag frontal/temporal/parieto-occipital channels
more often simply because those sites sit closer to jaw/neck/temporalis
muscle and pick up more EMG — this is normal scalp topography, not evidence
of a hardware fault, and is exactly what Stage 4's ICA is designed to remove
(as a Muscle-labeled component), not a reason to interpolate the channel at
Gate A. Two checks used in this session to tell the difference:
- Compare the "noisy" channel against a central comparison site (CZ/CPZ) at
  several different time windows spread across the recording, not just one:
  a channel that is bad "全程" (throughout) is a real candidate; a channel
  that is only bad in one or two short bursts is more likely transient
  muscle/movement, handled later by Stage 4 ICA / Stage 5 Gate D, not Stage 2
  channel exclusion.
- If suspicious of a *reference* geometry effect (quiet near the online
  hardware reference, noisier far from it), remember that re-referencing to
  average mastoids algebraically cancels *any* common online-reference
  contribution regardless of what it was — so a pattern that is purely a
  reference artifact will disappear after Stage 2's rereference, while a
  pattern caused by actual channel-specific noise will not.

## 11. Gates A/B/C/D are human decisions — do not make them yourself, even with MATLAB batch access

Captured 2026-09-02 during 01B. This machine has `/Applications/MATLAB_R2026a.app/bin/matlab
-batch "..."` available, which makes it possible for an assistant to run every
phase script end to end without any person present — including generating
plausible-looking evidence (topography/spectrum PNGs, quantitative summary
tables) and using it to decide bad channels, IC removal, and bad epochs
itself. **Do not do this.** The top-level skill instructions and every Gate
in `sop.md`/`n400-six-stage-828update.md` say these are human decisions for a
reason (they encode judgment calls — this participant's own instrumentation
history, tolerance for trial loss, etc. — that are not recoverable from the
data alone). In this session the assistant ran all four gates itself for 01B
before the user caught it and required a redo with genuine per-gate review;
several of the assistant's Gate C calls were also later shown to be
questionable once the user actually looked (see item 13 below).

The correct pattern per gate, confirmed working with this user:
1. Run the phase script through the point where it stops for the gate
   (training copy / icaweights.set / pooled epoch set).
2. Either (a) generate a quantitative summary + evidence plots and present
   them for review, or (b) — preferred by this user for Gates C and D
   specifically — hand back the exact single-line MATLAB commands to open
   the real EEGLAB review tool themselves (`pop_viewprops` for Gate C,
   `review_phase05_artifact_gate.m` → `pop_eegplot` for Gate D) in their own
   MATLAB session.
3. Wait for the user's actual decision (channel list / IC list / epoch
   list). Do not treat your own generated evidence as sufficient to decide.
4. Only then write the decision into `config_828_<ID>.m` with a comment
   attributing it to the user and citing the evidence file(s) reviewed.

## 12. `cfg.bad_channels` does not affect Stage 2 (reference) or Stage 3 (filter) output

Both `phase02_reference.m` and `phase03_filter.m` operate uniformly over
`[cfg.eeg_channels cfg.eog_channels]` (or `1:64` for reference) with no
`bad_channels` branching — a channel later marked bad still gets referenced
and filtered exactly like every other channel; it is only excluded starting
at `cfg.ica_channels` (Stage 4) and interpolated at Stage 5. So if a Gate A
decision changes (e.g. a channel is reclassified as bad) **after** Stage 2/3
already ran, those two stages' outputs are still valid and do not need to be
regenerated — only Stage 4 onward (different `ica_channels` set → different
rank → a genuinely different ICA decomposition with renumbered components,
which also invalidates any already-made Gate C decision) needs a redo.

## 13. ERPLAB's `PMnotch` filter silently no-ops without `'Design','notch'`

`pop_basicfilter(EEG, chans, 'Filter','PMnotch', 'Cutoff',50, ...)` **appears
to succeed** (prints "Done. What's next?", returns an EEG struct, no thrown
error) but leaves the data completely unfiltered if you don't also pass
`'Design','notch'`. `Design` defaults to `'butter'`; internally
`filter_tf.m` maps `Design` to a numeric `typef` (0=IIR Butterworth,
1=FIR, 2=Parks-McClellan notch), and the PMnotch code path only fires when
`typef==2`. With the default `typef==0` and `locutoff==hicutoff` (which is
how a PMnotch single-cutoff gets encoded), none of `filter_tf.m`'s branches
match, so it returns `v=0` ("something is wrong"), and `basicfilter.m`
surfaces that as a **non-fatal** GUI-style warning
(`errorfound('Wrong parameters for filtering.', ...)`) rather than an error —
in `-batch` mode this just prints to the console and execution continues
with the data untouched. Verified by direct before/after `pwelch` comparison:
without `'Design','notch'`, 50 Hz power was byte-for-byte unchanged (0.0 dB
attenuation); with it, attenuation at exactly 50.00 Hz was 56.7 dB (very
narrow notch — power even 0.5 Hz away is barely touched, so don't expect a
wide band average like 48-52 Hz to show much effect even when the filter is
working correctly — check the exact target frequency bin instead). Also note
`'Cutoff'` for `PMnotch` takes **one** value (the center frequency, e.g.
`50`), not a `[lo hi]` pair — passing two values errors immediately with a
clear message, unlike the silent `Design` mistake above.

## 14. A component's "peak ICLabel category + a spectral bump near a suspect frequency" is not enough — check whether it's actually narrowband

During 01B's Gate C, a hypothesis that many removed components reflected a
specific interference frequency was checked quantitatively rather than
accepted or rejected on sight: for every component, compute the Welch-PSD
peak frequency, the -3 dB bandwidth around that peak, and the relative power
ratio in the suspect band vs the broadband average. Concretely useful
result: components later confirmed as genuine alpha-band brain activity
(kept, not removed) had **higher** alpha-band (8-12 Hz) relative power than
the components that were removed as broadband EMG — the removed set's median
-3 dB bandwidth was almost 2x wider than the kept set's, which is the
opposite pattern from what a narrowband interference source would produce.
This is a cheap, reusable extra evidence type for the multi-evidence Gate C
rule (`n400-six-stage-828update.md` §5.7): a real narrowband interference
component should have a *narrow* bandwidth (a few Hz at most) sharply
localized at the suspect frequency, not a broad hump that merely crosses
through it — broad + high-frequency-leaning is far more consistent with
muscle/EMG than with a fixed-frequency electrical interference source.

## 15. Gate D GUI marks can live in several fields — audit before copying epoch numbers

Validated on 01B on 2026-09-02. The agreed 902 workflow keeps the formal
baseline epoch set untouched. The user may run ERPLAB Simple Voltage
Threshold to create candidates, manually add/remove marks, click `UPDATE
MARKS`, and save a separate `<ID>_gateD_manual_review.set`. Never click
`REJECT`, because all 300 physical epochs must survive to the formal flagged
dataset.

Before entering `cfg.artifact_bad_epochs`, inspect at least
`EEG.reject.rejmanual`, `rejmanualE`, `rejthresh`, all other populated
`EEG.reject.*` fields, and the epoch/event flags. GUI actions and ERPLAB
versions do not always populate the same field. If fields disagree, report
the exact sets and ask the user which marks are final; do not silently take
their union. For 01B's review copy, the final 11 marks were in `rejmanual`,
while `rejmanualE` and threshold fields were empty. That field pattern is an
observation about 01B, not a universal rule.

Use the descriptive filename `<ID>_gateD_manual_review.set` for later
participants instead of the ambiguous pilot filename `new.set`.

## 16. Fixed figure scales and sentence-output completeness are release criteria

The 902 official target-word scale is `[-20 20]` µV in every panel, with
negative up and both HC/LC accepted N values visible. A requested ±10 µV
comparison must be separately named and never replace the official figure;
01B demonstrated why, because its primary −4 dB panel clipped at ±10 µV
(HC N=5, LC N=1).

The post-Stage-6 sentence analysis is isolated under `sentence_epochs/` and
must reuse the Stage-6 ledger exactly. Do not call it complete by counting
only image stems: the required set is 20 PNG plus 20 FIG files. Each FIG
must have fixed x=`[-2300 800]` ms, y=`[-20 20]` µV, negative up, and two N
labels. The 01B runtime audit passed all 20 FIG checks and observed expected
edge coverage from 18 to 300 trials.
