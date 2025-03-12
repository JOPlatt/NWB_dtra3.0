function drtaNWB_figureControl(app)
%{
This function is used to control what is plotted on each figure
%}
% ChPlace = 2;
% for nk = 1: app.drta_handles.draq_p.no_chans
%     ChannelValues(nk) = app.Channels_GridLayout.Children(ChPlace).Value;
%     if nk <=16
%         ChPlace = ChPlace + 3;
%     else
%         ChPlace = ChPlace + 2;
%     end
% 
% end
% %setting inital channel values
% app.drta_handles.p.VisableChannel = ChannelValues;
noch = size(app.drta_handles.p.VisableChannel,2);

currentChan = find(app.drta_handles.p.VisableChannel == 1);

%pulling in relevant information about what needs to be plotted
data = drtaNWB_GetTraceData(app.drta_handles);
digi = data(:,app.drta_handles.draq_p.no_chans);

%determining the outcome fo the trial being plotted
try
    if DataShiftBitand_EditField.Value == 0
        shiftdata30 = bitand(digi,1+2+4+8+16+32);
    else
        shiftdata30 = bitand(digi,DataShiftBitand_EditField.Value);
    end
    if ShiftDropcBitand_EditField.Value == 0
        shift_dropc_nsampler = bitand(digi,1+2+4+8+16+32);
    else
        shift_dropc_nsampler = bitand(ShiftDropcBitand_EditField.Value);
    end
    %Please note that there are problems with the start of the trial.
    %Because of this we start looking 2 sec and beyond
    shiftdata30(1:app.drta_handles.draq_p.ActualRate*app.drta_handles.p.exclude_secs)=0;

    %determining which protocol is being used
    odor_on=[];
    if app.drta_handles.p.which_protocol == 1 || app.drta_handles.p.which_protocol == 6
        %dropcspm
        odor_on=find(shiftdata30==18,1,'first');
    elseif app.drta_handles.p.which_protocol == 5
        %dropcspm conc
        t_start=find(shift_dropc_nsampler==1,1,'first');
        if (sum((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7))>2.4*app.drta_handles.draq_p.ActualRate)&...
                ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
            odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
        end
    end

    %determining the outcome
    if sum(shiftdata30==8)>0.05*app.drta_handles.draq_p.ActualRate
        app.TrialOutcome.Text = 'Hit';
    elseif sum(shiftdata30==10)>0.05*app.drta_handles.draq_p.ActualRate
        app.TrialOutcome.Text = 'Miss';
    elseif sum(shiftdata30==12)>0.05*app.drta_handles.draq_p.ActualRate
        app.TrialOutcome.Text = 'CR';
    elseif sum(shiftdata30==14)>0.05*app.drta_handles.draq_p.ActualRate
        app.TrialOutcome.Text = 'FA';
    elseif isscalar(find(shiftdata30>=1,1,'first')) && ...
            (length(find(shiftdata30==8,1,'first'))~=1) && ...
            (length(find(shiftdata30==10,1,'first'))~=1) && ...
            (length(find(shiftdata30==12,1,'first'))~=1) && ...
            (length(find(shiftdata30>0))>app.drta_handles.draq_p.ActualRate*0.75)
        app.TrialOutcome.Text = 'Short';
    else
        app.TrialOutcome.Text = 'Inter';
    end
catch
end

