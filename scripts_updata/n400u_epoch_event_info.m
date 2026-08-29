function [eventIndex,eventItem,flag] = n400u_epoch_event_info(EEG,ep)
% Return the single time-locking event/index/flag for an ERPLAB epoch.
eventIndex = EEG.epoch(ep).event;
eventItem = EEG.epoch(ep).eventitem;
if iscell(eventIndex), eventIndex = eventIndex{1}; end
if iscell(eventItem), eventItem = eventItem{1}; end
assert(isscalar(eventIndex) && isscalar(eventItem), ...
    'Expected one time-locking event in epoch %d.',ep);
flag = EEG.epoch(ep).eventflag;
if iscell(flag), flag = flag{1}; end
assert(isscalar(flag));
end
