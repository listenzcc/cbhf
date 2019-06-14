function c = fun_corr(a, b)
c = zscore(a)' * zscore(b) / ( size(a,1)-1 );
end