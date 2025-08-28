function drta03_ShowDigital(app)
%{
This function shows any digital plots that have been selected

Created by Jonathan Platt
%}
drtaNWB_GetTraceData(app,app.TrialNoDigit_EditField.Value);
data = app.drta_Data.Signals.Digital;
currentChan = find(app.drta_Data.p.VisableChannelDigital == 1);
if app.D_all_CheckBox.Value == 1
    display_interval = app.drta_Data.p.display_interval;
else
    display_interval = app.drta_Main.Xinterval.digital;
end

maxInterval = size(data,1)/app.drta_Data.draq_p.ActualRate;

if display_interval > maxInterval
    display_interval = maxInterval;
    app.IntervalSecDigit_EditField.Value = maxInterval;
    app.IntervalSecDigit_EditField.Limits = [0 maxInterval];
    app.drta_Main.Xinterval.digital = maxInterval;
end
ii_from=floor((app.drta_Data.draq_p.acquire_display_start+app.drta_Data.p.start_display_time)...
    *app.drta_Data.draq_p.ActualRate+1);
ii_to=floor((app.drta_Data.draq_p.acquire_display_start+app.drta_Data.p.start_display_time...
    +display_interval)*app.drta_Data.draq_p.ActualRate);

if app.DigitalFigures.FiguresBuild == 0
    % if ~isempty(app.DigitalPlot_Grid.Children(2,1))
    %     filNames = fieldnames(app.DigitalFigures.DigiFig);
    %     tempt = app.DigitalPlot_Grid.Children.findobj('Trigger');
    %     app.DigitalPlot_Grid.Children = tempt;
    %     app.DigitalPlot_Grid.reset
    % end
    app.DigitalFigures.NumChannels = size(currentChan,2);
    ColumnSize = strings([1,app.DigitalFigures.NumChannels]);
    for ss = 1:sum(app.drta_Data.p.VisableChannelDigital)
        ColumnSize{ss} = '1x';

    end
    app.DigitalPlot_Grid.RowHeight = ColumnSize;
    for ii = 1:sum(app.drta_Data.p.VisableChannelDigital)
        uu = currentChan(ii);
        chanName = sprintf('DigitalCh%.2d',uu);
        app.DigitalFigures.DigiFig.(chanName) = uiaxes(app.DigitalPlot_Grid);
        app.DigitalFigures.DigiFig.(chanName).Layout.Row = app.DigitalFigures.NumChannels - ii + 1;
    end
else
    cla(app.DigitalPlot_Grid.Children,"reset");
end

