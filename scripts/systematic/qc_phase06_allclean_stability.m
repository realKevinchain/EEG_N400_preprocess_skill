%% Phase 6 QC: all-clean SEM and odd/even stability.
% Run config_<SUBJECT>.m first. This diagnostic is read-only.
% "All-clean" excludes EEG-artifact-flagged epochs only; behavior is ignored.

run(fullfile(cfg.repo_root,'scripts','systematic', ...
    'init_n400_runtime.m'));

EEG = pop_loadset('filename',cfg.flagged_set, ...
    'filepath',cfg.deriv_dir);
ERP = pop_loaderp('filename',cfg.sensitivity_erp, ...
    'filepath',cfg.erp_dir, ...
    'UpdateMainGui','off','History','off');

assert(EEG.trials == cfg.expected_trials);
assert(ERP.nbin == cfg.expected_bins);
assert(isequal(double(EEG.times(:)),double(ERP.times(:))));

labels = string({EEG.chanlocs.labels});
roiLabels = ["FZ" "FCZ" "CZ" "CPZ"];
roiIndex = nan(size(roiLabels));
for k = 1:numel(roiLabels)
    roiIndex(k) = find(strcmpi(labels,roiLabels(k)),1);
end
assert(all(isfinite(roiIndex)), ...
    'One or more ROI channels were not found.');

artifact = logical(EEG.reject.rejmanual(:));
assert(numel(artifact) == EEG.trials);
clean = ~artifact;

epochBin = nan(EEG.trials,1);
for ep = 1:EEG.trials
    item = EEG.epoch(ep).eventitem;
    if iscell(item), item = item{1}; end
    assert(isscalar(item));
    bins = EEG.EVENTLIST.eventinfo(item).bini;
    if iscell(bins), bins = cell2mat(bins); end
    bins = bins(bins >= 1 & bins <= cfg.expected_bins);
    assert(isscalar(bins));
    epochBin(ep) = bins;
end

