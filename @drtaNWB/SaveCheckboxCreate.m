function SaveCheckboxCreate(app)


%finding the number of channels
channel_total = app.drta_Data.draq_p.no_chans;
digital_total = size(app.drta_Data.Signals.Digital,2);
analog_total = app.drta_Data.draq_d.num_board_adc_channels;
%determining how many rows are needed based on only 10 per row
if channel_total > 10
    RowsNeeded = (ceil(channel_total/10)) + 6;
    RowsNeeded = RowsNeeded + (ceil(digital_total/10));
    RowsNeeded = RowsNeeded + (ceil(analog_total/10));
else
    RowsNeeded = 1;
end

%creating the rows' heights of 25 points
RowVals = num2cell(ones([1,RowsNeeded-1])*25);
RowVals(end+1) = {"1x"};
%assigning those values
app.Save_GridLayout.RowHeight = RowVals;
ColumnLimit = 10;   %initial conditions
CurrentRow = 1; %initial conditions
CurrentColumn = 1;  %initial conditions
%creating each label and check box
app.drta_Save.ChannelNames = {};
app.drta_Save.p.VisableChannel = zeros([channel_total,1]);
app.drta_Save.p.VisableDigital = zeros([digital_total,1]);
app.drta_Save.p.VisableAnalog = ones([analog_total,1]);
%preallocating y range choices
app.drta_Save.Yrange.DDChoice = cell([1, channel_total+1]);
app.drta_Save.Yrange.rangeVals = zeros([channel_total,1]);
app.drta_Save.Yrange.DDChoice{1} = sprintf('all');


for fn = 1:channel_total
    if fn == 1
        app.drta_Save.Labels.Electrodes = uilabel(app.Save_GridLayout,'Text',"Electrode Channels");
        app.drta_Save.Labels.Electrodes.HorizontalAlignment = 'center';
        app.drta_Save.Labels.Electrodes.FontSize = 14;
        app.drta_Save.Labels.Electrodes.FontName = 'Times New Roman';
        app.drta_Save.Labels.Electrodes.Layout.Row = CurrentRow;
        app.drta_Save.Labels.Electrodes.Layout.Column = [1 3];
        CurrentRow = CurrentRow + 1;
    end
    %checking to see if the next row is needed
    if fn > ColumnLimit
        CurrentRow = CurrentRow + 1;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 10;
    end
    %adding a 0 to the number if < 10 and creating a label
    if fn < 11
        ChTitle = uilabel(app.Save_GridLayout,'Text',append('E-00',num2str(fn-1)));
        app.drta_Save.ChannelNames{fn} = append('A-00',num2str(fn-1));
        
    elseif fn < 101
        ChTitle = uilabel(app.Save_GridLayout,'Text',append('E-0',num2str(fn-1)));
        app.drta_Save.ChannelNames{fn} = append('A-0',num2str(fn-1));
    else
        ChTitle = uilabel(app.Save_GridLayout,'Text',append('E-',num2str(fn-1)));
        app.drta_Save.ChannelNames{fn} = append('A-',num2str(fn-1));
    end
    app.drta_Save.Yrange.DDChoice{fn+1} = sprintf('%.2i',fn-1);
    app.drta_Save.Yrange.rangeVals(fn) = app.Yrange_amt.Value;
    %label settings
    ChTitle.HorizontalAlignment = 'center';
    ChTitle.FontSize = 14;
    ChTitle.Layout.Row = CurrentRow;
    ChTitle.Layout.Column = CurrentColumn;
    if fn < 11
        CurrentChNum = append('ChCB00',num2str(fn-1));
    elseif fn < 101
        CurrentChNum = append('ChCB0',num2str(fn-1));
    else
        CurrentChNum = append('ChCB',num2str(fn-1));
    end
    %creating a checkbox
    app.drta_Save.ChShown.(CurrentChNum) = uicheckbox(app.Save_GridLayout);
    %checkbox settings
    app.drta_Save.ChShown.(CurrentChNum).Layout.Row = CurrentRow;
    app.drta_Save.ChShown.(CurrentChNum).Layout.Column = CurrentColumn + 1;
    app.drta_Save.ChShown.(CurrentChNum).Text = {''};
    
    if fn < 16
        app.drta_Save.ChShown.(CurrentChNum).Value = 1;
        app.drta_Save.p.VisableChannel(fn) = 1;
    else
        app.drta_Save.ChShown.(CurrentChNum).Value = 0;
    end
    if fn < 11
        app.drta_Save.ChShown.(CurrentChNum).Tag = append('E-00',num2str(fn-1));
    elseif fn >=11 && fn < 100
        app.drta_Save.ChShown.(CurrentChNum).Tag = append('E-0',num2str(fn-1));
    else
        app.drta_Save.ChShown.(CurrentChNum).Tag = append('E-',num2str(fn-1));
    end
    app.drta_Save.ChShown.(CurrentChNum).ValueChangedFcn = createCallbackFcn(app,@SaveChControl, true);
    % if fn < 11
    %     DiffTagName = append('DiffA00',num2str(fn-1));
    % elseif fn >=11 && fn < 100
    %     DiffTagName = append('DiffA0',num2str(fn-1));
    % else
    %     DiffTagName = append('DiffA',num2str(fn-1));
    % end

    % %creating dropdown diff menu
    % app.drta_Save.DiffDropdowns.(DiffTagName) = uidropdown(app.Save_GridLayout);
    % %dropdown settings
    % ChNums = cell([1 channel_total+3]);
    % for ww = 1:channel_total
    %     ChNums{ww+3} = char(num2str(ww-1));
    % end
    % ChNums{1} = 'None';
    % ChNums{2} = 'Tet';
    % ChNums{3} = 'Avg';
    % app.drta_Save.DiffDropdowns.(DiffTagName).Layout.Row = CurrentRow + 1;
    % app.drta_Save.DiffDropdowns.(DiffTagName).Layout.Column = CurrentColumn;
    % app.drta_Save.DiffDropdowns.(DiffTagName).Items = ChNums;
    % app.drta_Save.DiffDropdowns.(DiffTagName).ValueChangedFcn = createCallbackFcn(app,@ChannelDiffChange, true);
    % app.drta_Save.DiffDropdowns.(DiffTagName).Enable = "off";
    % app.drta_Save.DiffDropdowns.(DiffTagName).Tag = DiffTagName;

    %moves the index to the next label location
    CurrentColumn = CurrentColumn + 2;
