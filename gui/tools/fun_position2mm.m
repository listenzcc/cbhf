function mm = fun_position2mm(position, mat)
if isrow(position)
    position = position';
end

r = mat(1:3, 1:3);
b = mat(1:3, 4);

mm = r*position + b;
end