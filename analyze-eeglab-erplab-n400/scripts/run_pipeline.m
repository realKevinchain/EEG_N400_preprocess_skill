function results = run_pipeline(config_function)
% RUN_PIPELINE Execute one reviewed stage of an EEGLAB/ERPLAB N400 pipeline.
%
% Example:
%   results = run_pipeline(@my_study_config);
%
% Run stages separately: preica -> train_ica -> review components and update
% config -> postica_erp. Vendor import, break/extreme-segment removal, and ICA
% component identification remain reviewed operations outside this automation.

if nargin < 1
    config_function = @config_template;
end
cfg = config_function();

if cfg.runtime.launch_eeglab
    if cfg.runtime.eeglab_nogui
        eeglab('nogui');
    else
        eeglab;
    end
end
validate_config(cfg);
record_environment(cfg);

results = struct([]);
score_rows = table();
for s = 1:numel(cfg.subjects)
    subject = cfg.subjects(s);
    fprintf('\n[%s] Stage: %s\n', subject.id, cfg.stage);
    switch lower(cfg.stage)
        case 'preica'
            out_file = run_preica(cfg, subject);
            results(end+1).id = subject.id; %#ok<AGROW>
            results(end).file = out_file;
        case 'train_ica'
            out_file = run_ica_training(cfg, subject);
            results(end+1).id = subject.id; %#ok<AGROW>
            results(end).file = out_file;
        case 'postica_erp'
            [out_file, row] = run_postica_erp(cfg, subject);
            results(end+1).id = subject.id; %#ok<AGROW>
            results(end).file = out_file;
            score_rows = [score_rows; row]; %#ok<AGROW>
    end
end

if strcmpi(cfg.stage, 'postica_erp')
    score_path = fullfile(cfg.paths.output_dir, cfg.output.score_filename);
    writetable(score_rows, score_path);
    fprintf('Wrote N400 scores: %s\n', score_path);
end
end

function out_file = run_preica(cfg, subject)
EEG = pop_loadset('filename', subject.input_file, 'filepath', cfg.paths.input_dir);
EEG = eeg_checkset(EEG);

if ~isempty(cfg.paths.channel_locations)
    EEG.chanlocs = pop_chanedit(EEG.chanlocs, 'load', ...
        {cfg.paths.channel_locations, 'filetype', 'autodetect'});
    EEG = eeg_checkset(EEG);
end

if cfg.resample.enable && EEG.srate ~= cfg.resample.analysis_rate_hz
    EEG = pop_resample(EEG, cfg.resample.analysis_rate_hz);
end

if cfg.filter.analysis.enable
    chans = resolve_channels(EEG, cfg.filter.analysis.channels);
    EEG = pop_basicfilter(EEG, chans, 'Boundary', 'boundary', ...
        'Cutoff', [cfg.filter.analysis.highpass_hz cfg.filter.analysis.lowpass_hz], ...
        'Design', 'butter', 'Filter', 'bandpass', ...
        'Order', cfg.filter.analysis.order, 'RemoveDC', cfg.filter.analysis.remove_dc);
end

if cfg.reference.initial.enable
    ref = resolve_channels(EEG, cfg.reference.initial.channels);
    excluded = resolve_channels_allow_empty(EEG, cfg.reference.initial.exclude_channels);
    EEG = pop_reref_with_exclusions(EEG, ref, excluded);
end

EEG.setname = [subject.id '_preica'];
out_file = fullfile(cfg.paths.output_dir, [EEG.setname '.set']);
pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', cfg.paths.output_dir);
end

function out_file = run_ica_training(cfg, subject)
EEG = pop_loadset('filename', [subject.id '_preica.set'], 'filepath', cfg.paths.output_dir);
ica_channels = resolve_channels(EEG, cfg.channels.ica_train);
bad = resolve_channels_allow_empty(EEG, subject.bad_channels);
ica_channels = setdiff(ica_channels, bad, 'stable');

EEG = pop_basicfilter(EEG, ica_channels, 'Boundary', 'boundary', ...
    'Cutoff', [cfg.filter.ica.highpass_hz cfg.filter.ica.lowpass_hz], ...
    'Design', 'butter', 'Filter', 'bandpass', ...
    'Order', cfg.filter.ica.order, 'RemoveDC', cfg.filter.ica.remove_dc);
if EEG.srate ~= cfg.ica.training_rate_hz
    EEG = pop_resample(EEG, cfg.ica.training_rate_hz);
end

