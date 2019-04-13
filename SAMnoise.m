% Plot a segment of Stimulus

clear all
clc

% STIMULUS PARAMETERS:
fs = 48000;             % sampling rate (Hz)
Dur = 250e-3;           % signal duration (sec)
npts = Dur * fs;        % number of points in stimulus waveform
dBSPL = 30;             % SPL (dB re: 20uPa)
m1 = 10^(-5/20);      % SAM modulation depth  
m2 = 10^(-0/20);      % SAM modulation depth  
fm = 32;                % SAM modulation frequency (Hz)

% window time domain waveform
rampdur = 5e-3;         % duration of cos-squared onset/offset (sec)
rampts = fs * rampdur;
step = pi/(rampts-1);
x = 0:step:pi;

%stim1 = (sqrt(2))*amp*sin(2*pi*fc*t);
amp = 10^(-(94-dBSPL)/20);  % for scaling stimuli into Pascals
t = [0:npts-1]/fs;      % stimulus time vector
stim1 = (sqrt(2))*amp*wgn(fs*Dur,1,1)';
modulator1 = m1*sin(2*pi*fm*t);
modulator2 = m2*sin(2*pi*fm*t);
stim21 = ((1 + modulator1).*(stim1));
stim22 = ((1 + modulator2).*(stim1));
am_tone1 = (sqrt(mean(stim1.^2))/sqrt(mean(stim21.^2))).*stim21;   % SAM tone (scaled to same rms as pure tone)
am_tone2 = (sqrt(mean(stim1.^2))/sqrt(mean(stim22.^2))).*stim22;   % SAM tone (scaled to same rms as pure tone)

%%
figure
sp1 = subplot(321);
set(sp1,'position',[0.1 0.72 0.4 0.25])
plot(t*1000,stim1/max(max(stim1),min(stim1)),'k')
axis([0 250 -1.1 1.1])
set(gca,'fontsize',12,'xtick',[])
% xlabel('Time (ms)','fontsize',12)
% ylabel('Normalized Amplitude','fontsize',12)
% title('unmodulated','fontsize',12,'fontweight','normal')
% legend('unmodulated')

sp2 = subplot(322);
set(sp2,'position',[0.6 0.72 0.35 0.25])
plotfft(stim1,fs,[10 4000],'dB');
ylim([-60 0])
set(gca,'fontsize',12,'xtick',[])


sp3 = subplot(323);
set(sp3,'position',[0.1 0.42 0.4 0.25])
plot(t*1000,am_tone1/max(max(am_tone1),min(am_tone1)),'k')
axis([0 250 -1.1 1.1])
set(gca,'fontsize',12,'xtick',[])
% xlabel('Time (ms)','fontsize',12)
ylabel('Normalized Amplitude','fontsize',12)
% title('depth = -5 dB','fontsize',12,'fontweight','normal')

sp4 = subplot(324);
set(sp4,'position',[0.6 0.42 0.35 0.25])
plotfft(am_tone1,fs,[10 4000],'dB');
ylim([-60 0])
set(gca,'fontsize',12,'xtick',[])
ylabel('Amplitude (dB)','fontsize',12)


sp5 = subplot(325);
set(sp5,'position',[0.1 0.12 0.4 0.25])
plot(t*1000,am_tone2/max(max(am_tone2),min(am_tone2)),'k')
axis([0 250 -1.1 1.1])
set(gca,'fontsize',12)
xlabel('Time (ms)','fontsize',12)
% ylabel('Normalized Amplitude','fontsize',12)
% title('depth = 0 dB','fontsize',12,'fontweight','normal')

sp6 = subplot(326);
set(sp6,'position',[0.6 0.12 0.35 0.25])
plotfft(am_tone2,fs,[10 4000],'dB');
ylim([-60 0])
set(gca,'fontsize',12)
xlabel('Frequency (Hz)','fontsize',12)

