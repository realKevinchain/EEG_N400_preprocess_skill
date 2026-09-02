%% Supplemental (NOT part of the locked 828update six-stage output):
% Word-onset-aligned DISPLAY built from the sentence-onset-locked epoch
% (phaseS1_sentence_epoch.m). The underlying data and baseline are left
% exactly as phaseS1 produced them (baseline-corrected to -200:0 ms relative
% to SENTENCE ONSET, not to the target word) -- alignment only shifts each
% trial's TIME AXIS by its own target-word latency for plotting, it does not
% recompute any baseline. The displayed window is a FIXED constant
% (WORD_ALIGNED_DISPLAY_MS below), the same for every participant, so ERPs
% are comparable across subjects. The target word sits close to the end of
% each sentence (little audio follows it), so the window is asymmetric:
% long on the pre-target side (-2300 ms, chosen from 01A's target-latency
% distribution so ~95% of trials show the full sentence lead-in; the
% longest-latency trials taper off with missing data at that far edge) and
% short on the post-target side (+800 ms, matching the official N400
% window; every trial has data there since even the latest-target trial
% still has >1200 ms of sentence-epoch room left). Time points are averaged
% over whatever trials have data there via omitnan. Reuses the
% same artifact (bit 1) and behavior (bit 2) decisions already recorded in
% the official trial ledger from phase06_average_erp.m, so the
% accepted/rejected trial set is identical to the official ERPs. Every
% trial's inclusion/exclusion is written to a CSV for the record.

run(fullfile(fileparts(mfilename('fullpath')),'init_828_runtime.m'));

% Fixed across all participants -- do not recompute per subject.
WORD_ALIGNED_DISPLAY_MS = [-2300 800];
PLOT_Y_LIMITS_UV = [-20 20];

sentDir = fullfile(cfg.result_root,'sentence_epochs');
epochSetName = sprintf('%s_828update_%s_sentence_epochs_baseline_pre200.set', ...
    cfg.subject,cfg.reference_tag);
latencyCsvPath = fullfile(sentDir,sprintf( ...
    '%s_828update_%s_sentence_target_latency.csv',cfg.subject,cfg.reference_tag));
ledgerPath = fullfile(cfg.tables_dir,cfg.ledger_csv);

rejectionCsvPath = fullfile(sentDir,sprintf( ...
    '%s_828update_%s_sentence_word_aligned_trial_log.csv',cfg.subject,cfg.reference_tag));
binSummaryPath = fullfile(sentDir,sprintf( ...
    '%s_828update_%s_sentence_word_aligned_bin_summary.csv',cfg.subject,cfg.reference_tag));
logPath = fullfile(sentDir,sprintf( ...
    '%s_828update_%s_sentence_word_aligned_log.txt',cfg.subject,cfg.reference_tag));
plotsRoot = fullfile(sentDir,'word_aligned_plots');
snrOrder = ["-4","-2","4","6","quiet"];
snrFileTag = ["-4dB","-2dB","4dB","6dB","quiet"];
siteFolders = ["cz","roi"];
modeFolders = ["all_clean","primary_correct_clean"];
plotPaths = strings(numel(modeFolders)*numel(siteFolders)* ...
    numel(snrOrder)*2,1);
plotIndex = 0;
for m = 1:numel(modeFolders)
    for si = 1:numel(siteFolders)
        for s = 1:numel(snrOrder)
            plotIndex = plotIndex+1;
            plotPaths(plotIndex) = fullfile(plotsRoot,modeFolders(m), ...
                siteFolders(si),sprintf('%s.png',snrFileTag(s)));
            plotIndex = plotIndex+1;
            plotPaths(plotIndex) = fullfile(plotsRoot,modeFolders(m), ...
                siteFolders(si),sprintf('%s.fig',snrFileTag(s)));
        end
    end
end
assert(plotIndex == numel(plotPaths));

