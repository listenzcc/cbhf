function redraw_hippocampus(handles)

console_report(handles, repmat('-', 1, 20))
console_report(handles, 'Redraw hippocampus ...')
parse_hippo_xyzmm(handles)
parse_options(handles)
plot_hippocampus(handles)
console_report(handles, 'Redraw hippocampus done')
end