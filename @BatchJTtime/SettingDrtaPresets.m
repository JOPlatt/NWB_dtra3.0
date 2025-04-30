function SettingDrtaPresets(app)

app.drta_data.p.do_filter=1;
app.drta_data.p.dt_pre_snip=0.0005;
app.drta_data.p.dt_post_snip=0.001;
app.drta_data.p.do_3xSD=0;
app.drta_data.p.display_interval=9;
%
app.drta_data.p.exclude_secs = 2;
app.drta_data.p.exc_sn = 0;
%
app.drta_data.p.filter_dt=0.001666667;
%
app.drta_data.p.high_filter = 5000;
%
app.drta_data.p.lastTrace = -1;
app.drta_data.p.lfp.maxLFP=9800;
app.drta_data.p.lfp.minLFP=-9800;
app.drta_data.p.lfp.delta_max_min_out=0.5;
app.drta_data.p.low_filter = 1000;

%
app.drta_data.p.nxSD = 2.5;
%
app.drta_data.p.read_entire_file = 0;
%
app.drta_data.p.setThr = 0;
app.drta_data.p.start_display_time=0;
app.drta_data.p.showLicks = 1;
app.drta_data.p.set2p5SD = 0;
app.drta_data.p.setm2p5SD = 0;
app.drta_data.p.setnxSD = 0;
%
app.drta_data.p.thrToSet = 0;


app.drta_data.p.trialNo = 1;
%

%
app.drta_data.p.whichPlot = 1;
app.drta_data.p.which_protocol = 1;
app.drta_data.p.which_display_th=1;
app.drta_data.p.which_c_program=1;
app.drta_data.p.which_channel=1;
app.drta_data.p.which_display=1;
app.drta_data.p.which_channel_th=1;
%
%Preferences for mspy
app.drta_data.p.mspy_exclude_dt=1; %Exclude
app.drta_data.p.pmspy_key_offset=2; %Use 2 for mspy before 3/13, and 0 afterwards



%
app.drta_data.draq_p.auto_thr_sign=1;

app.drta_data.draq_p.daq_gain=1;

app.drta_data.draq_p.acquire_display_start=0;
app.drta_data.draq_p.inp_max=10;