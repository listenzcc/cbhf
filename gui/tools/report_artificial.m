function report_artificial(handles)

global gvar

% Make preprocessed path
this_preprocessed_path = fullfile(gvar.subject_id_path, '_____preprocessed_4');

% Read head motion
d = dir(fullfile(this_preprocessed_path, 'rp_*.txt'));
hm = load(fullfile(d(1).folder, d(1).name));

hm = hm(11:end, :); % Remove first 10 TR to pervent artificial
gvar.head_motion = hm;

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