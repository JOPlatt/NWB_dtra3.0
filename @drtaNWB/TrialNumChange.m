function TrialNumChange(app,event)

switch event.Source.Tag
    case "TnumMinus"
        newTrial= app.drta_handles.p.trialNo-1;
    case "TnumPlus"
        newTrial=app.drta_handles.p.trialNo+1;
    case "TnumField"
        newTrial = app.Tnum_amt.Value;
    case "DigTnumField"
        newTrial = app.TrialNoDigit_EditField.Value;
    case "PIDnumField"
        newTrial = app.PIDtrial_EditField.Value;
end

app.drta_handles.p.trialNo = setTrialNo(app, newTrial);
app.Tnum_amt.Value = app.drta_handles.p.trialNo;
app.TrialNoDigit_EditField.Value = app.drta_handles.p.trialNo;
if app.PID_CheckBox.Value == 1
    app.PIDtrial_EditField.Value = app.drta_handles.p.trialNo;
end
% VarUpdate(app,"trialNo",app.drta_handles.p.trialNo)