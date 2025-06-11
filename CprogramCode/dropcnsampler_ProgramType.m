function dropcnsampler_ProgramType(app,varargin)

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
        %This is a dg file
        app.drta_data.draq_d.nEventTypes=2;
        app.drta_data.draq_d.eventlabels=[];
        app.drta_data.draq_d.eventlabels{1}='FinalValve';
        app.drta_data.draq_d.eventlabels{2}='OdorOn';
        %Find which odors were used
        app.drta_data.dropc_nsamp_odors=[];
        ii_dropc_nsamp_odors=0;
        % FV_interval=0;
        app.drta_data.dropc_nsamp_odorNo=[];
        for trialNo=1:TrialCount
            if ~isfield(app.drta_data,'drtachoices')
                disp(trialNo);
            end
            tic

            if app.Flags.AllTrials == 0
                currentTrial = app.TrialsExported(trialNo);
            else
                currentTrial = trialNo;
            end

            app.drta_data.p.trialNo=currentTrial;
            data=drtaNWB_GetTraceData(app.drta_data);

            digi = data(:,end-1);
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
                            app.drta_data.odor_ii(trialNo)=first_odor_ii;
                            % FV_interval=first_odor_ii-first_not_zero_ii;
                            app.drta_data.exclude_trial(trialNo)=0;
                            app.drta_data.dropc_nsamp_odorNo(trialNo)=odorNo;
                            %need to ask about this
                            if ~any(app.drta_data.dropc_nsamp_odors==odorNo, "all")
                                ii_dropc_nsamp_odors=ii_dropc_nsamp_odors+1;
                                app.drta_data.dropc_nsamp_odors(ii_dropc_nsamp_odors)=odorNo;
                            end
                        end
                    end

                    if found_odor==0
                        %This is odor 4?
                        %If there are at least 2 sec left this is indeed
                        %odor 4
                        first_four_ii=find(shiftdat==4,1,'first');
                        if ((length(shiftdat)-first_four_ii)/app.drta_data.draq_p.ActualRate)>=1.99
                            ii_dropc_nsamp_odors=ii_dropc_nsamp_odors+1;
                            app.drta_data.dropc_nsamp_odors(ii_dropc_nsamp_odors)=4;
                            app.drta_data.dropc_nsamp_odorNo(trialNo)=4;
                            app.drta_data.exclude_trial(trialNo)=0;
                            app.drta_data.odor_ii(trialNo)=first_four_ii+1*app.drta_data.draq_p.ActualRate;
                        else
                            app.drta_data.exclude_trial(trialNo)=1;
                        end
                    end

                else
                    %This may be a phantom odor, or a trial to be discarded
                    if first_not_zero==16
                        %Phantom odor
                        app.drta_data.exclude_trial(trialNo)=0;
                        app.drta_data.dropc_nsamp_odorNo(trialNo)=-1;
                    else
                        %Exclude this trial
                        app.drta_data.exclude_trial(trialNo)=1;
                    end
                end

            else
                %Exclude this trial
                app.drta_data.exclude_trial(trialNo)=1;
            end
            %             figure(1)
            %             plot(shiftdat)
        end
        app.drta_data.dropc_nsamp_odors=sort(app.drta_data.dropc_nsamp_odors);

        for jj=1:length(app.drta_data.dropc_nsamp_odors)
            app.drta_data.draq_d.nEventTypes=app.drta_data.draq_d.nEventTypes+1;
            app.drta_data.draq_d.eventlabels{app.drta_data.draq_d.nEventTypes}=['Odor' num2str(app.drta_data.dropc_nsamp_odors(jj))];
        end

        app.drta_data.draq_d.nEventTypes=app.drta_data.draq_d.nEventTypes+1;
        app.drta_data.draq_d.eventlabels{app.drta_data.draq_d.nEventTypes}='Phantom';
        app.drta_data.draq_d.nEvPerType=zeros(1,app.drta_data.draq_d.nEventTypes);
    case 2 % trial exclusion
        trialNo = varargin{2};
        shift_dropc_nsampler = varargin{3};
        shiftdata = varargin{4};

        if app.drta_data.exclude_trial(trialNo)==1

            app.drta_data.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            app.drta_data.p.trial_allch_processed(trialNo)=0;
        end

        try
            timeBefore=str2double(get(app.drta_data.timeBeforeFV,'String'));
        catch
            timeBefore=app.drta_data.time_before_FV;
        end
        firstFV=(find(shift_dropc_nsampler>0,1,'first')/app.drta_data.draq_p.ActualRate);

        if firstFV<timeBefore
            app.drta_data.exclude_trial(trialNo)=1;
            app.drta_data.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            app.drta_data.p.trial_allch_processed(trialNo)=0;
        end

        firstFVii=find(shift_dropc_nsampler>0,1,'first');
        pointsleft=length(shiftdata)-(firstFVii+3*app.drta_data.draq_p.ActualRate);

        if(pointsleft<1)
            app.drta_data.exclude_trial(trialNo)=1;
            app.drta_data.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            app.drta_data.p.trial_allch_processed(trialNo)=0;
        end
    case 3 % create events
        trialNo = varargin{2};
        shift_dropc_nsampler = varargin{3};

        if app.drta_data.exclude_trial(trialNo)~=1

            %Is this phantom?
            if app.drta_data.dropc_nsamp_odorNo(trialNo)==-1
                %Yes, phantom
                first_phantom_ii=find(shift_dropc_nsampler==16,1,'first');

                %Phantom final valve
                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=(app.drta_data.draq_d.t_trial(trialNo)+(first_phantom_ii/app.drta_data.draq_p.ActualRate)-1);
                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=1;
                app.drta_data.draq_d.nEvPerType(1)=app.drta_data.draq_d.nEvPerType(1)+1;

                %Phantom odorOn
                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=(app.drta_data.draq_d.t_trial(trialNo)+(first_phantom_ii/app.drta_data.draq_p.ActualRate));
                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=2;
                app.drta_data.draq_d.nEvPerType(2)=app.drta_data.draq_d.nEvPerType(2)+1;

                %Phantom odor
                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=(app.drta_data.draq_d.t_trial(trialNo)+(first_phantom_ii/app.drta_data.draq_p.ActualRate));
                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.nEventTypes;
                app.drta_data.draq_d.nEvPerType(app.drta_data.draq_d.nEventTypes)=app.drta_data.draq_d.nEvPerType(app.drta_data.draq_d.nEventTypes)+1;

            else
                %This is an odor

                %Final valve
                first_FV_ii=find(shift_dropc_nsampler==4,1,'first');
                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=(app.drta_data.draq_d.t_trial(trialNo)+(first_FV_ii/app.drta_data.draq_p.ActualRate)-1);
                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=1;
                app.drta_data.draq_d.nEvPerType(1)=app.drta_data.draq_d.nEvPerType(1)+1;

                %Phantom odorOn
                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=(app.drta_data.draq_d.t_trial(trialNo)+(app.drta_data.odor_ii(trialNo)/app.drta_data.draq_p.ActualRate));
                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=2;
                app.drta_data.draq_d.nEvPerType(2)=app.drta_data.draq_d.nEvPerType(2)+1;

                %odor
                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=(app.drta_data.draq_d.t_trial(trialNo)+(app.drta_data.odor_ii(trialNo)/app.drta_data.draq_p.ActualRate));
                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=find(app.drta_data.dropc_nsamp_odors==app.drta_data.dropc_nsamp_odorNo(trialNo))+2;
                app.drta_data.draq_d.nEvPerType(find(app.drta_data.dropc_nsamp_odorNo(trialNo))+2)=app.drta_data.draq_d.nEvPerType(find(app.drta_data.dropc_nsamp_odorNo(trialNo))+2)+1;

            end

        end
    case 4 % setup for block number
        app.drta_data.draq_d.blocks(1,1)=min(app.drta_data.draq_d.events)-0.00001;
        app.drta_data.draq_d.blocks(1,2)=max(app.drta_data.draq_d.events)+0.00001;

end
