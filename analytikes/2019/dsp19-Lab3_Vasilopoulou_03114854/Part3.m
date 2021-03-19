% Digital Signal Processing
% Lab 3 - Part 3 (2019)
% AM : 03114854
clear all
close all
clc

%% Parameters
N = 7; % Number of microphones
dist = 0.04; % Distance between microphones (m)
us = deg2rad(45);
c = 340; % Speed of sound in the air (m/sec)

%% Reading signals
[source,fs] = audioread('./MicArrayRealSignals/source.wav');
n = length(source); % Number of samples per signal
t = (1:n)./fs; % time vector

% Read the signals from the 7 microphones
sensor(:,1) = audioread('./MicArrayRealSignals/sensor_0.wav');
sensor(:,2) = audioread('./MicArrayRealSignals/sensor_1.wav');
sensor(:,3) = audioread('./MicArrayRealSignals/sensor_2.wav');
sensor(:,4) = audioread('./MicArrayRealSignals/sensor_3.wav');
sensor(:,5) = audioread('./MicArrayRealSignals/sensor_4.wav');
sensor(:,6) = audioread('./MicArrayRealSignals/sensor_5.wav');
sensor(:,7) = audioread('./MicArrayRealSignals/sensor_6.wav');

%% Delay-and-sum beamforming
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
audiowrite('real_ds.wav',y,fs);

%% Plot signals
figure; plot(t,source,'Color',[0.7 0.7 0.7]); xlabel('Time (sec)','Interpreter','latex'); xlim([0 n/fs]); ylabel('Amplitude','Interpreter','latex'); title('Source signal','Interpreter','latex');
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

%% SSNR calculations
ssnr_central_mic = ssnr(sensor(:,4),fs);
ssnr_das = ssnr(y,fs);
fprintf('\nCentral microphone SSNR : %g dB\n', ssnr_central_mic);
fprintf('\nDelay-and-sum Beamformer output signal SSNR : %g dB\n', ssnr_das);

%% Post-filtering with Wiener filter
n_frame = 0.026*fs; % Duration of the fraim : 26msec
output = post_filtering(y,n,n_frame,45,fs);
ssnr_out = ssnr(output,fs);
fprintf('\nPost-filtering output signal SSNR : %g dB\n', ssnr_out);
figure;
subplot(2,1,1); spectrogram(output,window,overlap,window,fs,'yaxis'); title('Post-filtering output signal','Interpreter','latex');
subplot(2,1,2); plot(t,output,'Color',[0.7 0.7 0.7]); xlabel('Time (sec)','Interpreter','latex'); ylabel('Amplitude','Interpreter','latex'); title('Post-filtering output signal','Interpreter','latex');

%% Save the output signal after post-filtering
audiowrite('real_mmse.wav',output,fs);

%% Mean SSNR
ssnr_mean = 0;
for i = 1:7
    ssnr_mean = ssnr_mean + ssnr(sensor(:,i),fs);
end
ssnr_mean = ssnr_mean/7;

fprintf('\nMean SSNR from the signals : %g dB\n', ssnr_mean);
fprintf('\nImprovement : %g %%\n',(ssnr_out - ssnr_mean)/ssnr_mean*100);