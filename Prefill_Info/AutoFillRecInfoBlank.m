
%{
AutoFillRecInfo
This script is used to prefill text fields for drta NWB
%}
try
    addpath(genpath(fullfile(pwd,"Prefill_Info")));
end
% Recording device information
Descrip = '';
Manufac = '';
ModelNum = '';
ModelName = '';
SerialNum = '';
% Subject information
Species = 'Mus musculus';
% Recording time description
TimeSeriesDescrip = 'Intan recording time series';
% Laboratory experiment was performed
LabName = 'Restrepo Lab';
% Adding all entries to structure
Info.Descrip = Descrip;
Info.Manufac = Manufac;
Info.ModelNum = ModelNum;
Info.ModelName = ModelName;
Info.SerialNum = SerialNum;
Info.Species = Species;
Info.TimeSeriesDescrip = TimeSeriesDescrip;
Info.LabName = LabName;
% filename (example, Intan32Ch)
FileName = '';
LocSave = fullfile(pwd,append(FileName,'.mat'));
save(LocSave,"Info");