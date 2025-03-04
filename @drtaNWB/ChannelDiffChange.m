function ChannelDiffChange(app,event)

tagName = event.Source.Tag;
ChNum = str2double(tagName(end-2:end));

switch event.Source.Value
    case 'None'
        app.drta_Main.ChDiffChoice(ChNum+1) = 0;
    case 'Tet'
        app.drta_Main.ChDiffChoice(ChNum+1) = 1;
    case 'Avg'
        app.drta_Main.ChDiffChoice(ChNum+1) = 2;
    otherwise
        app.drta_Main.ChDiffChoice(ChNum+1) = 3+str2double(event.Source.Value);
end


