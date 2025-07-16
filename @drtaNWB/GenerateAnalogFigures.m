function GenerateAnalogFigures(app)

drtaNWB_GetTraceData(app,app.Analogtrial_EditField.Value);
data = app.drta_Data.Signals.Analog';
if app.A_all_CheckBox.Value == 1
    display_interval = app.drta_Data.p.display_interval;
else
    display_interval = app.drta_Main.Xinterval.analog;
end
maxInterval = size(data,2)/app.drta_Data.draq_p.ActualRate;

if display_interval > maxInterval
    display_interval = maxInterval;
    app.AnalogInterval_EditField.Value = maxInterval;
    app.AnalogInterval_EditField.Limits = [0 maxInterval];
    app.drta_Main.Xinterval.analog = maxInterval;
end
ii_from=floor((app.drta_Data.draq_p.acquire_display_start+app.drta_Data.p.start_display_time)...
    *app.drta_Data.draq_p.ActualRate+1);
ii_to=floor((app.drta_Data.draq_p.acquire_display_start+app.drta_Data.p.start_display_time...
    +display_interval)*app.drta_Data.draq_p.ActualRate);
currentChan = find(app.drta_Data.p.VisableAnalog == 1);
if app.AnalogFigures.FiguresBuild == 0
    app.AnalogFigures.NumChannels = sum(app.drta_Data.p.VisableAnalog);
    ColumnSize = strings([1,app.AnalogFigures.NumChannels]);
    for ss = 1:app.AnalogFigures.NumChannels
        ColumnSize{ss} = '1x';

    end
    app.AnalogFigure_GridLayout.RowHeight = ColumnSize;
    for ut = 1:sum(app.drta_Data.p.VisableAnalog)
        uu = currentChan(ut);
        chanName = sprintf('analogCh%.2d',uu);
        app.AnalogFigures.analogFig.(chanName) = uiaxes(app.AnalogFigure_GridLayout);
        app.AnalogFigures.analogFig.(chanName).Layout.Row = app.AnalogFigures.NumChannels - ut + 1;
    end
else
    cla(app.AnalogFigure_GridLayout.Children);
end
DsetNum = app.drta_Data.draq_d.num_amplifier_channels;
for us = 1:sum(app.drta_Data.p.VisableAnalog)
    uu = currentChan(us);
    chanName = sprintf('analogCh%.2d',uu);

    data_shown = data(uu,:);
    plot(app.AnalogFigures.analogFig.(chanName),data_shown(ii_from:ii_to));

    dt=display_interval/5;
    dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
    d_samples=dt*app.drta_Data.draq_p.ActualRate;
    xticks(app.AnalogFigures.analogFig.(chanName),0:d_samples:display_interval*app.drta_Data.draq_p.ActualRate);
    if uu == 1
        time=app.drta_Data.p.start_display_time;
        jj=1;
        maxAmt = ceil(app.drta_Data.p.start_display_time+display_interval/dt)+1;
        tick_label = cell([1 maxAmt]);
        while time<(app.drta_Data.p.start_display_time+display_interval)
            tick_label{jj}=num2str(time);
            time=time+dt;
            jj=jj+1;
        end
        tick_label{jj}=num2str(time);
    end
    xticklabels(app.AnalogFigures.analogFig.(chanName),tick_label);
    ylabel(app.AnalogFigures.analogFig.(chanName),"Voltage (V)");
    xlim(app.AnalogFigures.analogFig.(chanName),[1 1+display_interval*app.drta_Data.draq_p.ActualRate]);
    if uu == 1 && app.AnalogFigures.FiguresBuild == 0
        app.AnalogFigures.analogFig.(chanName).XLabel.String = 'Time (Sec)';
    end
    maxAmt = max(data(uu,ii_from:ii_to));
    minAmt = min(data(uu,ii_from:ii_to));
    if uu == 3
        added10p = maxAmt*0.01;
    else
        added10p = maxAmt*0.1;
    end
    minus10p = 0;
    if minAmt > 0
        if uu == 3
            minus10p = minAmt*0.01;
        else
            minus10p = minAmt*0.1;
        end
    end
    ylim(app.AnalogFigures.analogFig.(chanName),[(minAmt-minus10p) (maxAmt+added10p)]);
    ytickformat(app.AnalogFigures.analogFig.(chanName),'%.3f')
    if app.AnalogFigures.FiguresBuild == 0
        switch uu
            case 1
                pName = sprintf('sniffing');
            case 2
                pName = sprintf('lick sensor');
            case 3
                pName = sprintf('mouse head');
            case 4
                pName = sprintf('photodiode');
            case 5
                pName = sprintf('Analog CH 5');
            case 6
                pName = sprintf('Analog CH 6');
            otherwise
                pName = sprintf('Analog CH %.2d',uu);
        end
        title(app.AnalogFigures.analogFig.(chanName),pName);
    end
end
app.AnalogFigures.FiguresBuild = 1;




