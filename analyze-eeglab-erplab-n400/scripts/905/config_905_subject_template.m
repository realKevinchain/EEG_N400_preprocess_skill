%% 905 CAR standard: copy to config_905_<SUBJECT>.m and edit per participant.

cfg.subject = 'XX';
cfg.behavior_subject = NaN;

cfg.project_root = 'TODO_ABSOLUTE_N400_PROJECT_PATH';
cfg.skill_root = 'TODO_ABSOLUTE_905_SKILL_DIRECTORY';
cfg.eeglab_root = ...
    'TODO_ABSOLUTE_EEGLAB_PATH';

cfg.input_dir = fullfile(cfg.project_root,'input_set');
cfg.behavior_dir = fullfile(cfg.project_root,'behavior');
cfg.bdf = fullfile(cfg.skill_root,'assets', ...
    'BDF_target_HC_LC_SNR_alltrials.txt');

% Resolve every channel by label at runtime. Never enter channel numbers here.
cfg.fixed_excluded_labels = {'M1','M2','CB1','CB2'};
cfg.eog_labels = {'VEOG','HEOG'};
cfg.trigger_label = 'TRIGGER';

% Gate A decisions. Ordinary participant-specific bad scalp channels are
% excluded from the initial CAR and ICA, then interpolated after ICA.
cfg.bad_channel_candidate_labels = {};
cfg.bad_channel_labels = {};
cfg.reference_mode = 'common_average';
cfg.reference_review_complete = false;
cfg.final_car_for_all = true;

cfg.analysis_rate = 250;
cfg.analysis_highpass = 0.1;
cfg.analysis_highpass_order = 2;
% Locked 905 line-noise step. ERPLAB PMnotch must use Design='notch'.
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

cfg.expected_raw_channels = 67;
cfg.expected_raw_scalp_channels = 64;
cfg.expected_analysis_scalp_channels = 60;
cfg.expected_analysis_channels = 63;
cfg.expected_trials = 300;
cfg.expected_bins = 10;
cfg.expected_trials_per_bin = 30;

run(fullfile(fileparts(mfilename('fullpath')),'refresh_905_config.m'));
