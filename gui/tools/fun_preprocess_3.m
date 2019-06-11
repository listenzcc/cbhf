function fun_preprocess_3(appPath, pathname, hObject)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
for j = 3 : 4
    if isKey(path_map, sprintf('_____preprocessed_%d', j))
        return
    end
end

workpath = fullfile(pathname, '_____preprocessed_2');
load(fullfile(appPath, 'resources', 'b_normalise.mat'), 'matlabbatch')

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm =...
    {fullfile(appPath, 'resources', 'b_TPM.nii')};

meanfile = dir(fullfile(workpath, 'mean*.nii'));
vol = [fullfile(workpath, meanfile.name), ',1'];
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {vol};

load(fullfile(workpath, 'fun_filenames.mat'), 'fun_filenames')
len = length(fun_filenames);
resample = cell(len, 1);
for j = 1 : len
    resample{j} = [fullfile(workpath, fun_filenames{j}), ',1'];
end
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = resample;

spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

movefile(...
    fullfile(pathname, '_____preprocessed_2'),...
    fullfile(pathname, '_____preprocessed_3'));

end
