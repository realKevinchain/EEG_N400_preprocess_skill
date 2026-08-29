function n400u_write_stage_log(cfg,stage,lines)
% Write one immutable plain-text stage log.
path = fullfile(cfg.logs_dir,sprintf( ...
    '%s_828update_%s_%s_pass.txt',cfg.subject,cfg.reference_tag,stage));
assert(exist(path,'file') == 0, ...
    'Stage log exists; stopped without overwriting: %s',path);
fid = fopen(path,'w');
assert(fid ~= -1);
closer = onCleanup(@() fclose(fid));
fprintf(fid,'Participant: %s\n',cfg.subject);
fprintf(fid,'Pipeline: 828update-six-stage\n');
fprintf(fid,'Stage: %s\n',stage);
lines = string(lines(:));
for k = 1:numel(lines)
    fprintf(fid,'%s\n',char(lines(k)));
end
clear closer
end
