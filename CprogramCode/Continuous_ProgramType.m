function Continuous_ProgramType(app,varargin)

ProcessType = varargin{1};

if app.Flags.SelectCh == 1
    NumCh = size(app.SelectedCh,1);
else
    NumCh = app.drta_Data.draq_p.no_spike_ch;
end

if app.Flags.AllTrials == 1
    TrialCount = app.drta_Data.draq_d.noTrials;
else
    TrialCount = size(app.TrilesExported,1);
end

switch ProcessType
    case 1 % generates labels
        app.drta_Data.draq_d.nEventTypes=2;
        app.drta_Data.draq_d.nEvPerType=zeros(1,2);
        app.drta_Data.draq_d.eventlabels=[];
        app.drta_Data.draq_d.eventlabels{1}='Event1';
        app.drta_Data.draq_d.eventlabels{2}='Event1';
    case 2 % trial exclusion
    case 3 % create events
        trialNo = varargin{2};
        %Event1
        t_start=(3+0.2)*app.drta_Data.draq_p.ActualRate;  %Note: 0.2 is a time pad used for filtering
        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+t_start/app.drta_Data.draq_p.ActualRate;
        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=1;
        app.drta_Data.draq_d.nEvPerType(1)=app.drta_Data.draq_d.nEvPerType(1)+1;

        %Event2
        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+t_start/app.drta_Data.draq_p.ActualRate;
        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=2;
        app.drta_Data.draq_d.nEvPerType(2)=app.drta_Data.draq_d.nEvPerType(2)+1;
    case 4 % setup for block number
        app.drta_Data.draq_d.blocks(1,1)=min(app.drta_Data.draq_d.events)-0.00001;
        app.drta_Data.draq_d.blocks(1,2)=max(app.drta_Data.draq_d.events)+0.00001;
end