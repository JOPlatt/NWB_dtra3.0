function PresetLoading(app)

[FileName,PathName] = uigetfile('*.mat', ...
    'Select preset file');
Prefill = load(fullfile(PathName,FileName));
app.Prefill = Prefill.Info;

if ~isempty(app.Prefill)
    app.LabName_EditField.Value = app.Prefill.LabName;
    app.Species_EditField.Value = app.Prefill.Species;
    app.TimeSeriesDescrp_EditField.Value = app.Prefill.TimeSeriesDescrip;
    app.DeviceDescription_EditField.Value = app.Prefill.Descrip;
    app.DeviceManufacturer_EditField.Value = app.Prefill.Manufac;
    app.DeviceModelNum_EditField.Value = app.Prefill.ModelNum;
    app.ModelName_EditField.Value = app.Prefill.ModelName;
    app.DeviceSeralNum_EditField.Value = app.Prefill.SerialNum;
end

disp('stopping')