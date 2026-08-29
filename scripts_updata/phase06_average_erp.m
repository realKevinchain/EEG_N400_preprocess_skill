%% 828update Phase 6: behavior ledger, two ERPs, reload QC, and plots.

run(fullfile(fileparts(mfilename('fullpath')),'init_828_runtime.m'));
ledgerPath = fullfile(cfg.tables_dir,cfg.ledger_csv);
binSummaryPath = fullfile(cfg.tables_dir,cfg.bin_summary_csv);
primaryERPPath = fullfile(cfg.erp_dir,cfg.primary_erp);
allcleanERPPath = fullfile(cfg.erp_dir,cfg.allclean_erp);
logPath = fullfile(cfg.logs_dir,sprintf( ...
    '%s_828update_%s_phase06_pass.txt',cfg.subject,cfg.reference_tag));
primaryPNG = fullfile(cfg.erp_dir,sprintf( ...
    '%s_828update_%s_erp_primary_correct_clean_cz_roi.png', ...
    cfg.subject,cfg.reference_tag));
primaryFIG = replace(primaryPNG,'.png','.fig');
allcleanPNG = fullfile(cfg.erp_dir,sprintf( ...
    '%s_828update_%s_erp_all_clean_cz_roi.png', ...
    cfg.subject,cfg.reference_tag));
allcleanFIG = replace(allcleanPNG,'.png','.fig');
outputs = {ledgerPath,binSummaryPath,primaryERPPath,allcleanERPPath, ...
    primaryPNG,primaryFIG,allcleanPNG,allcleanFIG,logPath};
present = cellfun(@(p) exist(p,'file') == 2,outputs);
if all(present)
    fprintf('828update Phase 6 already complete: %s\n',logPath);
    return
end
assert(~any(present),'Partial Phase 6 output exists; inspect before rerunning.');

EEG = pop_loadset('filename',cfg.flagged_set,'filepath',cfg.epochs_dir);
assert(EEG.trials == cfg.expected_trials);
behavior = n400u_read_behavior(cfg);
assert(behavior.rows == cfg.expected_trials);
assert(numel(behavior.correct) == cfg.expected_trials);
assert(all(ismember(behavior.correct,[0 1])));

eegCode = nan(cfg.expected_trials,1);
eegBin = nan(cfg.expected_trials,1);
flags = zeros(cfg.expected_trials,1,'uint16');
for ep = 1:EEG.trials
    [~,item,flag] = n400u_epoch_event_info(EEG,ep);
    info = EEG.EVENTLIST.eventinfo(item);
    eegCode(ep) = double(info.code);
    bins = info.bini;
    if iscell(bins), bins = cell2mat(bins); end
    bins = bins(bins >= 1 & bins <= cfg.expected_bins);
    assert(isscalar(bins));
    eegBin(ep) = bins;
    flags(ep) = uint16(flag);
    assert(flags(ep) == uint16(info.flag));
    assert(bitget(flags(ep),cfg.behavior_flag_bit) == 0, ...
        'Behavior bit 2 was already set before Phase 6.');
end
assert(isequal(eegCode,behavior.expected_code));
assert(isequal(eegBin,behavior.expected_bin));
artifact = logical(bitget(flags,cfg.artifact_flag_bit));
incorrect = behavior.correct == 0;
eegClean = ~artifact;
primaryGood = eegClean & ~incorrect;

LEDGER = table(repmat(string(cfg.subject),cfg.expected_trials,1), ...
    (1:cfg.expected_trials)',behavior.condition,behavior.snr, ...
    behavior.correct,behavior.expected_code,eegCode,eegBin,artifact, ...
    incorrect,eegClean,primaryGood, ...
    'VariableNames',{'Participant','EEGEpoch','Condition','SNR','Correct', ...
    'ExpectedTargetCode','EEGTargetCode','Bin','ArtifactFlagBit1', ...
    'BehaviorErrorBit2','EEGClean','PrimaryCorrectClean'});
writetable(LEDGER,ledgerPath);

BIN = table((1:cfg.expected_bins)',zeros(cfg.expected_bins,1), ...
    zeros(cfg.expected_bins,1),zeros(cfg.expected_bins,1), ...
    zeros(cfg.expected_bins,1),zeros(cfg.expected_bins,1), ...
    'VariableNames',{'Bin','Original','EEGArtifact','BehaviorError', ...
    'AllCleanAccepted','PrimaryAccepted'});
for b = 1:cfg.expected_bins
    inBin = eegBin == b;
    BIN.Original(b) = sum(inBin);
    BIN.EEGArtifact(b) = sum(inBin & artifact);
    BIN.BehaviorError(b) = sum(inBin & incorrect);
    BIN.AllCleanAccepted(b) = sum(inBin & eegClean);
    BIN.PrimaryAccepted(b) = sum(inBin & primaryGood);
end
assert(all(BIN.Original == cfg.expected_trials_per_bin));
writetable(BIN,binSummaryPath);

