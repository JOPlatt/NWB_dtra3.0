function ElectrodCheckboxCreate(app)

%finding the number of channels
channel_total = app.drta_handles.draq_p.no_chans;
%determining how many rows are needed based on only 10 per row
if channel_total > 10
    RowsNeeded = (ceil(channel_total/10)*2) + 1;
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
app.drta_handles.p.VisableChannel = zeros([channel_total,1]);
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
    if fn < 10
        CurrentChNum = append('ChCB00',num2str(fn-1));
    elseif fn < 100
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
        app.drta_handles.p.VisableChannel(fn) = 1;
    else
        app.drta_Main.ChShown.(CurrentChNum).Value = 0;
    end
    if fn < 11
        app.drta_Main.ChShown.(CurrentChNum).Tag = append('A-00',num2str(fn-1));
    elseif fn >=11 && fn < 100
        app.drta_Main.ChShown.(CurrentChNum).Tag = append('A-0',num2str(fn-1));
    else
        app.drta_Main.ChShown.(CurrentChNum).Tag = append('A-',num2str(fn-1));
    end
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

CurrentRow = CurrentRow + 2;

app.drta_Main.CombineChannel.clearlabel = uilabel(app.Channels_GridLayout,'Text',"Clear all selected Channels    ");
%label settings
app.drta_Main.CombineChannel.clearlabel.HorizontalAlignment = 'right';
app.drta_Main.CombineChannel.clearlabel.FontSize = 14;
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
app.drta_Main.CombineChannel.AllChDiff.Layout.Row = CurrentRow;
app.drta_Main.CombineChannel.AllChDiff.Layout.Column = [5 9];
%adding checkbox for all channels having the same diff
app.drta_Main.CombineChannel.SelectAllDiffDD = uicheckbox(app.Channels_GridLayout);
%checkbox settings
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

