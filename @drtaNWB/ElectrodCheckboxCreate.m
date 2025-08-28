function ElectrodCheckboxCreate(app)

%finding the number of channels
channel_total = app.drta_Data.draq_p.no_chans;
digital_total = size(app.drta_Data.Signals.Digital,2);
analog_total = app.drta_Data.draq_d.num_board_adc_channels;
%determining how many rows are needed based on only 10 per row
if channel_total > 10
    RowsNeeded = (ceil(channel_total/10)*2) + 7;
    RowsNeeded = RowsNeeded + (ceil(digital_total/10)*2);
    RowsNeeded = RowsNeeded + (ceil(analog_total/10)*2);
else
    RowsNeeded = 1;
end
% creating a vectore for diff calculation choices
app.drta_Main.ChDiffChoice = zeros([channel_total,1]);
%creating the rows' heights of 25 points
RowVals = num2cell(ones([1,RowsNeeded-1])*25);
RowVals(end+1) = {"1x"};
%assigning those values
app.Channels_GridLayout.RowHeight = RowVals;
ColumnLimit = 10;   %initial conditions
CurrentRow = 1; %initial conditions
CurrentColumn = 1;  %initial conditions
%creating each label and check box
app.drta_Main.ChannelNames = {};
app.drta_Data.p.VisableChannel = zeros([channel_total,1]);
app.drta_Data.p.VisableDigital = zeros([digital_total,1]);
app.drta_Data.p.VisableAnalog = ones([analog_total,1]);
%preallocating y range choices
app.drta_Main.Yrange.DDChoice = cell([1, channel_total+1]);
app.drta_Main.Yrange.rangeVals = zeros([channel_total,1]);
app.drta_Main.Yrange.DDChoice{1} = sprintf('all');
%
app.drta_Main.ChShown.Labels.Electrodes = uilabel(app.Channels_GridLayout,'Text',"Electrode Channels");
app.drta_Main.ChShown.Labels.Electrodes.HorizontalAlignment = 'center';
app.drta_Main.ChShown.Labels.Electrodes.FontSize = 14;
app.drta_Main.ChShown.Labels.Electrodes.FontName = 'Times New Roman';
app.drta_Main.ChShown.Labels.Electrodes.Layout.Row = CurrentRow;
app.drta_Main.ChShown.Labels.Electrodes.Layout.Column = [1 3];
CurrentRow = CurrentRow + 1;
%
for fn = 1:channel_total
    %checking to see if the next row is needed
    if fn > ColumnLimit
        CurrentRow = CurrentRow + 2;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 10;
    end
    %adding a 0 to the number if < 10 and creating a label
    ChTitle = uilabel(app.Channels_GridLayout,'Text',sprintf('E-%.3d',fn-1));
    app.drta_Main.ChannelNames.Electrode{fn} = sprintf('A-%.3d',fn-1);

    app.drta_Main.Yrange.DDChoice{fn+1} = sprintf('%.2i',fn-1);
    app.drta_Main.Yrange.rangeVals(fn) = app.Yrange_amt.Value;
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
    app.drta_Main.ChShown.(CurrentChNum) = uicheckbox(app.Channels_GridLayout);
    %checkbox settings
    app.drta_Main.ChShown.(CurrentChNum).Layout.Row = CurrentRow;
    app.drta_Main.ChShown.(CurrentChNum).Layout.Column = CurrentColumn + 1;
    app.drta_Main.ChShown.(CurrentChNum).Text = {''};
    
    if fn < 16
        app.drta_Main.ChShown.(CurrentChNum).Value = 1;
        app.drta_Data.p.VisableChannel(fn) = 1;
    else
        app.drta_Main.ChShown.(CurrentChNum).Value = 0;
    end
    app.drta_Main.ChShown.(CurrentChNum).Tag = sprintf('E-%.3d',fn-1);
    app.drta_Main.ChShown.NamesOnly(fn) = {sprintf('E-%.3d',fn-1)};
    app.drta_Main.ChShown.(CurrentChNum).ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);
    if fn < 11
        DiffTagName = append('DiffA00',num2str(fn-1));
    elseif fn >=11 && fn < 100
        DiffTagName = append('DiffA0',num2str(fn-1));
    else
        DiffTagName = append('DiffA',num2str(fn-1));
    end

    %creating dropdown diff menu
    app.drta_Main.DiffDropdowns.(DiffTagName) = uidropdown(app.Channels_GridLayout);
    %dropdown settings
    ChNums = cell([1 channel_total+3]);
    for ww = 1:channel_total
        ChNums{ww+3} = char(num2str(ww-1));
    end
    ChNums{1} = 'None';
    ChNums{2} = 'Tet';
    ChNums{3} = 'Avg';
    app.drta_Main.DiffDropdowns.(DiffTagName).Layout.Row = CurrentRow + 1;
    app.drta_Main.DiffDropdowns.(DiffTagName).Layout.Column = CurrentColumn;
    app.drta_Main.DiffDropdowns.(DiffTagName).Items = ChNums;
    app.drta_Main.DiffDropdowns.(DiffTagName).ValueChangedFcn = createCallbackFcn(app,@ChannelDiffChange, true);
    app.drta_Main.DiffDropdowns.(DiffTagName).Enable = "off";
    app.drta_Main.DiffDropdowns.(DiffTagName).Tag = DiffTagName;
    %moves the index to the next label location
    CurrentColumn = CurrentColumn + 2;
