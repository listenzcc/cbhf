function reset_preprocess(handles)

set(handles.pushbutton_preprocess, 'Enable', 'off')
set(handles.edit_crop_from, 'Enable', 'off')
set(handles.edit_crop_to, 'Enable', 'off')
set(handles.edit_crop_from, 'String', '20')
set(handles.edit_crop_to, 'String', '--')

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