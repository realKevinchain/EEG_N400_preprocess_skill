%% Refresh participant-dependent paths and locked 905 CAR filenames.

assert(exist('cfg','var') == 1);
assert(strcmp(cfg.reference_mode,'common_average'));
referenceTag = 'car';

cfg.result_root = fullfile(cfg.project_root,'result_905_car',cfg.subject);
cfg.continuous_dir = fullfile(cfg.result_root,'continuous');
cfg.ica_dir = fullfile(cfg.result_root,'ica');
cfg.epochs_dir = fullfile(cfg.result_root,'epochs');
cfg.eventlists_dir = fullfile(cfg.result_root,'eventlists');
cfg.tables_dir = fullfile(cfg.result_root,'tables');
cfg.erp_dir = fullfile(cfg.result_root,'erp');
cfg.qc_dir = fullfile(cfg.result_root,'qc');
cfg.logs_dir = fullfile(cfg.result_root,'logs');
cfg.reference_tag = referenceTag;

prefix = sprintf('%s_905_%s',cfg.subject,referenceTag);
cfg.imported_set = sprintf('%s_imported.set',cfg.subject);
cfg.referenced_set = sprintf('%s_continuous_initial_car_unfiltered.set',prefix);
cfg.preica_set = sprintf('%s_preica_01_30_250.set',prefix);
cfg.icatrain_set = sprintf('%s_icatrain_1_30_100.set',prefix);
cfg.ica_solution_set = sprintf('%s_icatrain_ica.set',prefix);
cfg.icaweights_set = sprintf('%s_preica_icaweights.set',prefix);
cfg.icaclean_set = sprintf('%s_preica_icaclean.set',prefix);
cfg.final_car_set = sprintf('%s_postica_interpolated_final_car.set',prefix);
cfg.binned_set = sprintf('%s_postica_bins_continuous.set',prefix);
cfg.epochs_set = sprintf('%s_target_epochs_baseline_pre200.set',prefix);
cfg.flagged_set = sprintf('%s_target_epochs_baseline_artifactflagged.set',prefix);
cfg.ledger_csv = sprintf('%s_trial_ledger.csv',prefix);
cfg.bin_summary_csv = sprintf('%s_bin_summary.csv',prefix);
cfg.primary_erp = sprintf('%s_erp_primary_correct_clean.erp',prefix);
cfg.allclean_erp = sprintf('%s_erp_all_clean.erp',prefix);