end
%
% digital channel selection
ColumnLimit = 10;   %initial conditions
CurrentColumn = 1;  %initial conditions
CurrentRow = CurrentRow + 2; %setting analog ch choice on a new row
PlotDigitalGridRow = 2;
PlotDigitalGridColumn = 2;
%
app.drta_Main.ChShown.Labels.Digital = uilabel(app.Channels_GridLayout,'Text',"Digital Channels");
app.drta_Main.ChShown.Labels.Digital.HorizontalAlignment = 'center';
app.drta_Main.ChShown.Labels.Digital.FontSize = 14;
app.drta_Main.ChShown.Labels.Digital.FontName = 'Times New Roman';
app.drta_Main.ChShown.Labels.Digital.Layout.Row = CurrentRow;
app.drta_Main.ChShown.Labels.Digital.Layout.Column = [1 3];
CurrentRow = CurrentRow + 1;
%
for dch = 1:digital_total
    %checking to see if the next row is needed
    if dch > ColumnLimit
        CurrentRow = CurrentRow + 2;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 10;
    end
    if dch == 1
        digitalName1 = sprintf('Trigger');
    elseif dch == 2
        digitalName1 = sprintf('Dig-Input');
    else
        digitalName1 = sprintf('D-%.3d',dch-3);
    end
    %adding a 0 to the number if < 10 and creating a label
    ChTitle = uieditfield(app.Channels_GridLayout);
    ChTitle.Value = digitalName1;
    app.drta_Main.ChannelNames.Digital{dch} = digitalName1;
    %label settings
    
    ChTitle.HorizontalAlignment = 'center';
    ChTitle.FontSize = 14;
    ChTitle.Layout.Row = CurrentRow;
    ChTitle.Layout.Column = CurrentColumn;
    CurrentChNum = sprintf('DigitalCh_label%.3d',dch-1);
    app.drta_Plot.NameField.(CurrentChNum) = ChTitle;
    % creating channel number for indexing
    % if dch < 3
    %     app.drta_Main.ChShown.(digitalName2).Value = 1;
    %     app.drta_Data.p.VisableDigital(dch) = 1;
    % else
    %     app.drta_Main.ChShown.(digitalName2).Value = 0;
    % end
    %creating a checkbox
    if dch == 1
        digitalName2 = sprintf('Trigger');
    elseif dch == 2
        digitalName2 = sprintf('Dig_Input');
    else
        digitalName2 = sprintf('D_%.3d',dch-3);
    end
    app.drta_Main.ChShown.(digitalName2) = uicheckbox(app.Channels_GridLayout);
    %checkbox settings
    app.drta_Main.ChShown.(digitalName2).Layout.Row = CurrentRow;
    app.drta_Main.ChShown.(digitalName2).Layout.Column = CurrentColumn + 1;
    app.drta_Main.ChShown.(digitalName2).Text = {''};
    app.drta_Main.ChShown.(digitalName2).Tag = sprintf('D-%.3d',dch-1);
    app.drta_Main.ChShown.(digitalName2).ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);
    switch dch
        case 1
            if app.drta_Data.draq_d.num_board_dig_in_channels >= 8
                app.drta_Main.ChShown.(digitalName2).Value = 1;
                app.drta_Data.p.VisableChannelDigital(dch) = 1;
            else
                app.drta_Main.ChShown.(digitalName2).Value = 0;
                app.drta_Data.p.VisableChannelDigital(dch) = 0;
            end
        case 2
            app.drta_Main.ChShown.(digitalName2).Value = 1;
            app.drta_Data.p.VisableChannelDigital(dch) = 1;
        
        otherwise
            app.drta_Main.ChShown.(digitalName2).Value = 0;
            app.drta_Data.p.VisableChannelDigital(dch) = 0;
    end
    %moves the index to the next label location
    CurrentColumn = CurrentColumn + 2;
    digitalName3 = sprintf('BitandCh%.3d',dch-1);
    % adding channel choices to digital plot
    if dch < (app.drta_Data.draq_d.num_board_dig_in_channels + 1)
        if dch == 1
            ChAmt = app.drta_Data.draq_d.num_board_dig_in_channels;
            DigRowNeeded = ceil(ChAmt/4) + 1;
            app.DigitalControls_Grid.RowHeight{11} = 30*DigRowNeeded;
            RowVals = repmat({"1x"},1,DigRowNeeded);
            %assigning those values
            app.DigitalSignalUsed_GridLayout.RowHeight = RowVals;
        end
        if PlotDigitalGridColumn == 6
            PlotDigitalGridRow = PlotDigitalGridRow + 1;
            PlotDigitalGridColumn = 2;
        end
        %creating a checkbox used for the bitand calculations
        digitalName1 = sprintf('D-%.3d',dch-1);
        
        app.drta_Main.digitalPlots.(digitalName3) = uicheckbox(app.DigitalSignalUsed_GridLayout);
        %checkbox settings
        
        app.drta_Main.digitalPlots.(digitalName3).Layout.Row = PlotDigitalGridRow;
        app.drta_Main.digitalPlots.(digitalName3).Layout.Column = PlotDigitalGridColumn;
        app.drta_Main.digitalPlots.(digitalName3).Text = {digitalName1};
        %moving to the next column
        PlotDigitalGridColumn = PlotDigitalGridColumn + 1; 
    end
