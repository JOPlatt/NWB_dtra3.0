function dropcspm_conc_ProgramType(app,varargin)

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
        % trialNo = varargin{2};
        % shiftdata30 = varargin{3};
        %I fixed the problems in drta_read_Intan_RHD2000_header, this should be OK

        %             timeBefore=str2double(get(app.drta_handles.timeBeforeFV,'String'));
        %             firstFV=find(shift_dropc_nsampler==1,1,'first')/app.drta_handles.draq_p.ActualRate;
        %
        %             if firstFV<timeBefore
        %                 app.drta_handles.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
        %                 app.drta_handles.p.trial_allch_processed(trialNo)=0;
        %             end
        %
        %             this_odor_on=find(shift_dropc_nsampler>1,1,'first');
        %             pointsleft=216000-(this_odor_on+3*app.drta_handles.draq_p.ActualRate);
        %
        %             if(pointsleft<1)
        %                 app.drta_handles.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
        %                 app.drta_handles.p.trial_allch_processed(trialNo)=0;
        %                 trialNo
        %                 pointsleft
        %             end
    case 3 % create events
        %All the labels without the "E" suffix are assigned the time at
        %odor on
        trialNo = varargin{2};
        shift_dropc_nsampler = varargin{3};

        if ~isempty(find(shift_dropc_nsampler>=1,1,'first'))
            %This is an odor trial or a short

            if length(find(shift_dropc_nsampler>=1))<3*app.drta_handles.draq_p.ActualRate
                %This is a short
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                t_start=find(shift_dropc_nsampler>=1,1,'first');
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+t_start/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=22;
                app.drta_handles.draq_d.nEvPerType(22)=app.drta_handles.draq_d.nEvPerType(22)+1;
            else
                %Find trial start time (event 1)
                %Note: This is the same as FINAL_VALVE


                if sum(shift_dropc_nsampler==1)>0.9*app.drta_handles.draq_p.ActualRate
                    t_start=find(shift_dropc_nsampler==1,1,'first');
                    app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                    app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+t_start/app.drta_handles.draq_p.ActualRate;
                    app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=1;
                    app.drta_handles.draq_d.nEvPerType(1)=app.drta_handles.draq_d.nEvPerType(1)+1;
                else
                    %It is extremely important, every single trial must have an
                    %accompanying t_start and odor_on

                    %First exclude this weird trial
                    app.drta_handles.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
                    app.drta_handles.p.trial_allch_processed(trialNo)=0;

                    %Then add it to the list as a short
                    app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                    app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+2;
                    app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=22;
                    app.drta_handles.draq_d.nEvPerType(1)=app.drta_handles.draq_d.nEvPerType(1)+1;

                end


                if exist('t_start')~=0
                    %Find odor on (event 2)
                    found_odor_on=0;
                    %Note, odor on must be longer than 2.4 sec and must take place after final
                    %valve when shift_dropc_nsampler==1
                    if (sum((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7))>2.4*app.drta_handles.draq_p.ActualRate)&...
                            ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
                        %                         odor_on=find((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7),1,'first');
                        odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
                        found_odor_on=1;
                        app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                        app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                        app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=2;
                        app.drta_handles.draq_d.nEvPerType(2)=app.drta_handles.draq_d.nEvPerType(2)+1;
                    else
                        %It is extremely important, every single trial must have an
                        %accompanying t_start followed by an odor_on

                        %First exclude this weird trial
                        app.drta_handles.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
                        app.drta_handles.p.trial_allch_processed(trialNo)=0;

                        %Then add it to the list as a short
                        app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                        app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+2;
                        app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=22;
                        app.drta_handles.draq_d.nEvPerType(2)=app.drta_handles.draq_d.nEvPerType(2)+1;
                    end

                    %Now do processing only if odor on was found
                    if (found_odor_on==1)
                        %Find Hit (event 3), HitE (event 4), S+ (event 5) and S+E
                        %(event 6)

                        if sum(shift_dropc_nsampler==8)>0.05*app.drta_handles.draq_p.ActualRate
                            hits=t_start+find(shift_dropc_nsampler(t_start:end)==8,1,'first');
                            if generate_dio_bits==1
                                dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                                shiftvec=bitshift( bitand(uint16(dio_bits(:,trialNo)),248), -2);
                                fv=shiftvec==6;
                                dio_bits(:,trialNo)=dio_bits(:,trialNo)+fv;
                            end

                            %Hit (event 3)

                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=3;
                            app.drta_handles.draq_d.nEvPerType(3)=app.drta_handles.draq_d.nEvPerType(3)+1;


                            %HitE (event 4)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+hits/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=4;
                            app.drta_handles.draq_d.nEvPerType(4)=app.drta_handles.draq_d.nEvPerType(4)+1;

                            %S+ (event 5)

                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=5;
                            app.drta_handles.draq_d.nEvPerType(5)=app.drta_handles.draq_d.nEvPerType(5)+1;


                            %S+E (event 6)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+hits/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=6;
                            app.drta_handles.draq_d.nEvPerType(6)=app.drta_handles.draq_d.nEvPerType(6)+1;

                        end

                        %Find Miss (event 7), MissE (event 8), S+ (event 5) and S+E
                        %(event 6)


                        if sum(shift_dropc_nsampler==10)>0.05*app.drta_handles.draq_p.ActualRate
                            miss=t_start+find(shift_dropc_nsampler(t_start:end)==10,1,'first');
                            if generate_dio_bits==1
                                dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                                shiftvec=bitshift( bitand(uint16(dio_bits(:,trialNo)),248), -2);
                                fv=shiftvec==6;
                                dio_bits(:,trialNo)=dio_bits(:,trialNo)+fv;
                            end

                            %Miss (event 7)

                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=7;
                            app.drta_handles.draq_d.nEvPerType(7)=app.drta_handles.draq_d.nEvPerType(7)+1;


                            %MissE
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+miss/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=8;
                            app.drta_handles.draq_d.nEvPerType(8)=app.drta_handles.draq_d.nEvPerType(8)+1;

                            %S+ (event 5)

                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=5;
                            app.drta_handles.draq_d.nEvPerType(5)=app.drta_handles.draq_d.nEvPerType(5)+1;


                            %S+E (event 6)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+miss/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=6;
                            app.drta_handles.draq_d.nEvPerType(6)=app.drta_handles.draq_d.nEvPerType(6)+1;

                        end

                        %Find CR (event 9), CRE (event 10), S- (event 11) and S-E
                        %(event 12)

                        if sum(shift_dropc_nsampler==12)>0.05*app.drta_handles.draq_p.ActualRate
                            crej=t_start+find(shift_dropc_nsampler(t_start:end)==12,1,'first');
                            if generate_dio_bits==1
                                dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                            end

                            %CR (event 9)

                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=9;
                            app.drta_handles.draq_d.nEvPerType(9)=app.drta_handles.draq_d.nEvPerType(9)+1;


                            %CRE (event 10)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+crej/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=10;
                            app.drta_handles.draq_d.nEvPerType(10)=app.drta_handles.draq_d.nEvPerType(10)+1;

                            %S- (event 11)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=11;
                            app.drta_handles.draq_d.nEvPerType(11)=app.drta_handles.draq_d.nEvPerType(11)+1;


                            %S-E (event 12)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+crej/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=12;
                            app.drta_handles.draq_d.nEvPerType(12)=app.drta_handles.draq_d.nEvPerType(12)+1;

                        end

                        %Find FA (event 13), FAE (event 14), S- (event 11) and S-E
                        %(event 12)

                        if sum(shift_dropc_nsampler(t_start:end)==14)>0.05*app.drta_handles.draq_p.ActualRate
                            false_alarm=t_start+find(shift_dropc_nsampler(t_start:end)==14,1,'first');
                            if generate_dio_bits==1
                                dio_bits(:,trialNo)=dio_bits(:,trialNo)-1;
                            end

                            %FA (event 13)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=13;
                            app.drta_handles.draq_d.nEvPerType(13)=app.drta_handles.draq_d.nEvPerType(13)+1;


                            %FAE
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+false_alarm/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=14;
                            app.drta_handles.draq_d.nEvPerType(14)=app.drta_handles.draq_d.nEvPerType(14)+1;

                            %S- (event 11)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=11;
                            app.drta_handles.draq_d.nEvPerType(11)=app.drta_handles.draq_d.nEvPerType(11)+1;

                            %S-E (event 12)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+false_alarm/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=12;
                            app.drta_handles.draq_d.nEvPerType(12)=app.drta_handles.draq_d.nEvPerType(12)+1;
                        end

                        %Find reinforcement (event 15)
                        if sum(shift_dropc_nsampler==32)>0.02*app.drta_handles.draq_p.ActualRate
                            reinf=t_start+find(shift_dropc_nsampler(t_start:end)==32,1,'first');
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+reinf/app.drta_handles.draq_p.ActualRate;
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=15;
                            app.drta_handles.draq_d.nEvPerType(15)=app.drta_handles.draq_d.nEvPerType(15)+1;
                        end


                        %Find which odor concentration this is
                        this_odor=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first');
                        if ~isempty(this_odor)
                            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                            this_odor_evNo=shift_dropc_nsampler(this_odor);
                            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=15+this_odor_evNo-1;
                            app.drta_handles.draq_d.nEvPerType(15+this_odor_evNo-1)=app.drta_handles.draq_d.nEvPerType(15+this_odor_evNo-1)+1;
                        end
                    end

                else
                    %This is an intermediate trial
                    app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                    app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+(length(shift_dropc_nsampler)/3)/app.drta_handles.draq_p.ActualRate;
                    app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=23;
                    app.drta_handles.draq_d.nEvPerType(23)=app.drta_handles.draq_d.nEvPerType(23)+1;
                end
            end



        else
            %This is an intermediate trial
            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+(length(shift_dropc_nsampler)/3)/app.drta_handles.draq_p.ActualRate;
            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=23;
            app.drta_handles.draq_d.nEvPerType(23)=app.drta_handles.draq_d.nEvPerType(23)+1;
        end

        % This code is here for troubleshooting
        %             figure(10)
        %             plot(shift_dropc_nsampler)
        %             pffft=1;
    case 4 % setup for block number
        indxOdorOn=find(strcmp('OdorOn',app.drta_handles.draq_d.eventlabels));
        evenTypeIndxOdorOn=find(app.drta_handles.draq_d.eventType==indxOdorOn);

        szev=size(evenTypeIndxOdorOn);
        numBlocks=ceil(szev(2)/20);
        app.drta_handles.draq_d.blocks=zeros(numBlocks,2);
        app.drta_handles.draq_d.blocks(1,1)=min(app.drta_handles.draq_d.events)-0.001;
        app.drta_handles.draq_d.blocks(numBlocks,2)=max(app.drta_handles.draq_d.events)+0.001;

        for blockNo=2:numBlocks
            app.drta_handles.draq_d.blocks(blockNo,1)=((app.drta_handles.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20))...
                +app.drta_handles.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20+1)))/2)-0.001;
        end
        for blockNo=1:numBlocks-1
            app.drta_handles.draq_d.blocks(blockNo,2)=((app.drta_handles.draq_d.events(evenTypeIndxOdorOn(blockNo*20))...
                +app.drta_handles.draq_d.events(evenTypeIndxOdorOn(blockNo*20+1)))/2)+0.001;
        end
end