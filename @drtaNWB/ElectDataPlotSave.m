function ElectDataPlotSave(app,varargin)

CurrentTab = varargin{1,1};

switch CurrentTab.Source.Tag
    case 'Electrode'
        Recording.RawData = app.drta_Plot.traces.rawData;
        Recording.ShownCh = app.drta_handles.p.VisableChannel;

end
DateNow = datetime('now','Format','dd-MMM-uuuu');
TimeNowHour = datetime('now','Format','HH');
TimeNowMin = datetime('now','Format','mm');
FileName = app.drta_handles.p.FileName(1:end-4);
DIRname = app.drta_handles.p.PathName;
MatSaveFileName = append('SelectedElectrodeData_',FileName,'_',string(DateNow),'_',string(TimeNowHour),'h',string(TimeNowMin),'m.mat');
MatSaveFileName = fullfile(DIRname,MatSaveFileName);
save(MatSaveFileName,"Recording",'-v7.3');