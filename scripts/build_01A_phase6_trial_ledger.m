%% 01A Phase 6: build the behavior-EEG trial ledger
%
% This script deliberately uses readcell instead of readtable for the source
% CSV. The behavior SNR column mixes text ("quiet") and numeric-looking text
% (-4, -2, 4, 6), which can be misclassified by automatic type inference.

behaviorFile = ...
    '/Users/kevinchain/Desktop/N400_project/behavior/01A.csv';
derivPath = ...
    '/Users/kevinchain/Desktop/N400_project/derivatives/';
tablePath = [ ...
    '/Users/kevinchain/Desktop/N400_project/' ...
    'derivatives/tables/01A/'];
primaryFile = ...
    '01A_m1ref_target_epochs_artifactflagged.set';
ledgerFile = fullfile(tablePath, ...
    '01A_m1ref_trial_ledger.csv');

assert(exist(behaviorFile,'file') == 2, ...
    'Behavior CSV not found.');
assert(exist(fullfile(derivPath,primaryFile),'file') == 2, ...
    'Final artifact-flagged primary EEG file not found.');
assert(exist(ledgerFile,'file') == 0, ...
    'Trial ledger already exists; stopped without overwriting.');

if ~exist('PRIMARY_FINAL','var') || ...
        ~isstruct(PRIMARY_FINAL) || ...
        ~isfield(PRIMARY_FINAL,'setname') || ...
        ~strcmp(PRIMARY_FINAL.setname, ...
            '01A_m1ref_target_epochs_artifactflagged')

    PRIMARY_FINAL = pop_loadset( ...
        'filename',primaryFile, ...
        'filepath',derivPath);
    PRIMARY_FINAL = eeg_checkset(PRIMARY_FINAL);
end

assert(PRIMARY_FINAL.trials == 300, ...
    'Expected 300 EEG epochs.');

%% Read raw CSV cells without column-type inference

rawBehavior = readcell(behaviorFile, ...
    'Delimiter',',', ...
    'TextType','string');

assert(size(rawBehavior,1) == 301, ...
    'Expected one header row plus 300 behavior rows.');

headers = strip(localTextColumn(rawBehavior(1,:)));
dataCells = rawBehavior(2:end,:);

subjectColumn = localFindHeader(headers,'Subject');
blockColumn = localFindHeader(headers,'Block');
conditionColumn = localFindHeader(headers,'condition');
snrColumn = localFindHeader(headers,'snr');
wordColumn = localFindHeader(headers,'word');
responseColumn = localFindHeader(headers,'Response1.RESP');
responseRTColumn = localFindHeader(headers,'Response1.RT');
truthColumn = localFindHeader(headers,'T/F');
rtColumn = localFindHeader(headers,'RT');
correctColumn = localFindHeader(headers,'Correct');

behaviorSubject = localNumericColumn( ...
    dataCells(:,subjectColumn));
behaviorBlock = localNumericColumn( ...
    dataCells(:,blockColumn));
behaviorCondition = upper(strip(localTextColumn( ...
    dataCells(:,conditionColumn))));
behaviorSNR = lower(strip(localTextColumn( ...
    dataCells(:,snrColumn))));
behaviorWord = localTextColumn( ...
    dataCells(:,wordColumn));
behaviorResponse = localTextColumn( ...
    dataCells(:,responseColumn));
behaviorResponseRT = localNumericColumn( ...
    dataCells(:,responseRTColumn));
behaviorTruth = localNumericColumn( ...
    dataCells(:,truthColumn));
behaviorRT = localNumericColumn( ...
    dataCells(:,rtColumn));
behaviorCorrect = localNumericColumn( ...
    dataCells(:,correctColumn));

assert(all(behaviorSubject == 11), ...
    'Behavior Subject must be 11 for participant 01A.');
assert(all(ismember(behaviorCondition,["HC","LC"])), ...
    'Unexpected behavior condition value.');
assert(all(ismember(behaviorSNR, ...
    ["-4","-2","4","6","quiet"])), ...
    'Unexpected behavior SNR value.');
assert(all(ismember(behaviorCorrect,[0 1])), ...
    'Correct must contain only 0/1.');
assert(isequal(behaviorTruth,behaviorCorrect), ...
    'T/F and Correct do not match.');

%% Map behavior condition and SNR to target code and bin

expectedTargetCode = nan(300,1);
expectedBin = nan(300,1);

