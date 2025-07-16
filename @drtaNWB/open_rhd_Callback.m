function open_rhd_Callback(app)

FileName=app.drta_Data.p.FileName;
app.drta_Data.drtaWhichFile = FileName;

%     %Setup the matlab header file
[app.drta_Data.draq_p,app.drta_Data.draq_d]=drta03_read_Intan_RHD2000_header(app);

NumOfCh = app.drta_Data.draq_d.num_amplifier_channels;
app.drta_Data.p.ch_processed(1:NumOfCh)=1;
app.drta_Data.p.lower_limit(1:NumOfCh)=-5000;
app.drta_Data.p.threshold(1:NumOfCh)=1300;
app.drta_Data.p.threexsdexists(1:NumOfCh) = 0;
app.drta_Data.p.upper_limit(1:NumOfCh)=5000;
if ~isfield(app.drta_Data.p,'doSubtract')
    app.drta_Data.p.doSubtract = 0;
    app.drta_Data.p.subtractCh = cell(1,NumOfCh);
end
app.drta_Data.draq_p.no_spike_ch=NumOfCh;
app.drta_Data.draq_p.prev_ylim(1:NumOfCh)=4000;
app.drta_Data.draq_p.no_chans=NumOfCh;


scaling = app.drta_Data.draq_p.scaling;
offset = app.drta_Data.draq_p.offset;

channelAmt = NumOfCh;
app.drta_Data.draq_p.dgordra = 3;
app.drta_Data.draq_p.no_spike_ch=channelAmt; % need to find correct number
app.drta_Data.draq_p.daq_gain=1;
app.drta_Data.draq_p.prev_ylim(1:17)=4000;
app.drta_Data.draq_p.no_chans=channelAmt; % need to find correct number
app.drta_Data.draq_p.acquire_display_start=0;
app.drta_Data.draq_p.inp_max=10;
% app.drta_Data.p.trialNo=2;
% app.drta_Data.p.low_filter=1000;
% app.drta_Data.p.high_filter=5000;
% app.drta_Data.p.whichPlot=1;
% app.drta_Data.p.lastTrace=-1;
% app.drta_Data.p.exclude_secs=2;
% app.drta_Data.p.set2p5SD=0;
% app.drta_Data.p.setm2p5SD=0;
% app.drta_Data.p.setnxSD=0;
% app.drta_Data.p.nxSD=2.5;
% app.drta_Data.p.showLicks=1;
% app.drta_Data.p.exc_sn=0;
% app.drta_Data.p.read_entire_file=0;
% app.drta_Data.p.setThr=0;
% app.drta_Data.p.thrToSet=0;
% app.drta_Data.p.which_protocol=1;



if exist('drta_p','var') == 1 && isfield(drta_p,'doSubtract')
    app.drta_Data.p.doSubtract=drta_p.doSubtract;
    app.drta_Data.p.subtractCh=drta_p.subtractCh;
else
    app.drta_Data.p.doSubtract=0;
    for i = 1:channelAmt
        app.drta_Data.p.subtractCh{i,1}{:} = 18;
    end
end

