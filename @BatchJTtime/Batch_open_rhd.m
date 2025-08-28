function Batch_open_rhd(app,FileNum)

fname = sprintf('drtaFile%.3d',FileNum);
%     %Setup the matlab header file
[app.data_files.(fname).draq_p,app.data_files.(fname).draq_d]=drta03_read_Intan_RHD2000_header(app,FileNum);

NumOfCh = app.data_files.(fname).draq_d.num_amplifier_channels;
app.data_files.(fname).p.ch_processed(1:NumOfCh)=1;
app.data_files.(fname).p.lower_limit(1:NumOfCh)=-5000;
app.data_files.(fname).p.threshold(1:NumOfCh)=1300;
app.data_files.(fname).p.threexsdexists(1:NumOfCh) = 0;
app.data_files.(fname).p.upper_limit(1:NumOfCh)=5000;
if ~isfield(app.data_files.(fname).p,'doSubtract')
    app.data_files.(fname).p.doSubtract = 0;
    app.data_files.(fname).p.subtractCh = cell(1,NumOfCh);
end
app.data_files.(fname).draq_p.no_spike_ch=NumOfCh;
app.data_files.(fname).draq_p.prev_ylim(1:NumOfCh)=4000;
app.data_files.(fname).draq_p.no_chans=NumOfCh;


scaling = app.data_files.(fname).draq_p.scaling;
offset = app.data_files.(fname).draq_p.offset;

channelAmt = NumOfCh;
app.data_files.(fname).draq_p.dgordra = 3;
app.data_files.(fname).draq_p.no_spike_ch=channelAmt; % need to find correct number
app.data_files.(fname).draq_p.daq_gain=1;
app.data_files.(fname).draq_p.prev_ylim(1:17)=4000;
app.data_files.(fname).draq_p.no_chans=channelAmt; % need to find correct number
app.data_files.(fname).draq_p.acquire_display_start=0;
app.data_files.(fname).draq_p.inp_max=10;
% app.data_files.(fname).p.trialNo=2;
% app.data_files.(fname).p.low_filter=1000;
% app.data_files.(fname).p.high_filter=5000;
% app.data_files.(fname).p.whichPlot=1;
% app.data_files.(fname).p.lastTrace=-1;
% app.data_files.(fname).p.exclude_secs=2;
% app.data_files.(fname).p.set2p5SD=0;
% app.data_files.(fname).p.setm2p5SD=0;
% app.data_files.(fname).p.setnxSD=0;
% app.data_files.(fname).p.nxSD=2.5;
% app.data_files.(fname).p.showLicks=1;
% app.data_files.(fname).p.exc_sn=0;
% app.data_files.(fname).p.read_entire_file=0;
% app.data_files.(fname).p.setThr=0;
% app.data_files.(fname).p.thrToSet=0;
% app.data_files.(fname).p.which_protocol=1;



if exist('drta_p','var') == 1 && isfield(drta_p,'doSubtract')
    app.data_files.(fname).p.doSubtract=drta_p.doSubtract;
    app.data_files.(fname).p.subtractCh=drta_p.subtractCh;
else
    app.data_files.(fname).p.doSubtract=0;
    for i = 1:channelAmt
        app.data_files.(fname).p.subtractCh{i,1}{:} = 18;
    end
end

