%% 01A pilot configuration for the independent 828update pipeline.

run(fullfile(fileparts(mfilename('fullpath')), ...
    'config_828_subject_template.m'));
cfg.subject = '01A';
cfg.behavior_subject = 11;

% NOTE: config_828_subject_template.m lives in a Google-Drive-synced folder
% shared with a collaborator and has been observed to be silently overwritten
% with the collaborator's own machine-specific paths. Every path this
% participant config depends on is therefore re-asserted explicitly below
% instead of trusting whatever the template currently contains.
cfg.project_root = ...
    '/Users/fishtambo/Desktop/Fish and Kevin''s Research/FYP/EEG分析/N400_project';
cfg.repo_root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
cfg.eeglab_root = ...
    '/Users/fishtambo/Desktop/Fish and Kevin''s Research/FYP/EEG分析/eeglab2026.0.0';
cfg.input_dir = fullfile(cfg.project_root,'input_set');
cfg.behavior_dir = fullfile(cfg.project_root,'behavior');
cfg.bdf = fullfile(cfg.repo_root,'assets','BDF_target_HC_LC_SNR_alltrials.txt');

% Gate A reviewed 2026-08-31: M1/M2 and all phase01 candidate channels
% (F2, FT11, C3, T8, CP3, CP2, CP4, PO7, POZ, CB1) inspected across multiple
% time windows via review_phase02_reference_gate.m. None were flat, saturated,
% or clipped. The elevated noise on the peripheral candidates matches normal
% temporal/frontal/parieto-occipital EMG topography (expected to be handled
% by ICA in Phase 4, not by channel exclusion). M1/M2 show a shared ~20 s
% physiological-looking drift (~0.05 Hz), well below the 0.1 Hz Phase 3
% highpass, and are not flat/saturated. No bad channels confirmed.
cfg.bad_channel_candidates = [];
cfg.bad_channels = [];
cfg.reference_mode = 'average_mastoid';
cfg.reference_exception_reason = '';
cfg.reference_review_complete = true;

% Gate B reviewed 2026-08-31: retained sample (12/276) and all 24 rejected
% segments inspected via review_phase04_threshold_gate.m. Rejections are
% coherent (23/24 peak at FP2, 1 at FPZ) consistent with blink contamination
% at the frontal pole; retained sample looked clean. Threshold gate approved.
% Gate C reviewed 2026-08-31 via pop_viewprops (ICLabel + map/spectrum/
% activation/EOG-timing inspection). Removed: 2, 16, 31 (high-confidence Eye,
% >80% ICLabel); 24, 27, 33, 37, 41, 55 (participant-reviewed, ICLabel Other-
% dominant, user-confirmed artifact on visual inspection); 39, 40, 56, 58
% (Channel Noise-dominant ICLabel). Kept 23 (Other-dominant, <1% variance
% explained, no consistent single-artifact signature across multiple time
% windows on review). Kept remaining Other/Brain components (insufficient
% positive evidence to remove).
cfg.run_ica = true;
cfg.ica_review_complete = true;
cfg.removed_ics = [2 16 24 27 31 33 37 39 40 41 55 56 58];
% Gate D reviewed 2026-08-31: condition-blind pooled review of all 300
% epochs via review_phase05_artifact_gate.m (eegplot), cross-checked against
% an automatic ScalpMaxAbs>100uV candidate list (18 epochs, all confirmed and
% included below). 37/300 epochs flagged; rejection rate 12.33%.
cfg.artifact_bad_epochs = [4 10 14 22 28 44 49 54 57 64 65 78 80 94 95 103 ...
    115 121 123 130 133 134 135 138 139 140 153 162 199 202 206 215 232 ...
    247 258 282 283];
cfg.artifact_review_complete = true;

run(fullfile(fileparts(mfilename('fullpath')),'refresh_828_config.m'));
