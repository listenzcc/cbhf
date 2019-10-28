function plot_parietal(handles, parietal_mm, parietal_order)

global gvar

if nargin < 2 || isempty(parietal_mm)
    is_redraw = false;
    parietal_mm = gvar.parietal_mm;
else
    is_redraw = true;
    set(handles.text_coor_x, 'String', sprintf('%.2f', parietal_mm(1)))
    set(handles.text_coor_y, 'String', sprintf('%.2f', parietal_mm(2)))
    set(handles.text_coor_z, 'String', sprintf('%.2f', parietal_mm(3)))
end

%% T1 image
% Calculate position of parietal
position_parietal_T1 = fun_mm2position(parietal_mm, gvar.vol_T1.mat);

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

%% Inject popupmenu_selector
if is_redraw
    ud = get(handles.axes_parietal_hist, 'Userdata');
    set(ud.red_circle, 'XData', parietal_order)
    set(ud.red_circle, 'YData', ud.cp_box(parietal_order, 1))
else
    sz = size(gvar.corr_map_parietal_T1);
    idx = find(~isnan(gvar.corr_map_parietal_T1));
    len = length(idx);
    [p1, p2, p3] = ind2sub(sz, idx);
    
    corr_map_img_4D = zeros(gvar.vol_4D.dim);
    for j = 1 : len
        c = gvar.corr_map_parietal_T1(p1(j), p2(j), p3(j));
        mm = fun_position2mm([p1(j), p2(j), p3(j)], gvar.vol_T1.mat);
        pp = fun_mm2position(mm, gvar.vol_4D.mat);
        if corr_map_img_4D(pp(1), pp(2), pp(3)) < c
            corr_map_img_4D(pp(1), pp(2), pp(3)) = c;
        end
    end
    
    sz = size(corr_map_img_4D);
    idx = find(0 ~= corr_map_img_4D);
    len = length(idx);
    [p1, p2, p3] = ind2sub(sz, idx);
    
    cp_box = nan(length(idx)+1, 4); % cp_box: a matrix storage corr and point
    for j = 1 : len
        cp_box(j, 1) = corr_map_img_4D(p1(j), p2(j), p3(j));
        cp_box(j, 2:4) = fun_position2mm([p1(j), p2(j), p3(j)], gvar.vol_4D.mat);
    end
    cp_box(len+1, 1) = gvar.corr_empirical;
    cp_box(len+1, 2:4) = gvar.parietal_mm_emperical;
    
    [a, b] = sort(cp_box(:, 1), 'descend');
    cp_box = cp_box(b, :);
    
    set(handles.text_coor_x, 'String', sprintf('%.2f', cp_box(1, 2)))
    set(handles.text_coor_y, 'String', sprintf('%.2f', cp_box(1, 3)))
    set(handles.text_coor_z, 'String', sprintf('%.2f', cp_box(1, 4)))
    
    string = cell(len, 1);
    for j = 1 : len
        string{j} = sprintf('%.4f, %d, %d, %d', cp_box(j, :));
    end
    set(handles.popupmenu_selector, 'String', string)
    
    set(gcf, 'CurrentAxes', handles.axes_parietal_hist)
    bar(cp_box(:, 1))
    
    hold on
    % draw green circle as emperical node
    strings = get(handles.popupmenu_selector, 'String');
    for j = 1 : length(strings)
        if strfind(strings{j}, sprintf('%d, %d, %d', gvar.parietal_mm_emperical))
            plot(j, cp_box(j, 1), 'go');
            break
        end
    end
    
    % draw red circle as current node
    x = 1;
    red_circle = plot(x, cp_box(x, 1), 'ro');
    hold off
    
    xlim([-0.05*len, 1.05*len])
    set(gca, 'XTick', [])
    set(gca, 'YTick', [])
    set(gca, 'Box', 'off')
    ud = struct;
    ud.red_circle = red_circle;
    ud.cp_box = cp_box;
    set(gca, 'Userdata', ud)
end

%% Function image
% Calculate position of parietal peak
position_parietal_fun = fun_mm2position(parietal_mm, gvar.vol_4D.mat);

% Calculate time series
ts_parietal = gvar.img_4D(position_parietal_fun(1), position_parietal_fun(2), position_parietal_fun(3), :);
ts_parietal = spm_detrend(squeeze(ts_parietal), 1);
ts_global = mean(mean(mean(gvar.img_4D)));
ts_global = spm_detrend(squeeze(ts_global), 1);
ts_hm = gvar.head_motion;
[x1, x2, ts_parietal] = process_ts(ts_parietal, ts_hm, ts_global);

% Plot time series
set(gcf, 'CurrentAxes', handles.axes_parietal_ts)

timeline = gvar.timeline(fix(gvar.crop_from/gvar.tr):fix(gvar.crop_to/gvar.tr));

lines = plot(timeline, zscore([gvar.ts_hippo, ts_parietal]));
set(lines, 'LineWidth', 2)
legend(lines, {'Hippocampus', 'Parietal'}, 'Location', 'best')

xlim([min(gvar.timeline), max(gvar.timeline)])
set(gca, 'XTick', [0 : 60 : max(gvar.timeline)])
set(gca, 'YTick', [])
set(gca, 'Box', 'off')

end