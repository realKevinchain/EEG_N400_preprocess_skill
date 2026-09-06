%% 905 Phase 5: interpolate, final CAR, bin, baseline epoch, and bit 1.
% First run creates the protected formal epoch file and stops at Gate D.

run(fullfile(fileparts(mfilename('fullpath')),'init_905_runtime.m'));
finalCarPath = fullfile(cfg.continuous_dir,cfg.final_car_set);
binnedPath = fullfile(cfg.continuous_dir,cfg.binned_set);
epochPath = fullfile(cfg.epochs_dir,cfg.epochs_set);
flaggedPath = fullfile(cfg.epochs_dir,cfg.flagged_set);
artifactQCPath = fullfile(cfg.qc_dir,sprintf( ...
    '%s_905_%s_phase05_epoch_qc.csv',cfg.subject,cfg.reference_tag));
decisionPath = fullfile(cfg.tables_dir,sprintf( ...
    '%s_905_%s_artifact_decisions.csv',cfg.subject,cfg.reference_tag));
rawEL = fullfile(cfg.eventlists_dir,sprintf( ...
    '%s_905_%s_eventlist_raw.txt',cfg.subject,cfg.reference_tag));
binnedEL = fullfile(cfg.eventlists_dir,sprintf( ...
    '%s_905_%s_eventlist_binned.txt',cfg.subject,cfg.reference_tag));
logPath = fullfile(cfg.logs_dir,sprintf( ...
    '%s_905_%s_phase05_pass.txt',cfg.subject,cfg.reference_tag));

finalPresent = [exist(flaggedPath,'file') == 2, ...
    exist(decisionPath,'file') == 2,exist(logPath,'file') == 2];
if all(finalPresent)
    fprintf('905 Phase 5 already complete: %s\n',flaggedPath);
    return
end
assert(~any(finalPresent), ...
    'Partial final Phase 5 output exists; inspect before rerunning.');

