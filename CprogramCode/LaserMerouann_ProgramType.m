function LaserMerouann_ProgramType(app,varargin)

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
        app.drta_handles.draq_d.nEvPerType=zeros(1,3);
        app.drta_handles.draq_d.nEventTypes=3;
        app.drta_handles.draq_d.eventlabels=cell(1,3);
        app.drta_handles.draq_d.eventlabels{1}='Laser';
        app.drta_handles.draq_d.eventlabels{2}='All';
        app.drta_handles.draq_d.eventlabels{3}='Inter';
    case 2 % trial exclusion
    case 3 % create events
        data = varargin{2};
        trialNo = varargin{3};
        if sum(data(:,18)>(app.drta_handles.draq_d.min_laser+(app.drta_handles.draq_d.max_laser-app.drta_handles.draq_d.min_laser)/2))==0
            %This is an inter trial
            t_start=3*app.drta_handles.draq_p.ActualRate;
            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+t_start/app.drta_handles.draq_p.ActualRate;
            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=3;
            app.drta_handles.draq_d.nEvPerType(3)=app.drta_handles.draq_d.nEvPerType(3)+1;

        else
            %This is a laser trial
            k=find(data(ceil(2.5*app.drta_handles.draq_p.ActualRate):end,18)>(app.drta_handles.draq_d.min_laser+(app.drta_handles.draq_d.max_laser-app.drta_handles.draq_d.min_laser)/2),1,'first');
            t_start=ceil(2.5*app.drta_handles.draq_p.ActualRate)+k-1;
            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+t_start/app.drta_handles.draq_p.ActualRate;
            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=1;
            app.drta_handles.draq_d.nEvPerType(1)=app.drta_handles.draq_d.nEvPerType(1)+1;
        end

        %Enter all trials
        t_start=3*app.drta_handles.draq_p.ActualRate;
        app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
        app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+t_start/app.drta_handles.draq_p.ActualRate;
        app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=2;
        app.drta_handles.draq_d.nEvPerType(2)=app.drta_handles.draq_d.nEvPerType(2)+1;
    case 4 % setup for block number
        app.drta_handles.draq_d.blocks(1,1)=min(app.drta_handles.draq_d.events)-0.00001;
        app.drta_handles.draq_d.blocks(1,2)=max(app.drta_handles.draq_d.events)+0.00001;
end