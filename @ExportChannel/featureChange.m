function featureChange(app,process)

switch process
    case 1
        selectedButton = app.Channel_ButtonGroup.SelectedObject;
        switch selectedButton
            case 'this' % single Ch
                app.Ch_DropDown.Visible = "on";
                app.Ch_DropDown.Enable = "on";
                app.IncludeCh_EditField.Visible = "off";
                app.IncludeCh_EditField.Enable = "off";
            case 'that' % multiple Ch
                app.Ch_DropDown.Visible = "off";
                app.Ch_DropDown.Enable = "off";
                app.IncludeCh_EditField.Visible = "on";
                app.IncludeCh_EditField.Enable = "on";
        end
    case 2
        selectedButton = app.Trial_ButtonGroup.SelectedObject;
        switch selectedButton
            case 'this'
                app.SelectTrials_Label.Visible = "off";
            case 'that'
                app.SelectTrials_Label.Visible = "on";
        end
end

