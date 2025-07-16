function TrialNumChange(app,event)

switch event.Source.Tag
    case "TnumMinus"
        newTrial= app.drta_Data.p.trialNo-1;
    case "TnumPlus"
        newTrial=app.drta_Data.p.trialNo+1;
    case "TnumField"
        newTrial = app.Tnum_amt.Value;
    case "DigTnumField"
        newTrial = app.TrialNoDigit_EditField.Value;
    case "AnalognumField"
        newTrial = app.Analogtrial_EditField.Value;
end

app.drta_Data.p.trialNo = setTrialNo(app, newTrial);
app.Tnum_amt.Value = app.drta_Data.p.trialNo;
app.TrialNoDigit_EditField.Value = app.drta_Data.p.trialNo;
app.Analogtrial_EditField.Value = app.drta_Data.p.trialNo;

% VarUpdate(app,"trialNo",app.drta_Data.p.trialNo)