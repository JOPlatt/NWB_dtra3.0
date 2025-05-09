function PlotStatusUpdate(app,textUpdate,WhichOne)

%{
This function adds to the output display
%}
textUpdate = string(textUpdate);

Text_size = length(textUpdate);
if WhichOne == 1
    OTsize = length(app.LFPOutputText);
    if Text_size == 1
        app.LFPOutputText((OTsize(1)+1),1) = textUpdate;
    else
        app.LFPOutputText((OTsize(1)+1):(OTsize(1)+Text_size),1) = textUpdate;
    end
    app.StatusLFP_TextArea.Value = app.LFPOutputText;
    scroll(app.StatusLFP_TextArea,'bottom');
elseif WhichOne == 2
    OTsize = length(app.DiffOutputText);
    if Text_size == 1
        app.DiffOutputText((OTsize(1)+1),1) = textUpdate;
    else
        app.DiffOutputText((OTsize(1)+1):(OTsize(1)+Text_size),1) = textUpdate;
    end
    app.StatusDiff_TextArea.Value = app.DiffOutputText;
    scroll(app.StatusDiff_TextArea,'bottom');
elseif WhichOne == 3
    OTsize = length(app.PIDOutputText);
    if Text_size == 1
        app.PIDOutputText((OTsize(1)+1),1) = textUpdate;
    else
        app.PIDOutputText((OTsize(1)+1):(OTsize(1)+Text_size),1) = textUpdate;
    end
    app.PIDupdate_TextArea.Value = app.PIDOutputText;
    scroll(app.PIDupdate_TextArea,'bottom');
end
pause(0.1);