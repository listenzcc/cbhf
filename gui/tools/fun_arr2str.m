function str = fun_arr2str(arr)
if iscolumn(arr)
    arr = arr';
end
str = '';
for e = arr
    str = sprintf('%s, %.2f', str, e);
end
str = str(3:end);
end

