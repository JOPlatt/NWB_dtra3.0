function drta03_ShowDigital(app)

data=drtaNWB_GetTraceData(app.drta_handles);
if app.D_all_CheckBox.Value == 1
    display_interval = app.drta_handles.p.display_interval;
else
    display_interval = app.drta_Main.Xinterval.digital;
end

maxInterval = size(data,1)/app.drta_handles.draq_p.ActualRate;

if display_interval > maxInterval
    display_interval = maxInterval;
    app.IntervalSecDigit_EditField.Value = maxInterval;
    app.IntervalSecDigit_EditField.Limits = [0 maxInterval];
    app.drta_Main.Xinterval.digital = maxInterval;
end
ii_from=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time)...
    *app.drta_handles.draq_p.ActualRate+1);
ii_to=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time...
    +display_interval)*app.drta_handles.draq_p.ActualRate);

if app.DigitalFigures.FiguresBuild == 0
    app.DigitalFigures.NumChannels = 2;
    % app.DigitalFigures.NumChannels = app.drta_handles.draq_d.num_board_adc_channels;
    ColumnSize = strings([1,app.DigitalFigures.NumChannels]);
    for ss = 1:app.DigitalFigures.NumChannels
        ColumnSize{ss} = '1x';

    end
    app.DigitalPlot_Grid.RowHeight = ColumnSize;
    for uu = 1:app.DigitalFigures.NumChannels
        chanName = sprintf('DigitalCh%.2d',uu);
        app.DigitalFigures.DigiFig.(chanName) = uiaxes(app.DigitalPlot_Grid);
        app.DigitalFigures.DigiFig.(chanName).Layout.Row = app.DigitalFigures.NumChannels - uu + 1;
    end
else
    cla(app.DigitalPlot_Grid.Children);
end
DsetNum = app.drta_handles.draq_d.num_amplifier_channels;
for uu = 1:app.DigitalFigures.NumChannels
    chanName = sprintf('DigitalCh%.2d',uu);
    if uu == 1
        whichCH = DsetNum+1;
        data_shown = data(:,whichCH);
    elseif uu  == 2
        if app.drta_handles.draq_d.num_board_adc_channels > 0
            analogsize = app.drta_handles.draq_d.num_board_adc_channels;
            if analogsize < 8
                whichCH = DsetNum+analogsize+2;
            else
                whichCH = DsetNum+6;
            end
        else
            whichCH = DsetNum+2;
        end
        data_shown = data(:,whichCH);
        shiftNum = app.ShiftDataBitand_EditField.Value;
        if shiftNum == 0
            data_shown=bitand(data_shown,1+2+4+8+16);
        else
            data_shown=bitand(data_shown,shiftNum);
        end
    end
    plot(app.DigitalFigures.DigiFig.(chanName),data_shown(ii_from:ii_to));

    dt=display_interval/5;
    dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
    d_samples=dt*app.drta_handles.draq_p.ActualRate;

    if uu == 1 && app.DigitalFigures.FiguresBuild == 0
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
            pName = sprintf('Trigger');
            exc_sn = app.ExcLicks_CheckBox.Value;
            if (exc_sn) && (ii==(size(data,2)-5))
                [~,lct]=findpeaks(abs(data_shown(ii_from+1:ii_to)-data_shown(ii_from:ii_to-1)),'MinPeakHeight',app.drta_handles.p.exc_sn_thr);
                hold on
                plot(app.DigitalFigures.DigiFig.(chanName),lct,data_shown(ii_from+lct),'or')
                hold off
            end

            min_y=min(data_shown(ii_from:ii_to));
            max_y=max(data_shown(ii_from:ii_to));
            if max_y==min_y
                this_y=max_y;
                max_y=this_y+1;
                min_y=this_y-1;
            end
            ylim(app.DigitalFigures.DigiFig.(chanName),[min_y-0.1*(max_y-min_y) max_y+0.1*(max_y-min_y)]);

            time=app.drta_handles.p.start_display_time;
            jj=1;
            maxAmt = ceil(app.drta_handles.p.start_display_time+display_interval/dt)+1;
            tick_label = cell([1 maxAmt]);
            while time<(app.drta_handles.p.start_display_time+display_interval)
                tick_label{jj}=num2str(time);
                time=time+dt;
                jj=jj+1;
            end
            tick_label{jj}=num2str(time);
            app.DigitalFigures.DigiFig.(chanName).XTickLabel = tick_label;
        
            xlim(app.DigitalFigures.DigiFig.(chanName),[1 1+display_interval*app.drta_handles.draq_p.ActualRate]);
            % xlim(app.DigitalFigures.DigiFig.(chanName),[1 1+app.drta_handles.p.display_interval*app.drta_handles.draq_p.ActualRate]);
            
            xticks(app.DigitalFigures.DigiFig.(chanName),0:d_samples:display_interval*app.drta_handles.draq_p.ActualRate);
        case 2
            pName = sprintf('Digital');
            %Draw a red line at odor on
            bitNum = app.ShiftBitand_EditField.Value;
            if bitNum == 0
                shift_dropc_nsampler=bitand(data_shown,1+2+4+8+16+32);
            else
                shift_dropc_nsampler=bitand(data_shown,bitNum);
            end

            odor_on=[];
            switch app.drta_handles.p.which_c_program
                case 2
                    %dropcspm
                    odor_on=find(shiftdata_all==18,1,'first');
                case 10
                    %dropcspm conc
                    t_start=find(shift_dropc_nsampler==1,1,'first');
                    if (sum((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7))>2.4*app.drta_handles.draq_p.ActualRate)&...
                            ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
                        %                         odor_on=find((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7),1,'first');
                        odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
                    end
            end

            if ~isempty(odor_on)
                plot(app.DigitalFigures.DigiFig.(chanName),[odor_on odor_on],[0 35],'-r');
            end
            app.DigitalFigures.DigiFig.(chanName).XTick = [];
            if (minAmt+minus10p) ~= (maxAmt+added10p)
                ylim(app.DigitalFigures.DigiFig.(chanName),[(minAmt+minus10p) (maxAmt+added10p)]);
            end
            xlim(app.DigitalFigures.DigiFig.(chanName),[1 1+display_interval*app.drta_handles.draq_p.ActualRate]);
        otherwise
            pName = sprintf('Digital CH %.2d',uu);
    end
    title(app.DigitalFigures.DigiFig.(chanName),pName);
end
app.DigitalFigures.FiguresBuild = 1;

