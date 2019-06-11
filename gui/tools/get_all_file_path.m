function files_path = get_all_file_path(dir_path)
dirs = dir(dir_path);
files_path = cell(length(dirs)-2, 1);
for j = 3 : length(dirs)
    files_path{j-2} = fullfile(dirs(j).folder, dirs(j).name);
end
end