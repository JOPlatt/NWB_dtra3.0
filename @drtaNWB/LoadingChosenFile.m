function LoadingChosenFile(app)
% this flab is used for 
app.FlagAlpha = true;
% Setting protocol for loading the data
protocolPick = app.protocolDropDown.Value;
switch protocolPick
    case 'dropcspm'
        app.drta_Data.p.which_protocol = 1;
    case 'laser (Ming)'
        app.drta_Data.p.which_protocol = 2;
    case 'dropcnsampler'
        app.drta_Data.p.which_protocol = 3;
    case 'laser (Merouann)'
        app.drta_Data.p.which_protocol = 4;
    case 'dropc_conc'
        app.drta_Data.p.which_protocol = 5;
    case 'dropcspm_hf'
        app.drta_Data.p.which_protocol = 6;
    case 'continuous'
        app.drta_Data.p.which_protocol = 7;
    case 'working_memory'
        app.drta_Data.p.which_protocol = 8;
    case 'laser (Schoppa)'
        app.drta_Data.p.which_protocol = 9;
end
%
% pulling values based on user inputs
app.drta_Data.trial_duration=app.trial_amt.Value;
app.drta_Data.pre_dt=app.dt_amt.Value;
%
% preventing changes to values after the data is loaded
app.dt_amt.Enable = false;
app.trial_amt.Enable = false;
% app.type_DropDown.Enable = true;
%
% updating output text
app.OutputText = [append("Loading: ",app.drta_Data.p.FileName)];
ReadoutUpdate(app,[append("Protocol: ",protocolPick)]);
%
% loading files
if strcmp(app.drta_Data.p.FileName(end-2:end),'rhd')
    open_rhd_Callback(app);
elseif strcmp(app.drta_Data.p.FileName(end-2:end),'edf')
    open_edf_Callback(app);
end
%
% updating output text
textUpdate = 'Creating Channel Options';
ReadoutUpdate(app,textUpdate)
%
% creating channel choices based on the number of channels recorded
ElectrodCheckboxCreate(app)
%
% updating output text
textUpdate = 'Done, Data is ready to be viewed';
ReadoutUpdate(app,textUpdate)
%
% setting flag to indicate the data has been loaded
app.Flags.fileLoaded = true;
% 
% allowing the data set to be saved
% app.Savematfile_Button.Enable = "on";
% app.CreateNWBfile_Button.Enable = "on";
%adding limits to the trial amount that can be seen
app.Tnum_amt.Limits = [1,app.drta_Data.draq_d.noTrials];
app.TrialNoDigit_EditField.Limits = [1,app.drta_Data.draq_d.noTrials];
app.Analogtrial_EditField.Limits = [1,app.drta_Data.draq_d.noTrials];

SaveCheckboxCreate(app)