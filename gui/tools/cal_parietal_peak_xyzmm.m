function cal_parietal_peak_xyzmm(handles)
global gvar

%% Default init
xmm = -47;
ymm = -68;
zmm = 36;

% Prepare time series
ts_hm = gvar.head_motion;
ts_global = mean(mean(mean(gvar.img_4D)));
ts_global = spm_detrend(squeeze(ts_global), 1);

corr_map_parietal_T1 = nan(gvar.vol_T1.dim);

%% Calculate FC
ts_mat = [];
p_fun_mat = [];
p_T1_mat = [];
for k = keys(gvar.mmgrid_parietal_mask)
    mm = fun_str2arr(k{1});
    
    p_T1 = fun_mm2position(mm, gvar.vol_T1.mat);
    if ~fun_check_inside(p_T1, gvar.vol_T1.dim)
        continue
    end
    
    p_fun = fun_mm2position(mm, gvar.vol_4D.mat);
    if ~fun_check_inside(p_fun, gvar.vol_4D.dim)
        continue
    end
    
    ts = gvar.img_4D(p_fun(1), p_fun(2), p_fun(3), :);
    
    ts_mat = [ts_mat, squeeze(ts)];
    p_fun_mat = [p_fun_mat, p_fun];
    p_T1_mat = [p_T1_mat, p_T1];
end

[detrend_ts, befor_bandpass_ts, final_ts] = process_ts(ts_mat, ts_hm, ts_global);
corr_map = fun_corr(final_ts, gvar.ts_hippo);

for j = 1 : size(p_T1_mat, 2)
    c = abs(corr_map(j));
    if isnan(corr_map_parietal_T1(p_T1_mat(1, j), p_T1_mat(2, j), p_T1_mat(3, j)))
        corr_map_parietal_T1(p_T1_mat(1, j), p_T1_mat(2, j), p_T1_mat(3, j)) = c;
    end
    if corr_map_parietal_T1(p_T1_mat(1, j), p_T1_mat(2, j), p_T1_mat(3, j)) < c
        corr_map_parietal_T1(p_T1_mat(1, j), p_T1_mat(2, j), p_T1_mat(3, j)) = c;
    end
end
gvar.corr_map_parietal_T1 = corr_map_parietal_T1;

%% Report and save data
set(handles.text_coor_x, 'String', sprintf('%.2f', xmm))
set(handles.text_coor_y, 'String', sprintf('%.2f', ymm))
set(handles.text_coor_z, 'String', sprintf('%.2f', zmm))
console_report(handles,...
    sprintf('TMS point in Parietal: %.2f, %.2f, %.2f', xmm, ymm, zmm))
gvar.parietal_mm = [xmm, ymm, zmm];

end