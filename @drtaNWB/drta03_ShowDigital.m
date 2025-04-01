function drta03_ShowDigital(app)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%This will plot the non-spike traces (traces reporting on
%digital values, sniffing, etc
handles = app.drta_handles;


%Get the data
scaling = handles.draq_p.scaling;
offset = handles.draq_p.offset;
samp_bef=floor(handles.draq_p.ActualRate*handles.p.dt_pre_snip);
samp_aft=floor(handles.draq_p.ActualRate*handles.p.dt_post_snip);




%Get the data for this trial

data=drtaNWB_GetTraceData(handles);


%17 trigger
%18 sniffing
%19 lick sensor
%20 mouse head
%21 photodiode
%22 digital input

this_record= size(data,2)-7;
%trig=data_this_trial(floor((this_record-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger):floor(this_record*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger));
trig=data(:,this_record);

%Plot the trigger signal
PlotNo1 = app.Trigger_Plot;
ii_from=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
            *handles.draq_p.ActualRate+1);
ii_to=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
            +handles.p.display_interval)*handles.draq_p.ActualRate);
plot(PlotNo1,trig(ii_from:ii_to));

ylabel(PlotNo1,'Trigger');
dt=handles.p.display_interval/5;
dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
d_samples=dt*handles.draq_p.ActualRate;
xticks(PlotNo1,0:d_samples:handles.p.display_interval*handles.draq_p.ActualRate);
time=handles.p.start_display_time;
jj=1;
while time<(handles.p.start_display_time+handles.p.display_interval)
    tick_label{jj}=num2str(time);
    time=time+dt;
    jj=jj+1;
end
tick_label{jj}=num2str(time);
xticklabels(PlotNo1,tick_label)

xlim(PlotNo1,[1 1+handles.p.display_interval*handles.draq_p.ActualRate]);
ylim(PlotNo1,[app.Trace_ylimitsMin_EditField.Value app.Trace_ylimtsMax_EditField.Value]);


%Plot 18 to 21

for ii=size(data,2)-6:size(data,2)-3
    
    this_data=[];
    %this_data=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger):floor(ii*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger));
    this_data=data(:,ii);
    CurrentPlot = [];
    switch ii
        case (size(data,2)-6)
            CurrentPlot = app.Sniffing_Plot;
        case (size(data,2)-5)
            CurrentPlot = app.Lick_Plot;
        case (size(data,2)-4)
            CurrentPlot = app.In_Port_Plot;
        case (size(data,2)-3)
            CurrentPlot = app.Diode_Plot;
    end
    plot(CurrentPlot,this_data(ii_from:ii_to),'-b');
    exc_sn = app.ExcLicks_CheckBox.Value;
    if (exc_sn) && (ii==(size(data,2)-5))
        [~,lct]=findpeaks(abs(this_data(ii_from+1:ii_to)-this_data(ii_from:ii_to-1)),'MinPeakHeight',handles.p.exc_sn_thr);
        hold on
        plot(CurrentPlot,lct,this_data(ii_from+lct),'or')
        hold off
    end
    
    min_y=min(this_data(ii_from:ii_to));
    max_y=max(this_data(ii_from:ii_to));
    if max_y==min_y
        this_y=max_y;
        max_y=this_y+1;
        min_y=this_y-1;
    end
    ylim(CurrentPlot,[min_y-0.1*(max_y-min_y) max_y+0.1*(max_y-min_y)]);
    
    xlim(CurrentPlot,[1 1+handles.p.display_interval*handles.draq_p.ActualRate]);
    ylabel(CurrentPlot,num2str(ii-16));
    
    xticks(CurrentPlot,0:d_samples:handles.p.display_interval*handles.draq_p.ActualRate);
    xticklabels(CurrentPlot,'');
     
    switch ii
        case (size(data,2)-6)
            ylabel(CurrentPlot,'Sniffing');
        case (size(data,2)-5)
            ylabel(CurrentPlot,'Lick');
        case (size(data,2)-4)
            ylabel(CurrentPlot,'In port');
        case (size(data,2)-3)
            ylabel(CurrentPlot,'Diode');
    end
    
end


