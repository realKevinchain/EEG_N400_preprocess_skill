%% Copy this file to config_<SUBJECT>.m and edit once per participant.

cfg.subject = '01B';
cfg.behavior_subject = 1;

cfg.project_root = '/Users/kevinchain/Desktop/N400_project';
cfg.repo_root = ...
    '/Users/kevinchain/Documents/Codex/eeg-n400-analysis-skills';
cfg.eeglab_root = ...
    '/Users/kevinchain/Documents/MATLAB/eeglab2026.0.0';

cfg.input_dir = fullfile(cfg.project_root,'input_set');
cfg.behavior_dir = fullfile(cfg.project_root,'behavior');
cfg.deriv_dir = fullfile(cfg.project_root,'derivatives');
cfg.eventlist_dir = fullfile(cfg.project_root, ...
    'events','eventlists',cfg.subject);
cfg.tables_dir = fullfile(cfg.deriv_dir, ...
    'tables',cfg.subject);
cfg.erp_dir = fullfile(cfg.deriv_dir, ...
    'erp',cfg.subject);
cfg.bdf = fullfile(cfg.repo_root,'events', ...
    'BDF_target_HC_LC_SNR_alltrials.txt');

cfg.eeg_channels = 1:64;
cfg.bad_channels = [26 34];  % T7, T8
cfg.ica_channels = setdiff(cfg.eeg_channels,cfg.bad_channels);
cfg.eog_channels = 65:66;
cfg.trigger_channel = 67;
cfg.m1_channel = 44;
cfg.m2_channel = 45;
cfg.aux_channels = 65:67;

cfg.analysis_rate = 250;
cfg.analysis_highpass = 0.1;
cfg.analysis_highpass_order = 2;
cfg.analysis_lowpass = 30;
cfg.analysis_lowpass_order = 8;

cfg.ica_rate = 100;
cfg.ica_highpass = 1;
cfg.ica_highpass_order = 8;
cfg.ica_task_end_seconds = 1.0;
cfg.ica_simple_threshold_uv = [-100 100];
cfg.ica_random_seed = 20260725;
cfg.run_ica = true;

% Fill after GUI component review; never copy another participant's ICs.
cfg.removed_ics = [1 3 30 32 46 50 59 61 62];

% Both mastoids passed visual QC, so use the project default.
cfg.reference_mode = 'average_mastoid'; % average_mastoid | m1 | m2
cfg.reference_exception_reason = '';
switch cfg.reference_mode
    case 'average_mastoid'
        cfg.final_reference_channels = ...
            [cfg.m1_channel cfg.m2_channel];
        cfg.reference_tag = 'mastref';
    case 'm1'
        assert(strlength(string( ...
            cfg.reference_exception_reason)) > 0, ...
            'Document why M2 is unusable before selecting M1 only.');
        cfg.final_reference_channels = cfg.m1_channel;
        cfg.reference_tag = 'm1ref';
    case 'm2'
        assert(strlength(string( ...
            cfg.reference_exception_reason)) > 0, ...
            'Document why M1 is unusable before selecting M2 only.');
        cfg.final_reference_channels = cfg.m2_channel;
        cfg.reference_tag = 'm2ref';
    otherwise
        error('Unsupported reference_mode: %s',cfg.reference_mode);
end
cfg.epoch_ms = [-200 800];
cfg.baseline_ms = [-200 0];

% Fill after condition-blind Phase 5 review.
cfg.artifact_bad_epochs = 118;
cfg.artifact_flag_bit = 1;
cfg.artifact_review_complete = true;

cfg.expected_trials = 300;
cfg.expected_bins = 10;
cfg.expected_trials_per_bin = 30;

cfg.imported_set = sprintf('%s_imported.set',cfg.subject);
cfg.preica_set = sprintf('%s_preica.set',cfg.subject);
cfg.icatrain_set = sprintf('%s_icatrain_reviewed.set',cfg.subject);
cfg.ica_solution_set = sprintf( ...
    '%s_icatrain_ica.set',cfg.subject);
cfg.icaweights_set = sprintf('%s_preica_icaweights.set',cfg.subject);
cfg.icaclean_set = sprintf('%s_preica_icaclean.set',cfg.subject);
cfg.ref_set = sprintf('%s_postica_%s.set', ...
    cfg.subject,cfg.reference_tag);
cfg.binned_set = sprintf('%s_postica_%s_bins.set', ...
    cfg.subject,cfg.reference_tag);
cfg.epochs_set = sprintf('%s_%s_target_epochs_pre200.set', ...
    cfg.subject,cfg.reference_tag);
cfg.nobase_set = sprintf( ...
    '%s_%s_target_epochs_nobaseline_diagnostic.set', ...
    cfg.subject,cfg.reference_tag);
cfg.flagged_set = sprintf( ...
    '%s_%s_target_epochs_artifactflagged.set', ...
    cfg.subject,cfg.reference_tag);
cfg.nobase_flagged_set = sprintf( ...
    '%s_%s_target_epochs_nobaseline_artifactflagged.set', ...
    cfg.subject,cfg.reference_tag);
cfg.ledger_csv = sprintf('%s_%s_trial_ledger.csv', ...
    cfg.subject,cfg.reference_tag);
cfg.primary_erp = sprintf( ...
    '%s_%s_erp_primary_correct_clean.erp', ...
    cfg.subject,cfg.reference_tag);
cfg.sensitivity_erp = sprintf( ...
    '%s_%s_erp_sensitivity_all_clean.erp', ...
    cfg.subject,cfg.reference_tag);
