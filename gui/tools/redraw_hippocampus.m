function redraw_hippocampus(handles)

reset_hippocampus(handles, 0)
reset_parietal(handles)

console_report(handles, repmat('-', 1, 20))
console_report(handles, 'Redraw hippocampus ...')
parse_hippo_xyzmm(handles)
parse_options(handles)
plot_hippocampus(handles)
console_report(handles, 'Redraw hippocampus done')

set(handles.radiobutton_head_motion, 'Enable', 'on')
set(handles.radiobutton_global, 'Enable', 'on')
set(handles.edit_bandpass_low, 'Enable', 'on')
set(handles.edit_bandpass_high, 'Enable', 'on')
set(handles.edit_coor_x, 'Enable', 'on')
set(handles.edit_coor_y, 'Enable', 'on')
set(handles.edit_coor_z, 'Enable', 'on')

set(handles.pushbutton_analysis_fc, 'Enable', 'on')
set(handles.pushbutton_redraw_hippo, 'Enable', 'on')

end