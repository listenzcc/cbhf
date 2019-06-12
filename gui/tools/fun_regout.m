function newa = fun_regout(a, b)

betas = fun_calbeta(a, b);

newa = a - b * betas;

end

function c = fun_calbeta(a, b)
if ~iscolumn(b)
    b = b';
end
if ~iscolumn(b)
    error('b must be a colomun')
end
if size(a, 1) ~= length(b)
    error('b and a must have same rows')
end

c = (b'*a) / (b'*b);

end