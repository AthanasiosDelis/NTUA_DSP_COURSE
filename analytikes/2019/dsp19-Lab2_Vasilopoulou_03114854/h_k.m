function result = h_k( L , M )
    % Filter h_k(n)
    result = zeros(M,L);
    for k = 0:(M-1)
        for n = 0:(L-1)
            w = sin((n+1/2)*pi/L);
            result(k+1,n+1) = sqrt( 2/M )*w*cos( pi*(2*k + 1)*(2*n + M + 1)/(4*M) );
        end
    end
end