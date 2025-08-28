function DataSet = dropcnsampler_ProgramType(app,varargin)
%{


%}

ProcessType = varargin{1};
DataSet = varargin{2};
if app.Flags.SelectCh == 1
    NumCh = sum(DataSet.SelectedCh);
else
    NumCh = DataSet.draq_p.no_spike_ch;
end

switch ProcessType
    case 1 % generates labels
        %This is a dg file
        DataSet.draq_d.nEventTypes=2;
        DataSet.draq_d.eventlabels=[];
        DataSet.draq_d.eventlabels{1}='FinalValve';
        DataSet.draq_d.eventlabels{2}='OdorOn';
        %Find which odors were used
        DataSet.dropc_nsamp_odors=[];
        DataSet.ii_dropc_nsamp_odors=0;
        % FV_interval=0;
        DataSet.dropc_nsamp_odorNo=[];

    case 2 % trial exclusion
        trialNo = DataSet.TrialsSaved;
        digi = DataSet.Signals.Digital(:,2); % need to make sure this is the correct channel
        shiftdat=bitand(digi,1+2+4+8+16+32);

        %For some reason the first trial is incorrect and has a 63 in
        %it
        shiftdat=shiftdat(shiftdat<63);

        %Find the vaule of the first number different from zero
        first_not_zero_ii=find(shiftdat>0,1,'first');

        if ~isempty(first_not_zero_ii)

            first_not_zero=shiftdat(first_not_zero_ii);

            if first_not_zero==4

                %This is an odor, find which odor
                found_odor=0;
                for odorNo=[1 2 8 16 32]
                    first_odor_ii=find(shiftdat==odorNo,1,'first');
                    if ~isempty(first_odor_ii)
                        found_odor=1;
                        DataSet.odor_ii(trialNo)=first_odor_ii;
                        % FV_interval=first_odor_ii-first_not_zero_ii;
                        DataSet.exclude_trial(trialNo)=0;
                        DataSet.dropc_nsamp_odorNo(trialNo)=odorNo;
                        %need to ask about this
                        if ~any(DataSet.dropc_nsamp_odors==odorNo, "all")
                            DataSet.ii_dropc_nsamp_odors=DataSet.ii_dropc_nsamp_odors+1;
                            DataSet.dropc_nsamp_odors(DataSet.ii_dropc_nsamp_odors)=odorNo;
                        end
                    end
                end

                if found_odor==0
                    %This is odor 4?
                    %If there are at least 2 sec left this is indeed
                    %odor 4
                    first_four_ii=find(shiftdat==4,1,'first');
                    if ((length(shiftdat)-first_four_ii)/DataSet.draq_p.ActualRate)>=1.99
                        DataSet.ii_dropc_nsamp_odors=DataSet.ii_dropc_nsamp_odors+1;
                        DataSet.dropc_nsamp_odors(DataSet.ii_dropc_nsamp_odors)=4;
                        DataSet.dropc_nsamp_odorNo(trialNo)=4;
                        DataSet.exclude_trial(trialNo)=0;
                        DataSet.odor_ii(trialNo)=first_four_ii+1*DataSet.draq_p.ActualRate;
                    else
                        DataSet.exclude_trial(trialNo)=1;
                    end
                end

            else
                %This may be a phantom odor, or a trial to be discarded
                if first_not_zero==16
                    %Phantom odor
                    DataSet.exclude_trial(trialNo)=0;
                    DataSet.dropc_nsamp_odorNo(trialNo)=-1;
                else
                    %Exclude this trial
                    DataSet.exclude_trial(trialNo)=1;
                end
            end

        else
            %Exclude this trial
            DataSet.exclude_trial(trialNo)=1;
        end
        %             figure(1)
        %             plot(shiftdat)

        DataSet.dropc_nsamp_odors=sort(DataSet.dropc_nsamp_odors);

        for jj=1:length(DataSet.dropc_nsamp_odors)
            DataSet.draq_d.nEventTypes=DataSet.draq_d.nEventTypes+1;
            DataSet.draq_d.eventlabels{DataSet.draq_d.nEventTypes}=['Odor' num2str(DataSet.dropc_nsamp_odors(jj))];
        end

        DataSet.draq_d.nEventTypes=DataSet.draq_d.nEventTypes+1;
        DataSet.draq_d.eventlabels{DataSet.draq_d.nEventTypes}='Phantom';
        DataSet.draq_d.nEvPerType=zeros(1,DataSet.draq_d.nEventTypes);

        shift_dropc_nsampler = DataSet.dropCsamples;
        shiftdata = DataSet.shiftdata;

        if DataSet.exclude_trial(trialNo)==1

            DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            DataSet.p.trial_allch_processed(trialNo)=0;
        end

        % try
        %     timeBefore=str2double(get(DataSet.timeBeforeFV,'String'));
        % catch
        %     timeBefore=DataSet.time_before_FV;
        % end
        % firstFV=(find(shift_dropc_nsampler>0,1,'first')/DataSet.draq_p.ActualRate);
        %
        % if firstFV<timeBefore
        %     DataSet.exclude_trial(trialNo)=1;
        %     DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
        %     DataSet.p.trial_allch_processed(trialNo)=0;
        % end

        firstFVii=find(shift_dropc_nsampler>0,1,'first');
        pointsleft=length(shiftdata)-(firstFVii+3*DataSet.draq_p.ActualRate);

        if(pointsleft<1)
            DataSet.exclude_trial(trialNo)=1;
            DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            DataSet.p.trial_allch_processed(trialNo)=0;
        end

        if DataSet.exclude_trial(trialNo)~=1

            %Is this phantom?
            if DataSet.dropc_nsamp_odorNo(trialNo)==-1
                %Yes, phantom
                first_phantom_ii=find(shift_dropc_nsampler==16,1,'first');

                %Phantom final valve
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=(DataSet.draq_d.t_trial(trialNo)+(first_phantom_ii/DataSet.draq_p.ActualRate)-1);
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=1;
                DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;

                %Phantom odorOn
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=(DataSet.draq_d.t_trial(trialNo)+(first_phantom_ii/DataSet.draq_p.ActualRate));
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
                DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;

                %Phantom odor
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=(DataSet.draq_d.t_trial(trialNo)+(first_phantom_ii/DataSet.draq_p.ActualRate));
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=DataSet.draq_d.nEventTypes;
                DataSet.draq_d.nEvPerType(DataSet.draq_d.nEventTypes)=DataSet.draq_d.nEvPerType(DataSet.draq_d.nEventTypes)+1;

            else
                %This is an odor

                %Final valve
                first_FV_ii=find(shift_dropc_nsampler==4,1,'first');
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=(DataSet.draq_d.t_trial(trialNo)+(first_FV_ii/DataSet.draq_p.ActualRate)-1);
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=1;
                DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;

                %Phantom odorOn
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=(DataSet.draq_d.t_trial(trialNo)+(DataSet.odor_ii(trialNo)/DataSet.draq_p.ActualRate));
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
                DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;

                %odor
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=(DataSet.draq_d.t_trial(trialNo)+(DataSet.odor_ii(trialNo)/DataSet.draq_p.ActualRate));
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=find(DataSet.dropc_nsamp_odors==DataSet.dropc_nsamp_odorNo(trialNo))+2;
                DataSet.draq_d.nEvPerType(find(DataSet.dropc_nsamp_odorNo(trialNo))+2)=DataSet.draq_d.nEvPerType(find(DataSet.dropc_nsamp_odorNo(trialNo))+2)+1;

            end

        end
    case 3 % setup for block number
        DataSet.draq_d.blocks(1,1)=min(DataSet.draq_d.events)-0.00001;
        DataSet.draq_d.blocks(1,2)=max(DataSet.draq_d.events)+0.00001;

end
