%% Read-only 905 Phase 4 threshold Gate B helper.

run(fullfile(fileparts(mfilename('fullpath')),'init_905_runtime.m'));
trainingPath = fullfile(cfg.ica_dir,cfg.icatrain_set);
assert(exist(trainingPath,'file') == 2,'Run Phase 4 once first.');
TRAINING = pop_loadset('filename',cfg.icatrain_set,'filepath',cfg.ica_dir);
stored = TRAINING.etc.n400_905_ica_training;
rejectedTrials = double(stored.threshold_rejected_trials(:)');
retainedTrials = double(stored.threshold_retained_trials(:)');

SOURCE = pop_loadset('filename',cfg.preica_set,'filepath',cfg.continuous_dir);
eogChannels = n400u_channel_indices(SOURCE,cfg.eog_labels);
triggerChannel = n400u_channel_indices(SOURCE,{cfg.trigger_label});
scalpChannels = setdiff(1:SOURCE.nbchan,[eogChannels triggerChannel],'stable');
badChannels = n400u_channel_indices(SOURCE,cfg.bad_channel_labels);
icaChannels = setdiff(scalpChannels,badChannels,'stable');
assert(isequal(upper(string(stored.ica_channel_labels)), ...
    upper(string({SOURCE.chanlocs(icaChannels).labels}))));
SOURCE = pop_basicfilter(SOURCE,icaChannels, ...
    'Filter','highpass','Design','butter','Cutoff',cfg.ica_highpass, ...
    'Order',cfg.ica_highpass_order,'RemoveDC','on','Boundary','boundary');
SOURCE = pop_resample(SOURCE,cfg.ica_rate);
codes = arrayfun(@(x) n400u_event_code(x.type),SOURCE.event);
startItems = find(ismember(codes,[11:15 21:25]));
assert(numel(startItems) == cfg.expected_trials);
ranges = nan(cfg.expected_trials,2);
recalculatedRejected = false(cfg.expected_trials,1);
for trial = 1:cfg.expected_trials
    startItem = startItems(trial);
    if trial < cfg.expected_trials
        nextStartItem = startItems(trial+1);
    else
        nextStartItem = numel(codes)+1;
    end
    targetItems = find(codes(startItem+1:nextStartItem-1) == ...
        codes(startItem)+100);
    assert(isscalar(targetItems), ...
        'Expected one target inside trial %d; found %d.', ...
        trial,numel(targetItems));
    targetItem = startItem+targetItems;
    firstPoint = max(1,ceil(double(SOURCE.event(startItem).latency)));
    lastPoint = min(SOURCE.pnts,ceil(double(SOURCE.event(targetItem).latency)+ ...
        cfg.ica_task_end_seconds*SOURCE.srate)-1);
    ranges(trial,:) = [firstPoint lastPoint];
    segment = double(SOURCE.data(icaChannels,firstPoint:lastPoint));
    recalculatedRejected(trial) = any( ...
        segment(:) < cfg.ica_simple_threshold_uv(1) | ...
        segment(:) > cfg.ica_simple_threshold_uv(2));
end
assert(isequal(find(recalculatedRejected)',rejectedTrials));
assert(isequal(find(~recalculatedRejected)',retainedTrials));
sampleCount = min(12,numel(retainedTrials));
samplePositions = unique(round(linspace(1,numel(retainedTrials),sampleCount)));
sampledRetained = retainedTrials(samplePositions);
fprintf('Threshold %.0f to %.0f uV; rejected %d/%d; rank %d.\n', ...
    cfg.ica_simple_threshold_uv(1),cfg.ica_simple_threshold_uv(2), ...
    numel(rejectedTrials),cfg.expected_trials,stored.numerical_rank);
fprintf('Rejected trials: '); fprintf('%d ',rejectedTrials);
fprintf('\nRetained sample: '); fprintf('%d ',sampledRetained);
fprintf('\nRead-only review: do not mark, delete, or save data.\n');
RETAINED_REVIEW = localReviewDataset( ...
    SOURCE,ranges,sampledRetained,icaChannels, ...
    sprintf('%s retained ICA sample',cfg.subject));
pop_eegplot(RETAINED_REVIEW,1,1,0);
if ~isempty(rejectedTrials)
    REJECTED_REVIEW = localReviewDataset( ...
        SOURCE,ranges,rejectedTrials,icaChannels, ...
        sprintf('%s rejected by +/-100 uV',cfg.subject));
    pop_eegplot(REJECTED_REVIEW,1,1,0);
end

function REVIEW = localReviewDataset(source,ranges,trials,channels,setname)
blocks = cell(1,numel(trials));
events = repmat(struct('type','','latency',0,'duration',0),1,numel(trials));
cursor = 1;
for k = 1:numel(trials)
    trial = trials(k);
    blocks{k} = source.data(channels,ranges(trial,1):ranges(trial,2));
    events(k).type = sprintf('trial_%03d',trial);
    events(k).latency = cursor;
    cursor = cursor+size(blocks{k},2);
end
REVIEW = source;
REVIEW.data = cat(2,blocks{:});
REVIEW.nbchan = numel(channels);
REVIEW.chanlocs = source.chanlocs(channels);
REVIEW.pnts = size(REVIEW.data,2);
REVIEW.trials = 1;
REVIEW.xmin = 0;
REVIEW.xmax = (REVIEW.pnts-1)/REVIEW.srate;
REVIEW.times = (0:REVIEW.pnts-1)/REVIEW.srate*1000;
REVIEW.event = events;
REVIEW.urevent = [];
REVIEW.epoch = [];
REVIEW.icaact = [];
REVIEW.icaweights = [];
REVIEW.icasphere = [];
REVIEW.icawinv = [];
REVIEW.icachansind = [];
REVIEW.reject = struct();
REVIEW.setname = setname;
REVIEW = eeg_checkset(REVIEW,'eventconsistency');
end
