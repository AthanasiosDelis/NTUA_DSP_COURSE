function result = g_k( L , M , h )
    % Filter g_k(n)
    result = zeros(M,L);
    for k = 1 : M
        for n = 0 : L-1
            result(k , n+1) = h(k , L - n);
        end
    end
end