function handles = drtaNWB_figureControl(FullStruct,handles)
%{
This function is used to control what is plotted on each figure
%}
%pulling in relevant information about what needs to be plotted
noch = handles.draq_p.no_spike_ch;
data = drtaNWB_GetTraceData(handles);
digi = data(:,handles.draq_p.no_chans);

%determining the outcome fo the trial being plotted
try
    shiftdata30 = bitand(digi,1+2+4+8+16+32);
    shift_dropc_nsampler = bitand(digi,1+2+4+8+16+32);
    %Please note that there are problems with the start of the trial.
    %Because of this we start looking 2 sec and beyond
    shiftdata30(1:handles.draq_p.ActualRate*handles.p.exclude_secs)=0;

    %determining which protocol is being used
    odor_on=[];
    if handles.p.which_protocol == 1 || handles.p.which_protocol == 6
        %dropcspm
        odor_on=find(shiftdata30==18,1,'first');
    elseif handles.p.which_protocol == 5
        %dropcspm conc
        t_start=find(shift_dropc_nsampler==1,1,'first');
        if (sum((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7))>2.4*handles.draq_p.ActualRate)&...
                ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
            odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
        end
    end

    %determining the outcome
    if sum(shiftdata30==8)>0.05*handles.draq_p.ActualRate
        FigTitle_TrialsOutcome(handles.w.drta,'Hit')

    elseif sum(shiftdata30==10)>0.05*handles.draq_p.ActualRate
        FigTitle_TrialsOutcome(handles.w.drta,'Miss')

    elseif sum(shiftdata30==12)>0.05*handles.draq_p.ActualRate
        FigTitle_TrialsOutcome(handles.w.drta,'CR')

    elseif sum(shiftdata30==14)>0.05*handles.draq_p.ActualRate
        FigTitle_TrialsOutcome(handles.w.drta,'FA')

    elseif(length(find(shiftdata30>=1,1,'first'))==1) && ...
            (length(find(shiftdata30==8,1,'first'))~=1) && ...
            (length(find(shiftdata30==10,1,'first'))~=1) && ...
            (length(find(shiftdata30==12,1,'first'))~=1) && ...
            (length(find(shiftdata30>0))>handles.draq_p.ActualRate*0.75)
        FigTitle_TrialsOutcome(handles.w.drta,'Short')

    else
        FigTitle_TrialsOutcome(handles.w.drta,'Inter')

    
    end
catch
end

