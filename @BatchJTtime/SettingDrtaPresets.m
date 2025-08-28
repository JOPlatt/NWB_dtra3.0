function SettingDrtaPresets(app,FileNum)

fname = sprintf('drtaFile%.3d',FileNum);
app.data_files.(fname)
app.data_files.(fname).p.do_filter=1;
app.data_files.(fname).p.dt_pre_snip=0.0005;
app.data_files.(fname).p.dt_post_snip=0.001;
app.data_files.(fname).p.do_3xSD=0;
app.data_files.(fname).p.display_interval=9;
%
app.data_files.(fname).p.exclude_secs = 2;
app.data_files.(fname).p.exc_sn = 0;
%
app.data_files.(fname).p.filter_dt=0.001666667;
%
app.data_files.(fname).p.high_filter = 5000;
%
app.data_files.(fname).p.lastTrace = -1;
app.data_files.(fname).p.lfp.maxLFP=9800;
app.data_files.(fname).p.lfp.minLFP=-9800;
app.data_files.(fname).p.lfp.delta_max_min_out=0.5;
app.data_files.(fname).p.low_filter = 1000;

%
app.data_files.(fname).p.nxSD = 2.5;
%
app.data_files.(fname).p.read_entire_file = 0;
%
app.data_files.(fname).p.setThr = 0;
app.data_files.(fname).p.start_display_time=0;
app.data_files.(fname).p.showLicks = 1;
app.data_files.(fname).p.set2p5SD = 0;
app.data_files.(fname).p.setm2p5SD = 0;
app.data_files.(fname).p.setnxSD = 0;
%
app.data_files.(fname).p.thrToSet = 0;


app.data_files.(fname).p.trialNo = 1;
%

%
app.data_files.(fname).p.whichPlot = 1;
app.data_files.(fname).p.which_protocol = 1;
app.data_files.(fname).p.which_display_th=1;
app.data_files.(fname).p.which_c_program=1;
app.data_files.(fname).p.which_channel=1;
app.data_files.(fname).p.which_display=1;
app.data_files.(fname).p.which_channel_th=1;
%
%Preferences for mspy
app.data_files.(fname).p.mspy_exclude_dt=1; %Exclude
app.data_files.(fname).p.pmspy_key_offset=2; %Use 2 for mspy before 3/13, and 0 afterwards



%
app.data_files.(fname).draq_p.auto_thr_sign=1;

app.data_files.(fname).draq_p.daq_gain=1;

app.data_files.(fname).draq_p.acquire_display_start=0;
app.data_files.(fname).draq_p.inp_max=10;