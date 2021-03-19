function Tg = PsychoacousticModel(t,P,b,Tq,frame_to_plot)
    %% 1.2 Tone and Noise Maskers
    P_TM = findToneMaskers(P);
    P_NM = findNoiseMaskers(P,P_TM,b);
    
    %% 1.3 Elimination and reorganization of the maskers
    [P_TM_red,P_NM_red] = checkMaskers(P_TM,P_NM,Tq,b);
    
    if t==frame_to_plot
        figure;
        hold on;
        P_TM(P_TM == 0) = NaN;
        stem(b,P_TM,'square','LineStyle','none');
        P_NM(P_NM == 0) = NaN;
        stem(b,P_NM,'LineStyle','none');
        plot(b,Tq,'--','LineWidth',1.45);
        plot(b,P,'LineWidth',1.45);
        title(sprintf('Masks for frame No.%d',t));
        xlabel('Frequency (Bark)')
        ylabel('Magnitude (dB SPL)')
        ylim([-10 200]);
        legend('Tone maskers','Noise maskers','Absolute threshold of hearing','Power Spectral Density');
        hold off
    end
    if t==frame_to_plot
        figure;
        hold on;
        P_TM_red(P_TM_red == 0) = NaN;
        stem(b,P_TM_red,'square','LineStyle','none');
        P_NM_red(P_NM_red == 0) = NaN;
        stem(b,P_NM_red,'LineStyle','none');
        plot(b,Tq,'--','LineWidth',1.45);
        plot(b,P,'LineWidth',1.45);
        title(sprintf('Reduced masks for frame No.%d',t));
        xlabel('Frequency (Bark)')
        ylabel('Magnitude (dB SPL)')
        ylim([-10 200]);
        legend('Tone maskers','Noise maskers','Absolute threshold of hearing','Power Spectral Density');
        hold off
    end
    %% 1.4 Individual Masking Thresholds
    temp = find( P_TM_red > 0 );
    if ~isempty(temp)
        L(1:length(temp)) = temp; % Tone maskers' positions
        T_TM = Threshold(P_TM_red,b,L,'tone'); 
    else
        T_TM = zeros(length(P_TM_red),1);
    end
    temp = find( P_NM_red > 0 );
    if ~isempty(temp)
        M(1:length(temp)) = temp; % Noise maskers' positions
        T_NM = Threshold(P_NM_red,b,M,'noise');
    else
        T_NM = zeros(length(P_TM_red),1);
    end
    % rows : frequences
    % colums : frequences of the tone/noise maskers
 
    %% 1.5 Global Masking Threshold
    Tg = 10.*log10( ( 10.^( (Tq')./10 ) ) + sum( 10.^( T_TM./10 ),2) + sum( 10.^( T_NM./10 ) ,2) );
    
    %% Show results for some frames
    if t == frame_to_plot
        plot_results(t,b,P_TM_red,P_NM_red,Tg,Tq,P);
    end
end