sample_step = max(1, floor(EEG.pnts * EEG.trials / 20000));
rank_data = reshape(EEG.data(ica_channels, :, :), numel(ica_channels), []);
rank_estimate = rank(double(rank_data(:, 1:sample_step:end)));
fprintf('[%s] ICA channels=%d, samples=%d, estimated rank=%d\n', ...
    subject.id, numel(ica_channels), size(rank_data, 2), rank_estimate);
if ~isempty(cfg.ica.expected_rank)
    assert(rank_estimate == cfg.ica.expected_rank, ...
        'Estimated rank %d differs from configured rank %d.', rank_estimate, cfg.ica.expected_rank);
elseif rank_estimate < numel(ica_channels)
    warning('Estimated data rank (%d) is below ICA channel count (%d). Review ICA dimensionality.', ...
        rank_estimate, numel(ica_channels));
end

EEG = pop_runica(EEG, 'icatype', cfg.ica.algorithm, ...
    'extended', cfg.ica.extended, 'chanind', ica_channels);
EEG = eeg_checkset(EEG);
EEG.etc.pipeline_qc.rank_estimate = rank_estimate;
EEG.setname = [subject.id '_ica'];
out_file = fullfile(cfg.paths.output_dir, [EEG.setname '.set']);
pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', cfg.paths.output_dir);
end

function [out_file, score_row] = run_postica_erp(cfg, subject)
EEG = pop_loadset('filename', [subject.id '_preica.set'], 'filepath', cfg.paths.output_dir);
ICA = pop_loadset('filename', [subject.id '_ica.set'], 'filepath', cfg.paths.output_dir);

assert(EEG.nbchan == ICA.nbchan, 'Channel count mismatch during ICA transfer.');
assert(isequal({EEG.chanlocs.labels}, {ICA.chanlocs.labels}), ...
    'Channel order/labels mismatch during ICA transfer.');
EEG.icaweights = ICA.icaweights;
EEG.icasphere  = ICA.icasphere;
EEG.icawinv    = ICA.icawinv;
EEG.icachansind = ICA.icachansind;
EEG = eeg_checkset(EEG);
if ~isempty(subject.ica_components)
    EEG = pop_subcomp(EEG, subject.ica_components, 0);
end

if cfg.reference.apply_before_interpolation
    EEG = apply_final_reference(EEG, cfg);
end
bad = resolve_channels_allow_empty(EEG, subject.bad_channels);
if ~isempty(bad)
    EEG = eeg_interp(EEG, bad, cfg.interpolation.method);
end
if ~cfg.reference.apply_before_interpolation
    EEG = apply_final_reference(EEG, cfg);
end

event_export = '';
if cfg.eventlist.export
    event_export = fullfile(cfg.paths.output_dir, [subject.id '_eventlist.txt']);
end
EEG = pop_creabasiceventlist(EEG, 'Eventlist', event_export, ...
    'BoundaryNumeric', cfg.eventlist.boundary_numeric, ...
    'BoundaryString', cfg.eventlist.boundary_string, ...
    'AlphanumericCleaning', cfg.eventlist.alphanumeric_cleaning, 'Warning', 'off');

binned_export = fullfile(cfg.paths.output_dir, [subject.id '_eventlist_binned.txt']);
EEG = pop_binlister(EEG, 'BDF', cfg.paths.bdf, 'ExportEL', binned_export, ...
    'Resetflag', cfg.binlister.reset_flags, 'SendEL2', 'EEG&Text', ...
    'UpdateEEG', cfg.binlister.update_eeg, 'Warning', 'off');

EEG = pop_epochbin(EEG, cfg.epoch.window_ms, cfg.epoch.baseline);

if cfg.artifact.absolute.enable
    chans = resolve_channels(EEG, cfg.artifact.absolute.channels);
    EEG = pop_artextval(EEG, 'Channel', chans, ...
        'Flag', cfg.artifact.absolute.flag, ...
        'Threshold', cfg.artifact.absolute.threshold_uv, ...
        'Twindow', cfg.artifact.absolute.window_ms);
end
if cfg.artifact.moving_peak_to_peak.enable
    chans = resolve_channels(EEG, cfg.artifact.moving_peak_to_peak.channels);
    EEG = pop_artmwppth(EEG, 'Channel', chans, ...
        'Flag', cfg.artifact.moving_peak_to_peak.flag, ...
        'Threshold', cfg.artifact.moving_peak_to_peak.threshold_uv, ...
        'Twindow', cfg.artifact.moving_peak_to_peak.window_ms, ...
        'Windowsize', cfg.artifact.moving_peak_to_peak.width_ms, ...
        'Windowstep', cfg.artifact.moving_peak_to_peak.step_ms);
