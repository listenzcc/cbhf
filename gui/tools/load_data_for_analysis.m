function load_data_for_analysis(handles)

global gvar
%% Loading mask
% Read hippocampal mask in mm
console_report(handles, 'Reading masks ...')
mmgrid_hippo_mask = fun_get_mmgrid_ROI(...
    spm_vol(fullfile(gvar.resources_path, 'Hippocampus.nii')));
mmgrid_parietal_mask = fun_get_mmgrid_ROI(...
    spm_vol(fullfile(gvar.resources_path, 'BA39_40.nii')));
console_report(handles, 'Reading masks done')

% Inject masks into userdata
gvar.mmgrid_hippo_mask = mmgrid_hippo_mask;
gvar.mmgrid_parietal_mask = mmgrid_parietal_mask;

%% Loading T1 image
% Read T1 image
console_report(handles, 'Reading T1 img ...')
vol = spm_vol(fullfile(gvar.resources_path, 'canonical', 'single_subj_T1.nii'));
gvar.vol_T1 = vol.mat;
img_T1 = spm_read_vols(vol);
gvar.img_T1 = nan(max(size(img_T1)), max(size(img_T1)), max(size(img_T1)));
gvar.img_T1(1:size(img_T1, 1), 1:size(img_T1, 2), 1:size(img_T1, 3)) = img_T1;
gvar.img_T1 = img_T1;
console_report(handles, 'Reading T1 img done')

% Read colormap
load(fullfile(gvar.resources_path, 'cm.mat'), 'cm')
gvar.colormap = cm;

%% Loading img_4D
% Make preprocessed path
this_preprocessed_path = fullfile(gvar.subject_id_path, '_____preprocessed_4');

% Load filenames of raw nii file
load(fullfile(this_preprocessed_path, 'filenames.mat'), 'raw_nii_fnames')

% Make paths of swfile
len = length(raw_nii_fnames);
paths = cell(len, 1);
for j = 1 : len
    [filepath, name, ext] = fileparts(raw_nii_fnames{j});
    paths{j} = fullfile(this_preprocessed_path, sprintf('sw%s', raw_nii_fnames{j}));
end

% Read data
console_report(handles, 'Reading images ...')
vols = spm_vol(paths);
vol_4D = vols{1};
dvols = cell2mat(vols);
dvols = dvols(11:end); % Remove first 10 TR to pervent artificial
img_4D = spm_read_vols(dvols);
console_report(handles, 'Reading images done')

% Inject img_4D and vol_4D into userdata
gvar.vol_4D = vol_4D;
gvar.img_4D = img_4D;

console_report(handles, 'Loading data done')

end