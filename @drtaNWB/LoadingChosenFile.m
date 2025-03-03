function LoadingChosenFile(app)

app.FlagAlpha = true;
protocolPick = app.protocolDropDown.Value;
switch protocolPick
    case 'dropcspm'
        app.drta_handles.p.which_protocol = 1;
    case 'laser (Ming)'
        app.drta_handles.p.which_protocol = 2;
    case 'dropcnsampler'
        app.drta_handles.p.which_protocol = 3;
    case 'laser (Merouann)'
        app.drta_handles.p.which_protocol = 4;
    case 'dropc_conc'
        app.drta_handles.p.which_protocol = 5;
    case 'dropcspm_hf'
        app.drta_handles.p.which_protocol = 6;
    case 'continuous'
        app.drta_handles.p.which_protocol = 7;
    case 'working_memory'
        app.drta_handles.p.which_protocol = 8;
    case 'laser (Schoppa)'
        app.drta_handles.p.which_protocol = 9;
end
app.drta_handles.trial_duration=app.trial_amt.Value;
app.drta_handles.pre_dt=app.dt_amt.Value;
app.dt_amt.Enable = false;
app.trial_amt.Enable = false;
% app.type_DropDown.Enable = true;
app.OutputText = [append("Loading: ",app.drta_handles.p.FileName)];
ReadoutUpdate(app,[append("Protocol: ",protocolPick)]);
if strcmp(app.drta_handles.p.FileName(end-2:end),'rhd')
    open_rhd_Callback(app);
elseif strcmp(app.drta_handles.p.FileName(end-2:end),'edf')
    open_edf_Callback(app);
end
ElectrodCheckboxCreate(app)
app.Flags.fileLoaded = true;

