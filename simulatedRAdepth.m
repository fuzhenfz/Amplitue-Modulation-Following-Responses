% calculate simulated RA for all modulation rates and depth
clear
clc

Fre = [32 64 128 256];
Depth = -(0:30);
%Depth = [-5 -10 -15 -20 -25 -30];

fs = 20000;
Dur = 300e-3;
Total = length(Fre);
len2cf;
RA_model = zeros(Total,length(Depth),100);
RA_mean = zeros(Total,length(Depth));
RA_std = zeros(Total,length(Depth));
hwait = waitbar(0,'waiting...');
for count = 1:100 % 仿真100次
    waitbar(count/100,hwait,[num2str(count),'/100']);    
    for i = 1:Total
        Freq = Fre(i);
        x_Freq = Freq / 4;
        for j = 1:length(Depth)
            Carrier = wgn(fs*Dur,1,1)';
            [OutputAveragedCFs,output] = Output_SAM(Freq,cf,Depth(j),Carrier,fs,Dur);
            spec = abs(fft(OutputAveragedCFs));
            spec = [spec(2:length(spec)) 1];
%             spec = resample(spec,fs/4,length(spec));% 重采样至fs/4
            RA = spec(x_Freq) / ((spec(x_Freq-1)+spec(x_Freq-2)+spec(x_Freq-3)+spec(x_Freq+1)+spec(x_Freq+2)+spec(x_Freq+3))/6);
            %         RA = mean(spec(Freq-2:Freq+2)) / mean(spec([Freq-14:Freq-3,Freq+3:Freq+14]));
            RA = 20 * log10(RA);            
            RA_model(i,j,count) = RA;
        end
    end
end
close(hwait);
save('RA_model(allCFsCarrier)model1.mat','RA_model');
%%


for i=1:4
    for j=1:length(Depth)
        RA_mean(i,j) = mean(RA_model(i,j,:));
        RA_std(i,j) = std(RA_model(i,j,:),1);
    end
end

figure
for i=1:4
    subplot(1,4,i);
    errorbar(Depth,RA_mean(i,:),RA_std(i,:),'--ob');
    title([num2str(Fre(i)),'Hz']);
    xlabel('Depth');
    xlim([-35 0]);
    grid on;
    hold off;
end