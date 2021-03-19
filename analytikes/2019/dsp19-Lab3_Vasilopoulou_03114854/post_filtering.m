% Funtion : post-filtering(signal, n, n_frame, o, fs)
%
% signal : output of the beamformer
% n : number of samples in signal
% n_frame : number of samples per frame
% o : overlap ( % ) for Overlap-Add reconstruction
% fs : sampling frequency
function result = post_filtering( signal, n, n_frame, o, fs )
    window = hamming(n_frame);
    overlap = floor(o/100*n_frame);
    noise = signal(1:n_frame);
    result = zeros(2*n,1);
    [P_noise,~] = pwelch(noise,[],overlap,n_frame,fs,'twosided');
    flag = 0;
    i = 0;
    while flag == 0
        start = i*overlap + 1;
        stop = start + n_frame - 1;
        res = stop - n;
        if res > 0
            flag = 1;
            s = [ signal( start : n ); zeros(res,1)];
        else
            s = signal( start : stop );
        end
        x = window .* s;
        X = fft(x);
        [P_frame,~] = pwelch(x,[],overlap,n_frame,fs,'twosided');
        Hw = 1 - (P_noise./P_frame);
        Y = Hw .* X;
        y = ifft(Y);
        result( start:stop ) = result( start:stop ) + y;
        i = i+1;
    end
    result = real(result(1:n));
end