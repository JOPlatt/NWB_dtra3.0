function BatchJTtimeStartUp(app)

addpath(genpath(fullfile(pwd,"ExternalCode")));
addpath(genpath(fullfile(pwd,"CprogramCode")));
addpath(genpath(fullfile(pwd,"matnwb")));

app.FileChoice_DropDown.Visible = "off";
app.FileChoice_DropDown.Enable = "off";
app.fileProcess_Label.Visible = "off";
app.SaveChoice_Button.Visible = "off";
app.MClustCurrentFile_Label.Text = "For all Files";
app.Flags.FileLoaded = 0;
app.Flags.DataLoaded = 0;

app.ProcessType_DropDown.Items = ProcessType(sprintf('Loading Screen'));

app.LoadingProcess_DropDown.Items = LoadProcess(sprintf('Loading Screen'));

app.Flags.LoadMethod = 1;
app.Flags.OutputType = 2;
app.Flags.ShowAnalog = 0;

app.AnalogFigures.CHnames = {'Sniffing','Lick Sensor','Mouse Head','Photodiode'};

%
app.drta_Data.p.do_filter=1;
app.drta_Data.p.dt_pre_snip=0.0005;
app.drta_Data.p.dt_post_snip=0.001;
app.drta_Data.p.do_3xSD=0;
app.drta_Data.p.display_interval=9;
%
app.drta_Data.p.exclude_secs = 2;
app.drta_Data.p.exc_sn = 0;
%
app.drta_Data.p.filter_dt=0.001666667;
%
app.drta_Data.p.high_filter = 5000;
%
app.drta_Data.p.lastTrace = -1;
app.drta_Data.p.lfp.maxLFP=9800;
app.drta_Data.p.lfp.minLFP=-9800;
app.drta_Data.p.lfp.delta_max_min_out=0.5;
app.drta_Data.p.low_filter = 1000;

%
app.drta_Data.p.nxSD = 2.5;
%
app.drta_Data.p.read_entire_file = 0;
%
app.drta_Data.p.setThr = 0;
app.drta_Data.p.start_display_time=0;
app.drta_Data.p.showLicks = 1;
app.drta_Data.p.set2p5SD = 0;
app.drta_Data.p.setm2p5SD = 0;
app.drta_Data.p.setnxSD = 0;
%
app.drta_Data.p.thrToSet = 0;


app.drta_Data.p.trialNo = 1;
%

%
app.drta_Data.p.whichPlot = 1;
app.drta_Data.p.which_protocol = 1;
app.drta_Data.p.which_display_th=1;
app.drta_Data.p.which_c_program=1;
app.drta_Data.p.which_channel=1;
app.drta_Data.p.which_display=1;
app.drta_Data.p.which_channel_th=1;
%
%Preferences for mspy
app.drta_Data.p.mspy_exclude_dt=1; %Exclude
app.drta_Data.p.pmspy_key_offset=2; %Use 2 for mspy before 3/13, and 0 afterwards



%
app.drta_Data.draq_p.auto_thr_sign=1;

app.drta_Data.draq_p.daq_gain=1;

app.drta_Data.draq_p.acquire_display_start=0;
app.drta_Data.draq_p.inp_max=10;
% setting GUI values
app.trial_amt.Value = 9;
app.dt_amt.Value = 6;