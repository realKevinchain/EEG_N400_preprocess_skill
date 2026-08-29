%% Read-only GUI helper for 828update reference Gate A.

run(fullfile(fileparts(mfilename('fullpath')),'init_828_runtime.m'));
EEG = pop_loadset('filename',cfg.imported_set,'filepath',cfg.input_dir);
phase1QC = fullfile(cfg.qc_dir,sprintf( ...
    '%s_828update_%s_phase01_channel_qc.csv', ...
    cfg.subject,cfg.reference_tag));
assert(exist(phase1QC,'file') == 2,'Run Phase 1 first.');
CHANNEL_QC = readtable(phase1QC,'TextType','string');
automaticChannels = double(CHANNEL_QC.Channel(logical( ...
    CHANNEL_QC.AutomaticBadChannelCandidate)));
channels = unique([cfg.m1_channel cfg.m2_channel ...
    cfg.bad_channel_candidates(:)' automaticChannels(:)'],'stable');
labels = upper(string({EEG.chanlocs.labels}));
[found,comparisonChannels] = ismember(["FZ","CZ","CPZ","PZ"],labels);
comparisonChannels = setdiff(comparisonChannels(found),channels,'stable');
displayChannels = [channels comparisonChannels];
fprintf('Review candidates: '); fprintf('%s ',EEG.chanlocs(channels).labels);
fprintf('\nNormal comparisons: '); ...
    fprintf('%s ',EEG.chanlocs(comparisonChannels).labels);
fprintf('\nRead-only review: do not mark, delete, or save data.\n');
REVIEW = pop_select(EEG,'channel',displayChannels);
pop_eegplot(REVIEW,1,0,0);
