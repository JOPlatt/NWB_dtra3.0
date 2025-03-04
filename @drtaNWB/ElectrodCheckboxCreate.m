function ElectrodCheckboxCreate(app)

%finding the number of channels
channel_total = app.drta_handles.draq_p.no_chans;
%determining how many rows are needed based on only 10 per row
if channel_total > 10
    RowsNeeded = ceil(channel_total/10)*2;
else
    RowsNeeded = 1;
end
% creating a vectore for diff calculation choices
app.drta_Main.ChDiffChoice = zeros([channel_total,1]);
%creating the rows' heights of 25 points
RowVals = num2cell(ones([1,RowsNeeded])*25);
%assigning those values
app.Channels_GridLayout.RowHeight = RowVals;
ColumnLimit = 10;   %initial conditions
CurrentRow = 1; %initial conditions
CurrentColumn = 1;  %initial conditions
%creating each label and check box
app.drta_Main.ChannelNames = {};
for fn = 1:channel_total
    %checking to see if the next row is needed
    if fn > ColumnLimit
        CurrentRow = CurrentRow + 2;
        CurrentColumn = 1;
        ColumnLimit = ColumnLimit + 10;
    end
    %adding a 0 to the number if < 10 and creating a label
    if fn < 10
        ChTitle = uilabel(app.Channels_GridLayout,'Text',append('A-00',num2str(fn-1)));
        app.drta_Main.ChannelNames{fn} = append('A-00',num2str(fn-1));
    elseif fn < 100
        ChTitle = uilabel(app.Channels_GridLayout,'Text',append('A-0',num2str(fn-1)));
        app.drta_Main.ChannelNames{fn} = append('A-0',num2str(fn-1));
    else
        ChTitle = uilabel(app.Channels_GridLayout,'Text',append('A-',num2str(fn-1)));
        app.drta_Main.ChannelNames{fn} = append('A-',num2str(fn-1));
    end
    %label settings
    ChTitle.HorizontalAlignment = 'center';
    ChTitle.FontSize = 14;
    ChTitle.Layout.Row = CurrentRow;
    ChTitle.Layout.Column = CurrentColumn;
    %creating a checkbox
    ChCheckBox = uicheckbox(app.Channels_GridLayout);
    %checkbox settings
    ChCheckBox.Layout.Row = CurrentRow;
    ChCheckBox.Layout.Column = CurrentColumn + 1;
    ChCheckBox.Text = {''};
    if fn < 16
        ChCheckBox.Value = 1;
    else
        ChCheckBox.Value = 0;
    end
    if fn < 11
        ChCheckBox.Tag = append('A-00',num2str(fn-1));
    elseif fn >=11 && fn < 100
        ChCheckBox.Tag = append('A-0',num2str(fn-1));
    else
        ChCheckBox.Tag = append('A-',num2str(fn-1));
    end
    if fn < 11
        DiffTagName = append('DiffA00',num2str(fn-1));
    elseif fn >=11 && fn < 100
        DiffTagName = append('DiffA0',num2str(fn-1));
    else
        DiffTagName = append('DiffA',num2str(fn-1));
    end

    if fn <= 16
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

    end
    %moves the index to the next label location
    CurrentColumn = CurrentColumn + 2;
end
