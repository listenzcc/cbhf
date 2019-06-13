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
        sprintf('%s4', filepath), sprintf('sw%s%s', name, ext));
end

% Read data
console_report(handles, 'Reading images ...')
vols = spm_vol(paths);
mat_4D = vols{1}.mat;
imgsz = vols{1}.dim;
dvols = cell2mat(vols);
dvols = dvols(6:end); % Remove first 5 TR to pervent artificial
img_4D = spm_read_vols(dvols);
console_report(handles, 'Reading images done')

% Set mm of hippocampal
mm_hippo = [-24, -18, -18];

% Calculate position of hippocampal
position_hippo = fun_mm2position(mm_hippo, mat_4D);

% Read hippocampal mask in mm
mmgrid_hippo_mask = fun_get_mmgrid_ROI(...
    spm_vol(fullfile(resources_path, 'Hippocampus.nii')));
mmgrid_parietal_mask = fun_get_mmgrid_ROI(...
    spm_vol(fullfile(resources_path, 'BA39_40.nii')));

% Make position set of hippocampal based on mmgrid_hippo_mask
set_hippo = containers.Map;
for k = keys(mmgrid_hippo_mask)
    mm = fun_str2arr(k{1});
    p = fun_mm2position(mm, mat_4D);
    if ~fun_check_inside(p, imgsz)
        continue
    end
    set_hippo(fun_arr2str(p)) = 1;
end

set_parietal = containers.Map;
for k = keys(mmgrid_parietal_mask)
    mm = fun_str2arr(k{1});
    p = fun_mm2position(mm, mat_4D);
    if ~fun_check_inside(p, imgsz)
        continue
    end
    set_parietal(fun_arr2str(p)) = 1;
end

% Calculate time series
ts_hippo = img_4D(position_hippo(1), position_hippo(2), position_hippo(3), :);
ts_hippo = spm_detrend(squeeze(ts_hippo), 1);

ts_hippo_ROI = nan(size(img_4D, 4), length(set_hippo));
ks = keys(set_hippo);
for j = 1 : length(ks)
    p = fun_str2arr(ks{j});
    ts = img_4D(p(1), p(2), p(3), :);
    ts_hippo_ROI(:, j) = spm_detrend(squeeze(ts), 1);
end

ts_parietal_ROI = nan(size(img_4D, 4), length(set_parietal));
ks = keys(set_parietal);
for j = 1 : length(ks)
    p = fun_str2arr(ks{j});
    ts = img_4D(p(1), p(2), p(3), :);
    ts_parietal_ROI(:, j) = spm_detrend(squeeze(ts), 1);
end

ts_global = mean(mean(mean(img_4D)));
ts_global = spm_detrend(squeeze(ts_global), 1);

% Remove global signal
new_ts_hippo = fun_regout(ts_hippo, ts_global);
new_ts_hippo_ROI = fun_regout(ts_hippo_ROI, ts_global);
new_ts_parietal_ROI = fun_regout(ts_parietal_ROI, ts_global);

% Band pass filter
fs = 1000 / subject_info_.RepetitionTime; % Hz

filtered_ts_hippo = bandpass(new_ts_hippo, [0.01, 0.1], fs);

filtered_ts_hippo_ROI = bandpass(new_ts_hippo_ROI, [0.01, 0.1], fs);

filtered_ts_parietal_ROI = bandpass(new_ts_parietal_ROI, [0.01, 0.1], fs);

% Plot time series
set(gcf, 'CurrentAxes', handles.axes_hippo_ts)
lines = plot(filtered_ts_hippo);
legend(lines, {'bandpassed ts'})
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'Box', 'off')

f = gcf;
% figure, bandpass(new_ts_hippo, [0.01, 0.1], fs)
% figure,
% subplot(2, 1, 1), plot(filtered_ts_hippo_ROI), title('hippo')
% subplot(2, 1, 2), plot(filtered_ts_parietal_ROI), title('parietal')
c = corr(filtered_ts_hippo_ROI, filtered_ts_parietal_ROI);
size(c)
figure
subplot(2, 2, 1), imagesc(c)
cc = c;
[x, y] = sort(max(c, [], 2), 'descend');
cc = cc(y, :);
[x, y] = sort(max(c, [], 1), 'descend');
cc = cc(:, y);
subplot(2, 2, 2), imagesc(cc)
subplot(2, 2, 3), hist(c(:))
figure(f);

end