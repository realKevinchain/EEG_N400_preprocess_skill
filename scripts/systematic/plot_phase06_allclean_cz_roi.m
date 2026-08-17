%% Phase 6 final all-clean ERP plot: CZ and FZ/FCZ/CZ/CPZ ROI.
% Requires cfg from the participant configuration script.
% HC is blue, LC is red, HC-LC is black, and negative voltage is up.
% The source is always the artifact-clean ERP; behavior is not filtered.

assert(exist('cfg','var') == 1, ...
    'Run the subject configuration script before this plotting script.');
run(fullfile(cfg.repo_root,'scripts','systematic', ...
    'init_n400_runtime.m'));

erpPath = fullfile(cfg.erp_dir,cfg.sensitivity_erp);
assert(exist(erpPath,'file') == 2, ...
    'All-clean ERP file not found: %s',erpPath);

ERP = pop_loaderp( ...
    'filename',cfg.sensitivity_erp, ...
    'filepath',cfg.erp_dir, ...
    'UpdateMainGui','off', ...
    'History','off');

assert(ERP.nbin == cfg.expected_bins && ERP.nbin == 10);
assert(ERP.pnts == 250);

channelLabels = upper(string({ERP.chanlocs.labels}));
roiLabels = ["FZ","FCZ","CZ","CPZ"];
[roiFound,roiIndices] = ismember(roiLabels,channelLabels);
assert(all(roiFound), ...
    'One or more requested ROI channels are missing.');

czIndex = find(channelLabels == "CZ");
assert(isscalar(czIndex),'CZ was not found uniquely.');

times = ERP.times(:);
cz = squeeze(double(ERP.bindata(czIndex,:,:)));
roi = squeeze(mean(double( ...
    ERP.bindata(roiIndices,:,:)),1));
assert(isequal(size(cz),[ERP.pnts ERP.nbin]));
assert(isequal(size(roi),[ERP.pnts ERP.nbin]));

czDifference = zeros(ERP.pnts,5);
roiDifference = zeros(ERP.pnts,5);
for snrIndex = 1:5
    hcBin = snrIndex;
    lcBin = snrIndex+5;
    czDifference(:,snrIndex) = ...
        cz(:,hcBin)-cz(:,lcBin);
    roiDifference(:,snrIndex) = ...
        roi(:,hcBin)-roi(:,lcBin);
end

allDisplayedValues = [ ...
    cz(:);roi(:);czDifference(:);roiDifference(:)];
assert(all(isfinite(allDisplayedValues)));
plotLimit = max(5, ...
    5*ceil(max(abs(allDisplayedValues))/5));

snrNames = ["-4 dB","-2 dB","+4 dB","+6 dB","quiet"];
colorHC = [0.00 0.25 0.75];
colorLC = [0.82 0.08 0.08];
colorDifference = [0.00 0.00 0.00];
accepted = ERP.ntrials.accepted;

fig = figure( ...
    'Name',sprintf('%s all-clean ERP: CZ and midline ROI', ...
        cfg.subject), ...
    'Color','w', ...
    'Position',[80 80 1500 760]);
layout = tiledlayout(fig,2,5, ...
    'TileSpacing','compact', ...
    'Padding','compact');

for snrIndex = 1:5
    hcBin = snrIndex;
    lcBin = snrIndex+5;
    ax = nexttile(layout,snrIndex);
    hold(ax,'on');
    plot(ax,times,cz(:,hcBin), ...
        'Color',colorHC,'LineWidth',1.5);
    plot(ax,times,cz(:,lcBin), ...
        'Color',colorLC,'LineWidth',1.5);
    plot(ax,times,czDifference(:,snrIndex), ...
        'Color',colorDifference,'LineWidth',2.0);
    xline(ax,0,'k:');
    yline(ax,0,'Color',[0.4 0.4 0.4],'LineStyle',':');
    xlim(ax,[times(1) times(end)]);
    ylim(ax,[-plotLimit plotLimit]);
    set(ax,'YDir','reverse');
    grid(ax,'on');
    title(ax,sprintf('%s; HC all-clean n=%d, LC all-clean n=%d', ...
        snrNames(snrIndex),accepted(hcBin),accepted(lcBin)));
    if snrIndex == 1
        ylabel(ax,'CZ amplitude (\muV)');
        legend(ax,{'HC all-clean','LC all-clean','HC - LC'}, ...
            'Location','best','FontSize',8);
    end
end

for snrIndex = 1:5
    hcBin = snrIndex;
    lcBin = snrIndex+5;
    ax = nexttile(layout,5+snrIndex);
    hold(ax,'on');
    plot(ax,times,roi(:,hcBin), ...
        'Color',colorHC,'LineWidth',1.5);
    plot(ax,times,roi(:,lcBin), ...
        'Color',colorLC,'LineWidth',1.5);
    plot(ax,times,roiDifference(:,snrIndex), ...
        'Color',colorDifference,'LineWidth',2.0);
    xline(ax,0,'k:');
    yline(ax,0,'Color',[0.4 0.4 0.4],'LineStyle',':');
    xlim(ax,[times(1) times(end)]);
    ylim(ax,[-plotLimit plotLimit]);
    set(ax,'YDir','reverse');
    grid(ax,'on');
    xlabel(ax,'Time from target onset (ms)');
    if snrIndex == 1
        ylabel(ax,'FZ/FCZ/CZ/CPZ ROI (\muV)');
    end
end

title(layout,sprintf([ ...
    '%s all-clean ERP: HC blue, LC red, ' ...
    'HC - LC black; negative up'],cfg.subject));

outputStem = sprintf('%s_%s_erp_all_clean_cz_midline_roi', ...
    cfg.subject,cfg.reference_tag);
pngFile = fullfile(cfg.erp_dir,[outputStem '.png']);
figFile = fullfile(cfg.erp_dir,[outputStem '.fig']);
exportgraphics(fig,pngFile,'Resolution',300);
savefig(fig,figFile);

fprintf('\n=== Phase 6 final all-clean ERP plot QC ===\n');
fprintf('Source ERP: %s\n',erpPath);
fprintf('Participant/reference: %s / %s\n', ...
    cfg.subject,cfg.reference_mode);
fprintf('Requested ROI channels found: %d/%d\n', ...
    sum(roiFound),numel(roiLabels));
fprintf('Difference formula: HC - LC\n');
fprintf('All-clean accepted HC bins: ');
fprintf('%d ',accepted(1:5));
fprintf('\nAll-clean accepted LC bins: ');
fprintf('%d ',accepted(6:10));
fprintf('\nBehavior correctness filter used: no\n');
fprintf('Plot range: %.1f to %.1f uV; negative up\n', ...
    -plotLimit,plotLimit);
fprintf('PNG saved: %s\n',pngFile);
fprintf('FIG saved: %s\n',figFile);
