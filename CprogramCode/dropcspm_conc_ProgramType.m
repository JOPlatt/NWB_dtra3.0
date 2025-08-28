function DataSet = dropcspm_conc_ProgramType(app,varargin)

ProcessType = varargin{1};
DataSet = varargin{2};
if app.Flags.SelectCh == 1
    NumCh = sum(DataSet.SelectedCh);
else
    NumCh = DataSet.draq_p.no_spike_ch;
end

switch ProcessType
    case 1 % generates labels
        DataSet.draq_d.nEvPerType=zeros(1,23);
        DataSet.draq_d.nEventTypes=23;
        DataSet.draq_d.eventlabels=cell(1,23);
        DataSet.draq_d.eventlabels{1}='TStart';
        DataSet.draq_d.eventlabels{2}='OdorOn';
        DataSet.draq_d.eventlabels{3}='Hit';
        DataSet.draq_d.eventlabels{4}='HitE';
        DataSet.draq_d.eventlabels{5}='S+';
        DataSet.draq_d.eventlabels{6}='S+E';
        DataSet.draq_d.eventlabels{7}='Miss';
        DataSet.draq_d.eventlabels{8}='MissE';
        DataSet.draq_d.eventlabels{9}='CR';
        DataSet.draq_d.eventlabels{10}='CRE';
        DataSet.draq_d.eventlabels{11}='S-';
        DataSet.draq_d.eventlabels{12}='S-E';
        DataSet.draq_d.eventlabels{13}='FA';
        DataSet.draq_d.eventlabels{14}='FAE';
        DataSet.draq_d.eventlabels{15}='Reinf';
        DataSet.draq_d.eventlabels{16}='Hi Od1'; %Highest concentration
        DataSet.draq_d.eventlabels{17}='Hi Od2';
        DataSet.draq_d.eventlabels{18}='Hi Od3';
        DataSet.draq_d.eventlabels{19}='Low Od4';
        DataSet.draq_d.eventlabels{20}='Low Od5';
        DataSet.draq_d.eventlabels{21}='Low Od6'; %Lowest concentration
        DataSet.draq_d.eventlabels{22}='Short';
        DataSet.draq_d.eventlabels{23}='Inter';
    case 2 % trial exclusion and create events
        trialNo = DataSet.TrialsSaved;
        % shiftdata30 = DataSet.shiftdata30;
        shift_dropc_nsampler = DataSet.dropCsamples;
        %I fixed the problems in drta_read_Intan_RHD2000_header, this should be OK

        %             timeBefore=str2double(get(DataSet.timeBeforeFV,'String'));
        %             firstFV=find(shift_dropc_nsampler==1,1,'first')/DataSet.draq_p.ActualRate;
        %
        %             if firstFV<timeBefore
        %                 DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
        %                 DataSet.p.trial_allch_processed(trialNo)=0;
        %             end
        %
        %             this_odor_on=find(shift_dropc_nsampler>1,1,'first');
        %             pointsleft=216000-(this_odor_on+3*DataSet.draq_p.ActualRate);
        %
        %             if(pointsleft<1)
        %                 DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
        %                 DataSet.p.trial_allch_processed(trialNo)=0;
        %                 trialNo
        %                 pointsleft
        %             end
        % create events
        %All the labels without the "E" suffix are assigned the time at
        %odor on
        if ~isempty(find(shift_dropc_nsampler>=1,1,'first'))
            %This is an odor trial or a short

            if length(find(shift_dropc_nsampler>=1))<3*DataSet.draq_p.ActualRate
                %This is a short
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                t_start=find(shift_dropc_nsampler>=1,1,'first');
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+t_start/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=22;
                DataSet.draq_d.nEvPerType(22)=DataSet.draq_d.nEvPerType(22)+1;
            else
                %Find trial start time (event 1)
                %Note: This is the same as FINAL_VALVE
                if sum(shift_dropc_nsampler==1)>0.9*DataSet.draq_p.ActualRate
                    t_start=find(shift_dropc_nsampler==1,1,'first');
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

                    %Then add it to the list as a short
                    DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                    DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+2;
                    DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=22;
                    DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;

                end

                if exist('t_start','var')
                    %Find odor on (event 2)
                    found_odor_on=0;
                    %Note, odor on must be longer than 2.4 sec and must take place after final
                    %valve when shift_dropc_nsampler==1
                    if (sum((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7))>2.4*DataSet.draq_p.ActualRate)&...
                            ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
                        %                         odor_on=find((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7),1,'first');
                        odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
                        found_odor_on=1;
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
                        DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;
                    else
                        %It is extremely important, every single trial must have an
                        %accompanying t_start followed by an odor_on

                        %First exclude this weird trial
                        DataSet.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
                        DataSet.p.trial_allch_processed(trialNo)=0;

                        %Then add it to the list as a short
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+2;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=22;
                        DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;
                    end

                    %Now do processing only if odor on was found
                    if (found_odor_on==1)
                        %Find Hit (event 3), HitE (event 4), S+ (event 5) and S+E
                        %(event 6)

                        if sum(shift_dropc_nsampler==8)>0.05*DataSet.draq_p.ActualRate
                            hits=t_start+find(shift_dropc_nsampler(t_start:end)==8,1,'first');
                            if generate_dio_bits==1
                                DataSet(:,trialNo)=DataSet(:,trialNo)-1;
                                shiftvec=bitshift( bitand(uint16(DataSet(:,trialNo)),248), -2);
                                fv=shiftvec==6;
                                DataSet(:,trialNo)=DataSet(:,trialNo)+fv;
                            end

                            %Hit (event 3)

                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3;
                            DataSet.draq_d.nEvPerType(3)=DataSet.draq_d.nEvPerType(3)+1;


                            %HitE (event 4)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+hits/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=4;
                            DataSet.draq_d.nEvPerType(4)=DataSet.draq_d.nEvPerType(4)+1;

                            %S+ (event 5)

                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=5;
                            DataSet.draq_d.nEvPerType(5)=DataSet.draq_d.nEvPerType(5)+1;


                            %S+E (event 6)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+hits/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=6;
                            DataSet.draq_d.nEvPerType(6)=DataSet.draq_d.nEvPerType(6)+1;

                        end

                        %Find Miss (event 7), MissE (event 8), S+ (event 5) and S+E
                        %(event 6)


                        if sum(shift_dropc_nsampler==10)>0.05*DataSet.draq_p.ActualRate
                            miss=t_start+find(shift_dropc_nsampler(t_start:end)==10,1,'first');
                            if generate_dio_bits==1
                                DataSet(:,trialNo)=DataSet(:,trialNo)-1;
                                shiftvec=bitshift( bitand(uint16(DataSet(:,trialNo)),248), -2);
                                fv=shiftvec==6;
                                DataSet(:,trialNo)=DataSet(:,trialNo)+fv;
                            end

                            %Miss (event 7)

                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=7;
                            DataSet.draq_d.nEvPerType(7)=DataSet.draq_d.nEvPerType(7)+1;


                            %MissE
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+miss/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=8;
                            DataSet.draq_d.nEvPerType(8)=DataSet.draq_d.nEvPerType(8)+1;

                            %S+ (event 5)

                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=5;
                            DataSet.draq_d.nEvPerType(5)=DataSet.draq_d.nEvPerType(5)+1;


                            %S+E (event 6)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+miss/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=6;
                            DataSet.draq_d.nEvPerType(6)=DataSet.draq_d.nEvPerType(6)+1;

                        end

                        %Find CR (event 9), CRE (event 10), S- (event 11) and S-E
                        %(event 12)

                        if sum(shift_dropc_nsampler==12)>0.05*DataSet.draq_p.ActualRate
                            crej=t_start+find(shift_dropc_nsampler(t_start:end)==12,1,'first');
                            if generate_dio_bits==1
                                DataSet(:,trialNo)=DataSet(:,trialNo)-1;
                            end

                            %CR (event 9)

                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=9;
                            DataSet.draq_d.nEvPerType(9)=DataSet.draq_d.nEvPerType(9)+1;


                            %CRE (event 10)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+crej/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=10;
                            DataSet.draq_d.nEvPerType(10)=DataSet.draq_d.nEvPerType(10)+1;

                            %S- (event 11)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=11;
                            DataSet.draq_d.nEvPerType(11)=DataSet.draq_d.nEvPerType(11)+1;


                            %S-E (event 12)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+crej/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=12;
                            DataSet.draq_d.nEvPerType(12)=DataSet.draq_d.nEvPerType(12)+1;

                        end

                        %Find FA (event 13), FAE (event 14), S- (event 11) and S-E
                        %(event 12)

                        if sum(shift_dropc_nsampler(t_start:end)==14)>0.05*DataSet.draq_p.ActualRate
                            false_alarm=t_start+find(shift_dropc_nsampler(t_start:end)==14,1,'first');
                            if generate_dio_bits==1
                                DataSet(:,trialNo)=DataSet(:,trialNo)-1;
                            end

                            %FA (event 13)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=13;
                            DataSet.draq_d.nEvPerType(13)=DataSet.draq_d.nEvPerType(13)+1;


                            %FAE
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+false_alarm/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=14;
                            DataSet.draq_d.nEvPerType(14)=DataSet.draq_d.nEvPerType(14)+1;

                            %S- (event 11)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=11;
                            DataSet.draq_d.nEvPerType(11)=DataSet.draq_d.nEvPerType(11)+1;

                            %S-E (event 12)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+false_alarm/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=12;
                            DataSet.draq_d.nEvPerType(12)=DataSet.draq_d.nEvPerType(12)+1;
                        end

                        %Find reinforcement (event 15)
                        if sum(shift_dropc_nsampler==32)>0.02*DataSet.draq_p.ActualRate
                            reinf=t_start+find(shift_dropc_nsampler(t_start:end)==32,1,'first');
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+reinf/DataSet.draq_p.ActualRate;
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=15;
                            DataSet.draq_d.nEvPerType(15)=DataSet.draq_d.nEvPerType(15)+1;
                        end


                        %Find which odor concentration this is
                        this_odor=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first');
                        if ~isempty(this_odor)
                            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+odor_on/DataSet.draq_p.ActualRate;
                            this_odor_evNo=shift_dropc_nsampler(this_odor);
                            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=15+this_odor_evNo-1;
                            DataSet.draq_d.nEvPerType(15+this_odor_evNo-1)=DataSet.draq_d.nEvPerType(15+this_odor_evNo-1)+1;
                        end
                    end

                else
                    %This is an intermediate trial
                    DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                    DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+(length(shift_dropc_nsampler)/3)/DataSet.draq_p.ActualRate;
                    DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=23;
                    DataSet.draq_d.nEvPerType(23)=DataSet.draq_d.nEvPerType(23)+1;
                end
            end



        else
            %This is an intermediate trial
            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+(length(shift_dropc_nsampler)/3)/DataSet.draq_p.ActualRate;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=23;
            DataSet.draq_d.nEvPerType(23)=DataSet.draq_d.nEvPerType(23)+1;
        end

        % This code is here for troubleshooting
        %             figure(10)
        %             plot(shift_dropc_nsampler)
        %             pffft=1;
    case 3 % setup for block number
        indxOdorOn=find(strcmp('OdorOn',DataSet.draq_d.eventlabels));
        evenTypeIndxOdorOn=find(DataSet.draq_d.eventType==indxOdorOn);

        szev=size(evenTypeIndxOdorOn);
        numBlocks=ceil(szev(2)/20);
        DataSet.draq_d.blocks=zeros(numBlocks,2);
        DataSet.draq_d.blocks(1,1)=min(DataSet.draq_d.events)-0.001;
        DataSet.draq_d.blocks(numBlocks,2)=max(DataSet.draq_d.events)+0.001;

        for blockNo=2:numBlocks
            DataSet.draq_d.blocks(blockNo,1)=((DataSet.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20))...
                +DataSet.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20+1)))/2)-0.001;
        end
        for blockNo=1:numBlocks-1
            DataSet.draq_d.blocks(blockNo,2)=((DataSet.draq_d.events(evenTypeIndxOdorOn(blockNo*20))...
                +DataSet.draq_d.events(evenTypeIndxOdorOn(blockNo*20+1)))/2)+0.001;
        end
end