function actualTrialNo = setTrialNo(app,trialNo)
sztrials=size(app.drta_handles.draq_d.t_trial);
actualTrialNo=trialNo;
if (trialNo<1)
    actualTrialNo=1;
    app.drta_handles.p.trialNo=1;
end

if (trialNo>sztrials(2))
    actualTrialNo=sztrials(2);
    app.drta_handles.p.trialNo=sztrials(2);
end

if (trialNo>=1)&&(trialNo<=sztrials(2))
    actualTrialNo=trialNo;
    app.drta_handles.p.trialNo=trialNo;
end

