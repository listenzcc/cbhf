function [dir_path, subject_info, string] = gui_select_folder
global gvar

dir_path = '';

lastdirmat = fullfile(gvar.runtime_path, 'dotfiles', 'lastdir.mat');
[a, b, c] = mkdir(gvar.runtime_path, 'dotfiles');

if exist(lastdirmat, 'file')
    load(lastdirmat, 'dir_path')
end

if exist(dir_path, 'dir')
    dir_path = uigetdir(dir_path);
else
    dir_path = uigetdir(pwd);
end

fnames = dir(dir_path);
fpath = fullfile(dir_path, fnames(3).name);
[subject_info, string] = get_subject_info(fpath);

save(lastdirmat, 'dir_path')

end