function redraw_parietal(handles)

set(handles.pushbutton_analysis_fc, 'Enable', 'off')

console_report(handles, repmat('-', 1, 20))
console_report(handles, 'Redraw parietal ...')
parse_hippo_xyzmm(handles)
parse_options(handles)

cal_parietal_peak_xyzmm(handles)
plot_parietal(handles)
console_report(handles, 'Redraw parietal done')

set(handles.pushbutton_analysis_fc, 'Enable', 'on')

end