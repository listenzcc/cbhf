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

% Calculate empirical
gvar.parietal_mm_emperical = [xmm, ymm, zmm];
pp = fun_mm2position(gvar.parietal_mm_emperical, gvar.vol_4D.mat);
ts_empirical = squeeze(gvar.img_4D(pp(1), pp(2), pp(3), :));

[detrend_ts, befor_bandpass_ts, final_ts] = process_ts(ts_empirical, ts_hm, ts_global);
gvar.corr_empirical = abs(fun_corr(final_ts, gvar.ts_hippo));
if isnan(gvar.corr_empirical)
    gvar.corr_empirical = 0;
end


%% Calculate FC
ts_mat = [];
p_fun_mat = [];
p_T1_mat = [];
for k = keys(gvar.mmgrid_parietal_mask)
    mm = fun_str2arr(k{1});
    
    if gvar.left_only == 1
        if mm(1) > 0
            continue
        end
    end
    
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

p_selector_mat = p_T1_mat;
vol_selector_mat = gvar.vol_T1.mat;

max_c = 0;
for j = 1 : size(p_selector_mat, 2)
    c = abs(corr_map(j));
    if c > max_c
        max_c = c;
        max_mm = fun_position2mm(p_selector_mat(:, j), vol_selector_mat);
    end
    if isnan(corr_map_parietal_T1(p_selector_mat(1, j), p_selector_mat(2, j), p_selector_mat(3, j)))
        corr_map_parietal_T1(p_selector_mat(1, j), p_selector_mat(2, j), p_selector_mat(3, j)) = c;
    end
    if corr_map_parietal_T1(p_selector_mat(1, j), p_selector_mat(2, j), p_selector_mat(3, j)) < c
        corr_map_parietal_T1(p_selector_mat(1, j), p_selector_mat(2, j), p_selector_mat(3, j)) = c;
    end
end
xmm = max_mm(1);
ymm = max_mm(2);
zmm = max_mm(3);

gvar.corr_map_parietal_T1 = corr_map_parietal_T1;

%% Report and save data
% set(handles.text_coor_x, 'String', sprintf('%.2f', xmm))
% set(handles.text_coor_y, 'String', sprintf('%.2f', ymm))
% set(handles.text_coor_z, 'String', sprintf('%.2f', zmm))
console_report(handles,...
    sprintf('TMS point in Parietal: %.2f, %.2f, %.2f', xmm, ymm, zmm))
gvar.parietal_mm = [xmm, ymm, zmm];

end