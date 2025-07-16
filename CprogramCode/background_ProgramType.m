function background_ProgramType(app,varargin)

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
        app.drta_Data.draq_d.nEvPerType=zeros(1,9);
        app.drta_Data.draq_d.nEventTypes=9;
        app.drta_Data.draq_d.eventlabels=cell(1,9);
        app.drta_Data.draq_d.eventlabels{1}='OdorA';
        app.drta_Data.draq_d.eventlabels{2}='OdorB';
        app.drta_Data.draq_d.eventlabels{3}='OdorAB';
        app.drta_Data.draq_d.eventlabels{4}='BkgA';
        app.drta_Data.draq_d.eventlabels{5}='BkgB';
        app.drta_Data.draq_d.eventlabels{6}='OdorBBkgA';
        app.drta_Data.draq_d.eventlabels{7}='OdorABkgB';
        app.drta_Data.draq_d.eventlabels{8}='OdorBBkgB';
        app.drta_Data.draq_d.eventlabels{9}='OdorABkgA';
    case 2 % trial exclusion
        shiftdata = varargin{2};
        trialNo = varargin{3};
        for ii=2:2:18
            t_start=find(shiftdata==ii,1,'first');
            if ~isempty(t_start)
                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+t_start/app.drta_data.draq_p.ActualRate;
                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=ii/2;
                app.drta_data.draq_d.nEvPerType(ii/2)=app.drta_data.draq_d.nEvPerType(ii/2)+1;
            end
        end
    case 3 % create events
    case 4 % setup for block number
        app.drta_Data.draq_d.blocks(1,1)=min(app.drta_Data.draq_d.events)-0.00001;
        app.drta_Data.draq_d.blocks(1,2)=max(app.drta_Data.draq_d.events)+0.00001;
end
