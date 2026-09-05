%% Supplemental (NOT part of the locked 905 six-stage output):
% Sentence-onset-locked epoch, -200 to 4000 ms, for whole-sentence viewing.
% Reuses the filtered/ICA-cleaned/interpolated/final-CAR continuous
% data produced by phase05_epoch_artifact.m; does not touch or duplicate the
% official target-word-locked -200/800 ms epoch or its outputs.

run(fullfile(fileparts(mfilename('fullpath')),'init_905_runtime.m'));

sentenceEpochMs = [-200 4000];
sentenceBaselineMs = [-200 0];

outDir = fullfile(cfg.result_root,'sentence_epochs');
if exist(outDir,'dir') ~= 7, mkdir(outDir); end
epochSetName = sprintf('%s_905_%s_sentence_epochs_baseline_pre200.set', ...
    cfg.subject,cfg.reference_tag);
epochPath = fullfile(outDir,epochSetName);
latencyCsvPath = fullfile(outDir,sprintf( ...
    '%s_905_%s_sentence_target_latency.csv',cfg.subject,cfg.reference_tag));
logPath = fullfile(outDir,sprintf( ...
    '%s_905_%s_sentence_epoch_log.txt',cfg.subject,cfg.reference_tag));

present = [exist(epochPath,'file') == 2,exist(latencyCsvPath,'file') == 2, ...
    exist(logPath,'file') == 2];
if all(present)
    fprintf('Sentence-onset epoch already complete: %s\n',epochPath);
    return
end
assert(~any(present), ...
    'Partial sentence-epoch output exists; inspect before rerunning.');

EEG = pop_loadset('filename',cfg.final_car_set,'filepath',cfg.continuous_dir);
EEG = eeg_checkset(EEG);

rawCodes = arrayfun(@(x) n400u_event_code(x.type),EEG.event);
lat = double([EEG.event.latency]);
startItems = find(ismember(rawCodes,[11:15 21:25]));
assert(numel(startItems) == cfg.expected_trials, ...
    'Expected %d sentence-start events, found %d.', ...
    cfg.expected_trials,numel(startItems));

targetLatencyMs = nan(cfg.expected_trials,1);
startCodeList = rawCodes(startItems);
for i = 1:cfg.expected_trials
    si = startItems(i);
    targetCode = rawCodes(si)+100;
    if i < cfg.expected_trials
        nextStartItem = startItems(i+1);
    else
        nextStartItem = numel(rawCodes)+1;
    end
    targetItems = find(rawCodes(si+1:nextStartItem-1) == targetCode);
    assert(isscalar(targetItems), ...
        'Expected one target inside sentence trial %d; found %d.', ...
        i,numel(targetItems));
    ti = si+targetItems;
    targetLatencyMs(i) = (lat(ti)-lat(si))/EEG.srate*1000;
end
assert(max(targetLatencyMs) <= sentenceEpochMs(2)-800, ...
    'Longest sentence leaves under 800 ms of post-target data in the window.');

behavior = n400u_read_behavior(cfg);
assert(behavior.rows == cfg.expected_trials);
condition = strings(cfg.expected_trials,1);
condition(startCodeList>=11 & startCodeList<=15) = "HC";
condition(startCodeList>=21 & startCodeList<=25) = "LC";
snrDigit = mod(startCodeList,10);
snrNames = ["-4","-2","4","6","quiet"];
snr = snrNames(snrDigit)';
assert(isequal(condition,behavior.condition), ...
    'Sentence-start condition order does not match behavior file order.');
assert(isequal(snr,behavior.snr), ...
    'Sentence-start SNR order does not match behavior file order.');

% Convert event types to plain numeric codes so pop_epoch matches reliably.
for k = 1:numel(EEG.event)
    EEG.event(k).type = rawCodes(k);
end
EEG = eeg_checkset(EEG,'eventconsistency');

SENT = pop_epoch(EEG,num2cell(unique(startCodeList)),sentenceEpochMs/1000, ...
    'newname',erase(epochSetName,'.set'),'epochinfo','yes');
SENT = eeg_checkset(SENT);
assert(SENT.trials == cfg.expected_trials, ...
    'Expected %d sentence epochs, got %d.',cfg.expected_trials,SENT.trials);
SENT = pop_rmbase(SENT,sentenceBaselineMs);
SENT = eeg_checkset(SENT);

n400u_assert_dataset_absent(epochPath);
SENT = pop_saveset(SENT,'filename',epochSetName,'filepath',outDir);
CHECK = pop_loadset('filename',epochSetName,'filepath',outDir);
assert(isequaln(CHECK.data,SENT.data));

LATENCY = table((1:cfg.expected_trials)',condition,snr,targetLatencyMs, ...
    'VariableNames',{'Trial','Condition','SNR','TargetLatency_ms'});
writetable(LATENCY,latencyCsvPath);

fid = fopen(logPath,'w');
fprintf(fid,'Sentence-onset epoch (supplemental; not part of the locked six-stage output)\n');
fprintf(fid,'Participant: %s\n',cfg.subject);
fprintf(fid,'Source: %s\n',fullfile(cfg.continuous_dir,cfg.final_car_set));
fprintf(fid,'Window: %d to %d ms; baseline %d to %d ms\n', ...
    sentenceEpochMs(1),sentenceEpochMs(2),sentenceBaselineMs(1),sentenceBaselineMs(2));
fprintf(fid,'Trials: %d\n',SENT.trials);
fprintf(fid,'Target latency range: %.0f to %.0f ms (relative to sentence onset)\n', ...
    min(targetLatencyMs),max(targetLatencyMs));
fprintf(fid,'Output: %s\n',epochPath);
fprintf(fid,'Latency table: %s\n',latencyCsvPath);
fclose(fid);

fprintf(['Sentence-onset epoch complete: %d trials, target latency %.0f-%.0f ms. ' ...
    'Saved %s.\n'],SENT.trials,min(targetLatencyMs),max(targetLatencyMs),epochPath);