if handles.p.whichPlot ~=11
    %Now proceed to plot all channels
    switch handles.p.whichPlot
        case 1
            %Raw data
            data1=data;
        %{
        ---------------------------------------------------------
        Filters the displayed graph(s) by only showong the chosen
        bandwidth. 
        Choices: 2-full spectra, 3-High Theta, 4-Full Theta,
        5-Full Beta, 6-Low Gamma, 7-High Gamma, 8-Full Gamma,
        9 or 10-Spike range 500-5000
        ---------------------------------------------------------
        %}
        %Filter with different bandwidths
        case 2
            fpass=[4 100];
        case 3 %High Theta 6-10
            fpass=[6 14];
        case 4 %Theta 2-12
            fpass=[2 14];
        case 5 %Beta 15-36
            fpass=[15 30];
        case 6 %Gamma1 35-65
            fpass=[35 65];
        case 7 %Gamma2 65-95
            fpass=[65 95];
        case 8 %Gamma 35-95
            fpass=[35 95];
        case {9,10} %Spikes 500-5000
            fpass=[500 5000];
    end
    %filtering the data
    if handles.p.whichPlot ~= 1
    bpFilt = designfilt('bandpassiir','FilterOrder',20, ...
        'HalfPowerFrequency1',fpass(1),'HalfPowerFrequency2',fpass(2), ...
        'SampleRate',floor(handles.draq_p.ActualRate));
    data1=filtfilt(bpFilt,data);
    end
    if handles.p.whichPlot==10
        %Calculate the moving variance
        data1=movvar(data1,ceil(0.05*handles.draq_p.ActualRate));
    end
    %{
    ---------------------------------------------------------
    Adjusting changels for ????????????
    ---------------------------------------------------------
    %}
    if (handles.p.doSubtract==1)
        data2=data1;
        for tetr=1:4
            for jj=1:4
                if str2double(handles.p.subtractCh{4*(tetr-1)+jj}{:,:})<=16
                    %Subtract one of the channels
                    data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-data2(:,str2double(handles.p.subtractCh{(tetr-1)*4+jj}{:,:}));
                elseif str2double(handles.p.subtractCh{4*(tetr-1)+jj}{:,:})==17
                    %Subtract tetrode mean
                    data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-mean(data2(:,(tetr-1)*4+1:(tetr-1)*4+4),2);
                elseif str2double(handles.p.subtractCh{4*(tetr-1)+jj}{:,:})==18
                    %Subtract average of all electrodes
                    data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-mean(data2,2);
                end
            end
        end
    end
    rangespace = -0.7;
    NumberSeen = 1;
    for ii=1:noch
        if handles.p.VisableChannel(ii) == 1
            %{
            Processing the data for each plot and showing each result on a
            single figure            
            %}
            handles.plot.s_handle.Visible = "on";
            ii_from=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time)...
                *handles.draq_p.ActualRate+1);
            ii_to=floor((handles.draq_p.acquire_display_start+handles.p.start_display_time...
                +handles.p.display_interval)*handles.draq_p.ActualRate);

            sz_dat=length(data1);
            tim=[0 sz_dat];
            
            %Calculate 2.5 SD
            %Now plot 3xmedian(std)
            datavec=data1(:,ii);
            
            sdvec=zeros(1,ceil(length(datavec)/1000));
            
            jj=0;
            for kk=1:1000:length(datavec)-1000
                jj=jj+1;
                sdvec(jj)=std(datavec(kk:kk+1000));
            end
            
            %Set threshold to 2.5 or -2.5 xSD
            two_half_med_SD=2.5*median(sdvec);
            
            %If this is zero this is the differentially subtracted
            %channel, set 2.5SD high
            if two_half_med_SD==0
                two_half_med_SD=100;
            end
            
            if handles.p.set2p5SD==1
                handles.p.threshold(ii)=two_half_med_SD;
            end
            if handles.p.setm2p5SD==1
                handles.p.threshold(ii)=-two_half_med_SD;
            end
            
            %Set threshold to nxSD
            nxSD=handles.p.nxSD*median(sdvec);
            
            %If nxSD=0 this is the differentially subtracted channel
            if nxSD==0
                nxSD=1000;
                handles.p.threshold(ii)=nxSD;
            end
            
            if handles.p.setnxSD==1
                handles.p.threshold(ii)=nxSD;
            end
            
            %Set threshold to uv
            if handles.p.setThr==1
                handles.p.threshold(ii)=handles.p.thrToSet;
            end
            %{
            Setting up the data into a matrix where each channel is
            normalized to be between two set points for stacking all of the
            channels onto one plot
            %}

            rangespace = rangespace + 1.3;
            %stacking the data
            for oy = 1:size(data1(ii_from:ii_to,ii),1)
                if data1(ii_from+oy-1,ii) >= handles.draq_p.prev_ylim(1)
                    MaxedData(oy,1) = handles.draq_p.prev_ylim(1);
                elseif data1(ii_from+oy-1,ii) <= -handles.draq_p.prev_ylim(1)
                    MaxedData(oy,1) = -handles.draq_p.prev_ylim(1);
                else
                    MaxedData(oy,1) = data1(ii_from+oy-1,ii);
                end
            end

            NeededNormed = [...
                -handles.draq_p.prev_ylim(1); ...
                handles.draq_p.prev_ylim(1); ...
                (floor(-2*handles.draq_p.prev_ylim(1)/3)); ...
                (floor(2*handles.draq_p.prev_ylim(1)/3)); ...
                MaxedData];
            dataNorm = normalize(NeededNormed ,"range",[(rangespace) (rangespace+1)]);
            CombinedDataSets(:,NumberSeen) = dataNorm(5:end);
            Wlimit(:,NumberSeen) = dataNorm(1:2);
            Mlimit(:,NumberSeen) = dataNorm(3:4);
            %stacking the y-tics and labels


            %stacking location for y-lines and y-labels
            yPlace(ii) = rangespace-.15; 
            NumberSeen = NumberSeen + 1;
            %stacking threshold locations
%             disp(handles.p.threshold(ii))

            %stacking other plot index locations
        end

    end

    PlotSpace = FullStruct.GridLayout5.Children.findobj('Tag','plotField');
    plot(PlotSpace,CombinedDataSets)             
    ylim(PlotSpace,[(yPlace(1)-.1) (yPlace(end)+1.4)]);
    xlabel(PlotSpace,'Time (sec)');
    %placing all the x-lines
    if exist("odor_on","var") ~= 0 && ...
            ~isempty(odor_on)
        xline(PlotSpace,odor_on,"LineWidth",0.8,"Color","black")
        xline(PlotSpace,odor_on,"LineWidth",12,"Alpha",0.3,"Color","red")
    end
    %placing all the y-lines
    if size(yPlace,2) > 1
        yline(PlotSpace,yPlace(2:end),"LineWidth",0.8,"Color","black","Alpha",1)
    end
    yline(PlotSpace,[sort([Wlimit(1,:),Wlimit(2,:)])], ...
        "LineWidth",0.4,"Color","black","Alpha",1,"LineStyle",":")
    %placing all tick lines for lables and index points
    yticks(PlotSpace,sort([Mlimit(1,:),Mlimit(2,:)],2))
    ChLables = yPlace+0.65;
    tLabels = [(yPlace+0.15),(yPlace+1.15)];
    
    dt=handles.p.display_interval/5;
    dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
    d_samples=dt*handles.draq_p.ActualRate;
    PlotSpace.XTick = 0:d_samples:handles.p.display_interval*handles.draq_p.ActualRate;
    PlotSpace.FontSize = 12;
    time=handles.p.start_display_time;
    jj=1;
    while time<(handles.p.start_display_time+handles.p.display_interval)
        tick_label{jj}=num2str(time);
        time=time+dt;
        jj=jj+1;
    end
    PlotSpace.XTickLabel = tick_label;


else
    drtaShowDigital(handles);

end



