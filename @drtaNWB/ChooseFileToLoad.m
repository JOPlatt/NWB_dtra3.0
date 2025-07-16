function ChooseFileToLoad(app)

[FileName,PathName] = uigetfile({'*.rhd'; ...
    '*.edf'},'Select rhd or edf file to open');
app.drta_Data.p.fullName=[PathName,FileName];
app.drta_Data.p.FileName=FileName;
app.drta_Data.p.PathName=PathName;
app.file_name.Value = app.drta_Data.p.FileName;
app.Load_Button.Visible = "on";
app.protocolDropDown.Visible = "on";
app.dt_Label.Visible = "on";
app.dt_amt.Visible = "on";
app.Trial_Label.Visible = "on";
app.trial_amt.Visible = "on";
app.Cprogrom_DropDown.Visible = "on";
app.LocationForOutput.Value = PathName;
app.DisplayProtocolLabel.Visible = "on";
app.MetaDataProtocolLabel.Visible = "on";
