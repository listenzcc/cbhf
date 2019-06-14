function parse_hippo_xyzmm(handles)
global gvar

% str2double
xmm = str2double(handles.edit_coor_x.String);
ymm = str2double(handles.edit_coor_y.String);
zmm = str2double(handles.edit_coor_z.String);

% dummy correction
if isnan(xmm)
    handles.edit_coor_x.String = '-28';
    xmm = -28;
    warndlg('Wrong input!')
end

if isnan(ymm)
    handles.edit_coor_y.String = '-14';
    ymm = -14;
    warndlg('Wrong input!')
end

if isnan(zmm)
    handles.edit_coor_z.String = '-14';
    zmm = -14;
    warndlg('Wrong input!')
end

console_report(handles,...
    sprintf('Target point in Hippocampus: %.2f, %.2f, %.2f', xmm, ymm, zmm))

% save data
gvar.hippo_mm = [xmm, ymm, zmm];

end