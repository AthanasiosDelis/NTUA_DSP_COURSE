function [start stop] = tone_limits(N,n)
start = zeros(n,1);
stop = zeros(n,1);
for i=1:n
    start(i) = (i-1)*N + (i-1)*100 + 1;
    stop(i) = i*N + (i-1)*100;
end
end