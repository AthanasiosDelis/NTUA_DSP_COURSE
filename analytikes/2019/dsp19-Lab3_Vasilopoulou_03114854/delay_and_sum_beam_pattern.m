function B = delay_and_sum_beam_pattern(N,d,f,u,us)
% Calculate the delay-and-sum beam pattern
    c = 340; % Speed of sound in the air
    a = ((2*pi*f*d)/(2*c)).*(cos(u)-cos(us));
    B = (1/N).*(sin(N*a)./sin(a));
end