function ElectrodCheckboxCreate(app)

%finding the number of channels
channel_total = app.drta_handles.draq_p.no_chans;
%determining how many rows are needed based on only 10 per row
if channel_total > 10
    RowsNeeded = ceil(channel_total/10)*2;
else
    RowsNeeded = 1;
end
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
    if fn < 11
        ChTitle = uilabel(app.Channels_GridLayout,'Text',append('A-00',num2str(fn-1)));
        app.drta_Main.ChannelNames{fn} = append('A-00',num2str(fn-1));
    elseif fn < 101
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
    elseif fn < 101
        ChCheckBox.Tag = append('A-0',num2str(fn-1));
    else
        ChCheckBox.Tag = append('A-',num2str(fn-1));
    end
    %creating dropdown diff menu
    DiffDropMenu = uidropdown(app.Channels_GridLayout);
    %dropdown settings
    ChNums = cell([1 channel_total+3]);
    for ww = 1:channel_total
        ChNums{ww} = char(num2str(ww));
    end
    ChNums{ww+1} = 'Tet';
    ChNums{ww+2} = 'Avg';
    ChNums{ww+3} = 'No';
    DiffDropMenu.Layout.Row = CurrentRow + 1;
    DiffDropMenu.Layout.Column = CurrentColumn;
    DiffDropMenu.Items = ChNums;

    %moves the index to the next label location
    CurrentColumn = CurrentColumn + 2;
end