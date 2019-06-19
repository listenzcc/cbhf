function reset_preprocess(handles)

set(handles.pushbutton_preprocess, 'Enable', 'off')

cleargca(handles.axes_head_motion_123)
cleargca(handles.axes_head_motion_456)

end

function cleargca(axes)
set(gcf, 'CurrentAxes', axes)
plot(0)
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'Box', 'off')
end