PRIMARY = EEG;
PRIMARY.reject.rejbehavior = incorrect';
PRIMARY.reject.rejbehaviorE = false(PRIMARY.nbchan,PRIMARY.trials);
for ep = 1:PRIMARY.trials
    [eventIndex,eventItem,oldFlag] = n400u_epoch_event_info(PRIMARY,ep);
    flag = bitset(uint16(oldFlag),cfg.behavior_flag_bit,incorrect(ep));
    PRIMARY.epoch(ep).eventflag = double(flag);
    PRIMARY.event(eventIndex).flag = double(flag);
    PRIMARY.EVENTLIST.eventinfo(eventItem).flag = double(flag);
    assert(logical(bitget(flag,cfg.behavior_flag_bit)) == incorrect(ep));
end
PRIMARY.reject.rejmanual = (artifact | incorrect)';

ERP_PRIMARY = pop_averager(PRIMARY,'Criterion','good', ...
    'ExcludeBoundary','on','SEM','on','Warning','off','DQ_flag',1);
ERP_ALLCLEAN = pop_averager(EEG,'Criterion','good', ...
    'ExcludeBoundary','on','SEM','on','Warning','off','DQ_flag',1);
ERP_PRIMARY.erpname = sprintf('%s_828update_primary_correct_clean',cfg.subject);
ERP_ALLCLEAN.erpname = sprintf('%s_828update_all_clean',cfg.subject);
ERP_PRIMARY.subject = cfg.subject;
ERP_ALLCLEAN.subject = cfg.subject;
[ERP_PRIMARY,statusPrimary] = pop_savemyerp(ERP_PRIMARY, ...
    'erpname',ERP_PRIMARY.erpname,'filename',cfg.primary_erp, ...
    'filepath',cfg.erp_dir,'gui','none','Warning','off');
[ERP_ALLCLEAN,statusAllclean] = pop_savemyerp(ERP_ALLCLEAN, ...
    'erpname',ERP_ALLCLEAN.erpname,'filename',cfg.allclean_erp, ...
    'filepath',cfg.erp_dir,'gui','none','Warning','off');
assert(statusPrimary == 2 && statusAllclean == 2);

PRIMARY_CHECK = pop_loaderp('filename',cfg.primary_erp, ...
    'filepath',cfg.erp_dir,'UpdateMainGui','off','History','off');
ALLCLEAN_CHECK = pop_loaderp('filename',cfg.allclean_erp, ...
    'filepath',cfg.erp_dir,'UpdateMainGui','off','History','off');
assert(isequaln(PRIMARY_CHECK.bindata,ERP_PRIMARY.bindata));
assert(isequaln(ALLCLEAN_CHECK.bindata,ERP_ALLCLEAN.bindata));
assert(isequaln(PRIMARY_CHECK.binerror,ERP_PRIMARY.binerror));
assert(isequaln(ALLCLEAN_CHECK.binerror,ERP_ALLCLEAN.binerror));
assert(isequaln(PRIMARY_CHECK.dataquality,ERP_PRIMARY.dataquality));
assert(isequaln(ALLCLEAN_CHECK.dataquality,ERP_ALLCLEAN.dataquality));
assert(isequaln(PRIMARY_CHECK.times,ERP_PRIMARY.times));
assert(isequaln(ALLCLEAN_CHECK.times,ERP_ALLCLEAN.times));
assert(sum(PRIMARY_CHECK.ntrials.accepted) == sum(primaryGood));
assert(sum(ALLCLEAN_CHECK.ntrials.accepted) == sum(eegClean));
assert(isequal(PRIMARY_CHECK.ntrials.accepted(:),BIN.PrimaryAccepted));
assert(isequal(ALLCLEAN_CHECK.ntrials.accepted(:),BIN.AllCleanAccepted));

plot_828_erp_qc(cfg,PRIMARY_CHECK,ALLCLEAN_CHECK);
n400u_write_stage_log(cfg,'phase06',{ ...
    sprintf('Primary accepted per bin: %s', ...
        mat2str(PRIMARY_CHECK.ntrials.accepted)), ...
    sprintf('All-clean accepted per bin: %s', ...
        mat2str(ALLCLEAN_CHECK.ntrials.accepted)), ...
    sprintf('Behavior errors: %d',sum(incorrect)), ...
    sprintf('EEG artifact epochs: %d',sum(artifact)), ...
    'ERP save/reload differences: 0', ...
    sprintf('Primary ERP: %s',primaryERPPath), ...
    sprintf('All-clean ERP: %s',allcleanERPPath)});
fprintf('828update Phase 6 PASS: primary accepted per bin = ');
fprintf('%d ',PRIMARY_CHECK.ntrials.accepted);
fprintf('\nAll-clean accepted per bin = ');
fprintf('%d ',ALLCLEAN_CHECK.ntrials.accepted);
fprintf('\nERP save/reload differences: 0.\n');
