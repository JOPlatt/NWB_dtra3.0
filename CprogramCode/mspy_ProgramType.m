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
        [FileName,PathName] = uigetfile('*.*','Enter location of keys.dat file');
        fullName=[PathName,FileName];
        fid=fopen(fullName);
        sec_post_trigger=textscan(fid,'%d',1);
        num_keys=textscan(fid,'%d',1);
        key_names=textscan(fid,'%s',num_keys{1});
        fclose(fid)
        for ii=1:num_keys{1}
            app.drta_Data.draq_d.eventlabels{ii}=key_names{1}(ii);
        end
        app.drta_Data.draq_d.nEvPerType=zeros(1,num_keys{1});
        app.drta_Data.draq_d.nEventTypes=num_keys{1};
    case 2 % trial exclusion
    case 3 % create events
        shiftdata = varargin{2};
        trialNo = varargin{3};
        current_ii=1;
        last_event=-10000000;
        while current_ii<length(shiftdata)
            event=find(shiftdata(current_ii:length(shiftdata))>=2+app.drta_Data.p.mspy_key_offset,1,'first');
            if ~isempty(event)
                if current_ii+event-1-last_event>app.drta_Data.p.mspy_key_offset*app.drta_Data.draq_p.ActualRate
                    eventNo=(shiftdata(current_ii+event-1)-app.drta_Data.p.mspy_key_offset)/2;
                    app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                    app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+event/app.drta_Data.draq_p.ActualRate;
                    app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=eventNo;
                    app.drta_Data.draq_d.nEvPerType(eventNo)=app.drta_Data.draq_d.nEvPerType(eventNo)+1;
                    last_evType=eventNo;
                else
                    eventNo=(shiftdata(current_ii+event-1)-app.drta_Data.p.mspy_key_offset)/2;
                    if eventNo~=last_evType
                        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+event/app.drta_Data.draq_p.ActualRate;
                        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=eventNo;
                        app.drta_Data.draq_d.nEvPerType(eventNo)=app.drta_Data.draq_d.nEvPerType(eventNo)+1;
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