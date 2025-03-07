function FigureSaving(app,varargin)

CurrentFig = varargin{1};
DateNow = datetime('now','Format','dd-MMM-uuuu');
TimeNowHour = datetime('now','Format','HH');
TimeNowMin = datetime('now','Format','mm');
FileName = app.drta_handles.p.FileName(1:end-4);
DIRname = app.drta_handles.p.PathName;
if varargin{2} == 1
    SaveFileName = append('LFPfigure_',FileName,'_',string(DateNow),'_',string(TimeNowHour),'h',string(TimeNowMin),'m');
    SaveFileName = fullfile(DIRname,SaveFileName);
end
fig1 = figure();
ax = axes;
copyobj(CurrentFig.Children,ax);
%{
need to add limits and title to figure
%}
saveas(fig1,SaveFileName,'fig')
saveas(fig1,SaveFileName,'png')
saveas(fig1,SaveFileName,'svg')
