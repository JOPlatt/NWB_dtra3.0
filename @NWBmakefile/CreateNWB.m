function CreateNWB(app)

% Creating NWB object
NWBfileSetup(app);
% adding subject information
addSubProperty(app);
% creating time table
TimeSeriesProperty(app);
% adding electrod data 
ElectrodeProperties(app);