times = double(EEG.times(:)');
postSamples = times >= 0 & times <= 796;
n400Samples = times >= 300 & times <= 500;
assert(any(postSamples) && any(n400Samples));

snrNames = ["-4 dB" "-2 dB" "+4 dB" "+6 dB" "quiet"]';
condition = [repmat("HC",5,1); repmat("LC",5,1)];
snrByBin = [snrNames; snrNames];

nClean = zeros(cfg.expected_bins,1);
nOdd = zeros(cfg.expected_bins,1);
nEven = zeros(cfg.expected_bins,1);
n400Mean = nan(cfg.expected_bins,1);
n400aSME = nan(cfg.expected_bins,1);
pointwiseSEMRMS = nan(cfg.expected_bins,1);
oddEvenR = nan(cfg.expected_bins,1);
oddEvenRMS = nan(cfg.expected_bins,1);
oddEvenN400Difference = nan(cfg.expected_bins,1);
reconstructionError = nan(cfg.expected_bins,1);

fullWave = cell(cfg.expected_bins,1);
semWave = cell(cfg.expected_bins,1);
oddWave = cell(cfg.expected_bins,1);
evenWave = cell(cfg.expected_bins,1);

for b = 1:cfg.expected_bins
    epochs = find(clean & epochBin == b);
    nClean(b) = numel(epochs);
    assert(nClean(b) >= 2, ...
        'Bin %d has fewer than two clean epochs.',b);

    trialROI = squeeze(mean(double( ...
        EEG.data(roiIndex,:,epochs)),1));
    if isvector(trialROI)
        trialROI = trialROI(:);
    end

    fullWave{b} = mean(trialROI,2);
    semWave{b} = std(trialROI,0,2) / sqrt(nClean(b));

    trialN400 = mean(trialROI(n400Samples,:),1);
    n400Mean(b) = mean(trialN400);
    n400aSME(b) = std(trialN400,0,2) / sqrt(nClean(b));
    pointwiseSEMRMS(b) = sqrt(mean( ...
        semWave{b}(n400Samples).^2));

    oddColumns = 1:2:nClean(b);
    evenColumns = 2:2:nClean(b);
    nOdd(b) = numel(oddColumns);
    nEven(b) = numel(evenColumns);
    oddWave{b} = mean(trialROI(:,oddColumns),2);
    evenWave{b} = mean(trialROI(:,evenColumns),2);

    correlationMatrix = corrcoef( ...
        oddWave{b}(postSamples), ...
        evenWave{b}(postSamples));
    oddEvenR(b) = correlationMatrix(1,2);
    oddEvenRMS(b) = sqrt(mean(( ...
        oddWave{b}(postSamples) - ...
        evenWave{b}(postSamples)).^2));
    oddEvenN400Difference(b) = mean( ...
        oddWave{b}(n400Samples)) - mean( ...
        evenWave{b}(n400Samples));

    erpROI = squeeze(mean(double( ...
        ERP.bindata(roiIndex,:,b)),1));
    reconstructionError(b) = max(abs( ...
        fullWave{b}(:) - erpROI(:)));
end

assert(isequal(nClean, ...
    double(ERP.ntrials.accepted(:))));
assert(max(reconstructionError) < 1e-4);

ALLCLEAN_STABILITY_QC = table( ...
    (1:cfg.expected_bins)',condition,snrByBin, ...
    nClean,nOdd,nEven,n400Mean,n400aSME, ...
    pointwiseSEMRMS,oddEvenR,oddEvenRMS, ...
    oddEvenN400Difference,reconstructionError, ...
    'VariableNames',{ ...
    'Bin','Condition','SNR','CleanN','OddN','EvenN', ...
    'N400Mean300_500','N400aSME', ...
    'PointwiseSEMRMS300_500','OddEvenR_0_796', ...
    'OddEvenRMS_0_796','OddEvenN400Difference', ...
    'ERPReconstructionError'});

fprintf('\n=== Phase 6 all-clean SEM and stability QC ===\n');
fprintf('Artifact epochs excluded: %d; behavior filtering used: 0\n', ...
    sum(artifact));
fprintf('ROI: FZ / FCZ / CZ / CPZ\n');
fprintf('N400 descriptive window: 300 to 500 ms\n');
fprintf('Maximum ERP reconstruction error: %.12g uV\n', ...
    max(reconstructionError));
disp(ALLCLEAN_STABILITY_QC);

allMagnitude = 0;
for b = 1:cfg.expected_bins
    candidates = [ ...
        fullWave{b}(:)-semWave{b}(:); ...
        fullWave{b}(:)+semWave{b}(:); ...
        oddWave{b}(:); evenWave{b}(:)];
    allMagnitude = max(allMagnitude,max(abs(candidates)));
end
yLimit = max(2,ceil(allMagnitude));

figure('Color','w','Name', ...
    sprintf('%s all-clean SEM and split-half stability',cfg.subject));
tiledlayout(2,5,'TileSpacing','compact','Padding','compact');
for b = 1:cfg.expected_bins
    nexttile;
    meanRow = fullWave{b}(:)';
    semRow = semWave{b}(:)';
    fill([times fliplr(times)], ...
        [meanRow-semRow fliplr(meanRow+semRow)], ...
        [0.75 0.75 0.75], ...
        'EdgeColor','none','FaceAlpha',0.45);
    hold on;
    plot(times,meanRow,'k','LineWidth',1.8);
    plot(times,oddWave{b},'b','LineWidth',1.0);
    plot(times,evenWave{b},'r','LineWidth',1.0);
    xline(0,':');
    yline(0,':');
    xlim([-200 796]);
    ylim([-yLimit yLimit]);
    set(gca,'YDir','reverse');
    grid on;
    title(sprintf('%s %s; n=%d; r=%.2f', ...
        condition(b),snrByBin(b),nClean(b),oddEvenR(b)));
    if b == 1
        legend({'SEM','all clean','odd','even'}, ...
            'Location','best');
    end
    if b > 5, xlabel('Time (ms)'); end
    if b == 1 || b == 6, ylabel('ROI amplitude (uV)'); end
end
sgtitle(sprintf(['%s all-clean stability: FZ/FCZ/CZ/CPZ; ' ...
    'negative up'],cfg.subject));