%% A. Interpolate ordinary bad channels and run the final CAR for everyone.
if exist(epochPath,'file') == 0
    n400u_assert_dataset_absent(finalCarPath);
    n400u_assert_dataset_absent(binnedPath);
    n400u_assert_dataset_absent(epochPath);
    preGatePaths = {finalCarPath,binnedPath,rawEL,binnedEL,artifactQCPath};
    assert(~any(cellfun(@(p) exist(p,'file') == 2,preGatePaths)), ...
        'Partial pre-gate Phase 5 output exists; inspect before rerunning.');

    EEG = pop_loadset('filename',cfg.icaclean_set,'filepath',cfg.ica_dir);
    EEG = eeg_checkset(EEG);
    assert(EEG.nbchan == cfg.expected_analysis_channels);
    labelsBefore = {EEG.chanlocs.labels};
    assert(isempty(intersect(upper(string(labelsBefore)), ...
        upper(string(cfg.fixed_excluded_labels)))));
    dimensionsBefore = size(EEG.data);
    eventsBefore = EEG.event;
    eogChannels = n400u_channel_indices(EEG,cfg.eog_labels);
    triggerChannel = n400u_channel_indices(EEG,{cfg.trigger_label});
    auxChannels = [eogChannels triggerChannel];
    scalpChannels = setdiff(1:EEG.nbchan,auxChannels,'stable');
    badChannels = n400u_channel_indices(EEG,cfg.bad_channel_labels);
    assert(all(ismember(badChannels,scalpChannels)));
    auxBefore = EEG.data(auxChannels,:);

    if ~isempty(badChannels)
        EEG = pop_interp(EEG,badChannels,'spherical');
    end
    assert(isequal(size(EEG.data),dimensionsBefore));
    assert(isequal({EEG.chanlocs.labels},labelsBefore));
    assert(isequaln(EEG.event,eventsBefore));
    assert(all(isfinite(double(EEG.data(:)))));

    hadICA = ~isempty(EEG.icaweights);
    EEG.icaact = [];
    EEG.icaweights = [];
    EEG.icasphere = [];
    EEG.icawinv = [];
    EEG.icachansind = [];
    EEG.etc.n400_905_interpolation = struct( ...
        'channel_labels',{cellstr(string(cfg.bad_channel_labels))}, ...
        'method','spherical','after_ica_cleaning',true, ...
        'ica_fields_cleared',hadICA, ...
        'fixed_exclusions_never_interpolated', ...
        {cellstr(string(cfg.fixed_excluded_labels))});

    % Mandatory for every participant. With no interpolated channels this is
    % mathematically redundant but enforces one identical final montage.
    eogChannels = n400u_channel_indices(EEG,cfg.eog_labels);
    triggerChannel = n400u_channel_indices(EEG,{cfg.trigger_label});
    auxChannels = [eogChannels triggerChannel];
    scalpChannels = setdiff(1:EEG.nbchan,auxChannels,'stable');
    assert(numel(scalpChannels) == cfg.expected_analysis_scalp_channels);
    EEG = pop_reref(EEG,[],'exclude',auxChannels,'refica','remove');
    EEG = eeg_checkset(EEG);
    assert(max(abs(double(EEG.data(auxChannels,:))-double(auxBefore)), ...
        [],'all') == 0,'Auxiliary channels changed during final CAR.');
    finalResidual = mean(double(EEG.data(scalpChannels,:)),1);
    % Final CAR is stored in single precision; retain a strict sub-0.005-uV
    % tolerance for the pointwise scalp mean.
    carResidualTolerance = 5e-3;
    assert(max(abs(finalResidual),[],'all') < carResidualTolerance, ...
        'Final 60-scalp-channel CAR residual exceeds tolerance.');
    EEG.etc.n400_905_final_reference = struct( ...
        'mode','common_average_all_retained_scalp', ...
        'applied_to_every_participant',true, ...
        'scalp_channel_count',numel(scalpChannels), ...
        'scalp_channel_labels',{cellstr(string({EEG.chanlocs(scalpChannels).labels}))}, ...
        'auxiliary_excluded',{cellstr([string(cfg.eog_labels) string(cfg.trigger_label)])}, ...
        'maximum_residual_uv',max(abs(finalResidual),[],'all'));
    EEG.setname = erase(cfg.final_car_set,'.set');
    n400u_assert_dataset_absent(finalCarPath);
    EEG = pop_saveset(EEG,'filename',cfg.final_car_set, ...
        'filepath',cfg.continuous_dir);

    EEG = pop_creabasiceventlist(EEG,'Eventlist',rawEL, ...
        'BoundaryNumeric',{-99},'BoundaryString',{'boundary'}, ...
        'AlphanumericCleaning','off','Warning','off');
    EEG = pop_binlister(EEG,'BDF',cfg.bdf,'ExportEL',binnedEL, ...
        'Resetflag','on','SendEL2','EEG&Text','UpdateEEG','on', ...
        'Warning','off');
    EEG = eeg_checkset(EEG,'makeur');
    counts = n400u_bin_counts(EEG,cfg.expected_bins);
    assert(isequal(counts,repmat(cfg.expected_trials_per_bin, ...
        1,cfg.expected_bins)));
    for k = 1:numel(EEG.EVENTLIST.eventinfo)
        code = double(EEG.EVENTLIST.eventinfo(k).code);
        if ismember(code,[98 99])
            bins = EEG.EVENTLIST.eventinfo(k).bini;
            if iscell(bins), bins = cell2mat(bins); end
            assert(~any(ismember(bins,1:cfg.expected_bins)), ...
                'Event code 98/99 entered a target bin.');
        end
    end
    EEG.setname = erase(cfg.binned_set,'.set');
    n400u_assert_dataset_absent(binnedPath);
    EEG = pop_saveset(EEG,'filename',cfg.binned_set, ...
        'filepath',cfg.continuous_dir);

    PRIMARY = pop_epochbin(EEG,cfg.epoch_ms,cfg.baseline_ms);
    PRIMARY = eeg_checkset(PRIMARY);
    assert(PRIMARY.trials == cfg.expected_trials);
    assert(abs(PRIMARY.times(1)-cfg.epoch_ms(1)) < 1e-6);
    assert(PRIMARY.times(end) <= cfg.epoch_ms(2) && ...
        PRIMARY.times(end) >= cfg.epoch_ms(2)-1000/cfg.analysis_rate-1e-6);
    eogChannels = n400u_channel_indices(PRIMARY,cfg.eog_labels);
    triggerChannel = n400u_channel_indices(PRIMARY,{cfg.trigger_label});
    scalpChannels = setdiff(1:PRIMARY.nbchan, ...
        [eogChannels triggerChannel],'stable');
    baseline = PRIMARY.times >= cfg.baseline_ms(1) & ...
        PRIMARY.times <= cfg.baseline_ms(2);
    assert(any(baseline));
    baselineMean = mean(double(PRIMARY.data(scalpChannels,baseline,:)),2);
    assert(max(abs(baselineMean),[],'all') < 1e-3, ...
        'The formal epochs are not correctly baseline corrected.');
    PRIMARY.setname = erase(cfg.epochs_set,'.set');
    PRIMARY.etc.n400_905_epoch = struct( ...
        'nominal_window_ms',cfg.epoch_ms, ...
        'stored_window_ms',[PRIMARY.times(1) PRIMARY.times(end)], ...
        'baseline_ms',cfg.baseline_ms,'source',cfg.final_car_set);
    n400u_assert_dataset_absent(epochPath);
    PRIMARY = pop_saveset(PRIMARY,'filename',cfg.epochs_set, ...
        'filepath',cfg.epochs_dir);

    epochMaxAbs = squeeze(max(abs(double( ...
        PRIMARY.data(scalpChannels,:,:))),[],[1 2]));
    epochP2P = squeeze(max(max(double(PRIMARY.data(scalpChannels,:,:)),[],2)- ...
        min(double(PRIMARY.data(scalpChannels,:,:)),[],2),[],1));
    veogMaxAbs = squeeze(max(abs(double( ...
        PRIMARY.data(eogChannels(1),:,:))),[],2));
    heogMaxAbs = squeeze(max(abs(double( ...
        PRIMARY.data(eogChannels(2),:,:))),[],2));
    EPOCH_QC = table((1:cfg.expected_trials)',epochMaxAbs(:), ...
        epochP2P(:),veogMaxAbs(:),heogMaxAbs(:), ...
        'VariableNames',{'Epoch','ScalpMaxAbs_uV','ScalpMaxP2P_uV', ...
        'VEOGMaxAbs_uV','HEOGMaxAbs_uV'});
    writetable(EPOCH_QC,artifactQCPath);
    fprintf(['GUI GATE D: inspect all 300 pooled baseline-corrected epochs. ' ...
        'Simple Voltage Threshold is a candidate screen only. Manually ' ...
        'add/remove marks, click UPDATE MARKS, never REJECT/delete, and ' ...
        'save the review copy as new.set in the epochs directory. Audit ' ...
        'all reject fields, enter one reconciled cfg.artifact_bad_epochs ' ...
        'list, set artifact_review_complete=true, then rerun Phase 5.\n']);
    return
