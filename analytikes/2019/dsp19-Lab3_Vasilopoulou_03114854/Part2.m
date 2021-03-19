% Digital Signal Processing
% Lab 3 - Part 2 (2019)
% AM : 03114854
clear all
close all
clc

%% Parameters
N = 7; % Number of microphones
dist = 0.08; % Distance between microphones (m)
us = deg2rad(45);
us_noise = deg2rad(135);
c = 340; % Speed of sound in the air (m/sec)

%% Reading signals
[source,fs] = audioread('./MicArraySimulatedSignals/source.wav');
n = length(source); % Number of samples per signal
t = (1:n)./fs; % time vector

% Plot the signal without noise
figure;
plot(t,source,'Color',[0.7 0.7 0.7]); xlabel('Time (sec)','Interpreter','latex'); xlim([0 n/fs]); ylabel('Amplitude','Interpreter','latex'); title('Source signal','Interpreter','latex');

% Read the signals from the 7 microphones
sensor(:,1) = audioread('./MicArraySimulatedSignals/sensor_0.wav');
sensor(:,2) = audioread('./MicArraySimulatedSignals/sensor_1.wav');
sensor(:,3) = audioread('./MicArraySimulatedSignals/sensor_2.wav');
sensor(:,4) = audioread('./MicArraySimulatedSignals/sensor_3.wav'); % Central microphone
sensor(:,5) = audioread('./MicArraySimulatedSignals/sensor_4.wav');
sensor(:,6) = audioread('./MicArraySimulatedSignals/sensor_5.wav');
sensor(:,7) = audioread('./MicArraySimulatedSignals/sensor_6.wav');

%% ********** Part A. Delay-and-sum beamforming **********
w = fs.*linspace(0,2*pi,n);
a = (1/N).*exp((-1i*(N-1)*dist*cos(us)/(2*c)).*w);
d = zeros(N,n);
for k = 1 : N
    d(k,:) = a .* exp((1i*dist*cos(us)*(k-1)/c).*w); % array manifold vector
end
S = fft(sensor);
Y = sum( d'.*S , 2);
y = real(ifft(Y));

%% Save the output signal from the beamformer
audiowrite('sim_ds.wav',y,fs);

%% Plot signals
figure; plot(t,y,'Color',[0.7 0.7 0.7]); xlabel('Time (sec)','Interpreter','latex'); xlim([0 n/fs]); ylabel('Amplitude','Interpreter','latex'); title('Beamformer output signal','Interpreter','latex');
figure; plot(t,y-source,'Color',[0.7 0.7 0.7]); xlabel('Time (sec)','Interpreter','latex'); xlim([0 n/fs]); ylabel('Amplitude','Interpreter','latex'); title('Noise in reconstructed signal y(t)','Interpreter','latex');
figure; plot(t,sensor(:,4),'Color',[0.7 0.7 0.7]); xlabel('Time (sec)','Interpreter','latex'); xlim([0 n/fs]); ylabel('Amplitude','Interpreter','latex'); title('Central microphone signal','Interpreter','latex');

%% Spectrograms
window = 0.02*fs;
overlap = 0.01*fs;
figure; 
subplot(3,1,1); spectrogram(source,window,overlap,window,fs,'yaxis'); title('Source signal','Interpreter','latex');
subplot(3,1,2); spectrogram(sensor(:,4),window,overlap,window,fs,'yaxis'); title('Signal from the central microphone','Interpreter','latex');
subplot(3,1,3); spectrogram(y,window,overlap,window,fs,'yaxis'); title('Output signal','Interpreter','latex');

%% SNR calculations
snr_central_mic = snr(source, source - sensor(:,4));
snr_das = snr(source, source - y);
fprintf('Central microphone SNR : %g dB\n', snr_central_mic);
fprintf('Delay-and-sum Beamformer output signal SNR : %g dB\n', snr_das);

%% ********** Part B. Single-channel Wiener filtering **********
start = 0.47*fs;
stop = 0.5*fs;

x = sensor(start:stop,4); % Selected frame from the central microphone
s = source(start:stop); %  Selected frame from the source signal
noise = x - s; % Noise in the frame

n = length(x); % Length of the selected frame
t = (0:(n-1))./fs.*100; % Time vector

%% Plot the signal from the selected frame
figure; 
subplot(3,1,1); plot(t,x,'Color',[0.7 0.7 0.7]); xlabel('Time (msec)','Interpreter','latex'); ylabel('Amplitude','Interpreter','latex'); title('Selected frame from the central microphone','Interpreter','latex');
subplot(3,1,2); plot(t,s,'Color',[0.7 0.7 0.7]); xlabel('Time (msec)','Interpreter','latex'); ylabel('Amplitude','Interpreter','latex'); title('Selected frame from source signal','Interpreter','latex');
subplot(3,1,3); plot(t,noise,'Color',[0.7 0.7 0.7]); xlabel('Time (msec)','Interpreter','latex'); ylabel('Amplitude','Interpreter','latex'); title('Noise in the selected frame','Interpreter','latex');

%% Power spectrum
window = 0.01*fs;
overlap = 0.005*fs;
[ Px, f ] = pwelch(x,window,overlap,n,fs,'twosided');
[ Pnoise, ~ ] = pwelch(noise,window,overlap,n,fs,'twosided');
f = f./1000;

%% IIR Wiener Filter DFT
Hw = 1 - Pnoise./Px;
nsd = (abs(1-Hw)).^2;
figure;
subplot(2,1,1); plot(f,db(Hw),'Color',[0.7 0.7 0.7]); ylim([-70 10]); title('Wiener filter frequency response','Interpreter','latex'); xlim([0 8]); ylabel('Amplitude (dB)','Interpreter','latex'); xlabel('Frequency (kHz)','Interpreter','latex');
subplot(2,1,2); plot(f,db(nsd),'Color',[0.7 0.7 0.7]); ylim([-200 10]); title('Speech Distortion Index','Interpreter','latex'); xlim([0 8]); ylabel('Amplitude (dB)','Interpreter','latex'); xlabel('Frequency (kHz)','Interpreter','latex');

%% Wiener filtering
X = Hw.*fft(x);
yw = ifft(X);
Ps = pwelch(s,window,overlap,n,fs,'twosided');
Pout = pwelch(yw,window,overlap,n,fs,'twosided');
Pdas = pwelch(y(start:stop),window,overlap,n,fs,'twosided');

%% Plot results
figure;
plot(f,db(Ps),f,db(Pdas),f,db(Pout),f,db(Pnoise));
xlabel('Frequency (kHz)','Interpreter','latex');
ylabel('Amplitude (dB)','Interpreter','latex');
legend({'Source signal','Output-Beamformer','Output-Wiener filter','Noise'},'Interpreter','latex');
xlim([0 8]);

%% SNR calculations
snr_yw = snr(s, s - yw);
snr_x = snr(s, s - x);
snr_b = snr(s, s - y(start:stop));

fprintf('\nResults:\n');
fprintf('Single-channel Wiener filter input SNR : %g dB\n', snr_x);
fprintf('Single-channel Wiener filter output SNR : %g dB\n', snr_yw);
fprintf('Beamformer output SNR : %g dB\n', snr_b);