function grid_mm = fun_get_mmgrid_ROI(ROI_fname)
v_roi = spm_vol(ROI_fname);
d_roi = spm_read_vols(v_roi);
grid_mm = containers.Map;

ind = find(d_roi > 0);
sz = size(d_roi);
for j = ind'
    [x, y, z] = ind2sub(sz, j);
    p = [x, y, z];
    mm = fun_position2mm(p, v_roi.mat);
    grid_mm(fun_arr2str(mm)) = 1;
end
end

