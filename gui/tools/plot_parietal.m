function plot_parietal(handles)

global gvar

%% T1 image
% Calculate position of parietal
position_parietal_T1 = fun_mm2position(gvar.parietal_mm, gvar.vol_T1.mat);

img_T1 = uint8(gvar.img_T1*128);
img_T1(~isnan(gvar.corr_map_parietal_T1)) =...
    gvar.corr_map_parietal_T1(~isnan(gvar.corr_map_parietal_T1)) * 128 + 128;
% Make position set of parietal based on mmgrid_hippo_mask
% for k = keys(gvar.mmgrid_parietal_mask)
%     mm = fun_str2arr(k{1});
%     p = fun_mm2position(mm, gvar.vol_T1.mat);
%     if ~fun_check_inside(p, gvar.vol_T1.dim)
%         continue
%     end
%     img_T1(p(1), p(2), p(3)) = 200;
% end

% Draw T1 image
draw_TMP(img_T1, position_parietal_T1, gvar.colormap,...
    handles.axes_parietal_x, handles.axes_parietal_y, handles.axes_parietal_z)

%% Function image
% Calculate position of parietal peak
position_parietal_fun = fun_mm2position(gvar.parietal_mm, gvar.vol_4D.mat);

% Calculate time series
ts_parietal = gvar.img_4D(position_parietal_fun(1), position_parietal_fun(2), position_parietal_fun(3), :);
ts_parietal = spm_detrend(squeeze(ts_parietal), 1);

% Remove head motion
if gvar.remove_head_motion == 1
    hm = gvar.head_motion;
    for s = hm
        ts_parietal = fun_regout(ts_parietal, s);
    end
end

% Remove global
if gvar.remove_head_motion == 1
    ts_global = mean(mean(mean(gvar.img_4D)));
    ts_global = spm_detrend(squeeze(ts_global), 1);
    ts_parietal = fun_regout(ts_parietal, ts_global);
end

% Band pass filter
fs = 1000 / gvar.subject_info_.RepetitionTime;
ts_parietal = bandpass(ts_parietal, gvar.bandpass_filter, fs);

% Plot time series
set(gcf, 'CurrentAxes', handles.axes_parietal_ts)
lines = plot([gvar.ts_hippo, ts_parietal]);
set(lines, 'LineWidth', 2)
legend(lines, {'Hippocampus', 'Parietal'}, 'Location', 'best')
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'Box', 'off')

end