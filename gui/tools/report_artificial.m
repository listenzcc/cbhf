function report_artificial(handles)

global subject_id_path

% Make preprocessed path
this_preprocessed_path = fullfile(subject_id_path, '_____preprocessed_4');

% Read head motion
d = dir(fullfile(this_preprocessed_path, 'rp_*.txt'));
hm = load(fullfile(d(1).folder, d(1).name));

% Plot head motion
set(gcf, 'CurrentAxes', handles.axes_head_motion_123)
plot(hm(:, 1:3))
set(gca, 'XTick', [])
set(gca, 'Box', 'off')

set(gcf, 'CurrentAxes', handles.axes_head_motion_456)
plot(hm(:, 4:6))
set(gca, 'XTick', [])
set(gca, 'Box', 'off')

% Report console
max_hm = max(abs(hm));
console_report(handles, 'Max head motion is')
console_report(handles,...
    sprintf('\t%0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f', max_hm));

end