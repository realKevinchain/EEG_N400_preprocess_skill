%% 905 Phase 4: ICA training, rank control, review, and cleaning.
% Run repeatedly. The script stops at the threshold and IC review gates.

run(fullfile(fileparts(mfilename('fullpath')),'init_905_runtime.m'));
CHANNEL_SOURCE = pop_loadset('filename',cfg.preica_set, ...
    'filepath',cfg.continuous_dir);
eogChannels = n400u_channel_indices(CHANNEL_SOURCE,cfg.eog_labels);
triggerChannel = n400u_channel_indices(CHANNEL_SOURCE,{cfg.trigger_label});
scalpChannels = setdiff(1:CHANNEL_SOURCE.nbchan, ...
    [eogChannels triggerChannel],'stable');
badChannels = n400u_channel_indices(CHANNEL_SOURCE,cfg.bad_channel_labels);
icaChannels = setdiff(scalpChannels,badChannels,'stable');
icaChannelLabels = string({CHANNEL_SOURCE.chanlocs(icaChannels).labels});
assert(numel(scalpChannels) == cfg.expected_analysis_scalp_channels);
assert(numel(icaChannels) >= 2);
clear CHANNEL_SOURCE
trainingPath = fullfile(cfg.ica_dir,cfg.icatrain_set);
solutionPath = fullfile(cfg.ica_dir,cfg.ica_solution_set);
weightsPath = fullfile(cfg.ica_dir,cfg.icaweights_set);
cleanPath = fullfile(cfg.ica_dir,cfg.icaclean_set);
thresholdQCPath = fullfile(cfg.qc_dir,sprintf( ...
    '%s_905_%s_phase04_threshold_qc.csv', ...
    cfg.subject,cfg.reference_tag));
logPath = fullfile(cfg.logs_dir,sprintf( ...
    '%s_905_%s_phase04_pass.txt',cfg.subject,cfg.reference_tag));

completePaths = {trainingPath,solutionPath,weightsPath,cleanPath, ...
    thresholdQCPath,logPath};
completePresent = cellfun(@(p) exist(p,'file') == 2,completePaths);
if all(completePresent)
    fprintf('905 Phase 4 already complete: %s\n',cleanPath);
    return
end
assert(~(any(completePresent(4:6)) && ...
    ~(exist(trainingPath,'file') == 2 && exist(thresholdQCPath,'file') == 2)), ...
    'Partial Phase 4 deliverables exist; inspect before rerunning.');
assert(~(exist(solutionPath,'file') == 2 && exist(trainingPath,'file') ~= 2), ...
    'ICA solution exists without its training copy.');
assert(~(exist(weightsPath,'file') == 2 && exist(solutionPath,'file') ~= 2), ...
    'Transferred weights exist without the ICA solution.');
assert(~(exist(cleanPath,'file') == 2 && exist(weightsPath,'file') ~= 2), ...
    'ICA-clean data exist without transferred weights.');