end
% digital channel selection
ColumnLimit = 10;   %initial conditions
CurrentColumn = 1;  %initial conditions
CurrentRow = CurrentRow + 1; %setting analog ch choice on a new row
for dch = 1:digital_total
    if dch == 1
        app.drta_Save.Labels.Digital = uilabel(app.Save_GridLayout,'Text',"Digital Channels");
        app.drta_Save.Labels.Digital.HorizontalAlignment = 'center';
        app.drta_Save.Labels.Digital.FontSize = 14;
        app.drta_Save.Labels.Digital.FontName = 'Times New Roman';
        app.drta_Save.Labels.Digital.Layout.Row = CurrentRow;
        app.drta_Save.Labels.Digital.Layout.Column = [1 3];
        CurrentRow = CurrentRow + 1;
    end
    %checking to see if the next row is needed
    if dch > ColumnLimit
        CurrentRow = CurrentRow + 1;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 10;
    end
    
    %adding a 0 to the number if < 10 and creating a label
    if dch < 11
        ChTitle = uilabel(app.Save_GridLayout,'Text',append('D-00',num2str(dch-1)));
        app.drta_Save.ChannelNames{dch} = append('D-00',num2str(dch-1));
    elseif dch < 101
        ChTitle = uilabel(app.Save_GridLayout,'Text',append('D-0',num2str(dch-1)));
        app.drta_Save.ChannelNames{dch} = append('D-0',num2str(dch-1));
    else
        ChTitle = uilabel(app.Save_GridLayout,'Text',append('D-',num2str(dch-1)));
        app.drta_Save.ChannelNames{dch} = append('D-',num2str(dch-1));
    end
    %label settings
    ChTitle.HorizontalAlignment = 'center';
    ChTitle.FontSize = 14;
    ChTitle.Layout.Row = CurrentRow;
    ChTitle.Layout.Column = CurrentColumn;

    if dch < 11
        CurrentChNum = append('DigitalChCB00',num2str(dch-1));
    elseif dch < 101
        CurrentChNum = append('DigitalChCB0',num2str(dch-1));
    else
        CurrentChNum = append('DigitalChCB',num2str(dch-1));
    end
    
    if dch < 3
        app.drta_Save.ChShown.(CurrentChNum).Value = 1;
        app.drta_Save.p.VisableDigital(dch) = 1;
    else
        app.drta_Save.ChShown.(CurrentChNum).Value = 0;
    end
    %creating a checkbox
    app.drta_Save.ChShown.(CurrentChNum) = uicheckbox(app.Save_GridLayout);
    %checkbox settings
    app.drta_Save.ChShown.(CurrentChNum).Layout.Row = CurrentRow;
    app.drta_Save.ChShown.(CurrentChNum).Layout.Column = CurrentColumn + 1;
    app.drta_Save.ChShown.(CurrentChNum).Text = {''};
    if dch < 11
        app.drta_Save.ChShown.(CurrentChNum).Tag = append('D-00',num2str(dch-1));
    elseif dch >=11 && dch < 100
        app.drta_Save.ChShown.(CurrentChNum).Tag = append('D-0',num2str(dch-1));
    else
        app.drta_Save.ChShown.(CurrentChNum).Tag = append('D-',num2str(dch-1));
    end
    app.drta_Save.ChShown.(CurrentChNum).ValueChangedFcn = createCallbackFcn(app,@SaveChControl, true);
    app.drta_Save.ChShown.(CurrentChNum).Value = 1;
    app.drta_Save.p.VisableChannelDigital(dch) = 1;
    %moves the index to the next label location
    CurrentColumn = CurrentColumn + 2;
