function [betterworth,chebyshevI,elliptic,kaiser] = filters

    % All frequencies are normalized to 1.
    
    stop1 = 0.18;    % First Stopband Frequency
    pass1 = 0.20;     % First Passband Frequency
    pass2 = 0.50;     % Second Passband Frequency
    stop2 = 0.52;    % Second Stopband Frequency
    
    attenuation = 80;  % First Stopband Attenuation (dB)
    ripple  = 1;       % Passband Ripple (dB)

    % Construct an FDESIGN object and call its ELLIP method.
    h  = fdesign.bandstop(stop1, pass1, pass2, stop2, attenuation, ripple, attenuation);
    elliptic = design(h, 'ellip', 'MatchExactly', 'both'); % Band to match exactly
