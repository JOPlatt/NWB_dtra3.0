function DataSet =  lighton1_ProgramType(app,varargin)

ProcessType = varargin{1};
DataSet = varargin{2};
if app.Flags.SelectCh == 1
    NumCh = sum(DataSet.SelectedCh);
else
    NumCh = DataSet.draq_p.no_spike_ch;
end

switch ProcessType
    case 1 % generates labels
        DataSet.draq_d.nEvPerType=zeros(1,2);
        DataSet.draq_d.nEventTypes=2;
        DataSet.draq_d.eventlabels=cell(1,2);
        
        DataSet.draq_d.eventlabels{1}='LightOn';
        DataSet.draq_d.eventlabels{2}='LightOn';
    case 2 % trial exclusion
        trialNo = DataSet.TrialsSaved;
        digidata= DataSet.AlogData(:,5);

        %This is a bit safer way to get min and max
        minmin_y=min(digidata);
        maxmax_y=max(digidata);
        max_y=mean(digidata(digidata>(minmin_y+(maxmax_y-minmin_y)/2)));
        min_y=mean(digidata(digidata<(minmin_y+(maxmax_y-minmin_y)/2)));

        if (max_y-min_y)>200
            timeBefore=str2double(get(DataSet.timeBeforeFV,'String'));
            firstLightOn=find(digidata>(min_y+(max_y-min_y)/2),1,'first')/DataSet.draq_p.ActualRate;
            if firstLightOn<timeBefore
                DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
                DataSet.p.trial_allch_processed(trialNo)=0;
            end
        else
            DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            DataSet.p.trial_allch_processed(trialNo)=0;
        end
        %create events
        %This is a bit safer way to get min and max
        minmin_y=min(digidata);
        maxmax_y=max(digidata);
        max_y=mean(digidata(digidata>(minmin_y+(maxmax_y-minmin_y)/2)));
        min_y=mean(digidata(digidata<(minmin_y+(maxmax_y-minmin_y)/2)));

        bad_trial=0;

        if (max_y-min_y)>200
            firstdig=find(digidata>min_y+0.5*(max_y-min_y),1,'first');
            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+firstdig/DataSet.draq_p.ActualRate;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=1;
            DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;


            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+firstdig/DataSet.draq_p.ActualRate;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
            DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;
        else
            bad_trial=1;
        end  %if (max_y-min_y)>200

        if bad_trial==1
            %It is extremely important, every single trial must have an
            %accompanying t_start and odor_on

            %First exclude this weird trial
            DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            DataSet.p.trial_allch_processed(trialNo)=0;

            %Then add this one
            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+2;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=1;
            DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;

            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+2;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
            DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;
        end
    case 3 % setup for block number
        DataSet.draq_d.blocks(1,1)=DataSet.draq_d.t_trial(1)-9;
        DataSet.draq_d.blocks(1,2)=DataSet.draq_d.t_trial(end)+9;
end