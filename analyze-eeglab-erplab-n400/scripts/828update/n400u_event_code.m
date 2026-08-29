function code = n400u_event_code(value)
% Convert numeric or string EEGLAB event types to a numeric code.
if isnumeric(value)
    code = double(value);
else
    token = regexp(char(string(value)),'-?\d+','match','once');
    code = str2double(token);
end
end
