function [x_r,bits] = AnalysisSynthesisFilterbank(t,x,h,g,Tg,M,L,N,type_of_quant,frame_to_plot)
    % Uniform M-Band Maximally Decimated Analysis-Synthesis Filterbank
    % 2.1
    u = zeros(M, L + N - 1); 
    y = zeros(M, ceil( ( N + L - 1 ) / M ));
    w = zeros(M, L + N );
    s = zeros(M, size(w,2)+size(g,2)-1);
    % 2.2
    %   audioinfo('music-dsp19.wav') % -> BitsPerSample : 16
    R = 2^16;
    slen = length(s(1,:));
    x_r = zeros(slen,1);
    
    % For filters 1 to M
    for i = 1:M
        
        % Modified Discrete Cosine Transform (MDCT)
        u(i,:) = conv(h(i,:),x);
        
        % Downsampling by M
        y(i,:) = downsample(u(i,:),M);

        % Quantization
        if strcmp( type_of_quant,'non-adaptive') 
            % Non adaptive quantizer
            [bits,partition,codebook] = quantization_values(0,-1,1,R,Tg);
            elseif strcmp( type_of_quant,'adaptive') 
            % Adaptive quantizer
            [bits,partition,codebook] = quantization_values(1,min(y(i,:)),max(y(i,:)),R,Tg);
            else
            disp('Error');
            return
        end
        for j = 1:size(y,2)
            [~,y2(i,j)] = quantiz(y(i,j),partition,codebook);
        end
        
        % Upsampling by M
        w(i,:) = upsample(y2(i,:),M);

        % Synthesis
        s(i,:) = conv(g(i,:),w(i,:));

        % Reconstructed signal
        x_r = x_r + s(i,:)';
    end
    
    
    if t == frame_to_plot
        figure;
        subplot(3, 2, 1); hold on; title('Signal x_1[n]'); xlabel('n'); plot(x(1:M),'LineWidth',1.3); hold off
        subplot(3, 2, 2); hold on; title('Convolved signal u_1[n]');  xlabel('n'); plot(u(1, :),'LineWidth',1.3); hold off
        subplot(3, 2, 3); hold on; title('Downsampled by M convolved signal y_1[n]'); xlabel('n'); plot(y(1, :),'LineWidth',1.3); hold off;
        subplot(3, 2, 4); hold on; title('Quantized and upsampled by M signal w_1[n]'); xlabel('n'); plot(w(1, :),'LineWidth',1.3); hold off;
        subplot(3, 2, 5); hold on; title('Synthesized signal s_1[n]'); xlabel('n'); plot(s(1, :),'LineWidth',1.3); hold off;
        
        figure;
        subplot(2, 1, 1); hold on; title('Signal x[n]'); xlabel('n'); plot(x,'LineWidth',1.3); hold off
        subplot(2, 1, 2); hold on; title(sprintf('Reconstructed window x_r_e_c[n]-%s',type_of_quant)); plot(x_r,'LineWidth',1.3); xlabel('n'); hold off
    end
    
end