%% A. Create the training copy and locked threshold review table.
if exist(trainingPath,'file') == 0
    n400u_assert_dataset_absent(trainingPath);
    assert(exist(solutionPath,'file') == 0 && exist(weightsPath,'file') == 0);
    EEG = pop_loadset('filename',cfg.preica_set, ...
        'filepath',cfg.continuous_dir);
    EEG = pop_basicfilter(EEG,icaChannels, ...
        'Filter','highpass','Design','butter', ...
        'Cutoff',cfg.ica_highpass,'Order',cfg.ica_highpass_order, ...
        'RemoveDC','on','Boundary','boundary');
    EEG = pop_resample(EEG,cfg.ica_rate);
    codes = arrayfun(@(x) n400u_event_code(x.type),EEG.event);
    startItems = find(ismember(codes,[11:15 21:25]));
    assert(numel(startItems) == cfg.expected_trials);
    ranges = nan(cfg.expected_trials,2);
    startCode = nan(cfg.expected_trials,1);
    targetCode = nan(cfg.expected_trials,1);
    minimumUV = nan(cfg.expected_trials,1);
    maximumUV = nan(cfg.expected_trials,1);
    absoluteMaximumUV = nan(cfg.expected_trials,1);
    peakChannel = strings(cfg.expected_trials,1);
    thresholdRejected = false(cfg.expected_trials,1);
    for trial = 1:cfg.expected_trials
        startItem = startItems(trial);
        expectedTarget = codes(startItem)+100;
        if trial < cfg.expected_trials
            nextStartItem = startItems(trial+1);
        else
            nextStartItem = numel(codes)+1;
        end
        targetItems = find(codes(startItem+1:nextStartItem-1) == ...
            expectedTarget);
        assert(isscalar(targetItems), ...
            'Expected one target inside trial %d; found %d.', ...
            trial,numel(targetItems));
        targetItem = startItem+targetItems;
        firstPoint = max(1,ceil(double(EEG.event(startItem).latency)));
        lastPoint = min(EEG.pnts,ceil(double( ...
            EEG.event(targetItem).latency)+ ...
            cfg.ica_task_end_seconds*EEG.srate)-1);
        ranges(trial,:) = [firstPoint lastPoint];
        startCode(trial) = codes(startItem);
        targetCode(trial) = codes(targetItem);
        segment = double(EEG.data(icaChannels,firstPoint:lastPoint));
        minimumUV(trial) = min(segment,[],'all');
        maximumUV(trial) = max(segment,[],'all');
        [absoluteMaximumUV(trial),linearIndex] = ...
            max(abs(segment),[],'all','linear');
        [channelPosition,~] = ind2sub(size(segment),linearIndex);
        peakChannel(trial) = string(EEG.chanlocs( ...
            icaChannels(channelPosition)).labels);
        thresholdRejected(trial) = ...
            minimumUV(trial) < cfg.ica_simple_threshold_uv(1) || ...
            maximumUV(trial) > cfg.ica_simple_threshold_uv(2);
    end
    assert(all(targetCode == startCode+100));
    THRESHOLD_QC = table((1:cfg.expected_trials)',startCode,targetCode, ...
        minimumUV,maximumUV,absoluteMaximumUV,peakChannel,thresholdRejected, ...
        'VariableNames',{'Trial','StartCode','TargetCode','MinimumUV', ...
        'MaximumUV','AbsoluteMaximumUV','PeakChannel','Rejected'});
    assert(exist(thresholdQCPath,'file') == 0, ...
        'Threshold QC exists without the training copy.');
    writetable(THRESHOLD_QC,thresholdQCPath);

    keepRanges = ranges(~thresholdRejected,:);
    assert(~isempty(keepRanges),'The threshold rejected every task segment.');
    removeRanges = localComplementRanges(keepRanges,EEG.pnts);
    if ~isempty(removeRanges)
        EEG = pop_select(EEG,'nopoint',removeRanges);
    end
    X = double(EEG.data(icaChannels,:));
    X = X-mean(X,2);
    numericalRank = rank(X);
    clear X
    expectedRank = numel(icaChannels)-1;
    assert(numericalRank == expectedRank, ...
        ['Unexpected ICA rank: observed %d, expected %d. Check reference, ' ...
        'flat/duplicate channels, and bad-channel decisions.'], ...
        numericalRank,expectedRank);
    EEG.etc.n400_905_ica_training = struct( ...
        'source',cfg.preica_set,'highpass_hz',cfg.ica_highpass, ...
        'sampling_rate_hz',cfg.ica_rate, ...
        'retained_window','trial start through target +1 s', ...
        'simple_threshold_uv',cfg.ica_simple_threshold_uv, ...
        'threshold_rejected_trials',find(thresholdRejected)', ...
        'threshold_retained_trials',find(~thresholdRejected)', ...
        'ica_channels',icaChannels, ...
        'ica_channel_labels',{cellstr(icaChannelLabels)}, ...
        'numerical_rank',numericalRank,'expected_rank',expectedRank, ...
        'reference_mode','common_average_good_scalp');
    EEG.setname = erase(cfg.icatrain_set,'.set');
    n400u_assert_dataset_absent(trainingPath);
    EEG = pop_saveset(EEG,'filename',cfg.icatrain_set,'filepath',cfg.ica_dir);
    fprintf(['905 ICA training copy created: rejected %d/%d task ' ...
        'segments; rank=%d/%d.\n'],sum(thresholdRejected), ...
        cfg.expected_trials,numericalRank,numel(icaChannels));
    fprintf(['GUI GATE B: run review_phase04_threshold_gate.m, then set ' ...
        'cfg.run_ica=true and rerun the config and Phase 4.\n']);
    return
end

%% B. Run extended Infomax with explicit PCA when rereferencing reduced rank.
assert(exist(thresholdQCPath,'file') == 2, ...
    'ICA training copy exists without its threshold QC table.');
if exist(solutionPath,'file') == 0
    n400u_assert_dataset_absent(solutionPath);
    assert(cfg.run_ica, ...
        'Complete threshold Gate B before setting cfg.run_ica=true.');
    EEG = pop_loadset('filename',cfg.icatrain_set,'filepath',cfg.ica_dir);
    training = EEG.etc.n400_905_ica_training;
    assert(isequal(double(training.ica_channels),double(icaChannels)));
    assert(isequal(upper(string(training.ica_channel_labels)), ...
        upper(icaChannelLabels)));
    numericalRank = double(training.numerical_rank);
    rng(cfg.ica_random_seed,'twister');
    arguments = {'icatype','runica','extended',1,'chanind',icaChannels};
    if numericalRank < numel(icaChannels)
        arguments(end+1:end+2) = {'pca',numericalRank};
    end
    EEG = pop_runica(EEG,arguments{:});
    assert(size(EEG.icaweights,1) == numericalRank);
    EEG.setname = erase(cfg.ica_solution_set,'.set');
    n400u_assert_dataset_absent(solutionPath);
    EEG = pop_saveset(EEG,'filename',cfg.ica_solution_set, ...
        'filepath',cfg.ica_dir);
