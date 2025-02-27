function open_rhd_Callback(app)

FileName=app.drta_handles.p.FileName;
app.drta_handles.drtaWhichFile = FileName;

%     %Setup the matlab header file
[app.drta_handles.draq_p,app.drta_handles.draq_d]=drta03_read_Intan_RHD2000_header(app);


scaling = app.drta_handles.draq_p.scaling;
offset = app.drta_handles.draq_p.offset;

channelAmt = 16;
app.drta_handles.draq_p.dgordra = 3;
app.drta_handles.draq_p.no_spike_ch=channelAmt; % need to find correct number
app.drta_handles.draq_p.daq_gain=1;
app.drta_handles.draq_p.prev_ylim(1:17)=4000;
app.drta_handles.draq_p.no_chans=22; % need to find correct number
app.drta_handles.draq_p.acquire_display_start=0;
app.drta_handles.draq_p.inp_max=10;
% app.drta_handles.p.trialNo=2;
% app.drta_handles.p.low_filter=1000;
% app.drta_handles.p.high_filter=5000;
% app.drta_handles.p.whichPlot=1;
% app.drta_handles.p.lastTrace=-1;
% app.drta_handles.p.exclude_secs=2;
% app.drta_handles.p.set2p5SD=0;
% app.drta_handles.p.setm2p5SD=0;
% app.drta_handles.p.setnxSD=0;
% app.drta_handles.p.nxSD=2.5;
% app.drta_handles.p.showLicks=1;
% app.drta_handles.p.exc_sn=0;
% app.drta_handles.p.read_entire_file=0;
% app.drta_handles.p.setThr=0;
% app.drta_handles.p.thrToSet=0;
% app.drta_handles.p.which_protocol=1;



if exist('drta_p','var') == 1 && isfield(drta_p,'doSubtract')
    app.drta_handles.p.doSubtract=drta_p.doSubtract;
    app.drta_handles.p.subtractCh=drta_p.subtractCh;
else
    app.drta_handles.p.doSubtract=0;
    for i = 1:channelAmt
        app.drta_handles.p.subtractCh{i,1}{:} = 18;
    end
end

for ii=1:app.drta_handles.draq_p.no_spike_ch
    try
        v_max=(app.drta_handles.draq_p.prev_ylim(ii)*app.drta_handles.draq_p.pre_gain*app.drta_handles.draq_p.daq_gain/1000000);
        v_min=-(app.drta_handles.draq_p.prev_ylim(ii)*app.drta_handles.draq_p.pre_gain*app.drta_handles.draq_p.daq_gain/1000000);
        app.drta_handles.draq_p.nat_max(ii)=(v_max-offset)/scaling;
        app.drta_handles.draq_p.nat_min(ii)=(v_min-offset)/scaling;
        app.drta_handles.draq_p.fig_max(ii)=0.12+(0.80/app.drta_handles.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/app.drta_handles.draq_p.no_spike_ch;
        app.drta_handles.draq_p.fig_min(ii)=0.12+(0.80/app.drta_handles.draq_p.no_spike_ch)*(ii-0.5);
    catch
        v_max=(app.drta_handles.draq_p.prev_ylim(ii)*app.drta_handles.draq_p.pre_gain(ii)*app.drta_handles.draq_p.daq_gain/1000000);
        v_min=-(app.drta_handles.draq_p.prev_ylim(ii)*app.drta_handles.draq_p.pre_gain(ii)*app.drta_handles.draq_p.daq_gain/1000000);
        app.drta_handles.draq_p.nat_max(ii)=(v_max-offset)/scaling;
        app.drta_handles.draq_p.nat_min(ii)=(v_min-offset)/scaling;
        app.drta_handles.draq_p.fig_max(ii)=0.12+(0.80/app.drta_handles.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/app.drta_handles.draq_p.no_spike_ch;
        app.drta_handles.draq_p.fig_min(ii)=0.12+(0.80/app.drta_handles.draq_p.no_spike_ch)*(ii-0.5);
    end

end

app.drta_handles.p.trial_ch_processed=ones(channelAmt,app.drta_handles.draq_d.noTrials); 
app.drta_handles.p.trial_allch_processed=ones(1,app.drta_handles.draq_d.noTrials);

if exist('drta_p','var')
    app.drta_handles.p.threshold=drta_p.threshold;
    if (isfield(drta_p,'ch_processed')~=0)
        app.drta_handles.p.ch_processed=drta_p.ch_processed;
    end
    if (isfield(drta_p,'trial_ch_processed')~=0)
        app.drta_handles.p.trial_ch_processed=drta_p.trial_ch_processed;
    end
    if (isfield(drta_p,'trial_allch_processed')~=0)
        app.drta_handles.p.trial_allch_processed=drta_p.trial_allch_processed;
    end
    if (isfield(drta_p,'upper_limit')~=0)
        app.drta_handles.p.upper_limit=drta_p.upper_limit;
        app.drta_handles.p.lower_limit=drta_p.lower_limit;
    end
    if isfield(drta_p,'exc_sn')
        app.drta_handles.p.exc_sn=drta_p.exc_sn;
        %         app.drta_handles.p.exc_sn_thr=drta_p.exc_sn_thr;
        %         app.drta_handles.p.exc_sn_ch=drta_p.exc_sn_ch;
    end
end

app.drta_handles.p.trialNo = 1;

%Find the threshold for the licks
app.drta_handles.p.lick_th_frac=0.3;
one_per=zeros(1,length(app.drta_handles.draq_d.t_trial));
ninetynine_per=zeros(1,length(app.drta_handles.draq_d.t_trial));
ii_from=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time)...
    *app.drta_handles.draq_p.ActualRate+1);
ii_to=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time...
    +app.drta_handles.p.display_interval)*app.drta_handles.draq_p.ActualRate)-2000;
ii=19; %These are licsk

old_trial=app.drta_handles.p.trialNo;

%Find out if the last trial can be read
app.drta_handles.p.trialNo=length(app.drta_handles.draq_d.t_trial);
try 
    data_this_trial=drtaNWB_GetTraceData(app.drta_handles);
catch
    app.drta_handles.draq_d.t_trial=app.drta_handles.draq_d.t_trial(1:end-1);
    app.drta_handles.draq_d.noTrials=app.drta_handles.draq_d.noTrials-1;
end

for trialNo=1:length(app.drta_handles.draq_d.t_trial)
    app.drta_handles.p.trialNo=trialNo;

    %         data_this_trial=handles.draq_d.data(floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*(trialNo-1)+1):...
    %             floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*trialNo)-2000);
    %
    data_this_trial=drtaNWB_GetTraceData(app.drta_handles);


    this_data=[];
    this_data=data_this_trial(floor((ii-1)*app.drta_handles.draq_p.ActualRate*app.drta_handles.draq_p.sec_per_trigger):floor(ii*app.drta_handles.draq_p.ActualRate*app.drta_handles.draq_p.sec_per_trigger));
    one_per(trialNo)=prctile(this_data(ii_from:ii_to),1);
    ninetynine_per(trialNo)=prctile(this_data(ii_from:ii_to),99);

end
app.drta_handles.p.trialNo=old_trial;
app.drta_handles.p.exc_sn_thr=app.drta_handles.p.lick_th_frac*mean(ninetynine_per-one_per);
app.drta_handles.p.lfp.maxLFP=3900;
app.drta_handles.p.lfp.minLFP=50;

app.min_amt.Value = app.drta_handles.p.lfp.minLFP;
app.max_amt.Value = app.drta_handles.p.lfp.maxLFP;

