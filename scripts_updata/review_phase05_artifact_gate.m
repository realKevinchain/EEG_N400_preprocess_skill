%% Read-only condition-blind helper for 902/828update Phase 5 Gate D.

run(fullfile(fileparts(mfilename('fullpath')),'init_828_runtime.m'));
epochPath = fullfile(cfg.epochs_dir,cfg.epochs_set);
assert(exist(epochPath,'file') == 2,'Run Phase 5 once first.');
EEG = pop_loadset('filename',cfg.epochs_set,'filepath',cfg.epochs_dir);
assert(EEG.trials == cfg.expected_trials);
scalp = setdiff(cfg.eeg_channels,[cfg.m1_channel cfg.m2_channel]);
REVIEW = pop_select(EEG,'channel',scalp);
for k = 1:numel(REVIEW.event)
    REVIEW.event(k).type = 'target';
end
REVIEW.setname = sprintf('%s pooled condition-blind epochs',cfg.subject);
fprintf(['Opening all %d baseline-corrected epochs. Conditions are hidden. ' ...
    'This helper is read-only: record epoch numbers only; do not mark, ' ...
    'delete, or save here. If using ERPLAB Simple Voltage Threshold, treat ' ...
    'it only as a candidate screen in a separate review copy, manually ' ...
    'UPDATE MARKS, never REJECT, save as <ID>_gateD_manual_review.set, ' ...
    'and audit all reject fields before entering the unified list.\n'], ...
    REVIEW.trials);
pop_eegplot(REVIEW,1,1,0);
