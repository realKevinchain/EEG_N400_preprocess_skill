%% Read-only GUI helper for 905 reference Gate A.

run(fullfile(fileparts(mfilename('fullpath')),'init_905_runtime.m'));
EEG = pop_loadset('filename',cfg.imported_set,'filepath',cfg.input_dir);
phase1QC = fullfile(cfg.qc_dir,sprintf( ...
    '%s_905_%s_phase01_channel_qc.csv', ...
    cfg.subject,cfg.reference_tag));
assert(exist(phase1QC,'file') == 2,'Run Phase 1 first.');
CHANNEL_QC = readtable(phase1QC,'TextType','string');
automaticChannels = double(CHANNEL_QC.RawChannel(logical( ...
    CHANNEL_QC.AutomaticBadChannelCandidate)))';
configuredChannels = n400u_channel_indices( ...
    EEG,cfg.bad_channel_candidate_labels);
channels = unique([configuredChannels automaticChannels],'stable');
labels = upper(strtrim(string({EEG.chanlocs.labels})));
[found,comparisonChannels] = ismember(["FZ","CZ","CPZ","PZ"],labels);
comparisonChannels = setdiff(comparisonChannels(found),channels,'stable');
displayChannels = [channels comparisonChannels];
fprintf('Fixed exclusions (not candidates): %s\n', ...
    strjoin(string(cfg.fixed_excluded_labels),', '));
fprintf('Review candidates: '); fprintf('%s ',EEG.chanlocs(channels).labels);
fprintf('\nNormal comparisons: '); ...
    fprintf('%s ',EEG.chanlocs(comparisonChannels).labels);
fprintf('\nRead-only review: do not mark, delete, or save data.\n');
REVIEW = pop_select(EEG,'channel',displayChannels);
pop_eegplot(REVIEW,1,0,0);
