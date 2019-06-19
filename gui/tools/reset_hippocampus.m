function reset_hippocampus(handles, clrgca)

if nargin < 2 || isempty(clrgca)
    clrgca = 1;
end

set(handles.pushbutton_redraw_hippo, 'Enable', 'off')
set(handles.pushbutton_analysis_fc, 'Enable', 'off')

set(handles.radiobutton_head_motion, 'Enable', 'off')
set(handles.radiobutton_global, 'Enable', 'off')
set(handles.edit_bandpass_low, 'Enable', 'off')
set(handles.edit_bandpass_high, 'Enable', 'off')
set(handles.edit_coor_x, 'Enable', 'off')
set(handles.edit_coor_y, 'Enable', 'off')
set(handles.edit_coor_z, 'Enable', 'off')

if clrgca
    cleargca(handles.axes_hippo_x)
    cleargca(handles.axes_hippo_y)
    cleargca(handles.axes_hippo_z)
    cleargca(handles.axes_hippo_ts)
end

end

function cleargca(axes)
set(gcf, 'CurrentAxes', axes)
plot(0)
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'Box', 'off')
end