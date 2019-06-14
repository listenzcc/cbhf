function redraw_hippocampus(handles)

console_report(handles, repmat('-', 1, 20))
parse_hippo_xyzmm(handles)
parse_options(handles)
plot_hippo(handles)

end