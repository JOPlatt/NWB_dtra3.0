function AllChControl(app,event)

tagName = event.Source.Tag;
if contains(tagName,'E-')
    tagName = 'SingleCh';
elseif contains(tagName,'D-')
    tagName = 'DigitalCh';
elseif contains(tagName,'A-')
    tagName = 'AnalogCh';
end
switch tagName
    case 'SelectNoCh'
        AllChnames = fieldnames(app.drta_Main.ChShown);
        fNames = fieldnames(app.drta_Main.DiffDropdowns);
        for ii = 1:size(AllChnames,1)
            app.drta_Main.ChShown.(AllChnames{ii}).Value = 0;
            app.drta_Data.p.VisableChannel(ii) = 0;
            app.drta_Main.CombineChannel.UnselectAll.Value = 0;
            app.drta_Main.DiffDropdowns.(fNames{ii}).Enable = 0;
        end
    case 'DiffForAllCh'
        if event.Source.Value == 1
            ShowingDD = 0;
            app.drta_Main.CombineChannel.AllChDiffDD.Enable = 1;
        else
            ShowingDD = 1;
            app.drta_Main.CombineChannel.AllChDiffDD.Enable = 0;
        end
        AllDiffNames = fieldnames(app.drta_Main.DiffDropdowns);
        for ii = 1:size(AllDiffNames,1)
            if app.drta_Data.p.VisableChannel(ii) == 1
                app.drta_Main.DiffDropdowns.(AllDiffNames{ii}).Enable = ShowingDD;
            end
        end
    case 'AllChDiff'
        AllDiffNames = fieldnames(app.drta_Main.DiffDropdowns);
        for ii = 1:size(app.drta_Data.p.VisableChannel,1)
            if app.drta_Data.p.VisableChannel(ii) == 1
                OneCh.Source.Tag = app.drta_Main.DiffDropdowns.(AllDiffNames{ii}).Tag;
                app.drta_Main.DiffDropdowns.(AllDiffNames{ii}).Value = event.Source.Value;
                OneCh.Source.Value = event.Source.Value;
                ChannelDiffChange(app,OneCh);
            end
        end
        
    case 'SingleCh'
        OneChTag = event.Source.Tag;
        Chnum = str2double(OneChTag(end-2:end));
        app.drta_Data.p.VisableChannel(Chnum+1) = event.Source.Value;
        fNames = fieldnames(app.drta_Main.DiffDropdowns);
        if app.Diff_CheckBox.Value == 1 && event.Source.Value == 1
            app.drta_Main.DiffDropdowns.(fNames{Chnum+1}).Enable = 1;
        else
            app.drta_Main.DiffDropdowns.(fNames{Chnum+1}).Enable = 0;
        end
    case 'PresetCh'
        AllChnames = fieldnames(app.drta_Main.ChShown);
        fNames = fieldnames(app.drta_Main.DiffDropdowns);
        for ii = 1:size(AllChnames,1)
            if app.drta_Data.p.VisableChannel(ii) == 1
                app.drta_Main.ChShown.(AllChnames{ii}).Value = 1;
                app.drta_Main.DiffDropdowns.(fNames{ii}).Enable = 1;
            else
                app.drta_Main.ChShown.(AllChnames{ii}).Value = 0;
                app.drta_Main.DiffDropdowns.(fNames{ii}).Enable = 0;
            end
        end
    case 'DigitalCh'
        OneChTag = event.Source.Tag;
        Chnum = str2double(OneChTag(end-2:end));
        app.drta_Data.p.VisableDigital(Chnum+1) = event.Source.Value;
        fNames = fieldnames(app.drta_Main.DiffDropdowns);
        if app.Diff_CheckBox.Value == 1 && event.Source.Value == 1
            app.drta_Main.DiffDropdowns.(fNames{Chnum+1}).Enable = 1;
        else
            app.drta_Main.DiffDropdowns.(fNames{Chnum+1}).Enable = 0;
        end
        if app.DigitalFigures.FiguresBuild == 1
            delete(app.DigitalPlot_Grid.Children);
            app.DigitalFigures.FiguresBuild = 0;
        end
    case 'AnalogCh'
        OneChTag = event.Source.Tag;
        Chnum = str2double(OneChTag(end-2:end));
        app.drta_Data.p.VisableAnalog(Chnum+1) = event.Source.Value;
        if app.AnalogFigures.FiguresBuild == 1
            delete(app.AnalogFigure_GridLayout.Children);
            app.AnalogFigures.FiguresBuild = 0;
        end
end

%need to test out switching on and off analog and digital ch using the
%checkboxes, remove PID checkbox, need to add limits for each ch shown

