function [OutputAveragedCFs,output] = Output_SAM(f_m,cf,Depth,Carrier,fs,Dur)

% STIMULUS PARAMETERS:

npts = Dur * fs;        % number of points in stimulus waveform
% fc = 8000;              % carrier (audio) frequency
dBSPL = 30;             % SPL (dB re: 20uPa)
m = 10^(Depth/20);      % SAM modulation depth
fm = f_m;                % SAM modulation frequency (Hz)


% AN MODEL PARAMETERS:
tdres = 1 / fs;       % time domain resolution (seconds)
% cf = fc;                % model CF = stimulus carrier frequency
spontrate = 50;       % spontaneous rate (sp/sec)
model = 1;            % model version (see README)
% model=3 was used in Nelson & Carney (2004)
species = 0;             % species (=0 for human, =9 for cat)
ifspike = 0;          % flag for scaling to generate spikes or not
shift = 2*spontrate;  % magnitude of 'shift' in new synapse model

% CN MODEL PARAMETERS:
tau_ex_cn = .5e-3;         % CN exc time constant
tau_inh_cn = 2e-3;         % CN inh time constant
cn_delay = 1e-3;        % "disynaptic inhibition delay" (all ANFs excitatory)
inh_str_cn = 0.6;       % re: excitatory strength == 1
afamp_cn = 1.5;         % alpha function area --> changes RATE of output cell

% IC MODEL PARAMETERS:
tau_ex_ic = 1e-3;       % IC exc time constant
tau_inh_ic = 3e-3;      % IC inh tune constant
ic_delay = 0.002;       % delay along inhibitory pathway
inh_str_ic = 1.5;       % re: exc strength == 1
afamp_ic = 1;           % alpha function area --> changes RATE of output cell


% window time domain waveform
rampdur = 5e-3;         % duration of cos-squared onset/offset (sec)
rampts = fs * rampdur;
step = pi/(rampts-1);
x = [0:step:pi];
offramp = (1+cos(x))./2;
onramp = (1+cos(fliplr(x)))./2;
steadypts = npts - 2*rampts;
o = ones(1,steadypts);
wholeramp = [onramp o offramp]; % Envelope for stimulus (i.e. on/off ramps)
%%%%%%%%%%%%%%%

amp = 10^(-(94-dBSPL)/20);  % for scaling stimuli into Pascals
t = [0:npts-1]/fs;      % stimulus time vector


%stim1 = (sqrt(2))*amp*sin(2*pi*fc*t);
stim1 = (sqrt(2))*amp*Carrier;
%stim1 = (sqrt(2))*amp*wgn(fs*Dur,1,1)';
modulator = m*sin(2*pi*fm*t);
stim2 = ((1 + modulator).*(stim1));
am_tone = (sqrt(mean(stim1.^2))/sqrt(mean(stim2.^2))).*stim2;   % SAM tone (scaled to same rms as pure tone)
% output = zeros(length(cf),5000);
for i0=1:length(cf)
    % Call AN model:
    an_sout = an_arlo_newsyn([tdres,cf(i0),spontrate,model,species,ifspike,shift],am_tone);  % for SAM tone
    
    
    % Generate alpha functions for CN model:
    alength_1 = fs*10*tau_ex_cn;    % limit duration of alpha functions for computations
    alength_2 = fs*10*tau_inh_cn;   % they are essentially zero for times longer than 10x their time constant
    
    i1 = 1:max(alength_1,alength_2);
    alpha_ex(i1) = (i1-1)*tdres .* exp(-(i1-1)*tdres/tau_ex_cn);    % generate alpha functions
    alpha_inh(i1) = (i1-1)*tdres .* exp(-(i1-1)*tdres/tau_inh_cn);
    alpha_ex = afamp_cn*alpha_ex/(sum(alpha_ex));                % normalize and scale
    alpha_inh = afamp_cn*inh_str_cn*alpha_inh/(sum(alpha_inh));
    
    cn_ex= [conv(alpha_ex,an_sout) zeros(1,fs*cn_delay)];   % carry out (SLOW) convolution: excitory input
    cn_inh= [zeros(1,fs*cn_delay) conv(alpha_inh,an_sout)];  % carry out (SLOW) convolution: inhibitory input
    
    % final CN model response:
    cn_sout = ((cn_ex-cn_inh) + abs(cn_ex-cn_inh))/2;   % subtract inhibition from excitation and half-wave-rectify
    
    cn_t = [0:(length(cn_sout)-1)]/fs;        % time vector for plotting CN responses
    
    
    % Generate alpha functions for IC model (same as CN model, but with different taus):
    alength_3 = fs*10*tau_ex_ic;
    alength_4 = fs*10*tau_inh_ic;
    i2 = 1:max(alength_3,alength_4);
    
    alpha_ex_ic(i2) = (i2-1)*tdres .* exp(-(i2-1)*tdres/tau_ex_ic);
    alpha_inh_ic(i2) = (i2-1)*tdres .* exp(-(i2-1)*tdres/tau_inh_ic);
    alpha_ex_ic = afamp_ic*alpha_ex_ic/(sum(alpha_ex_ic));
    alpha_inh_ic = afamp_ic*inh_str_ic*alpha_inh_ic/(sum(alpha_inh_ic));
    
    ic_lp_ex1 = [conv(alpha_ex_ic,cn_sout) zeros(1,fs*ic_delay)];
    ic_lp_inh1 = [zeros(1,fs*ic_delay) conv(alpha_inh_ic,cn_sout)];
    
    % final IC model response:
    ic_sout(i0,:) = ((ic_lp_ex1-ic_lp_inh1) + abs(ic_lp_ex1-ic_lp_inh1))/2;
    ic_t = [0:(length(ic_sout)-1)]/fs;
    
    % figure
    % subplot(411);plot(t,am_tone);ylabel('STIMULUS');axis([0 Dur+.025 1.1*min(am_tone) 1.1*max(am_tone)])
    % subplot(412);plot(t,an_sout);ylabel('AN SOUT');axis([0 Dur+.025 0 1.1*max(an_sout)])
    % subplot(413);plot(cn_t,cn_sout);ylabel('CN SOUT');axis([0 Dur+.025 0 1.1*max(cn_sout)])
    % subplot(414);plot(ic_t,ic_sout);ylabel('IC SOUT');axis([0 Dur+.025 0 1.1*max(ic_sout)]);xlabel('time (sec)')
    unitary_response = importdata('unitary_no_reg.mat');
    unitary_response = unitary_response(9:end);
    temp = conv(unitary_response,ic_sout(i0,:));
    % plot(output)
    %     output(i0,:) = temp;% 取全部
    output(i0,:) = temp(1001:6000);% 取稳态的部分，此时长度为5000，恰好是采样率的1/4
end
OutputAveragedCFs = mean(output);
% 注：由于卷积具有交换律，所以((AN-VCN-IC)*UR)× 500cf 等价于 ((AN-VCN-IC) × 500cf) * UR 
