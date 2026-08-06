%% Phase 6 QC: all-clean N400-window scalp topography.
% Run config_<SUBJECT>.m first. This diagnostic is read-only.
% HC-LC > 0 means LC is more negative than HC in the selected window.

run(fullfile(cfg.repo_root,'scripts','systematic', ...
    'init_n400_runtime.m'));

ERP = pop_loaderp('filename',cfg.sensitivity_erp, ...
    'filepath',cfg.erp_dir, ...
    'UpdateMainGui','off','History','off');

assert(ERP.nbin == cfg.expected_bins);
times = double(ERP.times(:)');
n400Samples = times >= 300 & times <= 500;
assert(any(n400Samples));

labels = string({ERP.chanlocs.labels});
scalpIndex = setdiff(cfg.eeg_channels, ...
    [cfg.m1_channel cfg.m2_channel]);
assert(numel(scalpIndex) == 62);

snrNames = ["-4 dB" "-2 dB" "+4 dB" "+6 dB" "quiet"]';
hcBins = 1:5;
lcBins = 6:10;

windowMean = squeeze(mean(double( ...
    ERP.bindata(:,n400Samples,:)),2));
hcMap = windowMean(:,hcBins);
lcMap = windowMean(:,lcBins);
differenceMap = hcMap-lcMap;
assert(all(isfinite([hcMap(:);lcMap(:);differenceMap(:)])));

roiLabels = ["FZ" "FCZ" "CZ" "CPZ"];
midlineLabels = ["FZ" "FCZ" "CZ" "CPZ" "PZ"];
roiIndex = localFindChannels(labels,roiLabels);
midlineIndex = localFindChannels(labels,midlineLabels);

hcROI = mean(hcMap(roiIndex,:),1)';
lcROI = mean(lcMap(roiIndex,:),1)';
differenceROI = mean(differenceMap(roiIndex,:),1)';
midlineDifference = differenceMap(midlineIndex,:)';

minimumDifference = nan(5,1);
maximumDifference = nan(5,1);
minimumChannel = strings(5,1);
maximumChannel = strings(5,1);
for s = 1:5
    scalpDifference = differenceMap(scalpIndex,s);
    [minimumDifference(s),minimumPosition] = min(scalpDifference);
    [maximumDifference(s),maximumPosition] = max(scalpDifference);
    minimumChannel(s) = labels(scalpIndex(minimumPosition));
    maximumChannel(s) = labels(scalpIndex(maximumPosition));
end

accepted = double(ERP.ntrials.accepted(:));

N400_TOPOGRAPHY_QC = table( ...
    snrNames, ...
    accepted(hcBins),accepted(lcBins), ...
    hcROI,lcROI,differenceROI, ...
    midlineDifference(:,1),midlineDifference(:,2), ...
    midlineDifference(:,3),midlineDifference(:,4), ...
    midlineDifference(:,5), ...
    minimumDifference,minimumChannel, ...
    maximumDifference,maximumChannel, ...
    'VariableNames',{ ...
    'SNR','HC_n','LC_n','HC_ROI','LC_ROI','HCminusLC_ROI', ...
    'FZ_Difference','FCZ_Difference','CZ_Difference', ...
    'CPZ_Difference','PZ_Difference', ...
    'MinimumDifference','MinimumChannel', ...
    'MaximumDifference','MaximumChannel'});

fprintf('\n=== Phase 6 all-clean N400 topography QC ===\n');
fprintf('Window: 300 to 500 ms\n');
fprintf('Scalp channels: %d; M1/M2 excluded: 1 / 1\n', ...
    numel(scalpIndex));
fprintf(['Sign convention: HC-LC > 0 means LC is more negative ' ...
    'than HC.\n']);
disp(N400_TOPOGRAPHY_QC);

allMapValues = [ ...
    hcMap(scalpIndex,:); ...
    lcMap(scalpIndex,:); ...
    differenceMap(scalpIndex,:)];
mapLimit = max(abs(allMapValues),[],'all');
mapLimit = max(1,ceil(mapLimit*2)/2);

figure('Color','w','Name', ...
    sprintf('%s all-clean N400 topography',cfg.subject));
tiledlayout(3,5,'TileSpacing','compact','Padding','compact');

for row = 1:3
    for s = 1:5
        nexttile;
        if row == 1
            values = hcMap(scalpIndex,s);
            rowName = 'HC';
        elseif row == 2
            values = lcMap(scalpIndex,s);
            rowName = 'LC';
        else
            values = differenceMap(scalpIndex,s);
            rowName = 'HC-LC';
        end
        topoplot(values,ERP.chanlocs(scalpIndex), ...
            'maplimits',[-mapLimit mapLimit], ...
            'electrodes','on','style','map', ...
            'numcontour',6);
        title(sprintf('%s %s',rowName,snrNames(s)));
        if s == 5
            colorbar;
        end
    end
end

colormap(turbo);
sgtitle(sprintf([ ...
    '%s all-clean 300-500 ms; common scale +/-%.1f uV; ' ...
    'HC-LC positive means LC more negative'], ...
    cfg.subject,mapLimit));

function index = localFindChannels(labels,wanted)
index = nan(size(wanted));
for k = 1:numel(wanted)
    index(k) = find(strcmpi(labels,wanted(k)),1);
end
assert(all(isfinite(index)), ...
    'One or more requested channels were not found.');
end