end

% analog channel selection
ColumnLimit = 10;   %initial conditions
CurrentColumn = 1;  %initial conditions
CurrentRow = CurrentRow + 1; %setting analog ch choice on a new row
%
app.drta_Main.ChShown.Labels.Analog = uilabel(app.Channels_GridLayout,'Text',"Analog Channels");
app.drta_Main.ChShown.Labels.Analog.HorizontalAlignment = 'center';
app.drta_Main.ChShown.Labels.Analog.FontSize = 14;
app.drta_Main.ChShown.Labels.Analog.FontName = 'Times New Roman';
app.drta_Main.ChShown.Labels.Analog.Layout.Row = CurrentRow;
app.drta_Main.ChShown.Labels.Analog.Layout.Column = [1 3];
CurrentRow = CurrentRow + 1;
%
for ach = 1:analog_total
    %checking to see if the next row is needed
    if ach > ColumnLimit
        CurrentRow = CurrentRow + 2;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 10;
    end
    if ach < 5
        AnalogName = app.AnalogFigures.CHnames{1,ach};
    else
        AnalogName = sprintf('A-%.3d',ach-4);
    end
    ChTitle = uieditfield(app.Channels_GridLayout);
    ChTitle.Value = AnalogName;
    app.drta_Main.ChannelNames.Analog{ach} = AnalogName;
    %label settings
    ChTitle.HorizontalAlignment = 'center';
    ChTitle.FontSize = 14;
    ChTitle.Layout.Row = CurrentRow;
    ChTitle.Layout.Column = CurrentColumn;
    CurrentChNum = sprintf('AnalogChCB%.3d',ach-1);
    app.drta_Plot.NameField.(CurrentChNum) = ChTitle;
    %creating a checkbox
    app.drta_Main.ChShown.(CurrentChNum) = uicheckbox(app.Channels_GridLayout);
    
    %checkbox settings
    app.drta_Main.ChShown.(CurrentChNum).Layout.Row = CurrentRow;
    app.drta_Main.ChShown.(CurrentChNum).Layout.Column = CurrentColumn + 1;
    app.drta_Main.ChShown.(CurrentChNum).Text = {''};
    app.drta_Main.ChShown.(CurrentChNum).Tag = sprintf('A-%.3d',ach-1);

    app.drta_Main.ChShown.(CurrentChNum).ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);
    %moves the index to the next label location
    app.drta_Main.ChShown.(CurrentChNum).Value = 1;
    app.drta_Data.p.VisableChannelAnalog(ach) = 1;
    CurrentColumn = CurrentColumn + 2;
