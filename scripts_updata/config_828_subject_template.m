%% Copy to config_828_<SUBJECT>.m and edit once per participant.

cfg.subject = 'XX';
cfg.behavior_subject = NaN;

cfg.project_root = 'TODO_ABSOLUTE_N400_PROJECT_PATH';
cfg.repo_root = fileparts(fileparts(mfilename('fullpath')));
cfg.eeglab_root = ...
    'TODO_ABSOLUTE_EEGLAB_PATH';

cfg.input_dir = fullfile(cfg.project_root,'input_set');
cfg.behavior_dir = fullfile(cfg.project_root,'behavior');
cfg.bdf = fullfile(cfg.repo_root,'events', ...
    'BDF_target_HC_LC_SNR_alltrials.txt');

cfg.eeg_channels = 1:64;
cfg.eog_channels = 65:66;
cfg.trigger_channel = 67;
cfg.m1_channel = 44;
cfg.m2_channel = 45;
cfg.aux_channels = 65:67;

% Reference Gate A. Bad channels are scalp channels only and are recorded
% here, excluded from ICA, then interpolated after ICA in Phase 5.
cfg.bad_channel_candidates = [];
cfg.bad_channels = [];
cfg.reference_mode = 'average_mastoid'; % average_mastoid | m1 | m2
cfg.reference_exception_reason = '';
cfg.reference_review_complete = false;

cfg.analysis_rate = 250;
cfg.analysis_highpass = 0.1;
cfg.analysis_highpass_order = 2;
% Locked 902 line-noise step. ERPLAB PMnotch must use Design='notch'.
cfg.line_notch_hz = 50;
cfg.analysis_lowpass = 30;
cfg.analysis_lowpass_order = 8;

cfg.ica_rate = 100;
cfg.ica_highpass = 1;
cfg.ica_highpass_order = 8;
cfg.ica_task_end_seconds = 1.0;
cfg.ica_simple_threshold_uv = [-100 100];
cfg.ica_random_seed = 20260725;
cfg.run_ica = false;
cfg.ica_review_complete = false;
cfg.removed_ics = [];

cfg.epoch_ms = [-200 800];
cfg.baseline_ms = [-200 0];
cfg.artifact_bad_epochs = [];
cfg.artifact_flag_bit = 1;
cfg.behavior_flag_bit = 2;
cfg.artifact_review_complete = false;

% Read-only Phase 1 QC thresholds; these never reject data automatically.
cfg.continuous_qc_window_seconds = 1;
cfg.continuous_segment_absolute_uv = 1000;
cfg.continuous_segment_p2p_uv = 1500;
cfg.continuous_segment_flat_fraction = 0.95;

cfg.expected_channels = 67;
cfg.expected_trials = 300;
cfg.expected_bins = 10;
cfg.expected_trials_per_bin = 30;

run(fullfile(fileparts(mfilename('fullpath')),'refresh_828_config.m'));
