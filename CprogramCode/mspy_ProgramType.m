function mspy_ProgramType(app,varargin)

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
    case 2 % trial exclusion
    case 3 % create events
        shiftdata = varargin{2};
        trialNo = varargin{3};
        current_ii=1;
        last_event=-10000000;
        while current_ii<length(shiftdata)
            event=find(shiftdata(current_ii:length(shiftdata))>=2+app.drta_handles.p.mspy_key_offset,1,'first');
            if ~isempty(event)
                if current_ii+event-1-last_event>app.drta_handles.p.mspy_key_offset*app.drta_handles.draq_p.ActualRate
                    eventNo=(shiftdata(current_ii+event-1)-app.drta_handles.p.mspy_key_offset)/2;
                    app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                    app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+event/app.drta_handles.draq_p.ActualRate;
                    app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=eventNo;
                    app.drta_handles.draq_d.nEvPerType(eventNo)=app.drta_handles.draq_d.nEvPerType(eventNo)+1;
                    last_evType=eventNo;
                else
                    eventNo=(shiftdata(current_ii+event-1)-app.drta_handles.p.mspy_key_offset)/2;
                    if eventNo~=last_evType
                        app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                        app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+event/app.drta_handles.draq_p.ActualRate;
                        app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=eventNo;
                        app.drta_handles.draq_d.nEvPerType(eventNo)=app.drta_handles.draq_d.nEvPerType(eventNo)+1;
                        last_evType=eventNo;
                    end
                end
                event=find(shiftdata(current_ii:length(shiftdata))==shiftdata(current_ii+event-1),1,'last');
                current_ii=current_ii+event;
                last_event=current_ii;

            else
                current_ii=length(shiftdata);
            end

        end
    case 4 % setup for block number
        handles.draq_d.blocks(1,1)=min(handles.draq_d.events)-0.00001;
        handles.draq_d.blocks(1,2)=max(handles.draq_d.events)+0.00001;
end