end

%% C. Transfer weights to the complete referenced 250-Hz formal dataset.
if exist(weightsPath,'file') == 0
    n400u_assert_dataset_absent(weightsPath);
    ICA = pop_loadset('filename',cfg.ica_solution_set,'filepath',cfg.ica_dir);
    EEG = pop_loadset('filename',cfg.preica_set,'filepath',cfg.continuous_dir);
    assert(strcmp(ICA.etc.n400_905_ica_training.reference_mode, ...
        EEG.etc.n400_905_reference.mode));
    assert(isequal(double(ICA.icachansind),double(icaChannels)));
    assert(isequal(upper(string({ICA.chanlocs(ICA.icachansind).labels})), ...
        upper(string({EEG.chanlocs(icaChannels).labels}))), ...
        'ICA and formal-data channel labels/order do not match.');
    EEG.icaweights = ICA.icaweights;
    EEG.icasphere = ICA.icasphere;
    EEG.icawinv = ICA.icawinv;
    EEG.icachansind = ICA.icachansind;
    EEG.icaact = [];
    EEG.etc.n400_905_ica_training = ICA.etc.n400_905_ica_training;
    EEG = eeg_checkset(EEG);
    EEG.setname = erase(cfg.icaweights_set,'.set');
    n400u_assert_dataset_absent(weightsPath);
    EEG = pop_saveset(EEG,'filename',cfg.icaweights_set, ...
        'filepath',cfg.ica_dir);
end

%% D. Stop for manual IC review, allowing a reviewed decision of zero removals.
if ~cfg.ica_review_complete
    fprintf(['GUI GATE C: load %s, use ICLabel only as decision support, ' ...
        'inspect maps/spectra/time courses/EOG, enter cfg.removed_ics, set ' ...
        'cfg.ica_review_complete=true, then rerun Phase 4.\n'],weightsPath);
    return
end
assert(exist(cleanPath,'file') == 0 && exist(logPath,'file') == 0, ...
    'Partial final Phase 4 output exists; inspect before rerunning.');
EEG = pop_loadset('filename',cfg.icaweights_set,'filepath',cfg.ica_dir);
removed = unique(cfg.removed_ics(:)','stable');
assert(all(removed == fix(removed)) && ...
    all(ismember(removed,1:size(EEG.icaweights,1))));
if ~isempty(removed)
    EEG = pop_subcomp(EEG,removed,0);
end
EEG.etc.n400_905_ica_rejection = struct( ...
    'removed_components',removed,'manual_review_complete',true, ...
    'iclabel_decision_support_only',true);
EEG.setname = erase(cfg.icaclean_set,'.set');
n400u_assert_dataset_absent(cleanPath);
EEG = pop_saveset(EEG,'filename',cfg.icaclean_set,'filepath',cfg.ica_dir);
CHECK = pop_loadset('filename',cfg.icaclean_set,'filepath',cfg.ica_dir);
assert(isequaln(CHECK.data,EEG.data));
n400u_write_stage_log(cfg,'phase04',{ ...
    sprintf('Training source: %s',cfg.preica_set), ...
    sprintf('ICA channel labels: %s',strjoin(icaChannelLabels,',')), ...
    sprintf('Numerical rank: %d', ...
        EEG.etc.n400_905_ica_training.numerical_rank), ...
    sprintf('Threshold rejected trials: %s',mat2str( ...
        EEG.etc.n400_905_ica_training.threshold_rejected_trials)), ...
    sprintf('Removed ICs: %s',mat2str(removed)), ...
    sprintf('Output: %s',cleanPath)});
fprintf('905 Phase 4 PASS: removed ICs=%s; saved %s.\n', ...
    mat2str(removed),cleanPath);

function removeRanges = localComplementRanges(keepRanges,lastPoint)
keepRanges = sortrows(keepRanges,1);
assert(all(keepRanges(:,1) <= keepRanges(:,2)));
assert(all(keepRanges(2:end,1) > keepRanges(1:end-1,2)));
removeRanges = zeros(0,2);
cursor = 1;
for k = 1:size(keepRanges,1)
    if keepRanges(k,1) > cursor
        removeRanges(end+1,:) = [cursor keepRanges(k,1)-1]; %#ok<AGROW>
    end
    cursor = keepRanges(k,2)+1;
end
if cursor <= lastPoint
    removeRanges(end+1,:) = [cursor lastPoint];
end
end
