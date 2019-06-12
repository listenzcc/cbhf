function arr = fun_str2arr(str)
arr = [];
for e = strsplit(str, ', ')
    arr = [arr, str2double(e)];
end
end

