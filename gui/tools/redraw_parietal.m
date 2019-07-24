function redraw_parietal(handles)

set(handles.pushbutton_analysis_fc, 'Enable', 'off')
set(handles.popupmenu_selector, 'Enable', 'off')
set(handles.pushbutton_emperical, 'Enable', 'off')

console_report(handles, repmat('-', 1, 20))
console_report(handles, 'Redraw parietal ...')
parse_hippo_xyzmm(handles)
parse_options(handles)

cal_parietal_peak_xyzmm(handles)
plot_parietal(handles)
console_report(handles, 'Redraw parietal done')

set(handles.pushbutton_analysis_fc, 'Enable', 'on')
set(handles.popupmenu_selector, 'Enable', 'on')
set(handles.pushbutton_emperical, 'Enable', 'on')
set(handles.pushbutton_next_large, 'Enable', 'on')
set(handles.pushbutton_back_largest, 'Enable', 'on')
set(handles.pushbutton_3D, 'Enable', 'on')

end