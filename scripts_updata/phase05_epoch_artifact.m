%% 828update Phase 5: interpolate, bin, baseline epoch, and artifact flags.
% First run creates the single baseline-corrected epoch file and stops.

run(fullfile(fileparts(mfilename('fullpath')),'init_828_runtime.m'));
interpolatedPath = fullfile(cfg.continuous_dir,cfg.interpolated_set);
binnedPath = fullfile(cfg.continuous_dir,cfg.binned_set);
epochPath = fullfile(cfg.epochs_dir,cfg.epochs_set);
flaggedPath = fullfile(cfg.epochs_dir,cfg.flagged_set);
artifactQCPath = fullfile(cfg.qc_dir,sprintf( ...
    '%s_828update_%s_phase05_epoch_qc.csv', ...
    cfg.subject,cfg.reference_tag));
decisionPath = fullfile(cfg.tables_dir,sprintf( ...
    '%s_828update_%s_artifact_decisions.csv', ...
    cfg.subject,cfg.reference_tag));
rawEL = fullfile(cfg.eventlists_dir,sprintf( ...
    '%s_828update_%s_eventlist_raw.txt',cfg.subject,cfg.reference_tag));
binnedEL = fullfile(cfg.eventlists_dir,sprintf( ...
    '%s_828update_%s_eventlist_binned.txt',cfg.subject,cfg.reference_tag));
logPath = fullfile(cfg.logs_dir,sprintf( ...
    '%s_828update_%s_phase05_pass.txt',cfg.subject,cfg.reference_tag));

finalPresent = [exist(flaggedPath,'file') == 2, ...
    exist(decisionPath,'file') == 2,exist(logPath,'file') == 2];
if all(finalPresent)
    fprintf('828update Phase 5 already complete: %s\n',flaggedPath);
    return
end
assert(~any(finalPresent), ...
    'Partial final Phase 5 output exists; inspect before rerunning.');