end



CurrentRow = CurrentRow + 2;
%label settings
app.drta_Main.CombineChannel.clearlabel = uilabel(app.Channels_GridLayout,'Text',"Clear all selected Channels    ");
app.drta_Main.CombineChannel.clearlabel.HorizontalAlignment = 'right';
app.drta_Main.CombineChannel.clearlabel.FontSize = 14;
app.drta_Main.CombineChannel.clearlabel.FontName = 'Times New Roman';
app.drta_Main.CombineChannel.clearlabel.Layout.Row = CurrentRow;
app.drta_Main.CombineChannel.clearlabel.Layout.Column = [1 3];
%adding checkbox for clearing all selected channels
app.drta_Main.CombineChannel.UnselectAll = uicheckbox(app.Channels_GridLayout);
%checkbox settings
app.drta_Main.CombineChannel.UnselectAll.Layout.Row = CurrentRow;
app.drta_Main.CombineChannel.UnselectAll.Layout.Column = 4;
app.drta_Main.CombineChannel.UnselectAll.Text = {''};
app.drta_Main.CombineChannel.UnselectAll.Tag = "SelectNoCh";
app.drta_Main.CombineChannel.UnselectAll.ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);
%label settings for all channels diff
app.drta_Main.CombineChannel.AllChDiff = uilabel(app.Channels_GridLayout,'Text',"Select Diff for all selected channels    ");
app.drta_Main.CombineChannel.AllChDiff.HorizontalAlignment = 'right';
app.drta_Main.CombineChannel.AllChDiff.FontSize = 14;
app.drta_Main.CombineChannel.AllChDiff.FontName = 'Times New Roman';
app.drta_Main.CombineChannel.AllChDiff.Layout.Row = CurrentRow;
app.drta_Main.CombineChannel.AllChDiff.Layout.Column = [5 9];
%adding checkbox for all channels having the same diff
app.drta_Main.CombineChannel.SelectAllDiffDD = uicheckbox(app.Channels_GridLayout);
app.drta_Main.CombineChannel.SelectAllDiffDD.Layout.Row = CurrentRow;
app.drta_Main.CombineChannel.SelectAllDiffDD.Layout.Column = 10;
app.drta_Main.CombineChannel.SelectAllDiffDD.Text = {''};
app.drta_Main.CombineChannel.SelectAllDiffDD.Tag = "DiffForAllCh";
app.drta_Main.CombineChannel.SelectAllDiffDD.ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);
%adding Dropdown menu for all Ch selected diff
app.drta_Main.CombineChannel.AllChDiffDD = uidropdown(app.Channels_GridLayout);
app.drta_Main.CombineChannel.AllChDiffDD.Layout.Row = CurrentRow;
app.drta_Main.CombineChannel.AllChDiffDD.Layout.Column = [11 12];
app.drta_Main.CombineChannel.AllChDiffDD.Items = ChNums;
app.drta_Main.CombineChannel.AllChDiffDD.ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);
app.drta_Main.CombineChannel.AllChDiffDD.Enable = "off";
app.drta_Main.CombineChannel.AllChDiffDD.Tag = "AllChDiff";
%adding label for channel preset dropdown
app.drta_Main.ChannelPreset.DDchoice_label = uilabel(app.Channels_GridLayout,'Text',"Selected channel preset    ");
app.drta_Main.ChannelPreset.DDchoice_label.HorizontalAlignment = 'right';
app.drta_Main.ChannelPreset.DDchoice_label.FontSize = 14;
app.drta_Main.ChannelPreset.DDchoice_label.FontName = 'Times New Roman';
app.drta_Main.ChannelPreset.DDchoice_label.Layout.Row = CurrentRow;
app.drta_Main.ChannelPreset.DDchoice_label.Layout.Column = [13 16];
%adding Dropdown for channel present
app.drta_Main.ChannelPreset.DDchoice = uidropdown(app.Channels_GridLayout);
app.drta_Main.ChannelPreset.DDchoice.Layout.Row = CurrentRow;
app.drta_Main.ChannelPreset.DDchoice.Layout.Column = [17 18];
app.drta_Main.ChannelPreset.DDchoice.Items = "Manual";
app.drta_Main.ChannelPreset.DDchoice.ValueChangedFcn = createCallbackFcn(app,@presetControl, true);
app.drta_Main.ChannelPreset.DDchoice.Tag = "PresetChoice";
%adding load button for channel preset
CurrentRow = CurrentRow + 1;
app.drta_Main.ChannelPreset.LoadButton = uibutton(app.Channels_GridLayout,"push");
app.drta_Main.ChannelPreset.LoadButton.Text = "Load channel preset";
app.drta_Main.ChannelPreset.LoadButton.FontSize = 14;
app.drta_Main.ChannelPreset.LoadButton.FontName = 'Times New Roman';
app.drta_Main.ChannelPreset.LoadButton.Layout.Row = CurrentRow;
app.drta_Main.ChannelPreset.LoadButton.Layout.Column = [1 3];
app.drta_Main.ChannelPreset.LoadButton.ButtonPushedFcn = createCallbackFcn(app,@presetControl, true);
app.drta_Main.ChannelPreset.LoadButton.Tag = "LoadPresetChSelect";
%adding label for checkbox to save current channel selected
app.drta_Main.ChannelPreset.savePreset_label = uilabel(app.Channels_GridLayout,'Text',"Save currently selected presets     ");
app.drta_Main.ChannelPreset.savePreset_label.HorizontalAlignment = 'right';
app.drta_Main.ChannelPreset.savePreset_label.FontSize = 14;
app.drta_Main.ChannelPreset.savePreset_label.FontName = 'Times New Roman';
app.drta_Main.ChannelPreset.savePreset_label.Layout.Row = CurrentRow;
app.drta_Main.ChannelPreset.savePreset_label.Layout.Column = [7 9];
%adding checkbox for saving current channels selected channels
app.drta_Main.ChannelPreset.CBsavePreset = uicheckbox(app.Channels_GridLayout);
app.drta_Main.ChannelPreset.CBsavePreset.Layout.Row = CurrentRow;
app.drta_Main.ChannelPreset.CBsavePreset.Layout.Column = 10;
app.drta_Main.ChannelPreset.CBsavePreset.Text = {''};
app.drta_Main.ChannelPreset.CBsavePreset.Tag = "CBsavePreset";
app.drta_Main.ChannelPreset.CBsavePreset.ValueChangedFcn = createCallbackFcn(app,@presetControl, true);
%adding textbox for file name
app.drta_Main.ChannelPreset.PresestFileName = uieditfield(app.Channels_GridLayout);
app.drta_Main.ChannelPreset.PresestFileName.Layout.Row = CurrentRow;
app.drta_Main.ChannelPreset.PresestFileName.Layout.Column = [11 15];
app.drta_Main.ChannelPreset.PresestFileName.HorizontalAlignment = 'right';
app.drta_Main.ChannelPreset.PresestFileName.FontSize = 14;
app.drta_Main.ChannelPreset.PresestFileName.FontName = 'Times New Roman';
app.drta_Main.ChannelPreset.PresestFileName.ValueChangedFcn = createCallbackFcn(app,@presetControl, true);
app.drta_Main.ChannelPreset.PresestFileName.Tag = "PresetSaveName";
app.drta_Main.ChannelPreset.PresestFileName.Enable = "off";
%adding save channel preset button
app.drta_Main.ChannelPreset.SavePresetButton = uibutton(app.Channels_GridLayout,"push");
app.drta_Main.ChannelPreset.SavePresetButton.Text = "Save preset";
app.drta_Main.ChannelPreset.SavePresetButton.FontSize = 14;
app.drta_Main.ChannelPreset.SavePresetButton.FontName = 'Times New Roman';
app.drta_Main.ChannelPreset.SavePresetButton.Layout.Row = CurrentRow;
app.drta_Main.ChannelPreset.SavePresetButton.Layout.Column = [17 18];
app.drta_Main.ChannelPreset.SavePresetButton.ButtonPushedFcn = createCallbackFcn(app,@presetControl, true);
app.drta_Main.ChannelPreset.SavePresetButton.Tag = "SavePreset";
app.drta_Main.ChannelPreset.SavePresetButton.Enable = "off";

%updating y-range dropdown choices
app.Yrange_DropDown.Items = app.drta_Main.Yrange.DDChoice;

