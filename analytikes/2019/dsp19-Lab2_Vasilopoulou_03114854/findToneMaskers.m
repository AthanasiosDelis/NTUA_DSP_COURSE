function result = findToneMaskers(P)
    ST1 =  ST(P);
    result = zeros( 1, length(P));
    for k = 2:255
        if ST1(k) >0
            result(k) = 10*log10( 10^(P(k-1)/10) + 10^(P(k)/10) + 10^(P(k+1)/10) );
        end
    end
end