%% A. Create all pre-gate outputs as one protected checkpoint.
if exist(epochPath,'file') == 0
    n400u_assert_dataset_absent(interpolatedPath);
    n400u_assert_dataset_absent(binnedPath);
    n400u_assert_dataset_absent(epochPath);
    preGatePaths = {interpolatedPath,binnedPath,rawEL,binnedEL,artifactQCPath};
    assert(~any(cellfun(@(p) exist(p,'file') == 2,preGatePaths)), ...
        'Partial pre-gate Phase 5 output exists; inspect before rerunning.');
    EEG = pop_loadset('filename',cfg.icaclean_set,'filepath',cfg.ica_dir);
    EEG = eeg_checkset(EEG);
    dimensionsBefore = size(EEG.data);
    labelsBefore = {EEG.chanlocs.labels};
    eventsBefore = EEG.event;
    badChannels = unique(cfg.bad_channels(:)','stable');
    assert(isempty(intersect(badChannels, ...
        [cfg.m1_channel cfg.m2_channel cfg.aux_channels])));
    if ~isempty(badChannels)
        EEG = pop_interp(EEG,badChannels,'spherical');
    end
    assert(isequal(size(EEG.data),dimensionsBefore));
    assert(isequal({EEG.chanlocs.labels},labelsBefore));
    assert(isequaln(EEG.event,eventsBefore));
    assert(all(isfinite(double(EEG.data(:)))));
    if ~isempty(badChannels)
        assert(all(isfinite(double(EEG.data(badChannels,:))),'all'));
    end
    hadICA = ~isempty(EEG.icaweights);
    EEG.icaact = [];
    EEG.icaweights = [];
    EEG.icasphere = [];
    EEG.icawinv = [];
    EEG.icachansind = [];
    EEG.etc.update828_interpolation = struct( ...
        'channels',badChannels,'method','spherical', ...
        'after_ica_cleaning',true,'ica_fields_cleared',hadICA);
    EEG.setname = erase(cfg.interpolated_set,'.set');
    n400u_assert_dataset_absent(interpolatedPath);
    EEG = pop_saveset(EEG,'filename',cfg.interpolated_set, ...
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
    baseline = PRIMARY.times >= cfg.baseline_ms(1) & ...
        PRIMARY.times <= cfg.baseline_ms(2);
    assert(any(baseline));
    baselineMean = mean(double(PRIMARY.data(cfg.eeg_channels,baseline,:)),2);
    assert(max(abs(baselineMean),[],'all') < 1e-3, ...
        'The formal epochs are not correctly baseline corrected.');
    PRIMARY.setname = erase(cfg.epochs_set,'.set');
    PRIMARY.etc.update828_epoch = struct( ...
        'nominal_window_ms',cfg.epoch_ms, ...
        'stored_window_ms',[PRIMARY.times(1) PRIMARY.times(end)], ...
        'baseline_ms',cfg.baseline_ms);
    n400u_assert_dataset_absent(epochPath);
    PRIMARY = pop_saveset(PRIMARY,'filename',cfg.epochs_set, ...
        'filepath',cfg.epochs_dir);

    scalp = setdiff(cfg.eeg_channels,[cfg.m1_channel cfg.m2_channel]);
    epochMaxAbs = squeeze(max(abs(double(PRIMARY.data(scalp,:,:))),[],[1 2]));
    epochP2P = squeeze(max(max(double(PRIMARY.data(scalp,:,:)),[],2)- ...
        min(double(PRIMARY.data(scalp,:,:)),[],2),[],1));
    veogMaxAbs = squeeze(max(abs(double(PRIMARY.data(cfg.eog_channels(1),:,:))),[],2));
    heogMaxAbs = squeeze(max(abs(double(PRIMARY.data(cfg.eog_channels(2),:,:))),[],2));
    EPOCH_QC = table((1:cfg.expected_trials)',epochMaxAbs(:), ...
        epochP2P(:),veogMaxAbs(:),heogMaxAbs(:), ...
        'VariableNames',{'Epoch','ScalpMaxAbs_uV','ScalpMaxP2P_uV', ...
        'VEOGMaxAbs_uV','HEOGMaxAbs_uV'});
    writetable(EPOCH_QC,artifactQCPath);
    fprintf(['GUI GATE D: run review_phase05_artifact_gate.m, review all ' ...
        '300 pooled epochs without condition labels, enter the unified ' ...
        'cfg.artifact_bad_epochs list, set artifact_review_complete=true, ' ...
        'then rerun Phase 5.\n']);
    return
end

if exist(epochPath,'file') == 2
    preGatePaths = {interpolatedPath,binnedPath,rawEL,binnedEL,artifactQCPath};
    assert(all(cellfun(@(p) exist(p,'file') == 2,preGatePaths)), ...
        'Epoch checkpoint exists but another pre-gate output is missing.');
end

%% B. Apply only the reviewed unified bit-1 artifact list.
if ~cfg.artifact_review_complete
    fprintf(['GUI GATE D is incomplete. Enter cfg.artifact_bad_epochs and ' ...
        'set artifact_review_complete=true before rerunning.\n']);
    return
end
assert(exist(flaggedPath,'file') == 0 && exist(decisionPath,'file') == 0 && ...
    exist(logPath,'file') == 0, ...
    'Partial final Phase 5 output exists; inspect before rerunning.');
PRIMARY = pop_loadset('filename',cfg.epochs_set,'filepath',cfg.epochs_dir);
badEpochs = unique(cfg.artifact_bad_epochs(:)','stable');
assert(all(badEpochs == fix(badEpochs) & badEpochs >= 1 & ...
    badEpochs <= PRIMARY.trials));
PRIMARY = localApplyFlags(PRIMARY,badEpochs, ...
    cfg.m1_channel,cfg.artifact_flag_bit);
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
    sprintf('Interpolated channels: %s',mat2str(cfg.bad_channels)), ...
    sprintf('Bin counts: %s',mat2str(n400u_bin_counts(CHECK,cfg.expected_bins))), ...
    sprintf('Nominal epoch window ms: %s',mat2str(cfg.epoch_ms)), ...
    sprintf('Baseline ms: %s',mat2str(cfg.baseline_ms)), ...
    sprintf('Artifact epochs bit 1: %s',mat2str(badEpochs)), ...
    sprintf('Trials physically retained: %d',CHECK.trials), ...
    sprintf('Output: %s',flaggedPath)});
fprintf(['828update Phase 5 PASS: %d/%d epochs carry bit 1; ' ...
    'all trials retained; baseline=%s ms.\n'],numel(badEpochs), ...
    CHECK.trials,mat2str(cfg.baseline_ms));

function EEG = localApplyFlags(EEG,badEpochs,markerChannel,flagBit)
mask = false(1,EEG.trials);
mask(badEpochs) = true;
EEG.reject.rejmanual = mask;
EEG.reject.rejmanualE = false(EEG.nbchan,EEG.trials);
EEG.reject.rejmanualE(markerChannel,badEpochs) = true;
for ep = 1:EEG.trials
    [eventIndex,eventItem,oldFlag] = n400u_epoch_event_info(EEG,ep);
    flag = bitset(uint16(oldFlag),flagBit,mask(ep));
    EEG.epoch(ep).eventflag = double(flag);
    EEG.event(eventIndex).flag = double(flag);
    EEG.EVENTLIST.eventinfo(eventItem).flag = double(flag);
end
EEG.etc.update828_artifact_rejection = struct( ...
    'flag_bit',flagBit,'bad_epochs',badEpochs, ...
    'manual_condition_blind_review',true,'trials_retained',EEG.trials);
EEG = eeg_checkset(EEG);
end
