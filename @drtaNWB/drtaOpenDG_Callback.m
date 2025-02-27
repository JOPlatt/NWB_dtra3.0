function drtaOpenDG_Callback(app)
%             drtaOpenDG_Callback(hObject, eventdata, app.drta_handles)
% hObject    handle to drtaOpenDG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% app.drta_handles    structure with app.drta_handles and user data (see GUIDATA)


FileName=app.drta_handles.p.FileName;
set(app.drta_handles.drtaWhichFile,'String',FileName);
load([app.drta_handles.p.fullName(1:end-2),'mat']);
try
    app.drta_handles.draq_p=params;
    app.drta_handles.draq_d=data;
catch
    app.drta_handles.draq_p=draq_p;
    app.drta_handles.draq_d=draq_d;
end


app.drta_handles.draq_p.dgordra=2;
% sz_t_trial=size(draq_d.t_trial);
% sz_samp=size(draq_d.samplesPerTrial);
% if (sz_t_trial(2)<data.noTrials)||(sz_samp(2)<data.noTrials)
%    app.drta_handles.draq_d.noTrials=min([sz_t_trial(2) sz_samp(2)]);
% end
%app.drta_handles.p.fid=fopen(app.drta_handles.p.fullName,'r');

scaling = app.drta_handles.draq_p.scaling;
offset = app.drta_handles.draq_p.offset;

app.drta_handles.draq_p.no_spike_ch=16;
app.drta_handles.draq_p.daq_gain=8;
app.drta_handles.draq_p.prev_ylim(1:17)=4000;
app.drta_handles.draq_p.no_chans=22;
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



if exist('drta_p')==1
    if isfield(drta_p,'doSubtract')
        app.drta_handles.p.doSubtract=drta_p.doSubtract;
        app.drta_handles.p.subtractCh=drta_p.subtractCh;
    else
        app.drta_handles.p.doSubtract=0;
        app.drta_handles.p.subtractCh=[18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18];
    end
else
    app.drta_handles.p.doSubtract=0;
    app.drta_handles.p.subtractCh=[18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18];
end

for (ii=1:app.drta_handles.draq_p.no_spike_ch)
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

app.drta_handles.p.trial_ch_processed=ones(16,app.drta_handles.draq_d.noTrials);
app.drta_handles.p.trial_allch_processed=ones(1,app.drta_handles.draq_d.noTrials);

if (exist('drta_p')~=0)
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

app.drta_handles.p.trialNo=1;

%Read recordings
if app.drta_handles.p.read_entire_file==1
    app.drta_handles.draq_d.data=drtaReadData(app.drta_handles);
end

%Find the threshold for the licks
app.drta_handles.p.lick_th_frac=0.3;
one_per=zeros(1,length(app.drta_handles.draq_d.t_trial));
ninetynine_per=zeros(1,length(app.drta_handles.draq_d.t_trial));
ii_from=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time)...
    *app.drta_handles.draq_p.ActualRate+1);
ii_to=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time...
    +app.drta_handles.p.display_interval)*app.drta_handles.draq_p.ActualRate)-2000;
ii=19; %These are licks

old_trial=app.drta_handles.p.trialNo;
for trialNo=1:length(app.drta_handles.draq_d.t_trial)-1
    app.drta_handles.p.trialNo=trialNo;

    data_this_trial=drtaGetTraceData(app.drta_handles);

    this_data=[];
    this_data=data_this_trial(:,ii);
    one_per(trialNo)=prctile(this_data(ii_from:ii_to),0.5);
    ninetynine_per(trialNo)=prctile(this_data(ii_from:ii_to),99.5);
end
app.drta_handles.p.trialNo=old_trial;
app.drta_handles.p.exc_sn_thr=app.drta_handles.p.lick_th_frac*mean(ninetynine_per-one_per);

app.drta_handles.p.lfp.maxLFP=4100;
app.drta_handles.p.lfp.minLFP=10;

% Update app.drta_handles structure
guidata(hObject, app.drta_handles);


%Open threshold window
h=drtaThresholdSnips;
app.drta_handles.w.drtaThresholdSnips=h;
drtaUpdateAllapp.drta_handlespw(hObject,app.drta_handles);
drtaThresholdSnips('updateapp.drta_handles',h,eventdata,app.drta_handles);

%Open browse traces
h=drtaBrowseTraces;
app.drta_handles.w.drtaBrowseTraces=h;
% Update app.drta_handles structure
guidata(hObject, app.drta_handles);
% Update app.drta_handles structure here and elsewhere
drtaUpdateAllapp.drta_handlespw(hObject, app.drta_handles);
drtaBrowseTraces('updateapp.drta_handles',h,eventdata,app.drta_handles);
drtaBrowseTraces('updateBrowseTraces',h);


