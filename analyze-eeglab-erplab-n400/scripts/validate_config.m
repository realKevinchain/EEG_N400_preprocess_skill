function validate_config(cfg)
% VALIDATE_CONFIG Fail early on placeholders, missing files, and functions.

valid_stages = {'preica','train_ica','postica_erp'};
assert(any(strcmpi(cfg.stage, valid_stages)), 'Unknown cfg.stage: %s', cfg.stage);
assert(cfg.decisions.parameters_reviewed, ...
    'Complete the parameter decision ledger, then set parameters_reviewed=true.');

serialized = evalc('disp(cfg)');
assert(isempty(strfind(serialized, 'TODO_')), ...
    'Configuration still contains TODO placeholders.'); %#ok<STREMP>
assert(exist(cfg.paths.project_root, 'dir') == 7, 'Missing project root: %s', cfg.paths.project_root);
if exist(cfg.paths.output_dir, 'dir') ~= 7
    mkdir(cfg.paths.output_dir);
end
assert(~isempty(cfg.subjects), 'No participants configured.');
assert(~isempty(cfg.channels.eeg), 'cfg.channels.eeg must be explicit.');
assert(~isempty(cfg.channels.ica_train), 'cfg.channels.ica_train must be explicit.');

required = {'pop_loadset','pop_saveset','eeg_checkset'};
switch lower(cfg.stage)
    case 'preica'
        required = [required {'pop_chanedit','pop_resample','pop_basicfilter','pop_reref'}];
        assert(exist(cfg.paths.input_dir, 'dir') == 7, 'Missing input directory: %s', cfg.paths.input_dir);
        for s = 1:numel(cfg.subjects)
            f = fullfile(cfg.paths.input_dir, cfg.subjects(s).input_file);
            assert(exist(f, 'file') == 2, 'Missing input dataset: %s', f);
        end
        if ~isempty(cfg.paths.channel_locations)
            assert(exist(cfg.paths.channel_locations, 'file') == 2, 'Missing channel-location file.');
        end
    case 'train_ica'
        required = [required {'pop_resample','pop_basicfilter','pop_runica'}];
    case 'postica_erp'
        required = [required {'pop_subcomp','pop_reref','eeg_interp', ...
            'pop_creabasiceventlist','pop_binlister','pop_epochbin', ...
            'pop_artextval','pop_artmwppth','pop_averager'}];
        assert(exist(cfg.paths.bdf, 'file') == 2, 'Missing BDF/BinList file: %s', cfg.paths.bdf);
        assert(~isempty(cfg.n400.roi_channels), 'N400 ROI must be explicit.');
        assert(cfg.n400.bin_mapping_reviewed, ...
            'Verify EventList/BinList mapping, then set bin_mapping_reviewed=true.');
        for s = 1:numel(cfg.subjects)
            assert(cfg.subjects(s).ica_reviewed, ...
                'ICA decision not reviewed for %s.', cfg.subjects(s).id);
        end
end

for i = 1:numel(required)
    assert(exist(required{i}, 'file') ~= 0, ...
        'Required function not found on MATLAB path: %s', required{i});
end

assert(numel(cfg.epoch.window_ms) == 2 && cfg.epoch.window_ms(1) < cfg.epoch.window_ms(2), ...
    'Invalid epoch window.');
assert(numel(cfg.n400.window_ms) == 2 && cfg.n400.window_ms(1) < cfg.n400.window_ms(2), ...
    'Invalid N400 window.');
end
