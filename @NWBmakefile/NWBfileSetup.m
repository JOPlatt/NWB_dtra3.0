function NWBfileSetup(app)


app.nwb = NwbFile( ...
    'session_description', string(app.SessionDescp_EditField.Value),...
    'identifier', 'MouseTest', ...
    'session_start_time', datetime(2018, 4, 25, 2, 30, 3, 'TimeZone', 'local'), ...
    'general_experimenter', 'Last, First', ... % optional
    'general_session_id', 'session_1234', ... % optional
    'general_institution', 'University of My Institution'); % optional

% Adding the general lab name
if ~isempty(app.LabName_EditField.Value)
    app.nwb.general_lab = app.LabName_EditField.Value;
end

