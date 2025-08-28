function AddDigitalPlot(app,event)
%{
This function is used to add additional plot names to the digitial plot
field.
%}

if ischar(event)
    %adds plot name to dropdown and to the drta_Main.digitalPlots struct
    app.drta_Main.digitalPlots.(event).prefilled = false;
    app.DigitalChChoice_DropDown.Items(1,end+1) = {event};
    digitalDDprefill(app,event);

else

    if isempty(app.AddedPlotName_EditField.Value)
        msgbox(sprintf('Missing additional plot name!!'));
    elseif any(contains(app.AddedPlotName_EditField.Value,app.drta_Main.digitalPlots.plotNames))
        msgbox(sprintf('This name is already in use.'));
    else
        NewName = app.AddedPlotName_EditField.Value;
        hasSpace = isspace(NewName);
        hasCamma = contains(NewName,',');
        if sum(hasSpace) ~= 0
            NewName(hasSpace) = '_';
        end
        if hasCamma == 1
            NewName = replace(NewName,',','_');
        end
        app.drta_Main.digitalPlots.(NewName).prefilled = false;
        app.DigitalChChoice_DropDown.Items(1,end+1) = {NewName};
        digitalDDprefill(app,NewName);
        % place to add the next row for the select Ch and Data Save
        AddDigitalChoice(app);
        app.drta_Main.digitalPlots.plotNames(end+1) = {app.AddedPlotName_EditField.Value};
        
    end
    %add error message that plot name needs to be added

end
