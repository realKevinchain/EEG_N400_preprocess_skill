function counts = n400u_bin_counts(EEG,expectedBins)
% Count target events assigned to each ERPLAB bin.
assert(isfield(EEG,'EVENTLIST') && isfield(EEG.EVENTLIST,'eventinfo'));
counts = zeros(1,expectedBins);
for k = 1:numel(EEG.EVENTLIST.eventinfo)
    bins = EEG.EVENTLIST.eventinfo(k).bini;
    if iscell(bins), bins = cell2mat(bins); end
    for b = bins(:)'
        if b >= 1 && b <= expectedBins
            counts(b) = counts(b)+1;
        end
    end
end
end