this_data=[];
this_data=data(:,end);
CurrentPlot = [];
CurrentPlot = app.Digital_Plot;
try
%     shiftdata_all=this_data;
%     one_twenty_eight_here=sum(this_data==128)
    shiftNum = app.ShiftDataBitand_EditField.Value;
    if shiftNum == 0
        shiftdata_all=bitand(this_data,1+2+4+8+16);
    else
        shiftdata_all=bitand(this_data,shiftNum);
    end
    plot(CurrentPlot,shiftdata_all(ii_from:ii_to));    
    %Draw a red line at odor on
    bitNum = app.ShiftBitand_EditField.Value;
    if bitNum == 0
        shift_dropc_nsampler=bitand(this_data,1+2+4+8+16+32);
    else
        shift_dropc_nsampler=bitand(this_data,bitNum);
    end

    odor_on=[];
    switch handles.p.which_c_program
        case 2
            %dropcspm
            odor_on=find(shiftdata_all==18,1,'first');
        case 10
            %dropcspm conc
            t_start=find(shift_dropc_nsampler==1,1,'first');
            if (sum((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7))>2.4*handles.draq_p.ActualRate)&...
                    ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
                %                         odor_on=find((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7),1,'first');
                odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
            end
    end
    
    if ~isempty(odor_on)
        plot(CurrentPlot,[odor_on odor_on],[0 35],'-r');
    end
    
    ylim(CurrentPlot,[0 35]);
    xlim(CurrentPlot,[1 1+handles.p.display_interval*handles.draq_p.ActualRate]);
    ylabel(CurrentPlot,'Digital');
        
    %This code is here to plot the digital data in a separate figure
       
%     try
%         close 1
%     catch
%     end
%     
%     hFig1 = figure(1);
%     set(hFig1, 'units','normalized','position',[.15 .6 .5 .23])
%     ax=gca;ax.LineWidth=3;
%     
%     plot(shiftdata_all(ii_from:ii_to));

    
    %This code is here to read the odor onset time measured with the PID in
    %dropc_conc in the sniff channel
    
   
%     %Find the onset of the odor
%      try
%         close 1
%     catch
%     end
%     
%     hFig1 = figure(1);
%     set(hFig1, 'units','normalized','position',[.15 .6 .7 .23])
%     
%     ii_FV=find(shiftdata_all==1,1,'first');
%     delta_ii_odor_on=find(shiftdata_all(ii_FV:end)>1,1,'first');
%     this_trace=shiftdata_all(ii_FV+delta_ii_odor_on-ceil(0.1*handles.draq_p.ActualRate):ii_FV+delta_ii_odor_on+ceil(0.2*handles.draq_p.ActualRate));
%     plot(([1:length(this_trace)]/handles.draq_p.ActualRate)-0.1,this_trace)
%     
%     %Plot the sniff channel
%      try
%         close 2
%     catch
%     end
%     
%     hFig2 = figure(2);
%     set(hFig2, 'units','normalized','position',[.15 .6 .7 .23])
%     
%     this_data=data(:,18);
%     this_trace=this_data(ii_FV+delta_ii_odor_on-ceil(0.1*handles.draq_p.ActualRate):ii_FV+delta_ii_odor_on+ceil(0.2*handles.draq_p.ActualRate));
%     plot(([1:length(this_trace)]/handles.draq_p.ActualRate)-0.1,this_trace)
%     
%If you rrun drta_save_sniffs you save decimated sniff traces
catch
end

% figure(1)
% hold on
% 
% %Plot the filtered output
% filtLFP_data=[];
% %this_data=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger):floor(ii*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger));
% filtLFP_data=data(:,21);
% 
% plot(filtLFP_data(ii_from:ii_to),'-b');
% 
% max_filtLFP_data=max(filtLFP_data(ii_from:ii_to));
% 
% %Plot the laserTTL
% laserTTL_data=[];
% %this_data=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger):floor(ii*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger));
% laserTTL_data=data(:,18);
% 
% max_laserTTL_data=max(laserTTL_data);
% 
% plot((max_filtLFP_data/max_laserTTL_data)*laserTTL_data(ii_from:ii_to),'-r');
