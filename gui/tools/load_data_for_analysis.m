function load_data_for_analysis(handles)
console_report(handles, 'Loading data ...')

userdata = struct;

%% Loading mask
global resources_path

% Read hippocampal mask in mm
console_report(handles, 'Reading masks ...')
mmgrid_hippo_mask = fun_get_mmgrid_ROI(...
    spm_vol(fullfile(resources_path, 'Hippocampus.nii')));
mmgrid_parietal_mask = fun_get_mmgrid_ROI(...
    spm_vol(fullfile(resources_path, 'BA39_40.nii')));
console_report(handles, 'Reading masks done')

% Inject masks into userdata
userdata.mmgrid_hippo_mask = mmgrid_hippo_mask;
userdata.mmgrid_parietal_mask = mmgrid_parietal_mask;

%% Loading img_4D
global subject_id_path

% Make preprocessed path
this_preprocessed_path = fullfile(subject_id_path, '_____preprocessed_4');

% Load filenames of raw nii file
load(fullfile(this_preprocessed_path, 'filenames.mat'), 'raw_nii_fnames')

% Make paths of swfile
len = length(raw_nii_fnames);
paths = cell(len, 1);
for j = 1 : len
    [filepath, name, ext] = fileparts(raw_nii_fnames{j});
    paths{j} = fullfile(...
        sprintf('%s4', filepath), sprintf('sw%s%s', name, ext));
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
userdata.vol_4D = vol_4D;
userdata.img_4D = img_4D;

set(handles.pushbutton_data_holder, 'UserData', userdata)

console_report(handles, 'Loading data done')

end