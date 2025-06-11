function ChannelSave(app)

if app.Flags.SingleCh == 1
    textUpdate = sprintf('Saving %s\n',app.Ch_DropDown.Value);
else
    textUpdate = sprintf('Saving multiple channels\n');
end
ReadoutUpdate(app,textUpdate)

drta03_GenerateEvents(app,handles);

if app.MClust_CheckBox.Value == 1
    textUpdate = "Generating MClust files, Please wait.";
    ReadoutUpdate(app,textUpdate);
    app.MClust_CheckBox.Enable = "off";
    drta03_GenerateMClust(app);
end