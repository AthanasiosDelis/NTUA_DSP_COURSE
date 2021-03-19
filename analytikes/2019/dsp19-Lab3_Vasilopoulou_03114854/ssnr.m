% Segmental SNR calculation
function result = ssnr(signal,fs) 
    L = 0.02*fs; % Window length of each frame, in samples
    M = floor( length(signal)/L ); % Number of frames
    noise = signal(1:L); %Noise signal for snr calculation
    sum = 0;
    for j = 0 : M-1
        frame = signal( j*L + 1 : (j + 1)*L);
        frame_snr = snr( frame, noise);
        if frame_snr < -5
            frame_snr = 0;
        elseif frame_snr > 35
            frame_snr = 35;
        end
        sum = sum + frame_snr;
    end
    result = (1/M)*sum;
end