for ii=1:app.drta_Data.draq_p.no_spike_ch
    try
        v_max=(app.drta_Data.draq_p.prev_ylim(ii)*app.drta_Data.draq_p.pre_gain*app.drta_Data.draq_p.daq_gain/1000000);
        v_min=-(app.drta_Data.draq_p.prev_ylim(ii)*app.drta_Data.draq_p.pre_gain*app.drta_Data.draq_p.daq_gain/1000000);
        app.drta_Data.draq_p.nat_max(ii)=(v_max-offset)/scaling;
        app.drta_Data.draq_p.nat_min(ii)=(v_min-offset)/scaling;
        app.drta_Data.draq_p.fig_max(ii)=0.12+(0.80/app.drta_Data.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/app.drta_Data.draq_p.no_spike_ch;
        app.drta_Data.draq_p.fig_min(ii)=0.12+(0.80/app.drta_Data.draq_p.no_spike_ch)*(ii-0.5);
    catch
        v_max=(app.drta_Data.draq_p.prev_ylim(ii)*app.drta_Data.draq_p.pre_gain(ii)*app.drta_Data.draq_p.daq_gain/1000000);
        v_min=-(app.drta_Data.draq_p.prev_ylim(ii)*app.drta_Data.draq_p.pre_gain(ii)*app.drta_Data.draq_p.daq_gain/1000000);
        app.drta_Data.draq_p.nat_max(ii)=(v_max-offset)/scaling;
        app.drta_Data.draq_p.nat_min(ii)=(v_min-offset)/scaling;
        app.drta_Data.draq_p.fig_max(ii)=0.12+(0.80/app.drta_Data.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/app.drta_Data.draq_p.no_spike_ch;
        app.drta_Data.draq_p.fig_min(ii)=0.12+(0.80/app.drta_Data.draq_p.no_spike_ch)*(ii-0.5);
    end

end

app.drta_Data.p.trial_ch_processed=ones(channelAmt,app.drta_Data.draq_d.noTrials); 
app.drta_Data.p.trial_allch_processed=ones(1,app.drta_Data.draq_d.noTrials);

if exist('drta_p','var')
    app.drta_Data.p.threshold=drta_p.threshold;
    if (isfield(drta_p,'ch_processed')~=0)
        app.drta_Data.p.ch_processed=drta_p.ch_processed;
    end
    if (isfield(drta_p,'trial_ch_processed')~=0)
        app.drta_Data.p.trial_ch_processed=drta_p.trial_ch_processed;
    end
    if (isfield(drta_p,'trial_allch_processed')~=0)
        app.drta_Data.p.trial_allch_processed=drta_p.trial_allch_processed;
    end
    if (isfield(drta_p,'upper_limit')~=0)
        app.drta_Data.p.upper_limit=drta_p.upper_limit;
        app.drta_Data.p.lower_limit=drta_p.lower_limit;
    end
    if isfield(drta_p,'exc_sn')
        app.drta_Data.p.exc_sn=drta_p.exc_sn;
        %         app.drta_Data.p.exc_sn_thr=drta_p.exc_sn_thr;
        %         app.drta_Data.p.exc_sn_ch=drta_p.exc_sn_ch;
    end
end

app.drta_Data.p.trialNo = 1;


% ii=19; 

old_trial=app.drta_Data.p.trialNo;

%Find out if the last trial can be read
app.drta_Data.p.trialNo=length(app.drta_Data.draq_d.t_trial);
try 
    drtaNWB_GetTraceData(app,app.drta_Data.p.trialNo);
catch
    app.drta_Data.draq_d.t_trial=app.drta_Data.draq_d.t_trial(1:end-1);
    app.drta_Data.draq_d.noTrials=app.drta_Data.draq_d.noTrials-1;
end

% processing licks from analog data
%Find the threshold for the licks
app.drta_Data.p.lick_th_frac=0.3;
one_per=zeros(1,length(app.drta_Data.draq_d.t_trial));
ninetynine_per=zeros(1,length(app.drta_Data.draq_d.t_trial));
ii_from=floor((app.drta_Data.draq_p.acquire_display_start+app.drta_Data.p.start_display_time)...
    *app.drta_Data.draq_p.ActualRate+1);
ii_to=floor((app.drta_Data.draq_p.acquire_display_start+app.drta_Data.p.start_display_time...
    +app.drta_Data.p.display_interval)*app.drta_Data.draq_p.ActualRate)-2000;
ii = 2; %These are licsk
if ~isempty(app.drta_Data.Signals.Analog)
    for trialNo=1:length(app.drta_Data.draq_d.t_trial)
        app.drta_Data.p.trialNo=trialNo;
        drtaNWB_GetTraceData(app,trialNo);
        %         data_this_trial=handles.draq_d.data(floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*(trialNo-1)+1):...
        %             floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*trialNo)-2000);
        %
        this_data=app.drta_Data.Signals.Analog(floor((ii-1)*app.drta_Data.draq_p.ActualRate*app.drta_Data.draq_p.sec_per_trigger):floor(ii*app.drta_Data.draq_p.ActualRate*app.drta_Data.draq_p.sec_per_trigger));
        one_per(trialNo)=prctile(this_data(ii_from:ii_to),1);
        ninetynine_per(trialNo)=prctile(this_data(ii_from:ii_to),99);
    end
end
app.drta_Data.p.trialNo=old_trial;

app.drta_Data.p.lfp.maxLFP=3900;
app.drta_Data.p.lfp.minLFP=50;
app.drta_Data.p.exc_sn_thr=app.drta_Data.p.lick_th_frac*mean(ninetynine_per-one_per);
app.min_amt.Value = app.drta_Data.p.lfp.minLFP;
app.max_amt.Value = app.drta_Data.p.lfp.maxLFP;

