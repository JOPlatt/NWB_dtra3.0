function AppTypeSwitchStation(app)

selectedButton = app.AppType.SelectedObject;
if selectedButton.Text == "rhd to NWB"
    app.drtaProcessVersion.Visible = "off";
    app.SelectFile_Button.Visible = "off";
    app.file_name.Visible = "off";
    app.protocolDropDown.Visible = "off";
    app.dt_Label.Visible = "off";
    app.dt_amt.Visible = "off";
    app.Trial_Label.Visible = "off";
    app.trial_amt.Visible = "off";
    app.Load_Button.Visible = "off";
    app.OutputLocationLabel.Visible = "on";
    app.NWBconvert.Visible = "on";
    app.ConvertrhdFileButton.Visible = "on";
    app.ConvertrhdFileButton.Enable = "off";
    app.OutputFileName.Visible = "on";
    app.NWBfilenameLabel.Visible = "on";
    app.IntanfilenameLabel.Visible = "on";
    app.InputFileName.Visible = "on";
    app.ChooseOutputLocationButton.Visible = "off";
    app.LocationForOutput.Visible = "on";
    NWBconvertSelectionChanged(app)
    app.GridLayoutTraces.Visible = "off";
    app.GridLayout.Visible = "on";
    app.GridLayout2.Visible = "on";
    app.GridLayout3.Visible = "on";
elseif selectedButton.Text == "View and process rhd file"
    app.NWBconvert.Visible = "off";
    app.ConvertrhdFileButton.Visible = "off";
    app.OutputFileName.Visible = "off";
    app.NWBfilenameLabel.Visible = "off";
    app.IntanfilenameLabel.Visible = "off";
    app.InputFileName.Visible = "off";
    app.CreateFileforConversionButton.Visible = "off";
    app.NextFile.Visible = "off";
    app.LastFile.Visible = "off";
    app.CurrentFileNumber.Visible = "off";
    app.FIlenumberProcessLabel.Visible = "off";
    app.NumberOfFileLabel.Visible = "off";
    app.FileNumber.Visible = "off";
    app.ChooseOutputLocationButton.Visible = "off";
    app.LocationForOutput.Visible = "off";
    app.drtaProcessVersion.Visible = "on";
    app.SelectFile_Button.Visible = "on";
    app.file_name.Visible = "on";
    app.protocolDropDown.Visible = "on";
    app.dt_Label.Visible = "on";
    app.dt_amt.Visible = "on";
    app.Trial_Label.Visible = "on";
    app.trial_amt.Visible = "on";
    app.Load_Button.Visible = "on";
    app.GridLayoutTraces.Visible = "on";
    app.GridLayout.Visible = "off";
    app.GridLayout2.Visible = "off";
    app.GridLayout3.Visible = "on";
    app.OutputLocationLabel.Visible = "off";
end