end

if exist(epochPath,'file') == 2
    preGatePaths = {finalCarPath,binnedPath,rawEL,binnedEL,artifactQCPath};
    assert(all(cellfun(@(p) exist(p,'file') == 2,preGatePaths)), ...
        'Epoch checkpoint exists but another pre-gate output is missing.');
end

%% B. Apply only the user-reviewed, reconciled bit-1 artifact list.
if ~cfg.artifact_review_complete
    fprintf(['GUI GATE D is incomplete. Audit new.set, enter ' ...
        'cfg.artifact_bad_epochs, and set artifact_review_complete=true.\n']);
    return
end
assert(exist(flaggedPath,'file') == 0 && exist(decisionPath,'file') == 0 && ...
    exist(logPath,'file') == 0, ...
    'Partial final Phase 5 output exists; inspect before rerunning.');
PRIMARY = pop_loadset('filename',cfg.epochs_set,'filepath',cfg.epochs_dir);
badEpochs = unique(cfg.artifact_bad_epochs(:)','stable');
assert(all(badEpochs == fix(badEpochs) & badEpochs >= 1 & ...
    badEpochs <= PRIMARY.trials));
eogChannels = n400u_channel_indices(PRIMARY,cfg.eog_labels);
triggerChannel = n400u_channel_indices(PRIMARY,{cfg.trigger_label});
scalpChannels = setdiff(1:PRIMARY.nbchan, ...
    [eogChannels triggerChannel],'stable');
PRIMARY = localApplyFlags(PRIMARY,badEpochs, ...
    scalpChannels,cfg.artifact_flag_bit);
PRIMARY.setname = erase(cfg.flagged_set,'.set');
n400u_assert_dataset_absent(flaggedPath);
PRIMARY = pop_saveset(PRIMARY,'filename',cfg.flagged_set, ...
    'filepath',cfg.epochs_dir);

isBad = false(cfg.expected_trials,1);
isBad(badEpochs) = true;
DECISIONS = table((1:cfg.expected_trials)',isBad, ...
    'VariableNames',{'Epoch','ArtifactFlagBit1'});
writetable(DECISIONS,decisionPath);
CHECK = pop_loadset('filename',cfg.flagged_set,'filepath',cfg.epochs_dir);
assert(CHECK.trials == cfg.expected_trials);
for ep = 1:CHECK.trials
    [eventIndex,eventItem,flag] = n400u_epoch_event_info(CHECK,ep);
    expected = isBad(ep);
    assert(logical(bitget(uint16(flag),cfg.artifact_flag_bit)) == expected);
    assert(uint16(CHECK.event(eventIndex).flag) == uint16(flag));
    assert(uint16(CHECK.EVENTLIST.eventinfo(eventItem).flag) == uint16(flag));
end
n400u_write_stage_log(cfg,'phase05',{ ...
    sprintf('Interpolated ordinary bad channels: %s', ...
        strjoin(string(cfg.bad_channel_labels),',')), ...
    'Final 60-scalp-channel CAR applied: 1', ...
    sprintf('Bin counts: %s',mat2str(n400u_bin_counts(CHECK,cfg.expected_bins))), ...
    sprintf('Nominal epoch window ms: %s',mat2str(cfg.epoch_ms)), ...
    sprintf('Baseline ms: %s',mat2str(cfg.baseline_ms)), ...
    sprintf('Artifact epochs bit 1: %s',mat2str(badEpochs)), ...
    sprintf('Trials physically retained: %d',CHECK.trials), ...
    sprintf('Output: %s',flaggedPath)});
fprintf(['905 Phase 5 PASS: final CAR applied; %d/%d epochs carry bit 1; ' ...
    'all trials retained.\n'],numel(badEpochs),CHECK.trials);

function EEG = localApplyFlags(EEG,badEpochs,scalpChannels,flagBit)
mask = false(1,EEG.trials);
mask(badEpochs) = true;
EEG.reject.rejmanual = mask;
EEG.reject.rejmanualE = false(EEG.nbchan,EEG.trials);
EEG.reject.rejmanualE(scalpChannels,badEpochs) = true;
for ep = 1:EEG.trials
    [eventIndex,eventItem,oldFlag] = n400u_epoch_event_info(EEG,ep);
    flag = bitset(uint16(oldFlag),flagBit,mask(ep));
    EEG.epoch(ep).eventflag = double(flag);
    EEG.event(eventIndex).flag = double(flag);
    EEG.EVENTLIST.eventinfo(eventItem).flag = double(flag);
end
EEG.etc.n400_905_artifact_rejection = struct( ...
    'flag_bit',flagBit,'bad_epochs',badEpochs, ...
    'manual_condition_blind_review',true,'trials_retained',EEG.trials);
EEG = eeg_checkset(EEG);
end
