function result = ST(P)
    result = zeros( 1, length(P) ) ;
    for k = 3:250
        if k < 63
    %            dk = 2;
            if ( P(k)>P(k+1)) && (P(k)>P(k-1)) ...
                    && (P(k)>P(k+2)+7) && (P(k)>P(k-2)+7)
                result(k) = 1;
            end
        elseif k < 127
    %            dk = [2,3]
            if ( P(k)>P(k+1)) && (P(k)>P(k-1)) ...
                    && (P(k)>P(k+2)+7) && (P(k)>P(k-2)+7) ...
                    && (P(k)>P(k+3)+7) && (P(k)>P(k-3)+7)
                result(k) = 1;
            end
        else
    %            dk = [2,6]
            if (P(k)>P(k+1)) && (P(k)>P(k-1)) ...
                    && (P(k)>P(k+2)+7) && (P(k)>P(k-2)+7) ... 
                    && (P(k)>P(k+3)+7) && (P(k)>P(k-3)+7)...
                    && (P(k)>P(k+4)+7) && (P(k)>P(k-4)+7) ...
                    && (P(k)>P(k+5)+7) && (P(k)>P(k-5)+7) ...
                    && (P(k)>P(k+6)+7) && (P(k)>P(k-6)+7)
                result(k) = 1;
            end            
        end
    end
end