%% 905 Phase 1: raw import, retained-montage, event, and behavior audit.

run(fullfile(fileparts(mfilename('fullpath')),'init_905_runtime.m'));
channelQCPath = fullfile(cfg.qc_dir,sprintf( ...
    '%s_905_%s_phase01_channel_qc.csv',cfg.subject,cfg.reference_tag));
segmentQCPath = fullfile(cfg.qc_dir,sprintf( ...
    '%s_905_%s_phase01_segment_qc.csv',cfg.subject,cfg.reference_tag));
logPath = fullfile(cfg.logs_dir,sprintf( ...
    '%s_905_%s_phase01_pass.txt',cfg.subject,cfg.reference_tag));
present = [exist(channelQCPath,'file') == 2, ...
    exist(segmentQCPath,'file') == 2,exist(logPath,'file') == 2];
if all(present)
    fprintf('905 Phase 1 already complete: %s\n',channelQCPath);
    return
end
assert(~any(present),'Partial Phase 1 output exists; inspect before rerunning.');

EEG = pop_loadset('filename',cfg.imported_set,'filepath',cfg.input_dir);
EEG = eeg_checkset(EEG);
assert(EEG.nbchan == cfg.expected_raw_channels);
labels = strtrim(string({EEG.chanlocs.labels}))';
assert(numel(unique(upper(labels))) == cfg.expected_raw_channels, ...
    'Raw channel labels must be unique case-insensitively.');
assert(all(isfinite(double(EEG.data(:)))));

fixedChannels = n400u_channel_indices(EEG,cfg.fixed_excluded_labels);
eogChannels = n400u_channel_indices(EEG,cfg.eog_labels);
triggerChannel = n400u_channel_indices(EEG,{cfg.trigger_label});
auxChannels = [eogChannels triggerChannel];
rawScalp = setdiff(1:EEG.nbchan,auxChannels,'stable');
retainedScalp = setdiff(rawScalp,fixedChannels,'stable');
assert(numel(rawScalp) == cfg.expected_raw_scalp_channels);
assert(numel(retainedScalp) == cfg.expected_analysis_scalp_channels);