if app.Flags.DataShownAs ~=12
    %Now proceed to plot all channels
    switch app.drta_handles.p.whichPlot
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
            fpass = [app.min_amt.Value app.max_amt.Value];
        case 3
            fpass=[4 100];
        case 4 %High Theta 6-10
            fpass=[6 14];
        case 5 %Theta 2-12
            fpass=[2 14];
        case 6 %Beta 15-36
            fpass=[15 30];
        case 7 %Gamma1 35-65
            fpass=[35 65];
        case 8 %Gamma2 65-95
            fpass=[65 95];
        case 9 %Gamma 35-95
            fpass=[35 95];
        case {10,11} %Spikes 500-5000
            fpass=[500 5000];
    end


    %filtering the data
    if app.drta_handles.p.whichPlot ~= 1
        app.min_amt.Value = fpass(1);
        app.max_amt.Value = fpass(2);

        app.drta_handles.p.lfp.minLFP=fpass(1);
        app.drta_handles.p.lfp.maxLFP=fpass(2);
        bpFilt = designfilt('bandpassiir','FilterOrder',6, ...
            'HalfPowerFrequency1',fpass(1),'HalfPowerFrequency2',fpass(2), ...
            'SampleRate',floor(app.drta_handles.draq_p.ActualRate));
        data1=filtfilt(bpFilt,data);

        if app.drta_handles.p.whichPlot==11
            %Calculate the moving variance
            data1=movvar(data1,ceil(0.05*app.drta_handles.draq_p.ActualRate));
        end
    end
    %{
    ---------------------------------------------------------
    Adjusting changels for ????????????
    ---------------------------------------------------------
    %}
    if any(app.drta_Main.ChDiffChoice ~= 0)
        data2=data1;
        for tetr=1:4
            for jj=1:4
                ChShown = app.drta_handles.p.VisableChannel((tetr-1)*4+jj);
                DiffChoice = app.drta_Main.ChDiffChoice((tetr-1)*4+jj);
                if ChShown == 1 && DiffChoice >= 3
                    %Subtract one of the channels
                    data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-data2(:,app.drta_Main.ChDiffChoice((tetr-1)*4+jj)-3);
                elseif ChShown == 1 && DiffChoice == 1
                    %Subtract tetrode mean
                    data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-mean(data2(:,(tetr-1)*4+1:(tetr-1)*4+4),2);
                elseif ChShown == 1 && DiffChoice == 2
                    %Subtract average of all electrodes
                    data1(:,(tetr-1)*4+jj)=data2(:,(tetr-1)*4+jj)-mean(data2,2);
                end
            end
        end
    end
    rangespace = -0.7;
    NumberSeen = 1;
    tagNum = 2;
    SeenNumber = sum(app.drta_handles.p.VisableChannel);
    AllChNames = cell([SeenNumber, 1]);
    for ss = 1:noch
        if app.drta_handles.p.VisableChannel(ss) == 1
            %{
            Processing the data for each plot and showing each result on a
            single figure            
            %}
            ChannelName = app.SelectChannelsTab.Children.Children.Children(tagNum,1).Tag;
            AllChNames{NumberSeen,1} = append(ChannelName,'------>');
            NumberSeen = NumberSeen + 1;
        end
        tagNum = tagNum + 3;
    end
    lowestTic = cell([sum(app.drta_handles.p.VisableChannel) 1]);
    lowTic= cell([sum(app.drta_handles.p.VisableChannel) 1]);
    higerTic = cell([sum(app.drta_handles.p.VisableChannel) 1]);
    highestTic = cell([sum(app.drta_handles.p.VisableChannel) 1]);
    for ik = 1:sum(app.drta_handles.p.VisableChannel)
        ii = currentChan(ik);

        app.drta_handles.plot.s_handle.Visible = "on";

        ii_from=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time)...
            *app.drta_handles.draq_p.ActualRate+1);
        ii_to=floor((app.drta_handles.draq_p.acquire_display_start+app.drta_handles.p.start_display_time...
            +app.drta_handles.p.display_interval)*app.drta_handles.draq_p.ActualRate);

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

        if app.drta_handles.p.set2p5SD==1
            app.drta_handles.p.threshold(ii)=two_half_med_SD;
        end
        if app.drta_handles.p.setm2p5SD==1
            app.drta_handles.p.threshold(ii)=-two_half_med_SD;
        end

        %Set threshold to nxSD
        nxSD=app.drta_handles.p.nxSD*median(sdvec);

        %If nxSD=0 this is the differentially subtracted channel
        if nxSD==0
            nxSD=1000;
            app.drta_handles.p.threshold(ii)=nxSD;
        end

        if app.drta_handles.p.setnxSD==1
            app.drta_handles.p.threshold(ii)=nxSD;
        end

        %Set threshold to uv
        if app.drta_handles.p.setThr==1
            app.drta_handles.p.threshold(ii)=app.drta_handles.p.thrToSet;
        end
        %{
            Setting up the data into a matrix where each channel is
            normalized to be between two set points for stacking all of the
            channels onto one plot
        %}
        % ***********************
        % the code below needs to be checked in reference to line 270
        % drtaPlotBrowseTraces also need to add the else part of the file
        % *****************
        rangespace = rangespace + 1.3;
        %stacking the data
        for oy = 1:size(data1(ii_from:ii_to,ii),1)
            if data1(ii_from+oy-1,ii) >= app.drta_handles.draq_p.prev_ylim(ii)
                MaxedData(oy,1) = app.drta_handles.draq_p.prev_ylim(ii);
            elseif data1(ii_from+oy-1,ii) <= -app.drta_handles.draq_p.prev_ylim(ii)
                MaxedData(oy,1) = -app.drta_handles.draq_p.prev_ylim(ii);
            else
                MaxedData(oy,1) = data1(ii_from+oy-1,ii);
            end
        end
        NeededNormed = [...
            -app.drta_handles.draq_p.prev_ylim(ii); ...
            app.drta_handles.draq_p.prev_ylim(ii); ...
            (floor(-2*app.drta_handles.draq_p.prev_ylim(ii)/3)); ...
            (floor(2*app.drta_handles.draq_p.prev_ylim(ii)/3)); ...
            MaxedData];
        % if ik > 1
            lowestTic{ik} = num2str(-app.drta_handles.draq_p.prev_ylim(ii));
            lowTic{ik} = num2str(floor(-2*app.drta_handles.draq_p.prev_ylim(ii)/3));
            higerTic{ik} = num2str(floor(2*app.drta_handles.draq_p.prev_ylim(ii)/3));
            highestTic{ik} = num2str(app.drta_handles.draq_p.prev_ylim(ii));
            dataNorm = normalize(NeededNormed ,"range",[(rangespace) (rangespace+1)]);
            CombinedDataSets(:,ik) = dataNorm(5:end);
            Wlimit(:,ik) = dataNorm(1:2);
            Mlimit(:,ik) = dataNorm(3:4);
            yPlace(ik) = rangespace-.15;

        % else
        %     CombinedDataSets = NeededNormed;
        % end

    end
    %happends independent of the number of channels shown Plot_figureGrid

    cla(app.figurePlot_UIAxes);
    app.figurePlot_UIAxes.Layout.Row = [1 (ik)];
    app.figurePlot_UIAxes.Layout.Column = 1;
    app.figurePlot_UIAxes.XTickLabels = {};
    app.figurePlot_UIAxes.YTickLabels = {};
    app.figurePlot_UIAxes.YLabel.Visible = "on";
    app.figurePlot_UIAxes.Title.Visible = "off";
    app.figurePlot_UIAxes.Box = 'on';
    app.figurePlot_UIAxes.Tag = 'plotField';

    PlotSpace = app.figurePlot_UIAxes;

    if SeenNumber > 1
        app.drta_Main.ChannelData = CombinedDataSets;
        plot(PlotSpace,CombinedDataSets)
        ylim(PlotSpace,[(yPlace(1)-.1) (yPlace(end)+1.4)]);
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
    else
        ylim(PlotSpace,[-app.drta_handles.draq_p.prev_ylim(ii) app.drta_handles.draq_p.prev_ylim(ii)])
    end
    xlabel(PlotSpace,'Time (sec)');
    if sum(app.drta_handles.p.VisableChannel) < 11
        combinedTicks = sort([Mlimit(1,:),Mlimit(2,:),ChLables(1,:),tLabels(1,:)],'ascend');
    else
        combinedTicks = sort([Mlimit(1,:),Mlimit(2,:),ChLables(1,:)],'ascend');
    end
    PlotSpace.YTick = combinedTicks;
    nameplace = 1;
    allTickLabels = cell([size(combinedTicks,2) 1]);
    for ss = 1:size(AllChNames,1)
        allTickLabels(nameplace) = lowestTic(ss);
        nameplace = nameplace + 1;
        if sum(app.drta_handles.p.VisableChannel) < 11
            allTickLabels(nameplace) = lowTic(ss);
            nameplace = nameplace + 1;
        end
        allTickLabels(nameplace) = AllChNames(ss);
        nameplace = nameplace + 1;
        if sum(app.drta_handles.p.VisableChannel) < 11
            allTickLabels(nameplace) = higerTic(ss);
            nameplace = nameplace + 1;
        end
        allTickLabels(nameplace) = highestTic(ss);
        nameplace = nameplace + 1;
    end
    PlotSpace.YTickLabel = allTickLabels;
    PlotSpace.FontSize = 18;
    %placing all the x-lines
    if exist("odor_on","var") ~= 0 && ...
            ~isempty(odor_on)
        xline(PlotSpace,odor_on,"LineWidth",0.8,"Color","black")
        xline(PlotSpace,odor_on,"LineWidth",12,"Alpha",0.3,"Color","red")
    end


    dt=app.drta_handles.p.display_interval/5;
    dt=round(dt*10^(-floor(log10(dt))))/10^(-floor(log10(dt)));
    d_samples=dt*app.drta_handles.draq_p.ActualRate;
    PlotSpace.XTick = 0:d_samples:app.drta_handles.p.display_interval*app.drta_handles.draq_p.ActualRate;
    PlotSpace.FontSize = 12;
    app.drta_Main.ChannelTime = 0:d_samples:app.drta_handles.p.display_interval*app.drta_handles.draq_p.ActualRate;
    time=app.drta_handles.p.start_display_time;
    jj=1;
    while time<(app.drta_handles.p.start_display_time+app.drta_handles.p.display_interval)
        tick_label{jj}=num2str(time);
        time=time+dt;
        jj=jj+1;
    end
    PlotSpace.XTickLabel = tick_label;
    app.drta_Main.xticlabels = tick_label;



end



