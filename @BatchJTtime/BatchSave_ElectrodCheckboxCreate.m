function BatchSave_ElectrodCheckboxCreate(app)


%finding the number of channels
channel_total = app.drta_Data.draq_d.num_amplifier_channels;
digital_total = app.drta_Data.draq_d.num_board_dig_in_channels + 2;
analog_total = app.drta_Data.draq_d.num_board_adc_channels;
%determining how many rows are needed based on only 10 per row
if channel_total > 10
    RowsNeeded = (ceil(channel_total/5)*2) + 8;
    RowsNeeded = RowsNeeded + (ceil(digital_total/5)*2);
    RowsNeeded = RowsNeeded + (ceil(analog_total/5)*2);
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
ColumnLimit = 5;   %initial conditions
CurrentRow = 1; %initial conditions
CurrentColumn = 1;  %initial conditions
%creating each label and check box
app.drta_Main.ChannelNames = {};
app.drta_Data.p.VisableChannel = zeros([channel_total,1]);
app.drta_Data.p.VisableDigital = zeros([digital_total,1]);
app.drta_Data.p.VisableAnalog = ones([analog_total,1]);
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
        CurrentRow = CurrentRow + 1;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 5;
    end
    %adding a 0 to the number if < 10 and creating a label
    ChTitle = uilabel(app.Channels_GridLayout,'Text',sprintf('E-%.3d',fn-1));
    app.drta_Main.ChannelNames.Electrode{fn} = sprintf('A-%.3d',fn-1);
    %label settings
    ChTitle.HorizontalAlignment = 'center';
    ChTitle.FontSize = 14;
    ChTitle.Layout.Row = CurrentRow;
    ChTitle.Layout.Column = CurrentColumn;
    CurrentChNum = sprintf('ChCB%.3d',fn-1);
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
    % app.drta_Main.ChShown.(CurrentChNum).ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);
    %moves the index to the next label location
    CurrentColumn = CurrentColumn + 2;
end
%
% digital channel selection
ColumnLimit = 5;   %initial conditions
CurrentColumn = 1;  %initial conditions
CurrentRow = CurrentRow + 1; %setting analog ch choice on a new row
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
        CurrentRow = CurrentRow + 1;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 5;
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
    if dch == 1
        digitalName2 = sprintf('Trigger');
    elseif dch == 2
        digitalName2 = sprintf('Dig_Input');
    else
        digitalName2 = sprintf('D_%.3d',dch-3);
    end
    ChTitle.HorizontalAlignment = 'center';
    ChTitle.FontSize = 14;
    ChTitle.Layout.Row = CurrentRow;
    ChTitle.Layout.Column = CurrentColumn;

    % creating channel number for indexing
    if dch < 3
        app.drta_Main.ChShown.(digitalName2).Value = 1;
        app.drta_Data.p.VisableDigital(dch) = 1;
    else
        app.drta_Main.ChShown.(digitalName2).Value = 0;
    end
    %creating a checkbox
    app.drta_Main.ChShown.(digitalName2) = uicheckbox(app.Channels_GridLayout);
    %checkbox settings
    app.drta_Main.ChShown.(digitalName2).Layout.Row = CurrentRow;
    app.drta_Main.ChShown.(digitalName2).Layout.Column = CurrentColumn + 1;
    app.drta_Main.ChShown.(digitalName2).Text = {''};
    app.drta_Main.ChShown.(digitalName2).Tag = sprintf('D-%.3d',dch-1);
    % app.drta_Main.ChShown.(digitalName2).ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);
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
    %moving to the next column
    CurrentColumn = CurrentColumn + 2;
end


% analog channel selection
ColumnLimit = 5;   %initial conditions
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
        CurrentRow = CurrentRow + 1;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 5;
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
    app.drta_Main.NameField.(CurrentChNum) = ChTitle;
    %creating a checkbox
    app.drta_Main.ChShown.(CurrentChNum) = uicheckbox(app.Channels_GridLayout);

    %checkbox settings
    app.drta_Main.ChShown.(CurrentChNum).Layout.Row = CurrentRow;
    app.drta_Main.ChShown.(CurrentChNum).Layout.Column = CurrentColumn + 1;
    app.drta_Main.ChShown.(CurrentChNum).Text = {''};
    app.drta_Main.ChShown.(CurrentChNum).Tag = sprintf('A-%.3d',ach-1);

    % app.drta_Main.ChShown.(CurrentChNum).ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);
    %moves the index to the next label location
    app.drta_Main.ChShown.(CurrentChNum).Value = 1;
    app.drta_Data.p.VisableChannelAnalog(ach) = 1;
    CurrentColumn = CurrentColumn + 2;
end

