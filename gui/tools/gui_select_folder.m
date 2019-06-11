function [dir_path, subject_info] = gui_select_folder
global runtime_path
lastdirmat = fullfile(runtime_path, 'dotfiles', 'lastdir.mat');
if exist(lastdirmat, 'file')
    load(lastdirmat, 'dir_path')
    dir_path = uigetdir(dir_path);
else
    dir_path = uigetdir(pwd);
end

fnames = dir(dir_path);
fpath = fullfile(dir_path, fnames(3).name);
subject_info = get_subject_info(fpath);
subject_info.inner_id = md5(fpath);

save(lastdirmat, 'dir_path')

end