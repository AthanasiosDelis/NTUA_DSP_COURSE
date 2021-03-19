clear all
close all
clc
%% Initial variables
N = 1024;
u = randn(1,N); % white noise
n = 0:(N-1);
f = 2*pi*rand(1,3);       % Random phase vector

%% Signal x[n]
x = 3*sin(0.3*pi*n + f(1)) + 5*cos(0.6*pi*n + f(2)) + 2*sin(0.7*pi*n + f(3)) + u;
figure;
plot(n,x,'Color',[0.7 0.7 0.7]); 
xlabel('n'); ylabel('x[n]');
xlim([0 N]); ylim('auto'); 

%% Periodogram
[P1,w] = periodogram(x);
figure;
periodogram(x)

%% Modified periodogram
window = floor(N/3);
noverlap = floor(0.75*window);
P2 = pwelch(x,hamming(window),noverlap);
figure;
pwelch(x,window,noverlap)