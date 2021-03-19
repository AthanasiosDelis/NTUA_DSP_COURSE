% ******* Part 3 *******

flag = 0;

%% 3.1
[speech,fs_speech] = audioread('speech_utterance.wav');
% The sampling frequency is 16kHz. The sampling period is Ts=1/fs=62.5usec
% We must use Hamming windows with length between 20msec and 30msec.
% 20msec < window_length < 30msec -> 
% 20msec/Ts < samples_per_window < 30msec/Ts ->
% 320 < samples_per_window < 480
window_speech = [333; 200; 800];

%% 3.2
[music,fs_music] = audioread('music.wav');
% The sampling frequency is 44.1kHz. The sampling period is Ts=1/fs=22.68usec
% We must use Hamming windows with length between 20msec and 30msec.
% 20msec < window_length < 30msec -> 
% 20msec/Ts < samples_per_window < 30msec/Ts ->
% 882 < samples_per_window < 1323
window_music = [954; 500; 1700];

%% ******************
selection = input(sprintf('Enter 1 for speech signal processing or 2 for music \nsignal processing: \n'));
if selection == 1
    signal = speech';
    fs = fs_speech;
    window = window_speech;
    text = 'Speech signal (Window length : %d)';
    clear window_music
    clear window_speech
    clear speech
    clear music
elseif selection == 2
    signal = music';
    fs = fs_music;
    window = window_music;
    text = 'Music (Window length : %d)';
    clear window_music
    clear window_speech
    clear speech
    clear music
else
    flag=1;
end
if ~flag
    display('Processing...');
    samples = length(signal);
    t = (0:samples-1)./fs;
    for i = 1:length(window)
        % Creating the hamming window
        hamming_window = hamming(window(i));

        % ***** Short-Time Energy calculation *****
        signal_sq = signal.^2;
        hamming_window_sq = hamming_window.^2;
        short_time_energy = conv(signal_sq,hamming_window_sq,'same');
        short_time_energy = short_time_energy./max(short_time_energy);

        % ***** Zero Crossing Rate calculation *****
        d = zeros(1,samples);
        d(2:samples) = abs(sign(signal(2:samples)) - sign(signal(1:samples-1)));
        zero_crossing_rate = conv(d,hamming_window,'same');
        zero_crossing_rate = zero_crossing_rate./max(zero_crossing_rate);

        % Show the results
        figure;
        plot(t , signal/max(abs((signal))),'Color',[0.6 0.6 0.6]);
        hold on;
        title(sprintf(text,window(i)));
        plot(t, short_time_energy ,'r');
        xlabel('Time (sec)');
        ylabel('Amplitude');
        xlim auto
        ylim auto
        legend('Signal','Short-Time Energy');
        hold off;

        figure;
        plot(t , signal/max(abs(signal)),'Color',[0.6 0.6 0.6]);
        hold on;
        plot(t , zero_crossing_rate,'r');
        hold on;
        title(sprintf(text,window(i)));
        xlabel('Time (sec)');
        ylabel('Amplitude');
        xlim auto
        ylim auto
        legend('Signal','Zero crossing rate');
        hold off;
    end
else
    display('Invalid input');
end