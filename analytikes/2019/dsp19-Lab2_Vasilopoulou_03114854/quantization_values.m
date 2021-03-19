function [B,partition,codebook] = quantization_values( adaptive, xmin, xmax, R, Tg )

    if adaptive==0
        % Non adaptive Quantizer
        B = 8; % Number of bits per sample
    else
        % Adaptive Quantizer
        B = ceil(log2( R/min( Tg ) )) - 1; % Number of bits per sample
    end
    number_of_levels = 2^B; % number of quantization levels
    D = abs(xmax-xmin)/number_of_levels; % quantization step size 
    
% Two parameters determine a quantization: a partition and a codebook. 
% A quantization partition defines several contiguous, nonoverlapping ranges
% of values within the set of real numbers. The length of the partition vector
% is one less than the number of partition intervals. A codebook tells the 
% quantizer which common value to assign to inputs that fall into each range
% of the partition. Represent a codebook as a vector whose length is the same
% as the number of partition intervals
   
    partition = xmin:D:(xmax-D);
    codebook = xmin:D:xmax;
end