function plot_artificial(handles)

global gvar

% Make preprocessed path
this_preprocessed_path = fullfile(gvar.subject_id_path, '_____preprocessed_4');

% Read head motion
d = dir(fullfile(this_preprocessed_path, 'rp_*.txt'));
hm = load(fullfile(this_preprocessed_path, d(1).name));
for j = 1 : 6
    hm(:, j) = hm(:, j) - mean(hm(:, j));
end
len = size(hm, 1);
tr = str2double(get(handles.edit_TRms, 'String'))/1000;
xtick = [1:len] * tr;

% Plot head motion
from = str2double(get(handles.edit_crop_from, 'String'));
to = str2double(get(handles.edit_crop_to, 'String'));

set(gcf, 'CurrentAxes', handles.axes_head_motion_123)
lines = plot(xtick, hm(:, 1:3));
for line = lines'
    set(line, 'Color', 0.8 + zeros(1, 3))
end
hold on
plot(xtick(fix(from/tr):fix(to/tr)), hm(fix(from/tr):fix(to/tr), 1:3));
hold off
xlim([min(xtick), max(xtick)])
tmp = hm(10:end, 1:3);
ylim([min(tmp(:)), max(tmp(:))] * 1.1)
set(gca, 'Box', 'off')
set(gca, 'XTick', [0 : 60 : max(xtick)])

set(gcf, 'CurrentAxes', handles.axes_head_motion_456)
lines = plot(xtick, hm(:, 4:6));
for line = lines'
    set(line, 'Color', 0.8 + zeros(1, 3))
end
hold on
plot(xtick(fix(from/tr):fix(to/tr)), hm(fix(from/tr):fix(to/tr), 4:6));
hold off
xlim([min(xtick), max(xtick)])
tmp = hm(10:end, 4:6);
ylim([min(tmp(:)), max(tmp(:))] * 1.1)
set(gca, 'Box', 'off')
set(gca, 'XTick', [0 : 60 : max(xtick)])

gvar.head_motion = hm(fix(from/tr):fix(to/tr), :);
gvar.crop_from = from;
gvar.crop_to = to;

% Report console
max_hm = max(abs(gvar.head_motion));
console_report(handles, 'Max head motion is')
console_report(handles,...
    sprintf('\t%0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f', max_hm));

end