end
if ~isempty(cfg.artifact.custom_function)
    EEG = cfg.artifact.custom_function(EEG);
end

EEG.setname = [subject.id '_postica_epoched'];
if cfg.output.save_intermediate_set
    pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', cfg.paths.output_dir);
end

ERP = pop_averager(EEG, 'Criterion', 'good', ...
    'ExcludeBoundary', cfg.average.exclude_boundary, 'SEM', cfg.average.compute_sem);
erp_path = fullfile(cfg.paths.output_dir, [subject.id '_ERP.mat']);
save(erp_path, 'ERP', '-mat');
score_row = score_n400(ERP, cfg, subject.id);
out_file = erp_path;
end

function EEG = apply_final_reference(EEG, cfg)
if ~cfg.reference.final.enable
    return;
end
if isempty(cfg.reference.final.channels)
    ref = [];
else
    ref = resolve_channels(EEG, cfg.reference.final.channels);
end
excluded = resolve_channels_allow_empty(EEG, cfg.reference.final.exclude_channels);
EEG = pop_reref_with_exclusions(EEG, ref, excluded);
end

function EEG = pop_reref_with_exclusions(EEG, ref, excluded)
if isempty(excluded)
    EEG = pop_reref(EEG, ref);
else
    EEG = pop_reref(EEG, ref, 'exclude', excluded);
end
end

function row = score_n400(ERP, cfg, subject_id)
chans = resolve_erp_channels(ERP, cfg.n400.roi_channels);
time_mask = ERP.times >= cfg.n400.window_ms(1) & ERP.times <= cfg.n400.window_ms(2);
assert(any(time_mask), 'No ERP samples fall in the N400 window.');
assert(cfg.n400.related_bin <= size(ERP.bindata, 3), 'Related bin is out of range.');
assert(cfg.n400.unrelated_bin <= size(ERP.bindata, 3), 'Unrelated bin is out of range.');

related_values = double(ERP.bindata(chans, time_mask, cfg.n400.related_bin));
unrelated_values = double(ERP.bindata(chans, time_mask, cfg.n400.unrelated_bin));
related = mean(related_values(:));
unrelated = mean(unrelated_values(:));
switch lower(cfg.n400.difference)
    case 'unrelated-minus-related'
        difference = unrelated - related;
    case 'related-minus-unrelated'
        difference = related - unrelated;
    otherwise
        error('Unknown N400 difference convention: %s', cfg.n400.difference);
end
row = table(string(subject_id), related, unrelated, difference, ...
    'VariableNames', {'subject_id','related_uv','unrelated_uv','difference_uv'});
end

function indices = resolve_channels(EEG, specification)
indices = resolve_channels_allow_empty(EEG, specification);
assert(~isempty(indices), 'Channel specification resolved to an empty set.');
end

function indices = resolve_channels_allow_empty(EEG, specification)
if isempty(specification)
    indices = [];
elseif isnumeric(specification)
    indices = specification;
else
    labels = {EEG.chanlocs.labels};
    specs = normalize_labels(specification);
    [found, indices] = ismember(specs, labels);
    assert(all(found), 'Unknown EEG channel label(s): %s', strjoin(specs(~found), ', '));
end
end

function indices = resolve_erp_channels(ERP, specification)
if isnumeric(specification)
    indices = specification;
else
    specs = normalize_labels(specification);
    if isstruct(ERP.chanlocs)
        [found, indices] = ismember(specs, {ERP.chanlocs.labels});
    else
        [found, indices] = ismember(specs, ERP.chanlocs);
    end
    assert(all(found), 'Unknown ERP channel label(s).');
end
assert(~isempty(indices), 'N400 ROI resolved to an empty set.');
end

function labels = normalize_labels(specification)
if iscell(specification)
    labels = specification;
elseif isstring(specification)
    labels = cellstr(specification);
elseif ischar(specification)
    labels = cellstr(specification);
else
    error('Channel labels must be numeric indices, char, string, or cell array.');
end
end

function record_environment(cfg)
path_out = fullfile(cfg.paths.output_dir, 'software_environment.txt');
fid = fopen(path_out, 'a');
assert(fid ~= -1, 'Cannot open environment log: %s', path_out);
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid, '\n=== %s | stage %s ===\n', datestr(now, 30), cfg.stage);
fprintf(fid, '%s\n', evalc('version'));
fprintf(fid, '%s\n', evalc('ver'));
names = {'eeglab','pop_runica','pop_creabasiceventlist','pop_binlister','pop_epochbin','pop_averager'};
for i = 1:numel(names)
    fprintf(fid, '%s: %s\n', names{i}, which(names{i}));
end
end
