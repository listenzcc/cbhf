function fun_preprocess_1

global gvar

% Return if dicom import already done
for j = 1 : 4
    if exist(fullfile(gvar.subject_id_path, sprintf('_____preprocessed_%d', j)), 'dir')
        return
    end
end

% Check DICOM files
DICOM_paths = get_all_file_path(gvar.subject_rawfile_path);
for j = 1 : length(DICOM_paths)
    if ~exist(DICOM_paths{j}, 'file')
        warndlg(sprintf('%s目录异常，请重新载入数据', gvar.subject_rawfile_path))
        return
    end
end

% Make preprocess path
this_preprocess_path = fullfile(gvar.subject_id_path, '_____preprocessed_');
[a, b, c] = mkdir(this_preprocess_path);

% Load batch file of DICOM import
load(fullfile(gvar.resources_path, 'b_DICOM_import.mat'), 'matlabbatch')

% Inject data
matlabbatch{1}.spm.util.import.dicom.outdir = {this_preprocess_path};
matlabbatch{1}.spm.util.import.dicom.data = DICOM_paths;

% Run batch
spm_jobman('initcfg')
spm_jobman('run', matlabbatch)

% Save imported nii files
[raw_nii_paths, raw_nii_fnames] = get_all_file_path(...
    fullfile(gvar.subject_id_path, '_____preprocessed_'));
gvar.raw_nii_fnames = raw_nii_fnames;
save(fullfile(gvar.subject_id_path, '_____preprocessed_', 'filenames.mat'), 'raw_nii_fnames')

% Stage preprocessed dir
movefile(...
    fullfile(gvar.subject_id_path, '_____preprocessed_'),...
    fullfile(gvar.subject_id_path, '_____preprocessed_1'));

end
