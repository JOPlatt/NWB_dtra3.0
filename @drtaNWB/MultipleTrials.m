function MultipleTrials(app,~)

if app.drta_Save.ChannelPreset.MoreTrials.Value == 1
    app.drta_Save.TrialIndex.Midposition.Visible = "on";
    app.drta_Save.TrialIndex.ENposition.Visible = "on";
else
    app.drta_Save.TrialIndex.Midposition.Visible = "off";
    app.drta_Save.TrialIndex.ENposition.Visible = "off";
end
