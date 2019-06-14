function draw_TMP(img_T1, pp, cm, axes_x, axes_y, axes_z)

%% Draw x slice
% draw slice
set(gcf, 'CurrentAxes', axes_x)
img_x = squeeze(img_T1(pp(1), :, :));
imshow(img_x', 'Colormap', cm)
set(gca, 'YDir', 'normal') % bottom up

% draw ruler
line([pp(2), pp(2)], get(gca, 'ylim'), 'color', 'green');
line(get(gca, 'xlim'), [pp(3), pp(3)], 'color', 'blue');

%% Draw y slice
% draw slice
set(gcf, 'CurrentAxes', axes_y)
img_y = squeeze(img_T1(:, pp(2), :));
imshow(img_y(end:-1:1, :)', 'Colormap', cm)
set(gca, 'YDir', 'normal') % bottom up

% draw ruler
line(size(img_T1, 1) + 1 - [pp(1), pp(1)], get(gca, 'xlim'), 'color', 'red');
line(get(gca, 'xlim'), [pp(3), pp(3)], 'color', 'blue');

% match width with x slice
xlim([0.5, 109.5])

%% Draw z slice
% draw slice
set(gcf, 'CurrentAxes', axes_z)
img_z = squeeze(img_T1(:, :, pp(3)));
imshow(img_z, 'Colormap', cm)
set(gca, 'YDir', 'normal') % bottom up

% draw ruler
line([pp(2), pp(2)], get(gca, 'ylim'), 'color', 'green');
line(get(gca, 'xlim'), [pp(1), pp(1)], 'color', 'red');

end

