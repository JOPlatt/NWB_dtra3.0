function AddDigitalChoice(app)

disp('holding point')

NewName = app.AddedPlotName_EditField.Value;
NumCBDig = size(app.drta_Main.digitalPlots.plotNames,2)-1;

if contains(app.drta_Main.digitalPlots.plotNames{NumCBDig},'Digital')
    tempName = app.drta_Main.digitalPlots.plotNames{NumCBDig};
    DigNum = str2double(tempName(end-2:end));
    lastNameUsed = sprintf('D_%.3d',DigNum);
else
    lastNameUsed = app.drta_Main.digitalPlots.plotNames{NumCBDig};
end
CurrentRow = app.drta_Main.ChShown.D_007.Layout.Row; %(app.drta_Main.digitalPlots.plotNames{lastNameUsed})
if NumCBDig >= 10
    CurrentRow = CurrentRow + 1;
    % moving all other rows and adding another row to the gridlayout
    app.Channels_GridLayout.RowHeight{end+1} = app.Channels_GridLayout.RowHeight{end};
    app.Channels_GridLayout.RowHeight{end-1} = 25;
    controlNames = fieldnames(app.drta_Main.ChannelPreset);
    for ii = size(controlNames,1):-1:1
        itemMoved = controlNames{ii};
        app.drta_Main.ChannelPreset.(itemMoved).Layout.Row = app.drta_Main.ChannelPreset.(itemMoved).Layout.Row + 1;
    end
    controlNames = fieldnames(app.drta_Main.CombineChannel);
    for ii = size(controlNames,1):-1:1
        itemMoved = controlNames{ii};
        app.drta_Main.CombineChannel.(itemMoved).Layout.Row = app.drta_Main.CombineChannel.(itemMoved).Layout.Row + 1;
    end
    analogNames = fieldnames(app.drta_Plot.NameField);
    onlyanalog = contains(analogNames,'Analog');
    analogNames = analogNames(onlyanalog);
    for ii = size(analogNames,1):-1:1
        app.drta_Plot.NameField.(analogNames{ii}).Layout.Row = app.drta_Plot.NameField.(analogNames{ii}).Layout.Row + 1;
        app.drta_Main.ChShown.(analogNames{ii}).Layout.Row = app.drta_Main.ChShown.(analogNames{ii}).Layout.Row + 1;
    end
    app.drta_Main.ChShown.Labels.Analog.Layout.Row = app.drta_Main.ChShown.Labels.Analog.Layout.Row + 1;
end
% finding the current column
CurrentColumn = app.drta_Main.ChShown.D_007.Layout.Column;
if CurrentColumn == 20
    CurrentColumn = 1;
else
    CurrentColumn = CurrentColumn + 1;
end
%adding a 0 to the number if < 10 and creating a label
ChTitle = uieditfield(app.Channels_GridLayout);
ChTitle.Value = NewName;
app.drta_Main.ChannelNames.Digital{end+1} = NewName;
%label settings


ChTitle.HorizontalAlignment = 'center';
ChTitle.FontSize = 14;
ChTitle.Layout.Row = CurrentRow;
ChTitle.Layout.Column = CurrentColumn;
digNames = fieldnames(app.drta_Plot.NameField);
digOnly = contains(digNames,'Digital');
digNames = digNames(digOnly);
lastDigName = digNames{end};
lastDigNum = str2double(lastDigName(end-2:end));
digitalName2 = sprintf('DigitalCh%.3d',lastDigNum+1);
app.drta_Plot.NameField.(digitalName2) = ChTitle;
% creating channel number for indexing
app.drta_Main.ChShown.(NewName).Value = 1;
app.drta_Data.p.VisableDigital(end+1) = 1;

%creating a checkbox
app.drta_Main.ChShown.(NewName) = uicheckbox(app.Channels_GridLayout);
%checkbox settings
app.drta_Main.ChShown.(NewName).Value = 1;
app.drta_Main.ChShown.(NewName).Layout.Row = CurrentRow;
app.drta_Main.ChShown.(NewName).Layout.Column = CurrentColumn + 1;
app.drta_Main.ChShown.(NewName).Text = {''};
app.drta_Main.ChShown.(NewName).Tag = sprintf('D-%.3d',NumCBDig+1);
app.drta_Main.ChShown.(NewName).ValueChangedFcn = createCallbackFcn(app,@AllChControl, true);

%adding new checkbox to the save tab


