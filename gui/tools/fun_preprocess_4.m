function fun_preprocess_4

global gvar

% Return if smooth already done
for j = 4
    if exist(fullfile(gvar.subject_id_path, sprintf('_____preprocessed_%d', j)), 'dir')
        return
    end
end

% Make preprocess path
this_preprocess_path = fullfile(gvar.subject_id_path, '_____preprocessed_3');

% Load filenames of raw nii file
load(fullfile(this_preprocess_path, 'filenames.mat'), 'raw_nii_fnames')

% Load batch file of smooth
load(fullfile(gvar.resources_path, 'b_smooth.mat'), 'matlabbatch')

% Inject data
len = length(raw_nii_fnames);
data = cell(len, 1);
for j = 1 : len
    data{j} = fullfile(this_preprocess_path, sprintf('w%s,1', raw_nii_fnames{j}));
end
matlabbatch{1}.spm.spatial.smooth.data = data;

% Run batch
spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

% Stage preprocessed dir
movefile(...
    fullfile(gvar.subject_id_path, '_____preprocessed_3'),...
    fullfile(gvar.subject_id_path, '_____preprocessed_4'));

end
