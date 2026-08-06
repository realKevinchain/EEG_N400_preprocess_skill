%% Load EEGLAB/ERPLAB paths once. Requires cfg in the workspace.

assert(exist('cfg','var') == 1, ...
    'Load a participant config into cfg first.');
assert(exist(cfg.eeglab_root,'dir') == 7, ...
    'EEGLAB directory not found.');

if exist('eeglab','file') ~= 2
    addpath(cfg.eeglab_root);
end
if exist('EEG','var') ~= 1
    eeglab;
end

erplabRoot = fullfile( ...
    cfg.eeglab_root,'plugins','erplab-master');
if exist('pop_basicfilter','file') ~= 2
    addpath(genpath(erplabRoot));
end

assert(exist('pop_basicfilter','file') == 2);
assert(exist('pop_averager','file') == 2);
