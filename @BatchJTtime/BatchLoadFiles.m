function BatchLoadFiles(app)


% Setting protocol for loading the data
app.data_files.drtaFile001
protocolPick = app.LoadingProcess_DropDown.Value;
app.data_files.drtaFile001.p.which_protocol = LoadProcess(protocolPick);
%
% pulling values based on user inputs
app.data_files.drtaFile001.trial_duration=app.trial_amt.Value;
app.data_files.drtaFile001.pre_dt=app.dt_amt.Value;
%
% preventing changes to values after the data is loaded
app.dt_amt.Enable = false;
app.trial_amt.Enable = false;
% app.type_DropDown.Enable = true;
%
% updating output text
app.OutputText = string([sprintf('Loading: %s for file info',app.data_files.drtaFile001.p.FileName)]);
ReadoutUpdate(app,string([sprintf('Protocol: %s will be used on all files',protocolPick)]));
%
app.data_files.drtaFile001.p.which_c_program = ProcessType(app.ProcessType_DropDown.Value);
ReadoutUpdate(app,string([sprintf('Protocol: %s will be used to save all files',app.ProcessType_DropDown.Value)]));

% need to change the file to only pull the number of channels to save on
% time along with the number of trials
% loading files
Fname = app.data_files.drtaFile001.p.FileName;
if strcmp(Fname(end-2:end),'rhd')
   Batch_open_rhd(app,1);
elseif strcmp(Fname(end-2:end),'edf')
    open_edf_Callback(app);
end
%
% updating output text
textUpdate = 'Creating Channel Options';
ReadoutUpdate(app,textUpdate)
%
app.drta_Data = app.data_files.drtaFile001;
% creating channel choices based on the number of channels recorded
BatchSave_ElectrodCheckboxCreate(app)

%
% updating output text
textUpdate = 'Done, Please choose channels before saving files';
ReadoutUpdate(app,textUpdate)
%
app.RunBatch_Button.Enable = "on";
