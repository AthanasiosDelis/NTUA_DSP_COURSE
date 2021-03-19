function result = Threshold(P_M,b,masks,masker_type)
    % P_M : Noise spectrum of tone maskers or noise maskers (P_TM / P_NM)
    % b : bark frequences
    % masks : matrix that contains the frequences of maskers
    % masker_type : tone / noise
    
    number_of_maskers = nnz(masks);
    T_M = zeros(length(P_M),length(masks));
    for k = 1 : number_of_maskers
        j = masks(k);
        for i = 1 : length(P_M)
            Db = b(i) - b(j);
            SF = 0;
            if  Db >= -3 && Db < -1
                SF = 17*Db - 0.4*P_M(j) + 11;
            elseif  Db >= -1 && Db < 0
                SF= (0.4*P_M(j) + 6)*Db;
            elseif Db >= 0 && Db < 1
                SF = -17*Db;
            elseif Db >= 1 && Db < 8
                SF = ( 0.15*P_M(j) - 17 )*Db - 0.15*P_M(j);
            else
                continue
            end
            if strcmp( masker_type, 'tone' )
                % T_TM
                T_M(i,k) = P_M(j) - 0.275*b(j) + SF - 6.025;
            elseif strcmp ( masker_type , 'noise' )
                % T_NM
                T_M(i,k) = P_M(j) - 0.175*b(j) + SF - 2.025;
            end
        end
    end
    result = T_M;
end