for ii = 1:sum(app.drta_Data.p.VisableChannelDigital)
    uu = currentChan(ii);
    chN = app.drta_Main.digitalPlots.plotNames{uu};
    if ~contains(chN,'DigitalCh') && ~contains(chN,'Trigger')
        bitValues = app.drta_Main.digitalPlots.(chN).bitUsed;
        bit_indices = [0,1,2,3,4,5,6,7];
        bit_mask = sum(2.^(bit_indices(bitValues == 1)));
        % ChUsed = app.drta_Main.digitalPlots.(chN(uu)).ChUsed;
        % DigitalChannels = 3:app.drta_Data.draq_d.num_board_dig_in_channels+2;
        % data_shown = data(:,DigitalChannels(ChUsed == 1));
        data_shown = data(:,uu);
        data_shown = bitand(data_shown,bit_mask);
        app.drta_Data.Signals.BitAndDigital.(chN) = data_shown;
    else
        data_shown = data(:,uu);
    end
    if ii > 1
        hold(app.DigitalFigures.DigiFig.(chanName),"off")
    end
    chanName = sprintf('DigitalCh%.2d',uu);
    plot(app.DigitalFigures.DigiFig.(chanName),data_shown(ii_from:ii_to));
    hold(app.DigitalFigures.DigiFig.(chanName),"on")
    if ii > 1
        uu2 = currentChan(1);
        chanNameold = sprintf('DigitalCh%.2d',uu2);
        app.DigitalFigures.DigiFig.(chanName).InnerPosition(1) = app.DigitalFigures.DigiFig.(chanNameold).InnerPosition(1);
        app.DigitalFigures.DigiFig.(chanName).InnerPosition(3) = app.DigitalFigures.DigiFig.(chanNameold).InnerPosition(3);
    end
    dt=display_interval/5;
    dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
    d_samples=dt*app.drta_Data.draq_p.ActualRate;

    if ii == 1 && app.DigitalFigures.FiguresBuild == 0
        app.DigitalFigures.DigiFig.(chanName).XLabel.String = 'Time (Sec)';
    end
    maxAmt = max(data_shown(ii_from:ii_to));
    minAmt = min(data_shown(ii_from:ii_to));
    added10p = maxAmt*0.1;
    minus10p = 0;
    if minAmt > 0
        minus10p = minAmt*0.1;
    end

    switch uu
        case 1
            % exc_sn = app.ExcLicks_CheckBox.Value;
            % if (exc_sn) && (uu == 2)
            %     [~,lct]=findpeaks(abs(data_shown(ii_from+1:ii_to)-data_shown(ii_from:ii_to-1)),'MinPeakHeight',app.drta_Data.p.exc_sn_thr);
            %     plot(app.DigitalFigures.DigiFig.(chanName),lct,data_shown(ii_from+lct),'or')
            % end

            min_y=min(data_shown(ii_from:ii_to));
            max_y=max(data_shown(ii_from:ii_to));
            if max_y==min_y
                this_y=max_y;
                max_y=this_y+1;
                min_y=this_y-1;
            end
            ylim(app.DigitalFigures.DigiFig.(chanName),[min_y-0.1*(max_y-min_y) max_y+0.1*(max_y-min_y)]);

            % time=app.drta_Data.p.start_display_time;
            % jj=1;
            % maxAmt = ceil(app.drta_Data.p.start_display_time+display_interval/dt)+1;
            % tick_label = cell([1 maxAmt]);
            % while time<(app.drta_Data.p.start_display_time+display_interval)
            %     tick_label{jj}=num2str(time);
            %     time=time+dt;
            %     jj=jj+1;
            % end
            % tick_label{jj}=num2str(time);
            % app.DigitalFigures.DigiFig.(chanName).XTickLabel = tick_label;
            %
            % xlim(app.DigitalFigures.DigiFig.(chanName),[1 1+display_interval*app.drta_Data.draq_p.ActualRate]);
            % % xlim(app.DigitalFigures.DigiFig.(chanName),[1 1+app.drta_Data.p.display_interval*app.drta_Data.draq_p.ActualRate]);
            %
            % xticks(app.DigitalFigures.DigiFig.(chanName),0:d_samples:display_interval*app.drta_Data.draq_p.ActualRate);
        case 2
            %Draw a red line at odor on


            odor_on=[];
            switch app.drta_Data.p.which_c_program
                case 2
                    %dropcspm
                    odor_on=find(data_shown==18,1,'first');
                case 10
                    data_shown = data(:,uu);
                    shift_dropc_nsampler=bitand(data_shown,1+2+4+8+16+32);
                    %dropcspm conc
                    t_start=find(shift_dropc_nsampler==1,1,'first');
                    if (sum((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7))>2.4*app.drta_Data.draq_p.ActualRate)&...
                            ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
                        %                         odor_on=find((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7),1,'first');
                        odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
                    end
            end

            if ~isempty(odor_on)
                xline(app.DigitalFigures.DigiFig.(chanName),[odor_on odor_on],'-r');
            end
            app.DigitalFigures.DigiFig.(chanName).XTick = [];
            if (minAmt+minus10p) ~= (maxAmt+added10p)
                ylim(app.DigitalFigures.DigiFig.(chanName),[(minAmt+minus10p) (maxAmt+added10p)]);
            end
            xlim(app.DigitalFigures.DigiFig.(chanName),[1 1+display_interval*app.drta_Data.draq_p.ActualRate]);
        otherwise

    end
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
    app.DigitalFigures.DigiFig.(chanName).XTickLabel = tick_label;

    xlim(app.DigitalFigures.DigiFig.(chanName),[1 1+display_interval*app.drta_Data.draq_p.ActualRate]);
    % xlim(app.DigitalFigures.DigiFig.(chanName),[1 1+app.drta_Data.p.display_interval*app.drta_Data.draq_p.ActualRate]);

    xticks(app.DigitalFigures.DigiFig.(chanName),0:d_samples:display_interval*app.drta_Data.draq_p.ActualRate);
    chN = replace(chN,'_',' ');
    chN = replace(chN,'-',' ');
    title(app.DigitalFigures.DigiFig.(chanName),chN);
    
end
app.DigitalFigures.FiguresBuild = 1;

