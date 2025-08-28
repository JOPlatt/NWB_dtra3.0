function DataSet = mspy_ProgramType(app,varargin)

ProcessType = varargin{1};
DataSet = varargin{2};
if app.Flags.SelectCh == 1
    NumCh = sum(DataSet.SelectedCh);
else
    NumCh = DataSet.draq_p.no_spike_ch;
end

switch ProcessType
    case 1 % generates labels
        [FileName,PathName] = uigetfile('*.*','Enter location of keys.dat file');
        fullName=[PathName,FileName];
        fid=fopen(fullName);
        sec_post_trigger=textscan(fid,'%d',1);
        num_keys=textscan(fid,'%d',1);
        key_names=textscan(fid,'%s',num_keys{1});
        fclose(fid);
        for ii=1:num_keys{1}
            DataSet.draq_d.eventlabels{ii}=key_names{1}(ii);
        end
        DataSet.draq_d.nEvPerType=zeros(1,num_keys{1});
        DataSet.draq_d.nEventTypes=num_keys{1};
    case 2 % trial exclusion and create events
        shiftdata = DataSet.shiftdata;
        trialNo = DataSet.TrialsSaved;
        current_ii=1;
        last_event=-10000000;
        while current_ii<length(shiftdata)
            event=find(shiftdata(current_ii:length(shiftdata))>=2+DataSet.p.mspy_key_offset,1,'first');
            if ~isempty(event)
                if current_ii+event-1-last_event>DataSet.p.mspy_key_offset*DataSet.draq_p.ActualRate
                    eventNo=(shiftdata(current_ii+event-1)-DataSet.p.mspy_key_offset)/2;
                    DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                    DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+event/DataSet.draq_p.ActualRate;
                    DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=eventNo;
                    DataSet.draq_d.nEvPerType(eventNo)=DataSet.draq_d.nEvPerType(eventNo)+1;
                    last_evType=eventNo;
                else
                    eventNo=(shiftdata(current_ii+event-1)-DataSet.p.mspy_key_offset)/2;
                    if eventNo~=last_evType
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+event/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=eventNo;
                        DataSet.draq_d.nEvPerType(eventNo)=DataSet.draq_d.nEvPerType(eventNo)+1;
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
    case 3 % setup for block number
        DataSet.draq_d.blocks(1,1)=min(DataSet.draq_d.events)-0.00001;
        DataSet.draq_d.blocks(1,2)=max(DataSet.draq_d.events)+0.00001;
end