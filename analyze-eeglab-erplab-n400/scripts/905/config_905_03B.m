%% 905 CAR participant configuration for 03B.
% Gate A is automated for this run with no ordinary bad scalp channels.
% Phase 4 and Phase 5 deliberately stop at the manual IC and epoch gates.

if exist('cfg','var') ~= 1
    cfg = struct();
end
cfg.subject = '03B';
cfg.behavior_subject = 6;

cfg.project_root = '/Users/kevinchain/Desktop/N400_project';
cfg.skill_root = '/Users/kevinchain/Documents/Codex/eeg-n400-analysis-skills/analyze-eeglab-erplab-n400';
cfg.eeglab_root = '/Users/kevinchain/Documents/MATLAB/eeglab2026.0.0';

cfg.input_dir = fullfile(cfg.project_root,'input_set');
cfg.behavior_dir = fullfile(cfg.project_root,'behavior');
cfg.bdf = fullfile(cfg.skill_root,'assets', ...
    'BDF_target_HC_LC_SNR_alltrials.txt');

cfg.fixed_excluded_labels = {'M1','M2','CB1','CB2'};
cfg.eog_labels = {'VEOG','HEOG'};
cfg.trigger_label = 'TRIGGER';

cfg.bad_channel_candidate_labels = {};
cfg.bad_channel_labels = {};
cfg.reference_mode = 'common_average';
cfg.reference_review_complete = true;
cfg.final_car_for_all = true;

cfg.analysis_rate = 250;
cfg.analysis_highpass = 0.1;
cfg.analysis_highpass_order = 2;
cfg.line_notch_hz = 50;
cfg.analysis_lowpass = 30;
cfg.analysis_lowpass_order = 8;

cfg.ica_rate = 100;
cfg.ica_highpass = 1;
cfg.ica_highpass_order = 8;
cfg.ica_task_end_seconds = 1.0;
cfg.ica_simple_threshold_uv = [-100 100];
cfg.ica_random_seed = 20260725;
cfg.run_ica = true;
cfg.ica_review_complete = true;
cfg.removed_ics = [2 5 9 10 14 16 19 22 25 27 28 31 32 33 35 36 37 ...
    39 40 41 42 43 44 45 46 48 50 53 52 54 55 57 58 59];

cfg.epoch_ms = [-200 800];
cfg.baseline_ms = [-200 0];
cfg.artifact_bad_epochs = [1 5 115 121 122 130 144 151 152 153 154 155 ...
    156 157 158 159 160 161 162 163 167 168 169 171 172 176 239 ...
    270 275 289];
cfg.artifact_flag_bit = 1;
cfg.behavior_flag_bit = 2;
cfg.artifact_review_complete = true;

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
% Coordinate-complete input is a working intermediate, not a result_905_car output.
cfg.input_dir = fullfile(cfg.project_root,'working_905',cfg.subject,'input_set');
