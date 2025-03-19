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
figBeingSaved = app.drta_Plot.traces;
MatSaveFileName = append('TracefigureData_',FileName,'_',string(DateNow),'_',string(TimeNowHour),'h',string(TimeNowMin),'m.mat');
MatSaveFileName = fullfile(DIRname,MatSaveFileName);
fig1 = figure();
ax = axes;
copyobj(CurrentFig.Children,ax);
title(ax,figBeingSaved.Title)
ax.XTick = figBeingSaved.Xtics;
ax.XTickLabel = figBeingSaved.Xticlabels;
xlabel(ax,figBeingSaved.Xlabels)
ax.YTick = figBeingSaved.Ytics;
ax.YTickLabel = figBeingSaved.Ylabels;
ax.YLim = figBeingSaved.Ylimits;
%{
need to add limits and title to figure
%}
saveas(fig1,SaveFileName,'fig')
saveas(fig1,SaveFileName,'png')
saveas(fig1,SaveFileName,'svg')
save(MatSaveFileName,"figBeingSaved",'-v7.3');
