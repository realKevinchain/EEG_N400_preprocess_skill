function cfg = config_template()
% CONFIG_TEMPLATE Central configuration for the staged EEGLAB/ERPLAB pipeline.
% Copy this file into the study repository, rename the function/file together,
% replace every TODO, and preserve the completed config with the results.

cfg.stage = 'preica'; % 'preica', 'train_ica', or 'postica_erp'
cfg.decisions.parameters_reviewed = false; % Set true after completing the decision ledger

cfg.paths.project_root = 'TODO_ABSOLUTE_PROJECT_PATH';
cfg.paths.input_dir    = fullfile(cfg.paths.project_root, 'input_set');
cfg.paths.output_dir   = fullfile(cfg.paths.project_root, 'derivatives');
cfg.paths.channel_locations = 'TODO_CHANNEL_LOCATION_FILE';
cfg.paths.bdf = fullfile(cfg.paths.project_root, 'events', 'TODO_BDF.txt');

% Use one row per participant. bad_channels and ica_components may contain
% numeric indices or exact channel labels. Set ica_reviewed=true only after
% inspecting maps, activations, spectra, and EOG relationships.
cfg.subjects = struct( ...
    'id',             {'TODO_S01'}, ...
    'input_file',     {'TODO_S01.set'}, ...
    'bad_channels',   {{}}, ...
    'ica_components', {[]}, ...
    'ica_reviewed',   {false});

% Explicit channel groups. Use exact labels or numeric indices. Do not leave
% the EEG/ICA groups empty. Keep auxiliary channels out of interpolation and
% the final EEG reference unless the scientific plan says otherwise.
cfg.channels.eeg = {'TODO_EEG_LABELS'};
cfg.channels.monopolar_eog = {'TODO_MONOPOLAR_EOG_LABELS'};
cfg.channels.bipolar_eog   = {'TODO_BIPOLAR_EOG_LABELS'};
cfg.channels.auxiliary     = {'TODO_AUX_LABELS_OR_REMOVE'};
cfg.channels.ica_train     = {'TODO_EEG_AND_MONOPOLAR_EOG_LABELS'};

cfg.runtime.launch_eeglab = true;
cfg.runtime.eeglab_nogui  = true;
cfg.runtime.stop_on_warning = false;

% Pre-ICA analysis copy. Values below are examples from the source workflow,
% not universal defaults. Replace them with prespecified study decisions.
cfg.resample.enable = true;
cfg.resample.analysis_rate_hz = 250; % [DECIDE]

cfg.filter.analysis.enable = true;
cfg.filter.analysis.channels = [cfg.channels.eeg cfg.channels.monopolar_eog cfg.channels.bipolar_eog];
cfg.filter.analysis.highpass_hz = 0.1; % [DECIDE]
cfg.filter.analysis.lowpass_hz  = 30;  % [DECIDE]
cfg.filter.analysis.order = 2;         % Verify slope semantics in local help
cfg.filter.analysis.remove_dc = 'on';

% Initial reference is only for data stored without a usable reference.
cfg.reference.initial.enable = false;
cfg.reference.initial.channels = {'TODO_INITIAL_REFERENCE_LABEL'};
cfg.reference.initial.exclude_channels = [cfg.channels.bipolar_eog cfg.channels.auxiliary];

% ICA-training copy. Appendix 3 uses 1-30 Hz, 48 dB/oct and 100 Hz, but these
% remain study/data decisions. The template does not delete breaks or extreme
% segments automatically; perform and document that reviewed step beforehand.
cfg.filter.ica.highpass_hz = 1;
cfg.filter.ica.lowpass_hz  = 30;
cfg.filter.ica.order = 8; % Confirm the installed pop_basicfilter order/slope mapping
cfg.filter.ica.remove_dc = 'on';
cfg.ica.training_rate_hz = 100;
cfg.ica.algorithm = 'runica';
cfg.ica.extended = 1;
cfg.ica.expected_rank = []; % Optional independently justified value

% Final reference and interpolation order are explicit. For an average
% reference, interpolation ordinarily precedes the reference or bad channels
% must be excluded from the reference computation.
cfg.reference.final.enable = true;
cfg.reference.final.channels = {'TODO_FINAL_REFERENCE_LABELS'}; % [] means average reference
cfg.reference.final.exclude_channels = [cfg.channels.bipolar_eog cfg.channels.auxiliary];
cfg.reference.apply_before_interpolation = false;
cfg.interpolation.method = 'spherical';

cfg.eventlist.export = true;
cfg.eventlist.boundary_numeric = {-99};
cfg.eventlist.boundary_string  = {'boundary'};
cfg.eventlist.alphanumeric_cleaning = 'off';

cfg.binlister.update_eeg = 'on';
cfg.binlister.reset_flags = 'on';

cfg.epoch.window_ms = [-200 800]; % [DECIDE]
cfg.epoch.baseline  = 'pre';      % [DECIDE], or numeric [start end]

% Verified built-in detectors. Add study-specific blink/eye step detection by
% assigning a reviewed function handle copied from local GUI history, e.g.
% cfg.artifact.custom_function = @(EEG) my_reviewed_artifact_steps(EEG);
cfg.artifact.custom_function = [];
cfg.artifact.absolute.enable = true;
cfg.artifact.absolute.channels = cfg.channels.eeg;
cfg.artifact.absolute.threshold_uv = [-150 150]; % starting value only
cfg.artifact.absolute.window_ms = cfg.epoch.window_ms;
cfg.artifact.absolute.flag = 1;

cfg.artifact.moving_peak_to_peak.enable = true;
cfg.artifact.moving_peak_to_peak.channels = cfg.channels.eeg;
cfg.artifact.moving_peak_to_peak.threshold_uv = 150; % starting value only
cfg.artifact.moving_peak_to_peak.window_ms = cfg.epoch.window_ms;
cfg.artifact.moving_peak_to_peak.width_ms = 200;
cfg.artifact.moving_peak_to_peak.step_ms = 100;
cfg.artifact.moving_peak_to_peak.flag = 2;

cfg.average.exclude_boundary = 'on';
cfg.average.compute_sem = 'on';

% N400 worked-example values are intentionally visible but must be justified
% for the actual study. Bins are numeric ERPLAB bin indices.
cfg.n400.related_bin = 1;   % TODO verify actual BinList mapping
cfg.n400.unrelated_bin = 2; % TODO verify actual BinList mapping
cfg.n400.bin_mapping_reviewed = false;
cfg.n400.roi_channels = {'TODO_N400_ROI_LABELS'};
cfg.n400.window_ms = [300 500]; % [DECIDE]
cfg.n400.difference = 'unrelated-minus-related';

cfg.output.save_intermediate_set = true;
cfg.output.score_filename = 'n400_scores.csv';
end
