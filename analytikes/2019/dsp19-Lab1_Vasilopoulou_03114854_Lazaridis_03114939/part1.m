% ***** Part 1 *****
%% 1.1
fs = 8192;
n = 1:1000;
N=1000;
d = zeros(10,1000);
d(1,:) =  sin(0.5346*n) + sin(0.9273*n); %1
d(2,:) =  sin(0.5346*n) + sin(1.0247*n); %2
d(3,:) =  sin(0.5346*n) + sin(1.1328*n); %3
d(4,:) =  sin(0.5906*n) + sin(0.9273*n); %4
d(5,:) =  sin(0.5906*n) + sin(1.0247*n); %5
d(6,:) =  sin(0.5906*n) + sin(1.1328*n); %6
d(7,:) =  sin(0.6535*n) + sin(0.9273*n); %7
d(8,:) =  sin(0.6535*n) + sin(1.0247*n); %8
d(9,:) =  sin(0.6535*n) + sin(1.1328*n); %9
d(10,:) = sin(0.7217*n) + sin(1.0247*n); %0

% % Plot the 10 touch-tones
% for i=1:10
%     figure;
%     plot(n,d(i,:));
%     xlabel('n')
%     if i==10
%         ylabel('d_0[n]');
%     else
%         ylabel(sprintf('d_%d[n]',i));
%     end
% end

%% 1.2
k = -499:500;
f = k*fs/N;
D4 = fft(d(4,:));
D4 = fftshift(D4);
figure;
plot(f,abs(D4));
xlabel('f(Hz)');
ylabel('|D_4(k)|');
D6 = fft(d(6,:));
D6 = fftshift(D6);
figure;
plot(f,abs(D6));
xlabel('f(Hz)');
ylabel('|D_6(k)|');

%% 1.3
% AM: 03114854 + 03114939 = 06229793
tone = zeros(1,8700);
[start, stop] = tone_limits(N,8);
tone(start(1):stop(1)) = d(10,:);
tone(start(2):stop(2)) = d(6,:);
tone(start(3):stop(3)) = d(2,:);
tone(start(4):stop(4)) = d(2,:);
tone(start(5):stop(5)) = d(9,:);
tone(start(6):stop(6)) = d(7,:);
tone(start(7):stop(7)) = d(9,:);
tone(start(8):stop(8)) = d(3,:);
figure;
plot([1:8700],tone);
xlabel('n');
ylabel('tone[n]');

audiowrite('tone_sequence.wav',tone,fs);

%% 1.4-1.5
square_window = ones(1,N);
k = zeros(8,4);
hamming_window = hamming(N)';
for i= 1:8
    signal = tone(start(i):stop(i)).*square_window;
    signal_sq = fft(signal);
    signal_sq = fftshift(signal_sq);
    signal = tone(start(i):stop(i)).*hamming_window;
    signal_ham = fft(signal);
    signal_ham = fftshift(signal_ham);
    k(i,:) = find(abs(signal_ham) > 210);
end
k = k - 500;
frequency = k(:,3:4)*fs/N;
touch_tone_freq = 2*pi*frequency/fs;
list = [k(:,3) touch_tone_freq(:,1) k(:,4) touch_tone_freq(:,2)];
display('List of k and touch-tones with hamming windows:');
display('     k      touch-tone    k     touch-tone');
disp(list);

%% 1.6
vector = ttdecode(tone,fs);
display('Touch-tones from our register numbers:');
disp(vector);

%% 1.7
load('my_touchtones.mat');
signal1 = easySig;
signal2 = hardSig;
vector1 = ttdecode(signal1,fs);
display('Touch-tones from easySig tone sequence:');
disp(vector1);
vector2 = ttdecode(signal2,fs);
display('Touch-tones from hardSig tone sequence:');
disp(vector2);