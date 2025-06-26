function Laser_Schoppa_ProgramType(app,varargin)

ProcessType = varargin{1};

if app.Flags.SelectCh == 1
    NumCh = size(app.SelectedCh,1);
else
    NumCh = app.drta_data.draq_p.no_spike_ch;
end

if app.Flags.AllTrials == 1
    TrialCount = app.drta_data.draq_d.noTrials;
else
    TrialCount = size(app.TrilesExported,1);
end

switch ProcessType
    case 1 % generates labels
        app.drta_handles.draq_d.nEvPerType=zeros(1,2);
        app.drta_handles.draq_d.nEventTypes=2;
        app.drta_handles.draq_d.eventlabels=cell(1,2);
        
        app.drta_handles.draq_d.eventlabels{1}='LightOn';
        app.drta_handles.draq_d.eventlabels{2}='LightOn';
    case 2 % trial exclusion
    case 3 % create events
        shiftdata = varargin{2};
        trialNo = varargin{3};
        firstdig=find(shiftdata==26,1,'first');
        app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
        app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+firstdig/app.drta_handles.draq_p.ActualRate;
        app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=1;
        app.drta_handles.draq_d.nEvPerType(1)=app.drta_handles.draq_d.nEvPerType(1)+1;


        app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
        app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+firstdig/app.drta_handles.draq_p.ActualRate;
        app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=2;
        app.drta_handles.draq_d.nEvPerType(2)=app.drta_handles.draq_d.nEvPerType(2)+1;

    case 4 % setup for block number
        app.drta_handles.draq_d.blocks(1,1)=app.drta_handles.draq_d.t_trial(1)-9;
        app.drta_handles.draq_d.blocks(1,2)=app.drta_handles.draq_d.t_trial(end)+9;
end
