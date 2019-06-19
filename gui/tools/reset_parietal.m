function reset_parietal(handles, clrgca)

if nargin < 2 || isempty(clrgca)
    clrgca = 1;
end

if clrgca
    cleargca(handles.axes_parietal_x)
    cleargca(handles.axes_parietal_y)
    cleargca(handles.axes_parietal_z)
    cleargca(handles.axes_parietal_ts)
end

set(handles.text_coor_x, 'String', '--')
set(handles.text_coor_y, 'String', '--')
set(handles.text_coor_z, 'String', '--')

end

function cleargca(axes)
set(gcf, 'CurrentAxes', axes)
plot(0)
set(gca, 'XTick', [])
set(gca, 'YTick', [])
set(gca, 'Box', 'off')
end