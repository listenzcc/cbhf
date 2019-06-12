function report_hippo_ts(handles)

global subject_id_path
global resources_path
global subject_info_

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
        sprintf('%s4', filepath),...
        sprintf('sw%s%s', name, ext));
end

% Read data
console_report(handles, 'Reading images ...')
vols = spm_vol(paths);
mat = vols{1}.mat;
dvols = cell2mat(vols);
img_4D = spm_read_vols(dvols(6:end));
size(img_4D)
console_report(handles, 'Reading images done')

% Set mm of hippocampal
mm_hippo = [-24, -18, -18];

% Calculate position of hippocampal
position_hippo = fun_mm2position(mm_hippo, mat);

% Calculate time series
ts_hippo = img_4D(position_hippo(1), position_hippo(2), position_hippo(3), :);
ts_hippo = squeeze(ts_hippo);
ts_hippo = spm_detrend(ts_hippo, 1);

ts_global = mean(mean(mean(img_4D)));
ts_global = squeeze(ts_global);
ts_global = spm_detrend(ts_global, 1);

new_ts_hippo = fun_regout(ts_hippo, ts_global);

fs = 1000 / subject_info_.RepetitionTime; % Hz
filtered_ts_hippo = bandpass(new_ts_hippo, [0.01, 0.1], fs);

% Plot time series
set(gcf, 'CurrentAxes', handles.axes_hippo_ts)
lines = plot(filtered_ts_hippo);
legend(lines, {'bandpassed ts'})
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'Box', 'off')

f = gcf;
figure, bandpass(new_ts_hippo, [0.01, 0.1], fs)
figure(f);
end