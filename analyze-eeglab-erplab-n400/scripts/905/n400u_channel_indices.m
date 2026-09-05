function indices = n400u_channel_indices(EEG,requestedLabels)
% Resolve channel labels case-insensitively and require exactly one match.

requested = string(requestedLabels);
requested = requested(:)';
if isempty(requested)
    indices = zeros(1,0);
    return
end
labels = strtrim(string({EEG.chanlocs.labels}));
indices = zeros(1,numel(requested));
for k = 1:numel(requested)
    hit = find(strcmpi(labels,strtrim(requested(k))));
    assert(isscalar(hit), ...
        'Expected exactly one channel labelled %s; found %d.', ...
        requested(k),numel(hit));
    indices(k) = hit;
end
assert(numel(unique(indices)) == numel(indices), ...
    'Requested channel labels do not resolve uniquely.');
end
