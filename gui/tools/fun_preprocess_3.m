function fun_preprocess_3

global gvar

% Return if normalize already done
for j = 3 : 4
    if exist(fullfile(gvar.subject_id_path, sprintf('_____preprocessed_%d', j)), 'dir')
        return
    end
end

% Make preprocess path
this_preprocess_path = fullfile(gvar.subject_id_path, '_____preprocessed_2');

% Load filenames of raw nii file
load(fullfile(this_preprocess_path, 'filenames.mat'), 'raw_nii_fnames')

% Load batch file of normalize
load(fullfile(gvar.resources_path, 'b_normalize.mat'), 'matlabbatch')

% Inject data
% 1. Inject template
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm =...
    {fullfile(gvar.resources_path, 'b_TPM.nii')};

% 2. Inject mean image to write
meanfile = dir(fullfile(this_preprocess_path, 'mean*.nii'));
vol = [fullfile(meanfile.folder, meanfile.name), ',1'];
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {vol};

% 3. Inject images to normalize
len = length(raw_nii_fnames);
resample = cell(len, 1);
for j = 1 : len
    resample{j} = fullfile(this_preprocess_path, sprintf('%s,1', raw_nii_fnames{j}));
end
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = resample;

% Run batch
spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

% Stage preprocessed dir
movefile(...
    fullfile(gvar.subject_id_path, '_____preprocessed_2'),...
    fullfile(gvar.subject_id_path, '_____preprocessed_3'));

end