end

% analog channel selection
ColumnLimit = 10;   %initial conditions
CurrentColumn = 1;  %initial conditions
CurrentRow = CurrentRow + 1; %setting analog ch choice on a new row
for ach = 1:analog_total
    if ach == 1
        app.drta_Save.Labels.Digital = uilabel(app.Save_GridLayout,'Text',"Analog Channels");
        app.drta_Save.Labels.Digital.HorizontalAlignment = 'center';
        app.drta_Save.Labels.Digital.FontSize = 14;
        app.drta_Save.Labels.Digital.FontName = 'Times New Roman';
        app.drta_Save.Labels.Digital.Layout.Row = CurrentRow;
        app.drta_Save.Labels.Digital.Layout.Column = [1 3];
        CurrentRow = CurrentRow + 1;
    end
    %checking to see if the next row is needed
    if ach > ColumnLimit
        CurrentRow = CurrentRow + 1;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 10;
    end
    
    %adding a 0 to the number if < 10 and creating a label
    if ach < 11
        ChTitle = uilabel(app.Save_GridLayout,'Text',append('A-00',num2str(ach-1)));
        app.drta_Save.ChannelNames{ach} = append('A-00',num2str(ach-1));
    elseif ach < 101
        ChTitle = uilabel(app.Save_GridLayout,'Text',append('A-0',num2str(ach-1)));
        app.drta_Save.ChannelNames{ach} = append('A-0',num2str(ach-1));
    else
        ChTitle = uilabel(app.Save_GridLayout,'Text',append('A-',num2str(ach-1)));
        app.drta_Save.ChannelNames{ach} = append('A-',num2str(ach-1));
    end

    

    %label settings
    ChTitle.HorizontalAlignment = 'center';
    ChTitle.FontSize = 14;
    ChTitle.Layout.Row = CurrentRow;
    ChTitle.Layout.Column = CurrentColumn;
    if ach < 11
        CurrentChNum = append('AnalogChCB00',num2str(ach-1));
    elseif ach < 101
        CurrentChNum = append('AnalogChCB0',num2str(ach-1));
    else
        CurrentChNum = append('AnalogChCB',num2str(ach-1));
    end
    
    

    %creating a checkbox
    app.drta_Save.ChShown.(CurrentChNum) = uicheckbox(app.Save_GridLayout);
    
    %checkbox settings
    app.drta_Save.ChShown.(CurrentChNum).Layout.Row = CurrentRow;
    app.drta_Save.ChShown.(CurrentChNum).Layout.Column = CurrentColumn + 1;
    app.drta_Save.ChShown.(CurrentChNum).Text = {''};
    if ach < 11
        app.drta_Save.ChShown.(CurrentChNum).Tag = append('A-00',num2str(ach-1));
    elseif ach >=11 && ach < 100
        app.drta_Save.ChShown.(CurrentChNum).Tag = append('A-0',num2str(ach-1));
    else
        app.drta_Save.ChShown.(CurrentChNum).Tag = append('A-',num2str(ach-1));
    end
    app.drta_Save.ChShown.(CurrentChNum).ValueChangedFcn = createCallbackFcn(app,@SaveChControl, true);
    %moves the index to the next label location
    app.drta_Save.ChShown.(CurrentChNum).Value = 1;
    app.drta_Save.p.VisableChannelAnalog(ach) = 1;
    CurrentColumn = CurrentColumn + 2;
end