CurrentRow = CurrentRow + 1;
ChTitle = uilabel(app.Channels_GridLayout,'Text',sprintf('Trials Saved'));
%label settings
ChTitle.HorizontalAlignment = 'center';
ChTitle.FontSize = 14;
ChTitle.Layout.Row = CurrentRow;
ChTitle.Layout.Column = 1;
app.drta_Main.ChShown.TrialLabel = ChTitle;
% Trial Starting index
ChTitle = uilabel(app.Channels_GridLayout,'Text',sprintf('Inital Trial'));
%label settings
ChTitle.HorizontalAlignment = 'center';
ChTitle.FontSize = 14;
ChTitle.Layout.Row = CurrentRow;
ChTitle.Layout.Column = [2 3];
app.drta_Main.ChShown.InitialTrialLabel = ChTitle;
%
ChTitle = uieditfield(app.Channels_GridLayout,"numeric");
ChTitle.Value = 1;
ChTitle.Limits = [1,(app.drta_Data.draq_d.noTrials-1)];
ChTitle.HorizontalAlignment = 'center';
ChTitle.FontSize = 14;
ChTitle.Layout.Row = CurrentRow;
ChTitle.Layout.Column = [4 5];
app.drta_Main.ChShown.InitialTrialAmt = ChTitle;
% Trial Ending index
ChTitle = uilabel(app.Channels_GridLayout,'Text',sprintf('Final Trial'));
%label settings
ChTitle.HorizontalAlignment = 'center';
ChTitle.FontSize = 14;
ChTitle.Layout.Row = CurrentRow;
ChTitle.Layout.Column = [6 7];
app.drta_Main.ChShown.FinalTrialLabel = ChTitle;
%
ChTitle = uieditfield(app.Channels_GridLayout,"numeric");
maxIndex = size(app.drta_Data.draq_d.t_trial);
ChTitle.Value = maxIndex(2);
ChTitle.Limits = [1,app.drta_Data.draq_d.noTrials];
ChTitle.HorizontalAlignment = 'center';
ChTitle.FontSize = 14;
ChTitle.Layout.Row = CurrentRow;
ChTitle.Layout.Column = [8 9];
app.drta_Main.ChShown.FinalTrialAmt = ChTitle;
%Bitand values
GridMk = uigridlayout(app.Channels_GridLayout);
GridMk.Layout.Row = [CurrentRow+1 CurrentRow+2];
GridMk.Layout.Column = [1 10];
GridMk.RowHeight = {25 25};
GridMk.RowSpacing = 1;
GridMk.ColumnWidth = {100 100 100 100 100};
GridMk.ColumnSpacing = 1;
app.drta_Main.ChShown.BitandGrid = GridMk;
%bitand label
ChTitle = uilabel(app.drta_Main.ChShown.BitandGrid,'Text',sprintf('Bitand Settings:'));
%label settings
ChTitle.HorizontalAlignment = 'center';
ChTitle.FontSize = 12;
ChTitle.Layout.Row = 1;
ChTitle.Layout.Column = 1;
app.drta_Main.ChShown.BirandLabel = ChTitle;
Bitands = [0 1 2 4 6 8 16 32 64];
BitPresests = [0 0 1 1 1 1 1 0 0];
bitcolumn = 2;
bitrow = 1;
for bit = 1:width(Bitands)
    dch = Bitands(bit);
    if bitcolumn == 6
        bitcolumn = 1;
        bitrow = 2;
    end
    %creating a checkbox used for the bitand calculations
    digitalName1 = sprintf('Bitand-%.2d',dch);
    digitalName2 = sprintf('bitand_%.2d',dch);
    app.drta_Main.digitalBitand.(digitalName2) = uicheckbox(app.drta_Main.ChShown.BitandGrid);
    %checkbox settings
    app.drta_Main.digitalBitand.(digitalName2).Layout.Row = bitrow;
    app.drta_Main.digitalBitand.(digitalName2).Layout.Column = bitcolumn;
    app.drta_Main.digitalBitand.(digitalName2).Text = {digitalName1};
    app.drta_Main.digitalBitand.(digitalName2).Value = BitPresests(bit);
    bitcolumn = bitcolumn + 1;
end
CurrentRow = CurrentRow+3;
%Preset value grid layout
GridPS = uigridlayout(app.Channels_GridLayout);
GridPS.Layout.Row = [CurrentRow CurrentRow+1];
GridPS.Layout.Column = [1 10];
GridPS.RowHeight = {25};
GridPS.RowSpacing = 1;
GridPS.ColumnWidth = {150 250 '1x'};
GridPS.ColumnSpacing = 1;
app.drta_Main.PresetValues.PresetGridlayout = GridPS;
%Preset button
app.drta_Main.PresetValues.LoadButton = uibutton(app.drta_Main.PresetValues.PresetGridlayout,"push");
app.drta_Main.PresetValues.LoadButton.Text = "Load channel preset";
app.drta_Main.PresetValues.LoadButton.FontSize = 14;
app.drta_Main.PresetValues.LoadButton.FontName = 'Times New Roman';
app.drta_Main.PresetValues.LoadButton.Layout.Row = 1;
app.drta_Main.PresetValues.LoadButton.Layout.Column = 1;
app.drta_Main.PresetValues.LoadButton.ButtonPushedFcn = createCallbackFcn(app,@BatchPresetControl, true);
app.drta_Main.PresetValues.LoadButton.Tag = "LoadPresetSelect";
%Preset text field
app.drta_Main.PresetValues.Preset_label = uilabel(app.drta_Main.PresetValues.PresetGridlayout,'Text',"No file Loaded");
app.drta_Main.PresetValues.Preset_label.HorizontalAlignment = 'Center';
app.drta_Main.PresetValues.Preset_label.FontSize = 14;
app.drta_Main.PresetValues.Preset_label.FontName = 'Times New Roman';
app.drta_Main.PresetValues.Preset_label.Layout.Row = 1;
app.drta_Main.PresetValues.Preset_label.Layout.Column = 2;