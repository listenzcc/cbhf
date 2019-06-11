function fun_preprocess_4(appPath, pathname, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
for j = 4
    if isKey(path_map, sprintf('_____preprocessed_%d', j))
        return
    end
end

workpath = fullfile(pathname, '_____preprocessed_3');
load(fullfile(appPath, 'resources', 'b_smooth.mat'), 'matlabbatch')

load(fullfile(workpath, 'fun_filenames.mat'), 'fun_filenames')
len = length(fun_filenames);
data = cell(len, 1);
for j = 1 : len
    data{j} = [fullfile(workpath, ['w', fun_filenames{j}]), ',1'];
end
matlabbatch{1}.spm.spatial.smooth.data = data;

spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

movefile(...
    fullfile(pathname, '_____preprocessed_3'),...
    fullfile(pathname, '_____preprocessed_4'));

end
