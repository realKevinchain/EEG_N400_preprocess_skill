function n400u_assert_dataset_absent(path)
% Stop if either a SET or its paired FDT output already exists.
[folder,name,extension] = fileparts(path);
assert(strcmpi(extension,'.set'),'Expected a .set path: %s',path);
setPath = fullfile(folder,[name '.set']);
fdtPath = fullfile(folder,[name '.fdt']);
assert(exist(setPath,'file') == 0 && exist(fdtPath,'file') == 0, ...
    'Dataset output exists; stopped without overwriting: %s',path);
end