for row = 1:300
    if behaviorCondition(row) == "HC"
        targetCodeBase = 110;
        binOffset = 0;
    elseif behaviorCondition(row) == "LC"
        targetCodeBase = 120;
        binOffset = 5;
    else
        error('Unexpected condition at behavior row %d.',row);
    end

    switch behaviorSNR(row)
        case "-4"
            snrIndex = 1;
        case "-2"
            snrIndex = 2;
        case "4"
            snrIndex = 3;
        case "6"
            snrIndex = 4;
        case "quiet"
            snrIndex = 5;
        otherwise
            error('Unexpected SNR "%s" at behavior row %d.', ...
                behaviorSNR(row),row);
    end

    expectedTargetCode(row) = targetCodeBase+snrIndex;
    expectedBin(row) = binOffset+snrIndex;
end

%% Extract target codes, bins, and bit-1 flags from the saved EEG

eegTargetCode = nan(300,1);
eegBin = nan(300,1);
eventListBit1 = false(300,1);
eventInfo = PRIMARY_FINAL.EVENTLIST.eventinfo;

for item = 1:numel(eventInfo)
    epochNumber = eventInfo(item).bepoch;
    binNumber = eventInfo(item).bini;

    if iscell(epochNumber)
        epochNumber = cell2mat(epochNumber);
    end
    if iscell(binNumber)
        binNumber = cell2mat(binNumber);
    end

    if isnumeric(epochNumber) && ...
            any(epochNumber(:) > 0) && ...
            isnumeric(binNumber) && ...
            any(binNumber(:) >= 1 & binNumber(:) <= 10)

        validEpoch = epochNumber(epochNumber > 0);
        validBin = binNumber( ...
            binNumber >= 1 & binNumber <= 10);
        ep = validEpoch(1);

        eegTargetCode(ep) = double(eventInfo(item).code);
        eegBin(ep) = validBin(1);
        eventListBit1(ep) = bitget( ...
            uint16(eventInfo(item).flag),1);
    end
end

assert(all(isfinite(eegTargetCode)), ...
    'Some EEG epochs lack a target code.');
assert(all(isfinite(eegBin)), ...
    'Some EEG epochs lack a target bin.');

targetCodeMatch = expectedTargetCode == eegTargetCode;
binMatch = expectedBin == eegBin;

assert(all(targetCodeMatch), ...
    'Behavior/EEG target-code mismatch.');
assert(all(binMatch), ...
    'Behavior/EEG bin mismatch.');

rejectBit1 = logical( ...
    PRIMARY_FINAL.reject.rejmanual(:));

assert(isequal(rejectBit1,eventListBit1), ...
    'EEG.reject and EVENTLIST artifact masks differ.');
assert(isequal(find(rejectBit1)', ...
    [4 22 133 202 206]), ...
    'Unexpected final bit-1 artifact list.');

eegClean = ~rejectBit1;
primaryCorrectClean = ...
    behaviorCorrect == 1 & eegClean;
allTrialClean = eegClean;

%% Construct the ledger

participant = repmat("01A",300,1);
behaviorRow = (1:300)';
eegEpoch = (1:300)';

LEDGER = table( ...
    participant,behaviorRow,eegEpoch, ...
    behaviorSubject,behaviorBlock, ...
    behaviorCondition,behaviorSNR, ...
    behaviorWord,behaviorResponse, ...
    behaviorResponseRT,behaviorTruth,behaviorRT, ...
    behaviorCorrect,expectedTargetCode,eegTargetCode,eegBin, ...
    targetCodeMatch,rejectBit1,eegClean, ...
    primaryCorrectClean,allTrialClean, ...
    'VariableNames',{ ...
    'Participant','BehaviorRow','EEGEpoch', ...
    'BehaviorSubject','Block','Condition','SNR', ...
    'Word','Response','ResponseRT','TruthValue','RT', ...
    'Correct','ExpectedTargetCode','EEGTargetCode','Bin', ...
    'TargetCodeMatch','ArtifactFlagBit1','EEGClean', ...
    'PrimaryCorrectClean','AllTrialClean'});

%% Final count gate

behaviorCorrectPerBin = zeros(10,1);
cleanAllPerBin = zeros(10,1);
correctCleanPerBin = zeros(10,1);

for b = 1:10
    binMask = eegBin == b;
    behaviorCorrectPerBin(b) = sum( ...
        behaviorCorrect == 1 & binMask);
    cleanAllPerBin(b) = sum(eegClean & binMask);
    correctCleanPerBin(b) = sum( ...
        primaryCorrectClean & binMask);
end

expectedBehaviorCorrect = ...
    [8 10 21 19 29 5 4 16 23 23]';
expectedCleanAll = ...
    [29 30 30 29 29 29 30 30 30 29]';
