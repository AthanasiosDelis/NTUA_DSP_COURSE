% Digital Signal Processing
% Lab 2 (2019)
% AM : 03114854

clear all; close all; clc

%% Part 1
% 1.0

frame_to_plot = 984;

N = 512; % Number of samples per window
[music , fs] = audioread('music-dsp19.wav'); % fs: sampling frequency
signal = ( music(:,1) + music(:,2) )'./2;
maxx = max(abs(signal));
signal = signal./maxx;
t = 0 : (1/fs) : (length(signal)-1)/fs ;
figure; plot(t,signal,'Color',[0.5 0.5 0.5]); title(' Normalized music signal'); ylabel('Amplitude'); xlabel('Time (sec)');

% 1.1
f = ( fs*( 1:(N/2) )/N );
% Absolute Threshold of Hearing
Tq = 3.64*(f./1000).^(-0.8) - 6.5*exp(-0.6.*(f./1000-3.3).^2) + 10^(-3)*(f./1000).^4;
figure; semilogx(f,Tq,'LineWidth',1.45); ylim([ -10 100 ]); grid on; title('Absolute Threshold of Hearing'); xlabel('Frequency (Hz)'); ylabel('Sound Pressure Level - SPL (dB)');

% Critical Bands
b = 13.*atan(0.00076.*f) + 3.5.*atan((f./7500).^2); % Bark frequences
figure; plot(f,b,'LineWidth',1.45); hold on; ylabel('Frequency (Bark)'); xlabel('Frequency (Hz)'); hold off;


% No overlap and Hanning windows
x = buffer(signal,N,0);
window = x.*hanning(N);
window_fft = fft(window);

figure; plot(x(:,frame_to_plot),'LineWidth',1.45); hold on; title(sprintf('Signal from frame No.%d',frame_to_plot)); ylabel('Amplitude'); xlabel('Time (sec)');
figure; plot(window(:,frame_to_plot),'LineWidth',1.45); hold on; title(sprintf('Signal with Hanning window from frame No.%d',frame_to_plot)); ylabel('Amplitude'); xlabel('Time (sec)');
figure; plot(f,abs(window_fft(1:256,frame_to_plot)),'LineWidth',1.45); hold on; title(sprintf('Fourier Transform of the signal from frame No.%d',frame_to_plot)); ylabel('Amplitude'); xlabel('Frequency (Hz)');


% Power spectrum ( Sound Pressure Level (dB) )
P = 90.302 + 10*log10(abs(window_fft(1 : N/2 , :)).^2);

figure; plot(b,P(:,frame_to_plot),'LineWidth',1.45); hold on; title(sprintf('Power Spectral Density from frame No.%d',frame_to_plot)); ylabel('Magnitude (SPL dB)'); xlabel('Frequency (Bark)');

disp('Processing ..');

Tg = zeros(size(P,1),size(P,2));

clear music window_fft

%% Part 2
% 2.0
% Modified Discrete Cosine Transform (MDCT)
M = 32; % Number of synthesis and analysis filters
L = 2*M;

% Analysis and Synthesis Filters
h = h_k(L,M);
g = g_k(L,M,h);

figure;
subplot(2, 1, 1); hold on; title('Analysis Filter h_1[n]'); plot(h(1, :)); xlabel('n'); hold off
subplot(2, 1, 2); hold on; title('Synthesis Filter g_1[n]'); plot(g(1, :)); xlabel('n'); hold off

figure; freqz(h(1, :)); hold on; title('Analysis Filter h_1 Frequency Response'); hold off;
figure; hold on; freqz(g(1, :)); title('Synthesis Filter g_1 Frequency Response'); hold off;

newBits = 0;
y_rec = zeros(1, (size(x,2))*(N + 2*L - 1) );
y_rec_adaptive = zeros(1, (size(x,2))*(N + 2*L - 1) );

y_rec_length = (N + 2*L - 1);
start = 1; 

for r = 1:size(P,2)
    Tg(:,r) = PsychoacousticModel(r,P(:,r),b,Tq,frame_to_plot );
end

for r = 1:size(P,2)
    [x_na,bits_na] = AnalysisSynthesisFilterbank(r,x(:,r),h,g,Tg(:,r),M,L,N,'non-adaptive',frame_to_plot);
    [x_a,bits_a] = AnalysisSynthesisFilterbank(r,x(:,r),h,g,Tg(:,r),M,L,N,'adaptive',frame_to_plot);
        
    newBits = newBits + bits_a;
     
    y_rec(start:start + y_rec_length - 1) = y_rec(start:start + y_rec_length - 1) + x_na';
    y_rec_adaptive(start:start + y_rec_length - 1) = y_rec_adaptive(start:start + y_rec_length - 1) + x_a'; 
           
    start = start + N;
end

% Final signals
y_rec = y_rec(L : (L + size(signal,2) - 1));
y_rec_adaptive = y_rec_adaptive(L : (L + size(signal,2) - 1));



% audiowrite('music_8bit.wav', y_rec, fs);
% audiowrite('music_adaptive.wav', y_rec_adaptive, fs);



% Meam Square Error
error_non_adaptive = signal - y_rec;  
error_adaptive = signal - y_rec_adaptive;

MSE_na = var(error_non_adaptive);
MSE_a = var(error_adaptive);
fprintf('\nMean Square Error for 8-bit quantization : %d\n',MSE_na);
fprintf('\nMean Square Error for adaptive quantization : %d\n',MSE_a);

% Plot reconstructed signals
figure; plot(t,y_rec,'Color',[0.5 0.5 0.5]); title('Reconstructed signal - Non adaptive quantization'); ylabel('Amplitude'); xlabel('Time (sec)');
figure; plot(t,y_rec_adaptive,'Color',[0.5 0.5 0.5]); title('Reconstructed signal - Adaptive quantization'); ylabel('Amplitude'); xlabel('Time (sec)');

% Plot error
figure;
subplot(2, 1, 1);
hold on
plot(t, error_non_adaptive);
title(sprintf ('Error for 8-bit quantization - Mean Square Error = %0.5e', MSE_na)); 
xlabel('Time (sec)');
ylabel ('Amplitude(dB)');
hold off
subplot(2, 1, 2);

hold on
plot(t, error_adaptive);
title(sprintf ('Error for adaptive quantization - Mean Square Error = %0.5e', MSE_a)); 
xlabel('Time (sec)');
ylabel ('Amplitude(dB)');
hold off

% compression ratio with 8-bit quantizer = 50%
compression_8bit = 8 / 16 * 100;

% compression ratio with adaptive quantizer based on psychoacoustic model I 
oldBits = 16 * length(signal);
compression_ad = newBits / oldBits * 100;

fprintf('\nCompression Ratio with 8-bit quantizer : %d\n',compression_8bit);
fprintf('\nCompression Ratio with adaptive quantizer\n based on Psychoacoustic Model I  : %f\n',compression_ad);