xyz = [[EEG.chanlocs(retainedScalp).X]' ...
    [EEG.chanlocs(retainedScalp).Y]' ...
    [EEG.chanlocs(retainedScalp).Z]'];
assert(isequal(size(xyz),[numel(retainedScalp) 3]) && ...
    all(isfinite(xyz),'all'), ...
    'One or more retained scalp channels lack finite XYZ coordinates.');

eventCodes = arrayfun(@(x) n400u_event_code(x.type),EEG.event)';
targetCodes = eventCodes(ismember(eventCodes,[111:115 121:125]));
behavior = n400u_read_behavior(cfg);
assert(behavior.rows == cfg.expected_trials);
assert(numel(targetCodes) == cfg.expected_trials);
assert(isequal(targetCodes,behavior.expected_code), ...
    'Behavior and EEG target codes are not trialwise identical.');

data = double(EEG.data(retainedScalp,:));
channelMedian = median(data,2);
centeredData = data-channelMedian;
channelSD = std(data,0,2);
channelRange = max(data,[],2)-min(data,[],2);
channelCenteredMaxAbs = max(abs(centeredData),[],2);
flatFraction = mean(abs(diff(data,1,2)) < 1e-9,2);
logSD = log(max(channelSD,eps));
robustCenter = median(logSD);
robustScale = 1.4826*median(abs(logSD-robustCenter));
if robustScale == 0, robustScale = 1; end
robustLogSDZ = (logSD-robustCenter)/robustScale;
lineNoiseRatio = nan(numel(retainedScalp),1);
if exist('pwelch','file') == 2
    window = max(32,round(4*EEG.srate));
    overlap = round(window/2);
    nfft = max(window,2^nextpow2(window));
    for k = 1:numel(retainedScalp)
        [pxx,f] = pwelch(data(k,:),window,overlap,nfft,EEG.srate);
        signalMask = f >= 45 & f <= 55;
        neighborMask = (f >= 40 & f < 45) | (f > 55 & f <= 60);
        lineNoiseRatio(k) = mean(pxx(signalMask))/ ...
            max(mean(pxx(neighborMask)),eps);
    end
end
automaticCandidate = flatFraction >= 0.05 | ...
    abs(robustLogSDZ) >= 5 | lineNoiseRatio >= 10;
CHANNEL_QC = table(retainedScalp(:),labels(retainedScalp), ...
    channelSD,channelRange,channelCenteredMaxAbs,flatFraction, ...
    robustLogSDZ,lineNoiseRatio,automaticCandidate, ...
    'VariableNames',{'RawChannel','Label','SD_uV','Range_uV', ...
    'CenteredMaxAbs_uV','FlatFraction','RobustLogSDZ', ...
    'LineNoiseRatio50Hz','AutomaticBadChannelCandidate'});
writetable(CHANNEL_QC,channelQCPath);

window = max(2,round(cfg.continuous_qc_window_seconds*EEG.srate));
starts = 1:window:EEG.pnts;
nWindows = numel(starts);
startSeconds = zeros(nWindows,1);
endSeconds = zeros(nWindows,1);
segmentMaxAbs = zeros(nWindows,1);
segmentP2P = zeros(nWindows,1);
flatChannelCount = zeros(nWindows,1);
for w = 1:nWindows
    first = starts(w);
    last = min(EEG.pnts,first+window-1);
    segment = centeredData(:,first:last);
    localCentered = segment-median(segment,2);
    startSeconds(w) = (first-1)/EEG.srate;
    endSeconds(w) = (last-1)/EEG.srate;
    segmentMaxAbs(w) = max(abs(localCentered),[],'all');
    segmentP2P(w) = max(max(segment,[],2)-min(segment,[],2));
    if size(segment,2) > 1
        localFlat = mean(abs(diff(segment,1,2)) < 1e-9,2);
        flatChannelCount(w) = sum(localFlat >= ...
            cfg.continuous_segment_flat_fraction);
    end
end
segmentCandidate = segmentMaxAbs >= cfg.continuous_segment_absolute_uv | ...
    segmentP2P >= cfg.continuous_segment_p2p_uv | flatChannelCount > 0;
SEGMENT_QC = table((1:nWindows)',startSeconds,endSeconds, ...
    segmentMaxAbs,segmentP2P,flatChannelCount,segmentCandidate, ...
    'VariableNames',{'Window','StartSeconds','EndSeconds','MaxAbs_uV', ...
    'MaxChannelP2P_uV','FlatChannelCount','AutomaticSegmentCandidate'});
writetable(SEGMENT_QC,segmentQCPath);

candidateLabels = labels(retainedScalp(automaticCandidate));
n400u_write_stage_log(cfg,'phase01',{ ...
    sprintf('Input: %s',fullfile(cfg.input_dir,cfg.imported_set)), ...
    sprintf('Raw channels: %d',EEG.nbchan), ...
    sprintf('Fixed exclusions: %s',strjoin(string(cfg.fixed_excluded_labels),',')), ...
    sprintf('Retained scalp channels: %d',numel(retainedScalp)), ...
    sprintf('Target events: %d',numel(targetCodes)), ...
    sprintf('Behavior/EEG aligned: %d/%d',cfg.expected_trials,cfg.expected_trials), ...
    sprintf('Automatic bad-channel candidates: %s',strjoin(candidateLabels,',')), ...
    sprintf('Abnormal time-window candidates: %d/%d',sum(segmentCandidate),nWindows)});
fprintf(['905 Phase 1 PASS: raw=%d, retained scalp=%d, targets=%d, ' ...
    'behavior alignment=%d/%d.\n'],EEG.nbchan,numel(retainedScalp), ...
    numel(targetCodes),cfg.expected_trials,cfg.expected_trials);
