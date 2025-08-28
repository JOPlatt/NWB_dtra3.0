function DataSet = spm2mult_ProgramType(app,varargin)

ProcessType = varargin{1};
DataSet = varargin{2};
if app.Flags.SelectCh == 1
    NumCh = sum(DataSet.SelectedCh);
else
    NumCh = DataSet.draq_p.no_spike_ch;
end

switch ProcessType
    case 1 % generates labels
        prompt = {'Enter the number of odors used as S+:'};
        dlg_title = 'Input for spm2mult';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_splus_odors=str2double(answer{1});
        DataSet.draq_d.nsp_odors = num_splus_odors;

        prompt = {'Enter the number of odors used as S-:'};
        dlg_title = 'Input for spm2mult';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_sminus_odors=str2double(answer{1});

        num_spmult_odors=num_sminus_odors+num_splus_odors;

        DataSet.draq_d.nEvPerType=zeros(1,3+num_spmult_odors*3);
        DataSet.draq_d.nEventTypes=3+num_spmult_odors*3;
        DataSet.draq_d.eventlabels=cell(1,3+num_spmult_odors*3);
        DataSet.draq_d.eventlabels{1}='TStart';
        DataSet.draq_d.eventlabels{2}='OdorOn';
        DataSet.draq_d.eventlabels{3}='Reinf';

        for odNum=1:num_splus_odors
            DataSet.draq_d.eventlabels{3+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S+'];
            DataSet.draq_d.eventlabels{3+3*(odNum-1)+2}=['Odor' num2str(odNum) '-Hit'];
            DataSet.draq_d.eventlabels{3+3*(odNum-1)+3}=['Odor' num2str(odNum) '-Miss'];
        end

        for odNum=num_splus_odors+1:num_spmult_odors
            DataSet.draq_d.eventlabels{3+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S-'];
            DataSet.draq_d.eventlabels{3+3*(odNum-1)+2}=['Odor' num2str(odNum) '-CR'];
            DataSet.draq_d.eventlabels{3+3*(odNum-1)+3}=['Odor' num2str(odNum) '-FA'];
        end
    case 2 % trial exclusion and create events
        shiftdata = DataSet.shiftdata;
        trialNo = DataSet.TrialsSaved;
        %Find trial start time (event 1)
        %Note: This is the same as FINAL_VALVE
        t_start=find(shiftdata==6,1,'first');
        if ~isempty(t_start)
            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+t_start/DataSet.draq_p.ActualRate;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=1;
            DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;
        else
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
        end

        %Find odor on (event 2)
        odor_on=find(shiftdata==18,1,'first');
        found_odor_on=0;
        if ~isempty(odor_on)
            found_odor_on=1;
            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
            DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;
        else
            %It is extremely important, every single trial must have an
            %accompanying t_start and odor_on

            %First exclude this weird trial
            DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            DataSet.p.trial_allch_processed(trialNo)=0;

            %Then add this one
            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+2;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
            DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(2)+1;
        end

        %Find Hit and S+
        hits=find(shiftdata==8,1,'first');
        if ~isempty(hits)

            %Determine the odor number
            for ii=20:2:64
                t_odor=find(shiftdata==ii,1,'first');
                if ~isempty(t_odor)
                    odNum=(ii-18)/2;
                    break;
                end
            end

            %Hit (event 3+3*(odNum-1)+2)
            if (found_odor_on==1)
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3+3*(odNum-1)+2;
                DataSet.draq_d.nEvPerType(3+3*(odNum-1)+2)=DataSet.draq_d.nEvPerType(3+3*(odNum-1)+2)+1;
            end

            %S+ (event 3+3*(odNum-1)+1)
            if (found_odor_on==1)
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3+3*(odNum-1)+1;
                DataSet.draq_d.nEvPerType(3+3*(odNum-1)+1)=DataSet.draq_d.nEvPerType(3+3*(odNum-1)+1)+1;
            end

        end

        %Find Miss and S+

        miss=find(shiftdata==10,1,'first');
        if ~isempty(miss)

            %Determine the odor number
            for ii=20:2:64
                t_odor=find(shiftdata==ii,1,'first');
                if ~isempty(t_odor)
                    odNum=(ii-18)/2;
                    break;
                end
            end

            %Miss (event 3+3*(odNum-1)+3)
            if (found_odor_on==1)
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3+3*(odNum-1)+3;
                DataSet.draq_d.nEvPerType(3+3*(odNum-1)+3)=DataSet.draq_d.nEvPerType(3+3*(odNum-1)+3)+1;
            end

            %S+ (event 3+3*(odNum-1)+1)
            if (found_odor_on==1)
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3+3*(odNum-1)+1;
                DataSet.draq_d.nEvPerType(3+3*(odNum-1)+1)=DataSet.draq_d.nEvPerType(3+3*(odNum-1)+1)+1;
            end
        end

        %Find CR and S-

        crej=find(shiftdata==12,1,'first');
        if ~isempty(crej)

            %Determine the odor number
            for ii=20:2:64
                t_odor=find(shiftdata==ii,1,'first');
                if ~isempty(t_odor)
                    odNum=(ii-18)/2;
                    break;
                end
            end

            %CR (event 3+3*(odNum-1)+2)
            if (found_odor_on==1)
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3+3*(odNum-1)+2;
                DataSet.draq_d.nEvPerType(3+3*(odNum-1)+2)=DataSet.draq_d.nEvPerType(3+3*(odNum-1)+2)+1;
            end

            %S- (event 3+3*(odNum-1)+1)
            if (found_odor_on==1)
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3+3*(odNum-1)+1;
                DataSet.draq_d.nEvPerType(3+3*(odNum-1)+1)=DataSet.draq_d.nEvPerType(3+3*(odNum-1)+1)+1;
            end


        end

        %Find FA and S-
        false_alarm=find(shiftdata==14,1,'first');
        if ~isempty(false_alarm)

            %Determine the odor number
            for ii=20:2:64
                t_odor=find(shiftdata==ii,1,'first');
                if ~isempty(t_odor)
                    odNum=(ii-18)/2;
                    break;
                end
            end

            %FA (event 3+3*(odNum-1)+3)
            if (found_odor_on==1)
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3+3*(odNum-1)+3;
                DataSet.draq_d.nEvPerType(3+3*(odNum-1)+3)=DataSet.draq_d.nEvPerType(3+3*(odNum-1)+3)+1;
            end

            %S- (event 3+3*(odNum-1)+1)
            if (found_odor_on==1)
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3+3*(odNum-1)+1;
                DataSet.draq_d.nEvPerType(3+3*(odNum-1)+1)=DataSet.draq_d.nEvPerType(3+3*(odNum-1)+1)+1;
            end

        end

        %Find reinforcement (event 3)
        reinf=find(shiftdata==16,1,'first');
        if ~isempty(reinf)
            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+reinf/DataSet.draq_p.ActualRate;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3;
            DataSet.draq_d.nEvPerType(3)=DataSet.draq_d.nEvPerType(3)+1;
        end
    case 3 % setup for block number
        DataSet.draq_d.blocks(1,1)=min(DataSet.draq_d.events)-0.00001;
        DataSet.draq_d.blocks(1,2)=max(DataSet.draq_d.events)+0.00001;
end