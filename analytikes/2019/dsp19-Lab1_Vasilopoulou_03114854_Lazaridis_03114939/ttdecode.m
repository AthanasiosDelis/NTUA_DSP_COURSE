function vector = ttdecode(tone,fs)
% vector : sequency of the touch-tone digits in the given signal
tone_limits = find_touch_tone_limits(tone);
number_of_tones = size(tone_limits,1);
vector = zeros(1,number_of_tones);
frequency = zeros(number_of_tones,4);
for i=1:number_of_tones
    start = tone_limits(i,1);
    stop = tone_limits(i,2);
    window_length = stop - start + 1;
    if (size(tone,1)==1)
        signal = tone(start:stop).*hamming(window_length)';
    else
         signal = tone(start:stop).*hamming(window_length);
    end
    signal_fft = fft(signal);
    signal_fft = fftshift(signal_fft);
    energy = (abs(signal_fft)).^2;
    y = find(energy > 4500);
    q=1;
    j=2;
    frequency(i,q) = y(1);
    energy_max = energy(y(1));
    while j < length(y) +1
        if y(j) == y(j-1) + 1
            if energy(y(j))> energy_max
                frequency(i,q) = y(j);
                energy_max = energy(y(j));
            end
        else
            energy_max = energy(y(j));
            q = q + 1;
            frequency(i,q) = y(j);
        end
        j = j + 1;
    end
end
frequency = (frequency(:,3:4)-500)*fs/1000;
w = 2*pi.*frequency./fs;
for i = 1 : number_of_tones
    rows = [0 0 0 0];
    columns = [0 0 0];
    for j = 1:2
        if w(i,j) > 0.5 && w(i,j) <= 0.56
            rows(1) = 1;
        elseif w(i,j) > 0.56 && w(i,j) <= 0.62
            rows(2) = 1;
        elseif w(i,j) > 0.62 && w(i,j) <= 0.68
            rows(3) = 1;
        elseif w(i,j) > 0.68 && w(i,j) <= 0.82
            rows(4) = 1;   
        elseif w(i,j) > 0.82 && w(i,j) <= 0.97
            columns(1) = 1;
        elseif w(i,j) > 0.97 && w(i,j) <= 1.08
            columns(2) = 1;
        elseif w(i,j) > 1.08 && w(i,j) <= 1.16
            columns(3) = 1;     
        else
            display('Error');
            break;
        end
    end
    if (rows(1) == 1 && columns(1) == 1)            % digit 1
        vector(i) = 1;
    elseif (rows(1) == 1 && columns(2) == 1)        % digit 2
        vector(i) = 2;
    elseif (rows(1) == 1 && columns(3) == 1)        % digit 3
        vector(i) = 3;
    elseif (rows(2) == 1 && columns(1) == 1)        % digit 4
        vector(i) = 4;
    elseif (rows(2) == 1 && columns(2) == 1)        % digit 5
        vector(i) = 5;
    elseif (rows(2) == 1 && columns(3) == 1)        % digit 6
        vector(i) = 6;
    elseif (rows(3) == 1 && columns(1) == 1)        % digit 7
        vector(i) = 7;
    elseif (rows(3) == 1 && columns(2) == 1)        % digit 8
        vector(i) = 8;
    elseif (rows(3) == 1 && columns(3) == 1)        % digit 9
        vector(i) = 9;
    elseif (rows(4) == 1 && columns(2) == 1)        % digit 0
        vector(i) = 0;
    end
end
end