for ii=1:app.data_files.(fname).draq_p.no_spike_ch
    try
        v_max=(app.data_files.(fname).draq_p.prev_ylim(ii)*app.data_files.(fname).draq_p.pre_gain*app.data_files.(fname).draq_p.daq_gain/1000000);
        v_min=-(app.data_files.(fname).draq_p.prev_ylim(ii)*app.data_files.(fname).draq_p.pre_gain*app.data_files.(fname).draq_p.daq_gain/1000000);
        app.data_files.(fname).draq_p.nat_max(ii)=(v_max-offset)/scaling;
        app.data_files.(fname).draq_p.nat_min(ii)=(v_min-offset)/scaling;
        app.data_files.(fname).draq_p.fig_max(ii)=0.12+(0.80/app.data_files.(fname).draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/app.data_files.(fname).draq_p.no_spike_ch;
        app.data_files.(fname).draq_p.fig_min(ii)=0.12+(0.80/app.data_files.(fname).draq_p.no_spike_ch)*(ii-0.5);
    catch
        v_max=(app.data_files.(fname).draq_p.prev_ylim(ii)*app.data_files.(fname).draq_p.pre_gain(ii)*app.data_files.(fname).draq_p.daq_gain/1000000);
        v_min=-(app.data_files.(fname).draq_p.prev_ylim(ii)*app.data_files.(fname).draq_p.pre_gain(ii)*app.data_files.(fname).draq_p.daq_gain/1000000);
        app.data_files.(fname).draq_p.nat_max(ii)=(v_max-offset)/scaling;
        app.data_files.(fname).draq_p.nat_min(ii)=(v_min-offset)/scaling;
        app.data_files.(fname).draq_p.fig_max(ii)=0.12+(0.80/app.data_files.(fname).draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/app.data_files.(fname).draq_p.no_spike_ch;
        app.data_files.(fname).draq_p.fig_min(ii)=0.12+(0.80/app.data_files.(fname).draq_p.no_spike_ch)*(ii-0.5);
    end

end

app.data_files.(fname).p.trial_ch_processed=ones(channelAmt,app.data_files.(fname).draq_d.noTrials); 
app.data_files.(fname).p.trial_allch_processed=ones(1,app.data_files.(fname).draq_d.noTrials);

if exist('drta_p','var')
    app.data_files.(fname).p.threshold=drta_p.threshold;
    if (isfield(drta_p,'ch_processed')~=0)
        app.data_files.(fname).p.ch_processed=drta_p.ch_processed;
    end
    if (isfield(drta_p,'trial_ch_processed')~=0)
        app.data_files.(fname).p.trial_ch_processed=drta_p.trial_ch_processed;
    end
    if (isfield(drta_p,'trial_allch_processed')~=0)
        app.data_files.(fname).p.trial_allch_processed=drta_p.trial_allch_processed;
    end
    if (isfield(drta_p,'upper_limit')~=0)
        app.data_files.(fname).p.upper_limit=drta_p.upper_limit;
        app.data_files.(fname).p.lower_limit=drta_p.lower_limit;
    end
    if isfield(drta_p,'exc_sn')
        app.data_files.(fname).p.exc_sn=drta_p.exc_sn;
        %         app.data_files.(fname).p.exc_sn_thr=drta_p.exc_sn_thr;
        %         app.data_files.(fname).p.exc_sn_ch=drta_p.exc_sn_ch;
    end
end

app.data_files.(fname).p.trialNo = 1;

%Find the threshold for the licks
app.data_files.(fname).p.lick_th_frac=0.3;
one_per=zeros(1,length(app.data_files.(fname).draq_d.t_trial));
ninetynine_per=zeros(1,length(app.data_files.(fname).draq_d.t_trial));
ii_from=floor((app.data_files.(fname).draq_p.acquire_display_start+app.data_files.(fname).p.start_display_time)...
    *app.data_files.(fname).draq_p.ActualRate+1);
ii_to=floor((app.data_files.(fname).draq_p.acquire_display_start+app.data_files.(fname).p.start_display_time...
    +app.data_files.(fname).p.display_interval)*app.data_files.(fname).draq_p.ActualRate)-2000;
ii = app.data_files.(fname).draq_p.no_chans + 3; %These are licsk
% ii=19; 

old_trial=app.data_files.(fname).p.trialNo;

%Find out if the last trial can be read
app.data_files.(fname).p.trialNo=length(app.data_files.(fname).draq_d.t_trial);

app.data_files.(fname).p.trialNo=old_trial;
app.data_files.(fname).p.lfp.maxLFP=3900;
app.data_files.(fname).p.lfp.minLFP=50;
