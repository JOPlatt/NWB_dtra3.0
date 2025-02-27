function drta03_SetPreferences(app)


%{
Setting up initial parameters (drta_handles.p)
%}
app.drta_handles.p.ch_processed(1:16)=1;
%
app.drta_handles.p.do_filter=1;
app.drta_handles.p.dt_pre_snip=0.0005;
app.drta_handles.p.dt_post_snip=0.001;
app.drta_handles.p.do_3xSD=0;
app.drta_handles.p.display_interval=9;
%
app.drta_handles.p.exclude_secs = 2;
app.drta_handles.p.exc_sn = 0;
%
app.drta_handles.p.filter_dt=0.001666667;
%
app.drta_handles.p.high_filter = 5000;
%
app.drta_handles.p.lastTrace = -1;
app.drta_handles.p.lfp.maxLFP=9800;
app.drta_handles.p.lfp.minLFP=-9800;
app.drta_handles.p.lfp.delta_max_min_out=0.5;
app.drta_handles.p.low_filter = 1000;
app.drta_handles.p.lower_limit(1:16)=-5000;
%
app.drta_handles.p.nxSD = 2.5;
%
app.drta_handles.p.read_entire_file = 0;
%
app.drta_handles.p.setThr = 0;
app.drta_handles.p.start_display_time=0;
app.drta_handles.p.showLicks = 1;
app.drta_handles.p.set2p5SD = 0;
app.drta_handles.p.setm2p5SD = 0;
app.drta_handles.p.setnxSD = 0;
%
app.drta_handles.p.thrToSet = 0;
app.drta_handles.p.threshold(1:16)=1300;
app.drta_handles.p.threexsdexists(1:16) = 0;
app.drta_handles.p.trialNo = 1;
%
app.drta_handles.p.upper_limit(1:16)=5000;
%
app.drta_handles.p.whichPlot = 1;
app.drta_handles.p.which_protocol = 1;
app.drta_handles.p.which_display_th=1;
app.drta_handles.p.which_c_program=1;
app.drta_handles.p.which_channel=1;
app.drta_handles.p.which_display=1;
app.drta_handles.p.which_channel_th=1;
%
%Preferences for mspy
app.drta_handles.p.mspy_exclude_dt=1; %Exclude
app.drta_handles.p.pmspy_key_offset=2; %Use 2 for mspy before 3/13, and 0 afterwards

if ~isfield(app.drta_handles.p,'doSubtract')
    app.drta_handles.p.doSubtract = 0;
    app.drta_handles.p.subtractCh = cell(1,16);
end

%
app.drta_handles.draq_p.auto_thr_sign=1;
app.drta_handles.draq_p.no_spike_ch=16;
app.drta_handles.draq_p.daq_gain=1;
app.drta_handles.draq_p.prev_ylim(1:17)=4000;
app.drta_handles.draq_p.no_chans=22;
app.drta_handles.draq_p.acquire_display_start=0;
app.drta_handles.draq_p.inp_max=10;
% setting GUI values
app.trial_amt.Value = 9;
app.dt_amt.Value = 6;
% setting protocol options
app.protocolDropDown.Items = ...
    {'dropcspm', ...
    'laser (Ming)', ...
    'dropcnsampler', ...
    'laser (Merouann)', ...
    'dropc_conc', ...
    'dropcspm_hf', ...
    'continuous', ...
    'working_memory', ...
    'laser (Schoppa)'};
