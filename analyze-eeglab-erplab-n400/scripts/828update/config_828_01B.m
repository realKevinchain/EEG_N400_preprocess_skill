%% 01B pilot configuration for the independent 828update pipeline.

run(fullfile(fileparts(mfilename('fullpath')), ...
    'config_828_subject_template.m'));
cfg.subject = '01B';
cfg.behavior_subject = 1;

% Candidates only. Gate A must independently confirm the final list.
cfg.bad_channel_candidates = [26 34]; % T7, T8 in the locked montage.
cfg.bad_channels = [];
cfg.reference_mode = 'average_mastoid';
cfg.reference_exception_reason = '';
cfg.reference_review_complete = false;

cfg.run_ica = false;
cfg.ica_review_complete = false;
cfg.removed_ics = [];
cfg.artifact_bad_epochs = [];
cfg.artifact_review_complete = false;

run(fullfile(fileparts(mfilename('fullpath')),'refresh_828_config.m'));
