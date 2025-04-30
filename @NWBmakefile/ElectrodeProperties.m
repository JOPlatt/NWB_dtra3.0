function ElectrodeProperties(app)

% Creating device information
Descpip = app.DeviceDescription_EditField.Value;
Manufac = app.DeviceManufacturer_EditField.Value;
ModelNum = app.DeviceModelNum_EditField.Value;
ModelName = app.ModelName_EditField.Value;
SerialNum = app.DeviceSeralNum_EditField.Value;

device = types.core.Device(...
    'description', Descpip, ...
    'manufacturer', Manufac, ...
    'model_number', ModelNum, ...
    'model_name', ModelName, ...
    'serial_number', SerialNum ...
);
 
% Add device to nwb object
app.nwb.general_devices.set('array', device);

% Creating electrode group table
numShanks = app.ShankNum_EditField.Value;
numChannelsPerShank = app.ChNumPerShank_EditField.Value;
numChannels = numShanks * numChannelsPerShank;
 
electrodesDynamicTable = types.hdmf_common.DynamicTable(...
    'colnames', {'location', 'group', 'group_name', 'label'}, ...
    'description', 'all electrodes');
 
for iShank = 1:numShanks
    shankGroupName = sprintf('shank%d', iShank);
    electrodeGroup = types.core.ElectrodeGroup( ...
        'description', sprintf('electrode group for %s', shankGroupName), ...
        'location', 'brain area', ...
        'device', types.untyped.SoftLink(device) ...
    );
    
    app.nwb.general_extracellular_ephys.set(shankGroupName, electrodeGroup);
    for iElectrode = 1:numChannelsPerShank
        electrodesDynamicTable.addRow( ...
            'location', 'unknown', ...
            'group', types.untyped.ObjectView(electrodeGroup), ...
            'group_name', shankGroupName, ...
            'label', sprintf('%s-electrode%d', shankGroupName, iElectrode));
    end
end
% Adding to the nwb structure
app.nwb.general_extracellular_ephys_electrodes = electrodesDynamicTable;

% Adding voltage recording to the nwb structure
electrode_table_region = types.hdmf_common.DynamicTableRegion( ...
    'table', types.untyped.ObjectView(electrodesDynamicTable), ...
    'description', 'all electrodes', ...
    'data', (0:length(electrodesDynamicTable.id.data)-1)');

DeviceTimeRate = app.drta.draq_p.ActualRate;
data = drtaNWB_GetTraceData(app.drta);
ElectrodeChData = data(:,1:numChannels);

raw_electrical_series = types.core.ElectricalSeries( ...
    'starting_time', 0.0, ... % seconds
    'starting_time_rate', DeviceTimeRate, ... % Hz
    'data', ElectrodeChData, ... % nChannels x nTime
    'electrodes', electrode_table_region, ...
    'data_unit', 'volts'); % need to make sure this is correct

app.nwb.acquisition.set('ElectricalSeries', raw_electrical_series);








