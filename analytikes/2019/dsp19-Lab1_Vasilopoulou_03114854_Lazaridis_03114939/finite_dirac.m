function d1 = finite_dirac(x,x0)
d1 = dirac(x-x0);
idx = d1 == Inf; % find Inf
d1(idx) = 1;  % set Inf to finite value
end