function behavior = n400u_read_behavior(cfg)
% Load and normalize the participant behavior CSV.
behaviorFile = fullfile(cfg.behavior_dir,[cfg.subject '.csv']);
assert(exist(behaviorFile,'file') == 2, ...
    'Behavior CSV not found: %s',behaviorFile);
raw = readcell(behaviorFile,'Delimiter',',','TextType','string');
headers = strip(localText(raw(1,:)));
cells = raw(2:end,:);
behavior.condition = upper(strip(localText( ...
    cells(:,localHeader(headers,'condition')))));
behavior.snr = lower(strip(localText( ...
    cells(:,localHeader(headers,'snr')))));
behavior.correct = [];
correctIndex = find(headers == "Correct",1);
if ~isempty(correctIndex)
    behavior.correct = localNumeric(cells(:,correctIndex));
end
behavior.rows = size(cells,1);
behavior.expected_code = nan(behavior.rows,1);
behavior.expected_bin = nan(behavior.rows,1);
for row = 1:behavior.rows
    snrIndex = find(behavior.snr(row) == ["-4","-2","4","6","quiet"]);
    assert(isscalar(snrIndex),'Unexpected SNR at behavior row %d.',row);
    if behavior.condition(row) == "HC"
        behavior.expected_code(row) = 110+snrIndex;
        behavior.expected_bin(row) = snrIndex;
    elseif behavior.condition(row) == "LC"
        behavior.expected_code(row) = 120+snrIndex;
        behavior.expected_bin(row) = 5+snrIndex;
    else
        error('Unexpected condition at behavior row %d.',row);
    end
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

function output = localNumeric(input)
output = nan(numel(input),1);
for k = 1:numel(input)
    value = input{k};
    if isnumeric(value) || islogical(value)
        output(k) = double(value);
    else
        output(k) = str2double(string(value));
    end
end
end
