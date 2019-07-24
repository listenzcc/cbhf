function fun_plot_3D_surface(fname, mms)
% fname: path of surface file
% mms: matrix of 3 x len, 3 means 3-axis, len means number of nodes,
%      the 1st node is hippocampus node, the last node is parietal node

%% Compute the length of nodes
len = size(mms, 2);

%% Build my surface structure
% Read surface file
fid=fopen(fname);
data = textscan(fid,'%f','CommentStyle','#');
fclose(fid);

vertex_number = data{1}(1);
coord = reshape(data{1}(2:1+3*vertex_number), [3, vertex_number]);
ntri = data{1}(3*vertex_number+2);
tri = reshape(data{1}(3*vertex_number+3:end), [3, ntri])';

surf = struct; % my surface structure
surf.vertex_number = vertex_number; % number of vertex
surf.coord = coord; % coordiate of each vertex
surf.tri = tri; % index of 3 vertex of each triangle
surf.ntri = ntri; % number of triangle

%% Calculate distances matrix from triangles to each nodes in mms
dists = nan(surf.ntri, len);

for j = 1 : surf.ntri
    % fetch triangle idx
    tri = surf.tri(j, :);
    % compute triangle center
    coord = mean(surf.coord(:, tri), 2);
    % substitute mms and center
    sub = mms - repmat(coord, 1, len);
    % calculate distances from mms to center
    dists(j, :) = diag(sub' * sub);
end

%% Plot
% Setup figure
fff = figure;
set(gca, 'Position', [0, 0, 1, 1])

% draw raw surface as background
volume = trisurf(surf.tri,...
    surf.coord(1, :), surf.coord(2, :), surf.coord(3, :),...
    'EdgeColor', 'none');
daspect([1, 1, 1])

% draw roi around nearest triangle
hold on
roi_other = nan(1, len);
if len < 10
    for j = 2 : len-1
        roi_other(j) = draw_roi(dists(:, j), surf, 10);
    end
end
roi_h = draw_roi(dists(:, 1), surf);
roi_p = draw_roi(dists(:, end), surf);
hold off

% dress up
shading('interp')
lighting('phong')
material('dull')
axis off;

% we want sketch to be gray colored
set(volume, 'FaceColor', 0.95+zeros(1, 3));
set(volume, 'FaceAlpha', 0.3);

% hippocampus roi as blue
set(roi_h, 'FaceColor', 'blue');
set(roi_h, 'FaceAlpha', 1);

% parietal roi as red
set(roi_p, 'FaceColor', 'red');
set(roi_p, 'FaceAlpha', 1);

for t = roi_other
    if isnan(t)
        continue
    end
    set(t, 'FaceColor', 0.5 + zeros(1, 3));
    set(t, 'FaceAlpha', 1);
end

% tight image
axis tight;
axis vis3d off;

% position camera
set(gca, 'View', [0, 90])
camlight('right')

% add backend for mouse motion
% move mouse to change view point
set(fff, 'WindowButtonMotionFcn', @ButttonMotionFcn)
% click button to change light position
set(fff, 'WindowButtonDownFcn', @ButttonDownFcn)

% text which node is what
text(mms(1, 1), mms(2, 1), mms(3, 1), 'EffectSpot')
text(mms(1, end), mms(2, end), mms(3, end), 'TargetSpot')

% rename running title
set(gcf, 'NumberTitle', 'off', 'Name', '3D')

end

function roi = draw_roi(dist, surf, roisz)
if nargin < 3
    roisz = 50;
end
[a, b] = sort(dist);
nearest_idx = b(1:roisz);
roi = trisurf(surf.tri(nearest_idx, :),...
    surf.coord(1, :), surf.coord(2, :), surf.coord(3, :));
end

function ButttonMotionFcn(src, event)
% do not change anything
cp = get_cp(gcf);
az = mod(720*cp(1), 360);
el = 180*(cp(2)-0.5);
set(gca, 'View', [az, el])
end

function cp = get_cp(fig)
% do not change anything
unit_axe = get(fig, 'Units');
set(fig, 'Units', 'normalized')
cp = get(fig, 'CurrentPoint');
set(fig, 'Units', unit_axe)
end

function ButttonDownFcn(src, event)
% do not change anything
c = get(gca, 'Children');
delete(findobj(c, 'Type', 'light'))
azel = get(gca, 'View');
if azel(1)>90 && azel(1) <270
    azel(1) = azel(1) + 180;
end
camlight(azel(1), azel(2));
end




