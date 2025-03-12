function ShowingDiffCheckbox(app)
fNames = fieldnames(app.drta_Main.DiffDropdowns);
if app.Diff_CheckBox.Value == 1
    Vchoice = "on";
else
    Vchoice = "off";
    ChoiceNum = size(app.drta_Main.ChDiffChoice,1);
    app.drta_Main.ChDiffChoice = zeros([ChoiceNum,1]);
end
for ii = 1:size(fNames,1)
    if app.drta_handles.p.VisableChannel(ii) == 1
        app.drta_Main.DiffDropdowns.(fNames{ii}).Enable = Vchoice;
    end
    if Vchoice == "off"
        app.drta_Main.DiffDropdowns.(fNames{ii}).Value = 'None';
    end
end