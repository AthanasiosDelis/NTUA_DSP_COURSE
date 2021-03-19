function freq = find_touch_tone_limits(tone)
% The function finds the limits of each touch-tone in the given signal.
tone_zeros = find(tone==0);
zeros_number = length(tone_zeros);
zeros_limits(1) = tone_zeros(1);
j=2;
for i = 2:zeros_number
    if tone_zeros(i) ~= tone_zeros(i-1)+1
        zeros_limits(j) = tone_zeros(i-1);
        zeros_limits(j+1) = tone_zeros(i);
        j=j+2;
    end
end
zeros_limits(j) = tone_zeros(zeros_number);
number_of_tones = floor(length(zeros_limits)/2) + 1;
% Check if the first element of the signal is a touch_tone
% or zero.
if zeros_limits(1) == 1
    number_of_tones = number_of_tones - 1;
else
    zeros_limits = [0 zeros_limits];
end
% Check if the last element of the signal is a touch_tone
% or zero.
if zeros_limits(length(zeros_limits)) == length(tone)
    number_of_tones = number_of_tones - 1;
    if tone(length(tone)) == 0
        zeros_limits(length(zeros_limits)) = [];
    end
elseif tone(zeros_limits(length(zeros_limits))+1)~=0
    zeros_limits = [zeros_limits length(tone)+1];
end
j=1;
for i = 1:2:(length(zeros_limits))
    u(j,1) = zeros_limits(i) + 1;
    u(j,2) = zeros_limits(i+1) - 1;
    j = j+1;
end
j=1;
for i = 1:length(u)
    n = floor((u(i,2)-u(i,1))/1000)+1;
    for e = 1:n
        freq(j,1) = u(i,1) + (e-1)*1000;
        freq(j,2) = u(i,1) + e*1000 - 1;
        j = j + 1;
    end
end
end