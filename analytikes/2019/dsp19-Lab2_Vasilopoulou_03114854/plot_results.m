function plot_results(frame_to_plot,b,P_TM,P_NM,T_g,Tq,P)
    figure;
    hold on;
    P_TM(P_TM == 0) = NaN;
    stem(b,P_TM,'square','LineStyle','none');
    P_NM(P_NM == 0) = NaN;
    stem(b,P_NM,'LineStyle','none');
    plot(b,T_g,'LineWidth',1.45);
    plot(b,Tq,'--','LineWidth',1.45);
    plot(b,P,'LineWidth',1.45);
    title(sprintf('Results for frame No.%d',frame_to_plot));
    xlabel('Frequency (Bark)')
    ylabel('Magnitude (dB SPL)')
    ylim([-10 200]);
    legend('Tone maskers','Noise maskers','Global masking threshold',...
        'Absolute threshold of hearing','Power Spectral Density');
    hold off
end