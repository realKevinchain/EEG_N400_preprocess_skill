%% Prepare a coordinate-complete derived input for the 905 03A run.
% The source import is preserved. Only missing XYZ fields are completed
% from the project digitizer file after a similarity fit on shared labels.

addpath(genpath('/Users/kevinchain/Documents/MATLAB/eeglab2026.0.0'));
if exist('cfg','var') == 1 && isfield(cfg,'subject')
    subject = cfg.subject;
else
    subject = '03A';
end
projectRoot = '/Users/kevinchain/Desktop/N400_project';
sourceDir = fullfile(projectRoot,'input_set');
sourceSet = [subject '_imported.set'];
% Coordinate-complete files are working intermediates, never result outputs.
targetDir = fullfile(projectRoot,'working_905',subject,'input_set');
targetSet = sourceSet;
digitizerFile = '/Users/kevinchain/Desktop/N400_project/metadata/64 -新电极帽.DAT';

if exist(fullfile(targetDir,targetSet),'file') == 2
    fprintf('Coordinate-complete derived input already exists: %s\n', ...
        fullfile(targetDir,targetSet));
    return
end
if exist(targetDir,'dir') ~= 7
    mkdir(targetDir);
end

EEG = pop_loadset('filename',sourceSet,'filepath',sourceDir);
assert(EEG.nbchan == 67);
labels = upper(strtrim(string({EEG.chanlocs.labels})))';

fid = fopen(digitizerFile,'r');
assert(fid >= 0,'Cannot open digitizer file: %s',digitizerFile);
cleanup = onCleanup(@() fclose(fid));
raw = textscan(fid,'%s %f %f %f %f','MultipleDelimsAsOne',true, ...
    'CollectOutput',true);
datLabels = upper(strtrim(string(raw{1})));
datPosition = raw{2}(:,2:4);
assert(size(datPosition,2) == 3);

existingXYZ = nan(EEG.nbchan,3);
for k = 1:EEG.nbchan
    values = [EEG.chanlocs(k).X EEG.chanlocs(k).Y EEG.chanlocs(k).Z];
    if numel(values) == 3 && all(isfinite(values))
        existingXYZ(k,:) = values;
    end
end
datXYZ = nan(EEG.nbchan,3);
hasDigitizer = false(EEG.nbchan,1);
for k = 1:EEG.nbchan
    hit = find(datLabels == labels(k),1);
    if ~isempty(hit)
        datXYZ(k,:) = datPosition(hit,:);
        hasDigitizer(k) = true;
    end
end
known = hasDigitizer & all(isfinite(existingXYZ),2);
missing = ~all(isfinite(existingXYZ),2);
assert(any(missing));
reserved = ismember(labels,upper(["M1" "M2" "CB1" "CB2" "VEOG" "HEOG" "TRIGGER"]));
missingScalp = missing & ~reserved;
assert(all(hasDigitizer(missingScalp)), ...
    'Missing XYZ channels are absent from the project digitizer file.');
assert(sum(known) >= 10);

% Row-vector similarity fit: digitizer coordinates -> existing EEGLAB XYZ.
source = datXYZ(known,:);
target = existingXYZ(known,:);
sourceCenter = mean(source,1);
targetCenter = mean(target,1);
source0 = source-sourceCenter;
target0 = target-targetCenter;
[U,S,V] = svd(source0'*target0,'econ');
R = U*V';
if det(R) < 0
    U(:,end) = -U(:,end);
    R = U*V';
end
scale = sum((source0*R).*target0,'all')/sum(source0.^2,'all');
assert(isfinite(scale) && scale > 0);
transform = (datXYZ-sourceCenter)*R*scale+targetCenter;
fitResidual = transform(known,:)-target;
fitRMS = sqrt(mean(fitResidual.^2,'all'));
fitMax = max(abs(fitResidual),[],'all');

missingLabels = labels(missingScalp);
for k = find(missingScalp)'
    EEG.chanlocs(k).X = transform(k,1);
    EEG.chanlocs(k).Y = transform(k,2);
    EEG.chanlocs(k).Z = transform(k,3);
end
EEG.chanlocs = convertlocs(EEG.chanlocs,'cart2all');
completedXYZ = nan(EEG.nbchan,3);
for k = 1:EEG.nbchan
    values = [EEG.chanlocs(k).X EEG.chanlocs(k).Y EEG.chanlocs(k).Z];
    if numel(values) == 3
        completedXYZ(k,:) = values;
    end
end
retainedScalp = ~reserved;
assert(all(isfinite(completedXYZ(retainedScalp,:)),'all'));
EEG.etc.n400_905_coordinate_completion = struct( ...
    'source_import',fullfile(sourceDir,sourceSet), ...
    'digitizer_file',digitizerFile, ...
    'method','similarity_fit_on_shared_channel_labels', ...
    'filled_labels',{cellstr(missingLabels)}, ...
    'shared_fit_channel_count',sum(known), ...
    'fit_rms_uv_like_coordinate_units',fitRMS, ...
    'fit_max_abs_coordinate_units',fitMax, ...
    'scale',scale, ...
    'rotation',R, ...
    'translation',targetCenter-sourceCenter*R*scale);
EEG.etc.n400_905_coordinate_completion.original_preserved = true;
EEG.setname = [subject '_imported_coordinate_complete_905'];
EEG = eeg_checkset(EEG);
EEG = pop_saveset(EEG,'filename',targetSet,'filepath',targetDir);
fprintf('Saved coordinate-complete derived input: %s\n', ...
    fullfile(targetDir,targetSet));
fprintf('Filled labels: %s; shared channels=%d; fit RMS=%.6g; max=%.6g.\n', ...
    strjoin(missingLabels,','),sum(known),fitRMS,fitMax);
