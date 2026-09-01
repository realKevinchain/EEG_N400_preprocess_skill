function plot_828_erp_qc(cfg,ERP_PRIMARY,ERP_ALLCLEAN)
% Generate fixed CZ and centroparietal 828update morphology figures.
labels = upper(string({ERP_ALLCLEAN.chanlocs.labels}));
cz = find(labels == "CZ",1);
roiNames = ["CZ","CP1","CPZ","CP2","P3","PZ","P4"];
roi = nan(1,numel(roiNames));
for k = 1:numel(roiNames)
    roi(k) = find(labels == roiNames(k),1);
end
assert(isscalar(cz) && all(isfinite(roi)));
localPlotOne(cfg,ERP_PRIMARY,cz,roi,'primary_correct_clean');
localPlotOne(cfg,ERP_ALLCLEAN,cz,roi,'all_clean');
end

function localPlotOne(cfg,ERP,cz,roi,mode)
times = double(ERP.times(:));
czData = squeeze(double(ERP.bindata(cz,:,:)));
roiData = squeeze(mean(double(ERP.bindata(roi,:,:)),1));
assert(isequal(size(czData),[ERP.pnts ERP.nbin]));
assert(isequal(size(roiData),[ERP.pnts ERP.nbin]));
accepted = double(ERP.ntrials.accepted(:)');
assert(numel(accepted) == ERP.nbin);
snrLabels = {'-4 dB','-2 dB','+4 dB','+6 dB','quiet'};
h = figure('Visible','off','Color','w','Position',[100 100 1700 720]);
tiledlayout(2,5,'TileSpacing','compact','Padding','compact');
for row = 1:2
    source = czData;
    siteLabel = 'CZ';
    if row == 2
        source = roiData;
        siteLabel = 'CZ/CP/P ROI';
    end
    for s = 1:5
        nexttile;
        hold on;
        hc = source(:,s);
        lc = source(:,s+5);
        plot(times,hc,'Color',[0.12 0.42 0.78],'LineWidth',1.4);
        plot(times,lc,'Color',[0.83 0.25 0.22],'LineWidth',1.4);
        plot(times,lc-hc,'Color',[0.1 0.1 0.1],'LineWidth',1.1);
        xline(0,':','Color',[0.35 0.35 0.35]);
        yline(0,':','Color',[0.35 0.35 0.35]);
        xlim([cfg.epoch_ms(1) min(cfg.epoch_ms(2),times(end))]);
        set(gca,'YDir','reverse','Box','off');
        title(sprintf('%s | %s (HC N=%d, LC N=%d)', ...
            siteLabel,snrLabels{s},accepted(s),accepted(s+5)));
        if row == 2, xlabel('Time (ms)'); end
        if s == 1, ylabel('Amplitude (uV; negative up)'); end
        if row == 1 && s == 1
            legend({'HC','LC','LC-HC'},'Location','best');
        end
    end
end
sgtitle(sprintf('%s 828update ERP: %s',cfg.subject,strrep(mode,'_',' ')));
pngPath = fullfile(cfg.erp_dir,sprintf( ...
    '%s_828update_%s_erp_%s_cz_roi.png', ...
    cfg.subject,cfg.reference_tag,mode));
figPath = replace(pngPath,'.png','.fig');
assert(exist(pngPath,'file') == 0 && exist(figPath,'file') == 0, ...
    'ERP plot exists; stopped without overwriting.');
exportgraphics(h,pngPath,'Resolution',180);
savefig(h,figPath);
close(h);
end
