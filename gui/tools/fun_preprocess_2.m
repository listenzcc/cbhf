function fun_preprocess_2(appPath, pathname, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
for j = 2 : 4
    if isKey(path_map, sprintf('_____preprocessed_%d', j))
        return
    end
end

workpath = fullfile(pathname, '_____preprocessed_1');
load(fullfile(appPath, 'resources', 'b_realign.mat'), 'matlabbatch')

load(fullfile(workpath, 'fun_filenames.mat'), 'fun_filenames')

len = length(fun_filenames);
data = {cell(len, 1)};
for j = 1 : len
    data{1}{j} = [fullfile(workpath, fun_filenames{j}), ',1'];
end
matlabbatch{1}.spm.spatial.realign.estwrite.data = data;

spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

movefile(...
    fullfile(pathname, '_____preprocessed_1'),...
    fullfile(pathname, '_____preprocessed_2'));

end