outputs = [{rejectionCsvPath,binSummaryPath,logPath}, cellstr(plotPaths)'];
present = cellfun(@(p) exist(p,'file') == 2,outputs);
if all(present)
    fprintf('Sentence word-aligned ERP already complete: %s\n',logPath);
    return
end
assert(~any(present), ...
    'Partial sentence word-aligned output exists; inspect before rerunning.');
assert(exist(fullfile(sentDir,epochSetName),'file') == 2, ...
    'Run phaseS1_sentence_epoch.m first.');
assert(exist(ledgerPath,'file') == 2, ...
    'Run phase06_average_erp.m first (trial ledger required).');

SENT = pop_loadset('filename',epochSetName,'filepath',sentDir);
latencyOpts = detectImportOptions(latencyCsvPath);
latencyOpts = setvartype(latencyOpts,{'Condition','SNR'},'string');
LATENCY = readtable(latencyCsvPath,latencyOpts);
LEDGER = readtable(ledgerPath);
assert(height(LATENCY) == cfg.expected_trials);
assert(height(LEDGER) == cfg.expected_trials);
assert(isequal(LATENCY.Trial,LEDGER.EEGEpoch), ...
    'Sentence-epoch trial numbering does not match the official trial ledger.');

srate = SENT.srate;
[~,zeroSampleIdx] = min(abs(SENT.times));
targetSampleAll = zeroSampleIdx+round(LATENCY.TargetLatency_ms/1000*srate);

winSamp = round(WORD_ALIGNED_DISPLAY_MS/1000*srate);
nSamp = winSamp(2)-winSamp(1)+1;
relTimes = (winSamp(1):winSamp(2))'/srate*1000;

% No re-baselining here: SENT.data already carries phaseS1's -200:0 ms
% (relative to SENTENCE ONSET) baseline correction. Shifting the time axis
% for display does not change that baseline choice.
nCh = SENT.nbchan;
wordAligned = nan(nCh,nSamp,cfg.expected_trials);
for tr = 1:cfg.expected_trials
    targetSample = targetSampleAll(tr);
    s0 = targetSample+winSamp(1);
    s1 = targetSample+winSamp(2);
    validS0 = max(s0,1);
    validS1 = min(s1,SENT.pnts);
    destStart = validS0-s0+1;
    destEnd = destStart+(validS1-validS0);
    wordAligned(:,destStart:destEnd,tr) = double(SENT.data(:,validS0:validS1,tr));
end
coverageCount = sum(~isnan(squeeze(wordAligned(1,:,:))),2);

includedAllClean = logical(LEDGER.EEGClean);
includedPrimary = logical(LEDGER.PrimaryCorrectClean);

TRIAL_LOG = table(LATENCY.Trial,LATENCY.Condition,LATENCY.SNR, ...
    LATENCY.TargetLatency_ms,logical(LEDGER.ArtifactFlagBit1), ...
    logical(LEDGER.BehaviorErrorBit2),includedAllClean,includedPrimary, ...
    'VariableNames',{'Trial','Condition','SNR','TargetLatency_ms', ...
    'ArtifactFlagBit1','BehaviorErrorBit2','IncludedAllClean','IncludedPrimary'});
writetable(TRIAL_LOG,rejectionCsvPath);

binCond = [repmat("HC",1,5) repmat("LC",1,5)];
binSnr = [snrOrder snrOrder];
BIN = table((1:cfg.expected_bins)',binCond',binSnr', ...
    zeros(cfg.expected_bins,1),zeros(cfg.expected_bins,1), ...
    zeros(cfg.expected_bins,1), ...
    'VariableNames',{'Bin','Condition','SNR','Original', ...
    'AllCleanAccepted','PrimaryAccepted'});
allCleanBinData = nan(nCh,nSamp,cfg.expected_bins);
primaryBinData = nan(nCh,nSamp,cfg.expected_bins);
for b = 1:cfg.expected_bins
    condMask = LATENCY.Condition == binCond(b) & LATENCY.SNR == binSnr(b);
    BIN.Original(b) = sum(condMask);
    allCleanMask = condMask & includedAllClean;
    primaryMask = condMask & includedPrimary;
    BIN.AllCleanAccepted(b) = sum(allCleanMask);
    BIN.PrimaryAccepted(b) = sum(primaryMask);
    allCleanBinData(:,:,b) = mean(wordAligned(:,:,allCleanMask),3,'omitnan');
    primaryBinData(:,:,b) = mean(wordAligned(:,:,primaryMask),3,'omitnan');
end
assert(all(BIN.Original == cfg.expected_trials_per_bin));
writetable(BIN,binSummaryPath);

localPlotWordAligned(cfg,SENT,relTimes,allCleanBinData, ...
    BIN.AllCleanAccepted,fullfile(plotsRoot,'all_clean'),'all clean', ...
    PLOT_Y_LIMITS_UV);
localPlotWordAligned(cfg,SENT,relTimes,primaryBinData, ...
    BIN.PrimaryAccepted,fullfile(plotsRoot,'primary_correct_clean'), ...
    'primary correct clean',PLOT_Y_LIMITS_UV);

fid = fopen(logPath,'w');
fprintf(fid,'Sentence word-aligned ERP (supplemental; not part of the locked six-stage output)\n');
fprintf(fid,'Participant: %s\n',cfg.subject);
fprintf(fid,'Source sentence epoch: %s\n',fullfile(sentDir,epochSetName));
fprintf(fid,['Word window: %.0f to %.0f ms (fixed across all participants); ' ...
    'baseline is phaseS1''s -200:0 ms relative to SENTENCE ONSET, unchanged ' ...
    'by the display shift.\n'],relTimes(1),relTimes(end));
fprintf(fid,['Coverage tapers toward the edges since sentences differ in length ' ...
    '(max trial coverage=%d, min=%d, out of %d trials).\n'], ...
    max(coverageCount),min(coverageCount),cfg.expected_trials);
fprintf(fid,'Plot Y limits: %.0f to %.0f uV (fixed for every panel).\n', ...
    PLOT_Y_LIMITS_UV(1),PLOT_Y_LIMITS_UV(2));
fprintf(fid,'Artifact/behavior decisions reused from: %s\n',ledgerPath);
fprintf(fid,'All-clean accepted per bin: %s\n',mat2str(BIN.AllCleanAccepted'));
fprintf(fid,'Primary accepted per bin: %s\n',mat2str(BIN.PrimaryAccepted'));
fprintf(fid,'Trial-by-trial inclusion record: %s\n',rejectionCsvPath);
fprintf(fid,'Plots (one file per mode/site/SNR): %s\n',plotsRoot);
fclose(fid);

fprintf('Sentence word-aligned ERP complete.\nAll-clean accepted per bin: ');
fprintf('%d ',BIN.AllCleanAccepted); fprintf('\nPrimary accepted per bin: ');
fprintf('%d ',BIN.PrimaryAccepted); fprintf('\n');

function localPlotWordAligned(cfg,SENT,relTimes,binData,acceptedN,modeDir, ...
    modeLabel,yLimitsUV)
labels = upper(string({SENT.chanlocs.labels}));
cz = find(labels == "CZ",1);
roiNames = ["CZ","CP1","CPZ","CP2","P3","PZ","P4"];
roi = nan(1,numel(roiNames));
for k = 1:numel(roiNames)
    roi(k) = find(labels == roiNames(k),1);
end
assert(isscalar(cz) && all(isfinite(roi)));
czData = squeeze(binData(cz,:,:));
roiData = squeeze(mean(binData(roi,:,:),1));

localPlotOneSite(cfg,relTimes,czData,'CZ',acceptedN, ...
    fullfile(modeDir,'cz'),modeLabel,yLimitsUV);
localPlotOneSite(cfg,relTimes,roiData,'CZ/CP/P ROI',acceptedN, ...
    fullfile(modeDir,'roi'),modeLabel,yLimitsUV);
end

function localPlotOneSite(cfg,relTimes,source,siteLabel,acceptedN,siteDir, ...
    modeLabel,yLimitsUV)
snrLabels = {'-4 dB','-2 dB','+4 dB','+6 dB','quiet'};
snrFileTag = {'-4dB','-2dB','4dB','6dB','quiet'};
if exist(siteDir,'dir') ~= 7, mkdir(siteDir); end
for s = 1:5
    pngPath = fullfile(siteDir,sprintf('%s.png',snrFileTag{s}));
    figPath = replace(pngPath,'.png','.fig');
    assert(exist(pngPath,'file') == 0 && exist(figPath,'file') == 0, ...
        'Word-aligned ERP plot exists; stopped without overwriting.');

    h = figure('Visible','off','Color','w','Position',[100 100 1000 750]);
    hold on;
    hc = source(:,s);
    lc = source(:,s+5);
    nHC = acceptedN(s);
    nLC = acceptedN(s+5);
    plot(relTimes,hc,'Color',[0.12 0.42 0.78],'LineWidth',2.2);
    plot(relTimes,lc,'Color',[0.83 0.25 0.22],'LineWidth',2.2);
    plot(relTimes,lc-hc,'Color',[0.1 0.1 0.1],'LineWidth',1.6);
    xline(0,':','Color',[0.35 0.35 0.35]);
    yline(0,':','Color',[0.35 0.35 0.35]);
    xlim([relTimes(1) relTimes(end)]);
    ylim(yLimitsUV);
    yticks(yLimitsUV(1):10:yLimitsUV(2));
    set(gca,'YDir','reverse','Box','off','FontSize',13);
    title(sprintf('%s 828update word-aligned ERP (%s) | %s | %s', ...
        cfg.subject,modeLabel,siteLabel,snrLabels{s}),'FontSize',13);
    xlabel('Time relative to target word (ms)','FontSize',13);
    ylabel('Amplitude (uV; negative up)','FontSize',13);
    legend({sprintf('HC (N=%d)',nHC),sprintf('LC (N=%d)',nLC),'LC-HC'}, ...
        'Location','best','FontSize',11);

    exportgraphics(h,pngPath,'Resolution',200);
    savefig(h,figPath);
    close(h);
end
end