expectedCorrectClean = ...
    [8 10 21 18 28 4 4 16 23 22]';

assert(isequal(behaviorCorrectPerBin, ...
    expectedBehaviorCorrect), ...
    'Behavior-correct bin counts differ from the Phase 1 audit.');
assert(isequal(cleanAllPerBin,expectedCleanAll), ...
    'EEG-clean bin counts differ from the locked Phase 5 result.');
assert(isequal(correctCleanPerBin, ...
    expectedCorrectClean), ...
    'Correct-and-clean bin counts are unexpected.');
assert(sum(behaviorCorrect) == 158, ...
    'Expected 158 behavior-correct trials.');
assert(sum(eegClean) == 295, ...
    'Expected 295 EEG-clean trials.');
assert(sum(primaryCorrectClean) == 154, ...
    'Expected 154 correct-and-clean trials.');
assert(sum(behaviorCorrect == 1 & rejectBit1) == 4, ...
    'Expected four correct trials lost to EEG artifact.');
assert(sum(behaviorCorrect == 0 & rejectBit1) == 1, ...
    'Expected one incorrect trial lost to EEG artifact.');

binNames = { ...
    'HC_-4','HC_-2','HC_+4','HC_+6','HC_quiet', ...
    'LC_-4','LC_-2','LC_+4','LC_+6','LC_quiet'}';

FINAL_COUNTS = table( ...
    (1:10)',binNames,behaviorCorrectPerBin, ...
    cleanAllPerBin,correctCleanPerBin, ...
    'VariableNames',{ ...
    'Bin','Condition','BehaviorCorrect', ...
    'EEGCleanAllTrials','PrimaryCorrectAndClean'});

%% Export and immediately verify the written ledger

writetable(LEDGER,ledgerFile);

assert(exist(ledgerFile,'file') == 2, ...
    'Ledger export failed.');

ledgerRawCheck = readcell(ledgerFile, ...
    'Delimiter',',', ...
    'TextType','string');

assert(size(ledgerRawCheck,1) == 301, ...
    'Reloaded ledger does not contain 300 data rows.');
assert(size(ledgerRawCheck,2) == width(LEDGER), ...
    'Reloaded ledger column count is incorrect.');

fprintf('\n=== Phase 6 behavior-EEG ledger gate ===\n');
fprintf('Behavior rows / EEG epochs: %d / %d\n', ...
    height(LEDGER),PRIMARY_FINAL.trials);
fprintf('Exact target-code matches: %d/300\n', ...
    sum(targetCodeMatch));
fprintf('Exact bin matches: %d/300\n',sum(binMatch));
fprintf('Artifact flagged / EEG clean: %d / %d\n', ...
    sum(rejectBit1),sum(eegClean));
fprintf('Behavior correct total: %d\n', ...
    sum(behaviorCorrect));
fprintf('Primary correct-and-clean total: %d\n', ...
    sum(primaryCorrectClean));
fprintf('Correct / incorrect trials lost to artifact: %d / %d\n', ...
    sum(behaviorCorrect == 1 & rejectBit1), ...
    sum(behaviorCorrect == 0 & rejectBit1));
fprintf('HC / LC primary correct-clean: %d / %d\n', ...
    sum(primaryCorrectClean & eegBin <= 5), ...
    sum(primaryCorrectClean & eegBin >= 6));
disp(FINAL_COUNTS);
fprintf('Ledger rows/columns: %d / %d\n', ...
    height(LEDGER),width(LEDGER));
fprintf('Ledger written and re-read successfully: 1\n');
fprintf('Ledger path:\n%s\n',ledgerFile);

%% Local conversion helpers

function index = localFindHeader(headers,name)
index = find(headers == string(name),1);
assert(~isempty(index), ...
    'Missing required behavior column: %s',name);
end

function output = localTextColumn(input)
output = strings(numel(input),1);
for index = 1:numel(input)
    value = input{index};
    if isempty(value)
        output(index) = missing;
    elseif isstring(value)
        output(index) = value;
    elseif ischar(value)
        output(index) = string(value);
    elseif isnumeric(value) || islogical(value)
        if isscalar(value) && isnan(double(value))
            output(index) = missing;
        else
            output(index) = string(value);
        end
    else
        output(index) = string(value);
    end
end
end

function output = localNumericColumn(input)
output = nan(numel(input),1);
for index = 1:numel(input)
    value = input{index};
    if isnumeric(value) || islogical(value)
        if isscalar(value)
            output(index) = double(value);
        end
    elseif isstring(value) || ischar(value)
        output(index) = str2double(string(value));
    end
end
end
