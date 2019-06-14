function plot_hippo(handles)

global gvar

%% T1 image
% Calculate position of hippocampal
position_hippo_T1 = fun_mm2position(gvar.hippo_mm, gvar.vol_T1);

img_T1 = uint8(gvar.img_T1*128);
% Make position set of hippocampal based on mmgrid_hippo_mask
for k = keys(gvar.mmgrid_hippo_mask)
    mm = fun_str2arr(k{1});
    p = fun_mm2position(mm, gvar.vol_T1);
    if ~fun_check_inside(p, size(img_T1))
        continue
    end
    img_T1(p(1), p(2), p(3)) = 200;
end

% Draw T1 image
set(gcf, 'CurrentAxes', handles.axes_hippo_x)
img_x = squeeze(img_T1(position_hippo_T1(1), :, :));
imshow(img_x', 'Colormap', gvar.colormap)
set(gca, 'YDir', 'normal')
line([position_hippo_T1(2), position_hippo_T1(2)], get(gca, 'ylim'), 'color', 'green');
line(get(gca, 'xlim'), [position_hippo_T1(3), position_hippo_T1(3)], 'color', 'blue');

set(gcf, 'CurrentAxes', handles.axes_hippo_y)
img_y = squeeze(img_T1(:, position_hippo_T1(2), :));
imshow(img_y(end:-1:1, :)', 'Colormap', gvar.colormap)
set(gca, 'YDir', 'normal')
line(size(img_T1, 1) + 1 - [position_hippo_T1(1), position_hippo_T1(1)], get(gca, 'xlim'), 'color', 'red');
line(get(gca, 'xlim'), [position_hippo_T1(3), position_hippo_T1(3)], 'color', 'blue');
xlim([0.5, 109.5])

set(gcf, 'CurrentAxes', handles.axes_hippo_z)
img_z = squeeze(img_T1(:, :, position_hippo_T1(3)));
imshow(img_z, 'Colormap', gvar.colormap)
set(gca, 'YDir', 'normal')
line([position_hippo_T1(2), position_hippo_T1(2)], get(gca, 'ylim'), 'color', 'green');
line(get(gca, 'xlim'), [position_hippo_T1(1), position_hippo_T1(1)], 'color', 'red');

%% Function image
% Calculate position of hippocampal
position_hippo_fun = fun_mm2position(gvar.hippo_mm, gvar.vol_4D.mat);

% Calculate time series
ts_hippo = gvar.img_4D(position_hippo_fun(1), position_hippo_fun(2), position_hippo_fun(3), :);
ts_hippo = spm_detrend(squeeze(ts_hippo), 1);
raw_ts_hippo = ts_hippo;

% Remove head motion
if gvar.remove_head_motion == 1
    hm = gvar.head_motion;
    for s = hm
        ts_hippo = fun_regout(ts_hippo, s);
    end
end

% Remove global
if gvar.remove_head_motion == 1
    ts_global = mean(mean(mean(gvar.img_4D)));
    ts_global = spm_detrend(squeeze(ts_global), 1);
    ts_hippo = fun_regout(ts_hippo, ts_global);
end

% Band pass filter
fs = 1000 / gvar.subject_info_.RepetitionTime;
gvar.ts_hippo_before_bp = ts_hippo;
ts_hippo = bandpass(ts_hippo, gvar.bandpass_filter, fs);

gvar.ts_hippo = ts_hippo;

% Plot time series
set(gcf, 'CurrentAxes', handles.axes_hippo_ts)
lines = plot([raw_ts_hippo, ts_hippo]);
set(lines(2), 'LineWidth', 2)
legend(lines, {'Raw', 'Process'}, 'Location', 'best')
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'Box', 'off')

end