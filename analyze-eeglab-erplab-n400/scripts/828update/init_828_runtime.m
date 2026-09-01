%% Initialize the independent 828update runtime and output directories.

assert(exist('cfg','var') == 1, ...
    'Load an 828update participant config first.');
run(fullfile(fileparts(mfilename('fullpath')),'validate_828_config.m'));
assert(exist(cfg.eeglab_root,'dir') == 7,'EEGLAB directory not found.');
if exist('eeglab','file') ~= 2
    addpath(cfg.eeglab_root);
end
if exist('EEG','var') ~= 1
    eeglab;
end
if exist('pop_basicfilter','file') ~= 2
    pluginsDir = fullfile(cfg.eeglab_root,'plugins');
    pluginEntries = dir(pluginsDir);
    isErplabDir = [pluginEntries.isdir] & ...
        startsWith({pluginEntries.name},'erplab','IgnoreCase',true);
    assert(any(isErplabDir), ...
        'No ERPLAB plugin folder found under %s.',pluginsDir);
    erplabNames = {pluginEntries(isErplabDir).name};
    addpath(genpath(fullfile(pluginsDir,erplabNames{1})));
end
assert(exist('pop_basicfilter','file') == 2);
assert(exist('pop_epochbin','file') == 2);
assert(exist('pop_averager','file') == 2);

outputDirs = {cfg.result_root,cfg.continuous_dir,cfg.ica_dir, ...
    cfg.epochs_dir,cfg.eventlists_dir,cfg.tables_dir,cfg.erp_dir, ...
    cfg.qc_dir,cfg.logs_dir};
for k = 1:numel(outputDirs)
    if exist(outputDirs{k},'dir') ~= 7
        mkdir(outputDirs{k});
    end
end