%adding save button for channel selected
CurrentRow = CurrentRow + 2;
app.drta_Save.ChannelPreset.LoadButton = uibutton(app.Save_GridLayout,"push");
app.drta_Save.ChannelPreset.LoadButton.Text = "Save Selected Channels";
app.drta_Save.ChannelPreset.LoadButton.FontSize = 14;
app.drta_Save.ChannelPreset.LoadButton.FontName = 'Times New Roman';
app.drta_Save.ChannelPreset.LoadButton.Layout.Row = CurrentRow;
app.drta_Save.ChannelPreset.LoadButton.Layout.Column = [1 3];
app.drta_Save.ChannelPreset.LoadButton.ButtonPushedFcn = createCallbackFcn(app,@SaveFile, true);
app.drta_Save.ChannelPreset.LoadButton.Tag = "SaveChButton";
%adding label for multiple trial checkbox
app.drta_Save.Labels.Digital = uilabel(app.Save_GridLayout,'Text',"Multiple Trials");
app.drta_Save.Labels.Digital.HorizontalAlignment = 'right';
app.drta_Save.Labels.Digital.FontSize = 14;
app.drta_Save.Labels.Digital.FontName = 'Times New Roman';
app.drta_Save.Labels.Digital.Layout.Row = CurrentRow;
app.drta_Save.Labels.Digital.Layout.Column = [4 5];
% adding checkbox to allow for multiple trials to be selected
app.drta_Save.ChannelPreset.MoreTrials = uicheckbox(app.Save_GridLayout);
%checkbox settings
app.drta_Save.ChannelPreset.MoreTrials.Layout.Row = CurrentRow;
app.drta_Save.ChannelPreset.MoreTrials.Layout.Column = 6;
app.drta_Save.ChannelPreset.MoreTrials.Text = {''};
app.drta_Save.ChannelPreset.MoreTrials.Tag = "AddingTrials";
app.drta_Save.ChannelPreset.MoreTrials.ValueChangedFcn = createCallbackFcn(app,@MultipleTrials, true);
%adding label for multiple trial checkbox
app.drta_Save.Labels.Digital = uilabel(app.Save_GridLayout,'Text',"Trial Being saved:");
app.drta_Save.Labels.Digital.HorizontalAlignment = 'center';
app.drta_Save.Labels.Digital.FontSize = 14;
app.drta_Save.Labels.Digital.FontName = 'Times New Roman';
app.drta_Save.Labels.Digital.Layout.Row = CurrentRow;
app.drta_Save.Labels.Digital.Layout.Column = [7 9];
% creating a gridlayout for the trial entry
app.drta_Save.TrialGrid = uigridlayout(app.Save_GridLayout);
app.drta_Save.TrialGrid.Layout.Row = CurrentRow;
app.drta_Save.TrialGrid.Layout.Column = [10 12];
app.drta_Save.TrialGrid.RowHeight = {"1x"};
app.drta_Save.TrialGrid.ColumnWidth = [{5} {30} {15} {30} {"1x"}];
app.drta_Save.TrialGrid.Padding = [1 1 1 1];
app.drta_Save.TrialGrid.ColumnSpacing = 1;
app.drta_Save.TrialGrid.RowSpacing = 1;
% adding numeric field for trial being saved or the first trial being saved
app.drta_Save.TrialIndex.STposition = uieditfield(app.drta_Save.TrialGrid,"numeric");
app.drta_Save.TrialIndex.STposition.Layout.Row = 1;
app.drta_Save.TrialIndex.STposition.Layout.Column = 2;
app.drta_Save.TrialIndex.STposition.HorizontalAlignment = 'center';

% adding text field for space text
app.drta_Save.TrialIndex.Midposition = uiimage(app.drta_Save.TrialGrid); %uieditfield(app.drta_Save.TrialGrid,"text");
app.drta_Save.TrialIndex.Midposition.ImageSource = fullfile(pwd,'@drtaNWB','Images','colon-marker.png');
app.drta_Save.TrialIndex.Midposition.Layout.Row = 1;
app.drta_Save.TrialIndex.Midposition.Layout.Column = 3;
app.drta_Save.TrialIndex.Midposition.Visible = "off";

% adding numeric field for final trial to be saved
app.drta_Save.TrialIndex.ENposition = uieditfield(app.drta_Save.TrialGrid,"numeric");
app.drta_Save.TrialIndex.ENposition.Layout.Row = 1;
app.drta_Save.TrialIndex.ENposition.Layout.Column = 4;
app.drta_Save.TrialIndex.ENposition.HorizontalAlignment = 'center';
app.drta_Save.TrialIndex.ENposition.Visible = "off";