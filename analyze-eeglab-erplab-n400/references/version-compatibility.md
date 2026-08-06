# Version and Compatibility Record

Last checked: 2026-07-17. Recheck official pages before claiming these are current.

## Source-book software era

- `[BOOK]` Requirements state MATLAB 2017a+, EEGLAB 2022.0+, and ERPLAB 9.0+ (PDF pp. 9, 18–19).
- `[BOOK]` The author reports mainly using MATLAB 2017a/2020b, EEGLAB 2020.0, and ERPLAB 8.23 while writing, while recommending the later minimum versions above (PDF p. 18).
- `[BOOK]` GUI appearance and sometimes results may change with newer releases (PDF p. 18).

## Official state checked in 2026

- `[GENERAL]` The official SCCN download directory lists EEGLAB 2026.0.0, and the official revision/news pages describe the 2026 release. Sources: [SCCN download directory](https://sccn.ucsd.edu/eeglab/download/daily/), [EEGLAB revision history](https://eeglab.org/others/EEGLAB_revision_history.html).
- `[GENERAL]` The official ERPLAB GitHub release page identifies ERPLAB 13.00 as latest and distinguishes ERPLAB Studio from ERPLAB Classic. Source: [ERPLAB releases](https://github.com/ucdavis/erplab/releases).
- `[GENERAL]` The ERPLAB 13.00 release notes recommend against MATLAB 2025a or later at the time of that release because of reported bugs. Treat this as a release-specific warning and recheck compatibility before use.

## Known migration concerns

| Area | Book-era behavior | Current handling |
|---|---|---|
| GUI | Classic ERPLAB menus inside EEGLAB | Studio and Classic both exist; menu paths/screens may differ |
| History | Book copies Classic GUI commands from `EEG.history`/`eegh` | Still use local history, but compare argument names with local `help` |
| BinLister | Book-era ERPLAB 8/9 workflow | ERPLAB 12.20 release notes describe optimized BinLister and removal of automatic backup writes; specify output files explicitly |
| Channel interpolation | Book demonstrates ERPLAB selective interpolation | ERPLAB 12.20 notes fixes for newer EEGLAB; verify output and channel metadata |
| Measurement/baseline | Book demonstrates then-current Measurement Tool | ERPLAB 12.10 notes a critical fix for custom/poststimulus baselines; validate installed version and preview scores |
| Filter calls | Book history uses `pop_basicfilter` with named options | Run local `help pop_basicfilter`; do not assume old order/slope semantics without verification |
| Artifact calls | Core functions remain in official repository | Use GUI history/local help because defaults and GUI persistence can change |

## Runtime provenance to capture

Save at minimum:

- `version` and `ver` output from MATLAB;
- full paths from `which('eeglab')`, `which('pop_runica')`, `which('pop_creabasiceventlist')`, and `which('pop_averager')`;
- `EEG.etc.eeglabvers` when available;
- ERPLAB release folder/tag and Classic vs Studio;
- all plugin versions involved in import, line-noise removal, or ICA classification;
- local help text or GUI history when a stored template call is changed.

