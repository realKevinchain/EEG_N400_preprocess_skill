%% 01B validated pilot record for 902 -- never copy participant decisions.
% This file preserves the reviewed 01B decisions for auditability. For a
% new participant, copy config_828_subject_template.m instead and repeat all
% four gates independently; T7/T8, IC numbers, and bad epochs below are NOT
% cohort defaults.

run(fullfile(fileparts(mfilename('fullpath')), ...
    'config_828_subject_template.m'));
cfg.subject = '01B';
cfg.behavior_subject = 1;

% NOTE: config_828_subject_template.m lives in a Google-Drive-synced folder
% shared with a collaborator and has been observed to be silently overwritten
% with the collaborator's own machine-specific paths. Every path this
% participant config depends on is therefore re-asserted explicitly below
% instead of trusting whatever the template currently contains.
cfg.project_root = ...
    '/Users/fishtambo/Desktop/Fish and Kevin''s Research/FYP/EEG分析/N400_project';
cfg.repo_root = fileparts(fileparts(mfilename('fullpath')));
cfg.eeglab_root = ...
    '/Users/fishtambo/Desktop/Fish and Kevin''s Research/FYP/EEG分析/eeglab2026.0.0';
cfg.input_dir = fullfile(cfg.project_root,'input_set');
cfg.behavior_dir = fullfile(cfg.project_root,'behavior');
cfg.bdf = fullfile(cfg.repo_root,'events','BDF_target_HC_LC_SNR_alltrials.txt');

% ============================================================
% RUN 2 (2026-09-02): user asked for a full redo from Stage 3 onward with
% (a) a 50 Hz notch filter added to phase03_filter.m and (b) T7/T8 now
% marked as bad scalp channels (excluded from ICA, interpolated after).
% Stage 2 (reference) is unaffected by either change and was NOT rerun.
% Gates B/C/D from run 1 (below, preserved for traceability) are SUPERSEDED
% because a different ica_channels set (62 vs 64 channels, rank 61 vs 63)
% produces a completely different ICA decomposition -- component numbering
% and epoch content are not comparable across runs. Gate B/C/D were reset,
% then independently reviewed again; the completed run-2 decisions follow.
% ============================================================

% Gate A reviewed and confirmed by Fish (user) 2026-09-01 (run 1): no bad
% channels, based on qc/01B_gateA_candidate_vs_central_review.png and
% qc/01B_828update_mastref_phase02_reference_gate.csv (M1/M2/T7/T8 vs
% CZ/CPZ across 5 time windows). See prior version of this file (git/backup)
% for the full run-1 writeup.
% REVISED 2026-09-02 by Fish (user): T7/T8 now marked bad and will be
% spherically interpolated after ICA (Stage 5), independent of the notch
% filter change. Reference mode and Stage 2 output are unchanged by this
% revision (bad_channels does not affect referencing, only ICA channel
% selection and post-ICA interpolation).
cfg.bad_channel_candidates = [26 34]; % T7, T8 in the locked montage.
cfg.bad_channels = [26 34]; % T7, T8 -- marked bad by user 2026-09-02.
cfg.reference_mode = 'average_mastoid';
cfg.reference_exception_reason = '';
cfg.reference_review_complete = true;

% Gate B reviewed and confirmed by Fish (user) 2026-09-02 on the run-2
% (62-channel/rank-61, T7/T8 excluded) training copy: 19/300 (6.3%)
% rejected, still all FP1(14)/FP2(5), essentially unchanged from run 1
% since T7/T8 exclusion doesn't affect this threshold. Retained-sample
% AbsoluteMaximumUV (n=281): min 14.8, mean 36.5, p95 86.6, max 99.6 uV.
% Approved.
cfg.run_ica = true;
% Gate C reviewed and confirmed by Fish (user) 2026-09-02 on the run-2
% 61-component decomposition. User visually reviewed the component maps,
% spectra, activations, continuous data, and ICLabel decision support, then
% confirmed the final removal list below. IC6 and IC7 were reviewed
% separately and retained: IC6 had alpha-like 10-12 Hz power but ambiguous
% lateral topography; IC7 had broad beta-range activity without sufficient
% evidence of a non-brain source. Their screenshots are preserved under
% result_update/01B/qc/gateC_user_review/.
cfg.ica_review_complete = true;
cfg.removed_ics = [1 4 8 20 31 41 52 56 61];
% Gate C: SUPERSEDED run-1 decision (2026-09-01, user removed_ics =
% [1 5 6 7 8 9 17 21 23 24 25 27 31 37 41 43 46 47 49 53 56 58 60] on the
% 63-component/64-channel decomposition, citing a recurring ~10 Hz
% interference pattern from this lab's prior analyses) no longer applies --
% component numbering will differ with 62 ICA channels. Reset for fresh
% review; also added a 50 Hz PMnotch filter in Stage 3 in case any of that
% ~10 Hz-adjacent content was mains-related (verified 56.7 dB attenuation
% exactly at 50.00 Hz; pipeline data already had negligible 48-52 Hz power
% by this stage regardless, since Stage 3's 30 Hz lowpass already removes
% it -- see environment-notes-and-known-issues.md for the full diagnostic).
% The completed run-2 Gate C decision is recorded above.
% Gate D reviewed and confirmed by Fish (user) 2026-09-02 on the run-2
% baseline-corrected epoch set. The user applied a simple-threshold screen,
% manually updated the final epoch marks, and saved the review copy as
% result_update/01B/epochs/new.set. Read-only audit found 11/300 epochs
% (3.67%) in EEG.reject.rejmanual; rejmanualE and all threshold fields were
% empty, and all 300 physical epochs were retained.
cfg.artifact_bad_epochs = [49 52 66 70 98 118 194 203 246 253 292];
cfg.artifact_review_complete = true;
% Gate D: SUPERSEDED run-1 decision (2026-09-01, artifact_bad_epochs =
% [95 97 98 118] from epochs/epcohs.new.set) no longer applies -- epoch
% content changes with the new interpolated/ICA-clean upstream data. The
% completed run-2 Gate D decision is recorded above.

run(fullfile(fileparts(mfilename('fullpath')),'refresh_828_config.m'));
