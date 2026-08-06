%% Phase 1: audit the GUI-imported canonical SET against behavior.
% Prerequisite: cfg is loaded and <subject>_imported.set exists.

run(fullfile(cfg.repo_root,'scripts','systematic', ...
    'init_n400_runtime.m'));

EEG = pop_loadset('filename',cfg.imported_set, ...
    'filepath',cfg.input_dir);
EEG = eeg_checkset(EEG);

assert(EEG.nbchan == 67);
assert(numel(unique(string( ...
    {EEG.chanlocs.labels}))) == 67);
assert(all(isfinite(EEG.data(:))));

eventCodes = nan(1,numel(EEG.event));
for k = 1:numel(EEG.event)
    eventCodes(k) = localEventCode(EEG.event(k).type);
end
targetMask = ismember(eventCodes, ...
    [111:115 121:125]);
targetCodes = eventCodes(targetMask)';

behaviorFile = fullfile( ...
    cfg.behavior_dir,[cfg.subject '.csv']);
raw = readcell(behaviorFile, ...
    'Delimiter',',','TextType','string');
headers = strip(localText(raw(1,:)));
cells = raw(2:end,:);
condition = upper(strip(localText( ...
    cells(:,localHeader(headers,'condition')))));
snr = lower(strip(localText( ...
    cells(:,localHeader(headers,'snr')))));

assert(size(cells,1) == cfg.expected_trials);
assert(numel(targetCodes) == cfg.expected_trials);

expectedCodes = nan(cfg.expected_trials,1);
for row = 1:cfg.expected_trials
    snrIndex = find(snr(row) == ...
        ["-4","-2","4","6","quiet"]);
    assert(isscalar(snrIndex));
    if condition(row) == "HC"
        expectedCodes(row) = 110+snrIndex;
    elseif condition(row) == "LC"
        expectedCodes(row) = 120+snrIndex;
    else
        error('Unexpected condition at behavior row %d.',row);
    end
end

assert(isequal(targetCodes,expectedCodes));
fprintf(['Phase 1 PASS: %s; channels=%d, events=%d, ' ...
    'behavior/target alignment=%d/%d.\n'], ...
    cfg.subject,EEG.nbchan,numel(EEG.event), ...
    sum(targetCodes == expectedCodes), ...
    cfg.expected_trials);

function code = localEventCode(value)
if isnumeric(value)
    code = double(value);
else
    token = regexp(char(string(value)), ...
        '-?\d+','match','once');
    code = str2double(token);
end
end

function index = localHeader(headers,name)
index = find(headers == string(name),1);
assert(~isempty(index),'Missing behavior column: %s',name);
end

function output = localText(input)
output = strings(numel(input),1);
for k = 1:numel(input)
    value = input{k};
    if isstring(value) || ischar(value)
        output(k) = string(value);
    elseif isnumeric(value) || islogical(value)
        output(k) = string(value);
    else
        output(k) = missing;
    end
end
end
