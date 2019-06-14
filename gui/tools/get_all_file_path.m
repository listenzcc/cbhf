function [files_path, files_name] = get_all_file_path(dir_path)
dirs = dir(dir_path);
dirs = dirs(3:end); % remove . and .. from dirs

files_path = cell(length(dirs), 1);
files_name = cell(length(dirs), 1);
for j = 1 : length(dirs)
    files_path{j} = fullfile(dirs(j).folder, dirs(j).name);
    files_name{j} = dirs(j).name;
end

end