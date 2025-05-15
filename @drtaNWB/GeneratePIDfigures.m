function GeneratePIDfigures(app)

data=drtaNWB_GetTraceData(app.drta_handles);
display_interval = app.AnalogInterval_EditField.Value;
maxInterval = size(data,1)/app.drta_handles.draq_p.ActualRate;

if display_interval > maxInterval
    display_interval = maxInterval;
    app.AnalogInterval_EditField.Value = maxInterval;
    app.AnalogInterval_EditField.Limits = [0 maxInterval];
end
ii_from=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time)...
            *app.drta_handles.draq_p.ActualRate+1);
ii_to=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time...
            +display_interval)*app.drta_handles.draq_p.ActualRate);
for ll = 1:2
    if ll == 1
        % plotting PID from column end-1 from the dataset
        PlotNo = app.PIDendMinusOne_UIAxes;
        SetNum = size(data,2) - 1;
        titleText = 'Analog Ch 7';
    else
        % plotting PID from the end column of the dataset
        PlotNo = app.PIDendSet_UIAxes;
        SetNum = size(data,2);
        titleText = 'Analog Ch 8';
    end
plot(PlotNo,data(ii_from:ii_to,SetNum));
title(PlotNo,titleText);
dt=display_interval/5;
dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
d_samples=dt*app.drta_handles.draq_p.ActualRate;
xticks(PlotNo,0:d_samples:display_interval*app.drta_handles.draq_p.ActualRate);
time=app.drta_handles.p.start_display_time;
jj=1;
while time<(app.drta_handles.p.start_display_time+display_interval)
    tick_label{jj}=num2str(time);
    time=time+dt;
    jj=jj+1;
end
tick_label{jj}=num2str(time);
xticklabels(PlotNo,tick_label);
PlotNo.XLabel.String = 'Time (Sec)';
xlim(PlotNo,[1 1+display_interval*app.drta_handles.draq_p.ActualRate]);
ylim(PlotNo,[0 (max(data(ii_from:ii_to,SetNum)+10))]);


end
