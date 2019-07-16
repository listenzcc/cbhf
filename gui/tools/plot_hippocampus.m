function plot_hippocampus(handles)

global gvar

%% T1 image
% Calculate position of hippocampal
position_hippo_T1 = fun_mm2position(gvar.hippo_mm, gvar.vol_T1.mat);

img_T1 = uint8(gvar.img_T1*128);
% Make position set of hippocampal based on mmgrid_hippo_mask
for k = keys(gvar.mmgrid_hippo_mask)
    mm = fun_str2arr(k{1});
    p = fun_mm2position(mm, gvar.vol_T1.mat);
    if ~fun_check_inside(p, gvar.vol_T1.dim)
        continue
    end
    img_T1(p(1), p(2), p(3)) = 200;
end

% Draw T1 image
draw_TMP(img_T1, position_hippo_T1, gvar.colormap,...
    handles.axes_hippo_x, handles.axes_hippo_y, handles.axes_hippo_z)

%% Function image
% Calculate position of hippocampal
position_hippo_fun = fun_mm2position(gvar.hippo_mm, gvar.vol_4D.mat);

% Calculate time series
raw_ts = gvar.img_4D(position_hippo_fun(1), position_hippo_fun(2), position_hippo_fun(3), :);
ts_hm = gvar.head_motion;
ts_global = mean(mean(mean(gvar.img_4D)));
ts_global = spm_detrend(squeeze(ts_global), 1);

[detrend_ts, befor_bandpass_ts, final_ts] = process_ts(raw_ts, ts_hm, ts_global);

raw_ts_hippo = detrend_ts;
gvar.ts_hippo_before_bp = befor_bandpass_ts;
gvar.ts_hippo = final_ts;

% Plot time series
set(gcf, 'CurrentAxes', handles.axes_hippo_ts)

timeline = gvar.timeline(fix(gvar.crop_from/gvar.tr):fix(gvar.crop_to/gvar.tr));

lines = plot(timeline, [raw_ts_hippo, gvar.ts_hippo]);
set(lines(2), 'LineWidth', 2)
set(lines(2), 'Color', 'Black')
set(lines(1), 'Color', 0.5 + zeros(1, 3))
legend(lines, {'Raw', 'Process'}, 'Location', 'best')

xlim([min(gvar.timeline), max(gvar.timeline)])
set(gca, 'XTick', [0 : 60 : max(gvar.timeline)])
set(gca, 'YTick', [])
set(gca, 'Box', 'off')

end