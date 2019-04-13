% scatter and fitting of RA for 32 Hz and -5 dB depth
load('RA_model(allCFsCarrier)model1.mat')

%% scatter for all modulation rates and depth  
Depth = -(0:30);
Fre = [32 64 128 256];
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
res = zeros(4,length(Depth));
for i=1:4
    for j=1:length(Depth)
        res(i,j) = 10^(RA_mean(i,j)/20);
    end
end

%% scatter and fitting for 32 Hz and -5 dB

load('A0.mat')
fm_index = 4;
p0 = A0(fm_index,:);
para = lsqcurvefit(@myfun,p0,Depth,RA_mean(fm_index,:),[0 -30 0],[1 0 1]);
figure
hold on;
for i1 = 1:length(Depth)
    for count=1:100
        sc = plot(Depth(i1),RA_model(fm_index,i1,count),'*','color',[0.7 0.7 0.7],'markersize',3);
    end
end
eb = errorbar(Depth,RA_mean(fm_index,:),RA_std(fm_index,:),'--sk','MarkerSize',4,'MarkerEdgeColor','k','MarkerFaceColor','w','linewidth',1);
ft = plot(Depth,myfun(para,Depth),'r-','linewidth',2);
line([para(2) para(2)],[-27 15],'linestyle','--','color','b','linewidth',1)
text(para(2)+2,-5,['T = ' num2str(roundn(para(2),-2)) ' dB'],'color','b','fontsize',12)

lg = legend([sc,eb,ft],'individual','average','fitting curve');
set(lg,'location','northwest')
xlabel('Modulation depth (dB)');
ylabel('Relative amplitude (dB)','fontsize',14)
axis([-32 2 -10 30]);
set(gca,'FontSize',14)
box on
