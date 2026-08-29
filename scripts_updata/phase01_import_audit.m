%% 828update Phase 1: imported-data, channel, event, and behavior audit.

run(fullfile(fileparts(mfilename('fullpath')),'init_828_runtime.m'));
channelQCPath = fullfile(cfg.qc_dir,sprintf( ...
    '%s_828update_%s_phase01_channel_qc.csv', ...
    cfg.subject,cfg.reference_tag));
segmentQCPath = fullfile(cfg.qc_dir,sprintf( ...
    '%s_828update_%s_phase01_segment_qc.csv', ...
    cfg.subject,cfg.reference_tag));
logPath = fullfile(cfg.logs_dir,sprintf( ...
    '%s_828update_%s_phase01_pass.txt',cfg.subject,cfg.reference_tag));
present = [exist(channelQCPath,'file') == 2, ...
    exist(segmentQCPath,'file') == 2,exist(logPath,'file') == 2];
if all(present)
    fprintf('828update Phase 1 already complete: %s\n',channelQCPath);
    return
end
assert(~any(present), ...
    'Partial Phase 1 output exists; inspect it before rerunning.');

EEG = pop_loadset('filename',cfg.imported_set,'filepath',cfg.input_dir);
EEG = eeg_checkset(EEG);
assert(EEG.nbchan == cfg.expected_channels);
labels = string({EEG.chanlocs.labels})';
assert(numel(unique(labels)) == cfg.expected_channels);
assert(all(isfinite(double(EEG.data(:)))));
assert(strcmpi(labels(cfg.m1_channel),'M1'));
assert(strcmpi(labels(cfg.m2_channel),'M2'));
assert(strcmpi(labels(cfg.eog_channels(1)),'VEOG'));
assert(strcmpi(labels(cfg.eog_channels(2)),'HEOG'));
assert(strcmpi(labels(cfg.trigger_channel),'TRIGGER'));
xyz = [[EEG.chanlocs(cfg.eeg_channels).X]' ...
    [EEG.chanlocs(cfg.eeg_channels).Y]' ...
    [EEG.chanlocs(cfg.eeg_channels).Z]'];
assert(all(isfinite(xyz),'all'), ...
    'One or more EEG channels lack finite XYZ coordinates.');

eventCodes = arrayfun(@(x) n400u_event_code(x.type),EEG.event)';
targetCodes = eventCodes(ismember(eventCodes,[111:115 121:125]));
behavior = n400u_read_behavior(cfg);
assert(behavior.rows == cfg.expected_trials);
assert(numel(targetCodes) == cfg.expected_trials);
assert(isequal(targetCodes,behavior.expected_code), ...
    'Behavior and EEG target codes are not trialwise identical.');

data = double(EEG.data(cfg.eeg_channels,:));
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
lineNoiseRatio = nan(numel(cfg.eeg_channels),1);
if exist('pwelch','file') == 2
    window = max(32,round(4*EEG.srate));
    overlap = round(window/2);
    nfft = max(window,2^nextpow2(window));
    for k = 1:numel(cfg.eeg_channels)
        [pxx,f] = pwelch(data(k,:),window,overlap,nfft,EEG.srate);
        signalMask = f >= 45 & f <= 55;
        neighborMask = (f >= 40 & f < 45) | (f > 55 & f <= 60);
        lineNoiseRatio(k) = mean(pxx(signalMask))/ ...
            max(mean(pxx(neighborMask)),eps);
    end
end
automaticCandidate = flatFraction >= 0.05 | ...
    abs(robustLogSDZ) >= 5 | lineNoiseRatio >= 10;
CHANNEL_QC = table(cfg.eeg_channels(:),labels(cfg.eeg_channels), ...
    channelSD,channelRange,channelCenteredMaxAbs,flatFraction, ...
    robustLogSDZ,lineNoiseRatio,automaticCandidate, ...
    'VariableNames',{'Channel','Label','SD_uV','Range_uV', ...
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

n400u_write_stage_log(cfg,'phase01',{ ...
    sprintf('Input: %s',fullfile(cfg.input_dir,cfg.imported_set)), ...
    sprintf('Channels: %d',EEG.nbchan), ...
    sprintf('Events: %d',numel(EEG.event)), ...
    sprintf('Target events: %d',numel(targetCodes)), ...
    sprintf('Behavior/EEG aligned: %d/%d',cfg.expected_trials,cfg.expected_trials), ...
    sprintf('Automatic bad-channel candidates: %s', ...
        mat2str(cfg.eeg_channels(automaticCandidate))), ...
    sprintf('Abnormal time-window candidates: %d/%d', ...
        sum(segmentCandidate),nWindows)});
fprintf(['828update Phase 1 PASS: channels=%d, targets=%d, ' ...
    'behavior alignment=%d/%d.\n'],EEG.nbchan,numel(targetCodes), ...
    cfg.expected_trials,cfg.expected_trials);
