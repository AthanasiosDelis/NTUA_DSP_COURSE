% ******* Part 2 *******
%% 2.1(a)
fs = 1000; %sampling frequency
N = 2000; % number of samples: 2sec/Ts = 2sec * 1000samples/sec = 2000samples
n = 0:(1/fs):2;
x = 2*cos(2*pi*70*n) + 3*sin(2*pi*140*n) + 0.15*randn(1,N+1);
figure(1);
plot(n*fs,x)
title('Graph of x[n]');
xlabel('n');
ylabel('x[n]');

%% 2.1(b)
% window length : 0.04sec
nfft = 40; % number of samples of the Hamming window
noverlap = nfft/2;
window = hamming(nfft);
[s,f,t] = spectrogram(x,window,noverlap,nfft,fs);
figure(2);
surf(t,f,abs(s),'EdgeColor','none');
colormap jet
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
zlabel('Amplitude');
title('Short-Time Fourier Transform spectrum');

%% 2.1(c)
[s,f] = wavescales('morl',fs);
cwtstruct = cwtft({x,1/fs},'Scales',s,'Wavelet','morl');
cfs = cwtstruct.cfs;
figure(3);
surf(n,f,abs(cfs),'EdgeColor','none');
colormap jet
title('Discrete-Time Continuous Wavelet Transform spectrum');
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
zlabel('Amplitude');

%% 2.2(a)
x = 1.7*cos(180*pi*n) + 0.15*randn(1,2001) + 1.7*finite_dirac(n,0.625) + 1.7*finite_dirac(n,0.800);
figure(4);
plot(n*fs,x)
title('Graph of x[n]');
xlabel('n');
ylabel('x[n]');

%% 2.2(b)
% window length : 0.04sec
nfft = 40; % number of samples of the Hamming window
noverlap = nfft/2;
window = hamming(nfft);
[s,f,t] = spectrogram(x,window,noverlap,nfft,fs);
figure(5);
contour(t,f,abs(s));
colorbar;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
zlabel('Amplitude');
title('Short-Time Fourier Transform spectrum');

%% 2.2(c)
[s,f] = wavescales('morl',fs);
cwtstruct = cwtft({x,1/fs},'Scales',s,'Wavelet','morl');
cfs = cwtstruct.cfs;
figure(6);
contour(n,f,abs(cfs));
colorbar;
title('Discrete-Time Continuous Wavelet Transform spectrum');
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
zlabel('Amplitude');