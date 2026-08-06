# GUI and MATLAB Crosswalk

Run each operation once in the installed Classic GUI, inspect `EEG.history` or `eegh`, and compare the generated call with local `help`. ERPLAB Studio and Classic menus differ; the book primarily demonstrates Classic inside EEGLAB.

| Operation | Classic GUI path | MATLAB function / pattern | Status and source |
|---|---|---|---|
| Load `.set` | File > Load existing dataset | `EEG = pop_loadset('filename', f, 'filepath', p);` | Confirmed in book pp. 303–340 and [EEGLAB functions](https://eeglab.org/tutorials/ConceptsGuide/EEGLAB_functions.html) |
| Vendor import | File > Import data | Plugin-specific `pop_*` call | `[DECIDE]`; capture current GUI history, do not guess |
| Channel locations | Edit > Channel locations | `EEG.chanlocs = pop_chanedit(EEG.chanlocs, 'load', {...});` | Confirmed by [EEGLAB history tutorial](https://eeglab.org/tutorials/11_Scripting/Using_EEGLAB_history.html) |
| Resample | Tools > Change sampling rate | `EEG = pop_resample(EEG, new_rate);` | Confirmed by [EEGLAB resampling tutorial](https://eeglab.org/tutorials/05_Preprocess/resampling.html); anti-alias filter is applied |
| ERPLAB EEG filter | ERPLAB > Filter & Frequency Tools > Filters for EEG data | `EEG = pop_basicfilter(EEG, channels, ...);` | Book history example p. 311; verify local ERPLAB 13 help/options |
| EEGLAB FIR filter | Tools > Filter the data | `EEG = pop_eegfiltnew(EEG, ...);` | `[GENERAL]`; current EEGLAB alternative, not the book's ERPLAB Butterworth example |
| Re-reference | Tools > Re-reference | `EEG = pop_reref(EEG, ref_channels);` | Current EEGLAB function; choice of reference: book pp. 130–153 |
| ERPLAB channel equations | ERPLAB > EEG Channel Operations | `EEG = pop_eegchanoperator(EEG, equation_file, ...);` | Book pp. 321–327; preserves repeatable equations |
| Interpolate channels | ERPLAB > Preprocess EEG > Selective Electrode Interpolation, or EEGLAB channel tools | `EEG = eeg_interp(EEG, bad_channels, 'spherical');` | Function is current EEGLAB; exact ERPLAB GUI history may differ by version |
| Run ICA | Tools > Decompose data by ICA | `EEG = pop_runica(EEG, 'icatype','runica','extended',1, ...);` | Book pp. 241–271; [EEGLAB ICA tutorial](https://eeglab.org/tutorials/06_RejectArtifacts/RunICA.html) |
| Remove reviewed ICs | Tools > Remove components from data | `EEG = pop_subcomp(EEG, components, 0);` | Current EEGLAB pattern; component list is `[DECIDE]` |
| Create EventList | ERPLAB > EventList > Create EEG EventList | `EEG = pop_creabasiceventlist(EEG, ...);` | Book pp. 45–47; [ERPLAB source](https://github.com/ucdavis/erplab/blob/master/pop_functions/pop_creabasiceventlist.m) |
| Assign bins | ERPLAB > Assign bins (BINLISTER) | `EEG = pop_binlister(EEG, 'BDF', bdf, ...);` | Book pp. 48–51; [ERPLAB source](https://github.com/ucdavis/erplab/blob/master/pop_functions/pop_binlister.m) |
| Bin-based epoch/baseline | ERPLAB > Extract bin-based epochs | `EEG = pop_epochbin(EEG, epoch_ms, baseline);` | Book pp. 52–54, 368; [ERPLAB source](https://github.com/ucdavis/erplab/blob/master/pop_functions/pop_epochbin.m) |
| Absolute voltage artifact | ERPLAB > Artifact Detection > Simple voltage threshold | `EEG = pop_artextval(EEG, 'Channel', ..., 'Flag', ..., 'Threshold', ..., 'Twindow', ...);` | Book history p. 69; [ERPLAB source](https://github.com/ucdavis/erplab/blob/master/pop_functions/pop_artextval.m) |
| Moving-window peak-to-peak | ERPLAB > Artifact Detection > Moving window peak-to-peak | `EEG = pop_artmwppth(EEG, 'Channel', ..., 'Flag', ..., 'Threshold', ..., 'Twindow', ..., 'Windowsize', ..., 'Windowstep', ...);` | [ERPLAB source](https://github.com/ucdavis/erplab/blob/master/pop_functions/pop_artmwppth.m); scientific settings remain `[DECIDE]` |
| Step-like blink/eye detector | ERPLAB > Artifact Detection > Step-like artifacts | `pop_artstep` with call copied from local history | `[UNVERIFIED]` argument list in this Skill; use GUI history because versions differ |
| Average ERPs | ERPLAB > Compute averaged ERPs | `ERP = pop_averager(EEG, 'Criterion','good','ExcludeBoundary','on','SEM','on');` | Book pp. 58–66; [ERPLAB source](https://github.com/ucdavis/erplab/blob/master/pop_functions/pop_averager.m) |
| Difference wave | ERPLAB > ERP Bin Operations | `ERP = pop_binoperator(ERP, {'BinX = BinB - BinA label ...'});` | Book pp. 93–94 |
| ERP measurement | ERPLAB > ERP Measurement Tool | Capture current `pop_geterpvalues` call from history, or use the transparent fixed-window code in this Skill | Function options are `[UNVERIFIED]` across releases; book pp. 83–90, 272–300 |
| Save EEG | File > Save current dataset as | `EEG = pop_saveset(EEG, 'filename', f, 'filepath', p);` | Book pp. 325–327 |

## Translation rules

1. Prefer a `pop_*` function for a GUI-equivalent operation and use its local help as the interface contract.
2. Keep GUI-derived calls in a pilot script, replace literals with config values, and rerun on one participant.
3. Compare the scripted output with the manually processed output before cohort execution.
4. Record changed function names/arguments in `version-compatibility.md` or the study methods log.
5. Mark any remembered but unconfirmed call `[UNVERIFIED]` until local help or official source confirms it.

