% Digital Signal Processing
% Lab 3 - Part 1 (2019)
% AM : 03114854
clear all
close all
clc

%% 1 Delay-and-sum beam pattern for different number of microphones and distance d = 8cm
d = 0.08; % Distance between microphones
f = 2000; 
us = pi/2; 
u = linspace(0,pi,5000);
figure;
title('Delay-and-sum beam pattern for distance 8cm and different number of microphones, \theta_s = 90^{\circ}');
xlabel('\theta (degrees)');
ylabel('|B| (dB)');
hold on
for N = 4:4:16 % Number of microphones
    B = delay_and_sum_beam_pattern(N,d,f,u,us);
    plot(rad2deg(u),20*log(abs(B)));
end
legend('N=4','N=8','N=12','N=16');
hold off

%% 2 Delay-and-sum beam pattern for 8 microphones and different distances between microphones
N = 8; % Number of microphones
f = 2000; 
us = pi/2; 
u = linspace(0,pi,5000);
figure;
title('Delay-and-sum beam pattern for 8 microphones and different distances, \theta_s = 90^{\circ}');
xlabel('\theta (degrees)');
ylabel('|B| (dB)');
hold on
for d = 0.08:0.04:0.20 % Distance between microphones
    B = delay_and_sum_beam_pattern(N,d,f,u,us);
    plot(rad2deg(u),20*log(abs(B)));
end
legend('d = 8cm','d = 12cm','d = 16cm','d = 20cm');
hold off

%% 3 Delay-and-sum beam pattern for different frequencies of "noise" signals
N = 8; % Number of microphones
d = 0.08; % Distance between microphones
us = pi/2;
u = deg2rad([0 45 60]);
f = 0:0.5:8000;
figure
title('Delay-and-sum beam pattern for 8 microphones, \theta_s = 90^{\circ}');
xlabel('f (kHz)');
ylabel('|B| (dB)');
for j = 1:3
    hold on
    c = 340; % Speed of sound in air
    a = ((2*pi*d)*(cos(u(j))-cos(us))/(2*c)).*f;
    B = (1/N).*(sin(N*a)./sin(a));
    plot(f./1000,20*log(abs(B)));
end
legend('\theta = 0^{\circ}', '\theta = 45^{\circ}', '\theta = 60^{\circ}');
hold off

%% 4
N = 8; % Number of microphones
d = 0.08; % Distance between microphones
f = 2000;
us = deg2rad([0 45 90]);
u = linspace(-pi,pi,10000);
figure;
hold on
for j = 1:3
    subplot(1,3,j);
    B = delay_and_sum_beam_pattern(N,d,f,u,us(j));
    semilogr_polar(u,B,'r');
    if j == 1
        title('\theta_s = 0^{\circ}');
    elseif j == 2
        title('\theta_s = 45^{\circ}');
    else
        title('\theta_s = 90^{\circ}');
    end
end
hold off
