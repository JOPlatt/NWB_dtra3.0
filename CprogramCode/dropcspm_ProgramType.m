function dropcspm_ProgramType(app,varargin)

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
        NoOfEvents = 17;
        app.drta_data.draq_d.nEventTypes=NoOfEvents;
        app.drta_data.draq_d.nEvPerType=zeros(1,NoOfEvents);
        app.drta_data.draq_d.eventlabels=cell(1,NoOfEvents);
        app.drta_data.draq_d.eventlabels{1}='TStart';
        app.drta_data.draq_d.eventlabels{2}='OdorOn';
        app.drta_data.draq_d.eventlabels{3}='Hit';
        app.drta_data.draq_d.eventlabels{4}='HitE';
        app.drta_data.draq_d.eventlabels{5}='S+';
        app.drta_data.draq_d.eventlabels{6}='S+E';
        app.drta_data.draq_d.eventlabels{7}='Miss';
        app.drta_data.draq_d.eventlabels{8}='MissE';
        app.drta_data.draq_d.eventlabels{9}='CR';
        app.drta_data.draq_d.eventlabels{10}='CRE';
        app.drta_data.draq_d.eventlabels{11}='S-';
        app.drta_data.draq_d.eventlabels{12}='S-E';
        app.drta_data.draq_d.eventlabels{13}='FA';
        app.drta_data.draq_d.eventlabels{14}='FAE';
        app.drta_data.draq_d.eventlabels{15}='Reinf';
        app.drta_data.draq_d.eventlabels{16}='Short';
        app.drta_data.draq_d.eventlabels{17}='Inter';
    case 2 % trial exclusion
        % trialNo = varargin{2};
        % shiftdata30 = varargin{3};
        % timeBefore=str2double(get(app.drta_data.timeBeforeFV,'String'));
        % firstFV=find(shiftdata30==6,1,'first')/app.drta_data.draq_p.ActualRate;
        % 
        % if firstFV<timeBefore
        %     app.drta_data.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
        %     app.drta_data.p.trial_allch_processed(trialNo)=0;
        % end
        % 
        % this_odor_on=find(shiftdata==18,1,'first');
        % pointsleft=216000-(this_odor_on+3*app.drta_data.draq_p.ActualRate);
        % 
        % if(pointsleft<1)
        %     app.drta_data.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
        %     app.drta_data.p.trial_allch_processed(trialNo)=0;
        % end
    case 3 % create events
        %dropcspm
            %All the labels without the "E" suffix are assigned the time at
            %odor on
            %             figure(1)
            %             plot(shiftdata)
            shiftdata = varargin{2};
            trialNo = varargin{3};
            generate_dio_bits = varargin{4};

            start_ii=(app.drta_data.draq_p.sec_before_trigger-6)*app.drta_data.draq_p.ActualRate+1;
            end_ii=(app.drta_data.draq_p.sec_before_trigger+2)*app.drta_data.draq_p.ActualRate;
            
            if ~isempty(find(shiftdata>=1,1,'first'))
                
                if sum(shiftdata(start_ii:end_ii)>=1)<3*app.drta_data.draq_p.ActualRate
                    %This is a short
                    app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                    t_start=find(shiftdata(start_ii:end_ii)>=1,1,'first')+start_ii;
                    app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+t_start/app.drta_data.draq_p.ActualRate;
                    app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=16;
                    app.drta_data.draq_d.nEvPerType(16)=app.drta_data.draq_d.nEvPerType(16)+1;
                else
                    %Find trial start time (event 1)
                    %Note: This is the same as FINAL_VALVE
                    if sum(shiftdata(start_ii:end_ii)==6)>0.5*app.drta_data.draq_p.ActualRate
                        t_start=find(shiftdata(start_ii:end_ii)==6,1,'first')+start_ii;
                        app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                        app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+t_start/app.drta_data.draq_p.ActualRate;
                        app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=1;
                        app.drta_data.draq_d.nEvPerType(1)=app.drta_data.draq_d.nEvPerType(1)+1;
                    else
                        %It is extremely important, every single trial must have an
                        %accompanying t_start and odor_on
                        
                        %First exclude this weird trial
                        app.drta_data.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
                        app.drta_data.p.trial_allch_processed(trialNo)=0;
                        
                        %Then add it to the list
                        app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                        app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+2;
                        app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=1;
                        app.drta_data.draq_d.nEvPerType(1)=app.drta_data.draq_d.nEvPerType(1)+1;
                        
                    end
                    
                    if exist('t_start','var')
                        %Find odor on (event 2)
                        found_Hit=sum(shiftdata==8)>0.05*app.drta_data.draq_p.ActualRate;
                        found_Miss=sum(shiftdata==10)>0.05*app.drta_data.draq_p.ActualRate;
                        found_CR=sum(shiftdata==12)>0.05*app.drta_data.draq_p.ActualRate;
                        found_FA=sum(shiftdata==14)>0.05*app.drta_data.draq_p.ActualRate;
                        foundEvent=found_Hit||found_Miss||found_CR||found_FA;
                        
                        found_odor_on=0;
                        if (sum(shiftdata(t_start:end_ii)==18)>2.4*app.drta_data.draq_p.ActualRate) && foundEvent...
                                && sum(shiftdata(t_start:end_ii) == 18) > 0 %Very important: each odor On has to have an event
                            
                            odor_on=t_start+find(shiftdata(t_start:end)==18,1,'first');
                            found_odor_on=1;
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+odor_on/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=2;
                            app.drta_data.draq_d.nEvPerType(2)=app.drta_data.draq_d.nEvPerType(2)+1;
                        else
                            %It is extremely important, every single trial must have an
                            %accompanying t_start and odor_on
                            
                            %First exclude this weird trial
                            app.drta_data.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
                            app.drta_data.p.trial_allch_processed(trialNo)=0;
                            
                            %Then add it to the list
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+2;
                            %                         app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=2;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=17;   %Add it as an inter
                            app.drta_data.draq_d.nEvPerType(2)=app.drta_data.draq_d.nEvPerType(2)+1;
                        end
                        
                        
                        %Find Hit (event 3), HitE (event 4), S+ (event 5) and S+E
                        %(event 6)
                        
                        if sum(shiftdata(t_start:t_start+6*app.drta_data.draq_p.ActualRate)==8)>0.05*app.drta_data.draq_p.ActualRate
                            hits=t_start+find(shiftdata(t_start:end)==8,1,'first');
                            
                            if generate_dio_bits==1
                                app.drta_data.dio_bits(:,trialNo)=app.drta_data.dio_bits(:,trialNo)-1;
                                shiftvec=bitshift( bitand(uint16(app.drta_data.dio_bits(:,trialNo)),248), -2);
                                fv=shiftvec==6;
                                app.drta_data.dio_bits(:,trialNo)=app.drta_data.dio_bits(:,trialNo)+fv;
                            end
                            
                            %Hit (event 3)
                            if (found_odor_on==1)
                                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+odor_on/app.drta_data.draq_p.ActualRate;
                                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=3;
                                app.drta_data.draq_d.nEvPerType(3)=app.drta_data.draq_d.nEvPerType(3)+1;
                            end
                            
                            %HitE (event 4)
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+hits/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=4;
                            app.drta_data.draq_d.nEvPerType(4)=app.drta_data.draq_d.nEvPerType(4)+1;
                            
                            %S+ (event 5)
                            if (found_odor_on==1)
                                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+odor_on/app.drta_data.draq_p.ActualRate;
                                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=5;
                                app.drta_data.draq_d.nEvPerType(5)=app.drta_data.draq_d.nEvPerType(5)+1;
                                
                            end
                            
                            %S+E (event 6)
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+hits/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=6;
                            app.drta_data.draq_d.nEvPerType(6)=app.drta_data.draq_d.nEvPerType(6)+1;
                            
                        end
                        
                        %Find Miss (event 7), MissE (event 8), S+ (event 5) and S+E
                        %(event 6)
                        
                        
                        if sum(shiftdata(t_start:t_start+6*app.drta_data.draq_p.ActualRate)==10)>0.05*app.drta_data.draq_p.ActualRate
                            miss=t_start+find(shiftdata(t_start:end)==10,1,'first');
                            
                            if generate_dio_bits==1
                                app.drta_data.dio_bits(:,trialNo)=app.drta_data.dio_bits(:,trialNo)-1;
                                shiftvec=bitshift( bitand(uint16(app.drta_data.dio_bits(:,trialNo)),248), -2);
                                fv=shiftvec==6;
                                app.drta_data.dio_bits(:,trialNo)=app.drta_data.dio_bits(:,trialNo)+fv;
                            end
                            
                            %Miss (event 7)
                            if (found_odor_on==1)
                                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+odor_on/app.drta_data.draq_p.ActualRate;
                                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=7;
                                app.drta_data.draq_d.nEvPerType(7)=app.drta_data.draq_d.nEvPerType(7)+1;
                            end
                            
                            %MissE
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+miss/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=8;
                            app.drta_data.draq_d.nEvPerType(8)=app.drta_data.draq_d.nEvPerType(8)+1;
                            
                            %S+ (event 5)
                            if (found_odor_on==1)
                                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+odor_on/app.drta_data.draq_p.ActualRate;
                                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=5;
                                app.drta_data.draq_d.nEvPerType(5)=app.drta_data.draq_d.nEvPerType(5)+1;
                                
                            end
                            
                            %S+E (event 6)
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+miss/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=6;
                            app.drta_data.draq_d.nEvPerType(6)=app.drta_data.draq_d.nEvPerType(6)+1;
                            
                        end
                        
                        %Find CR (event 9), CRE (event 10), S- (event 11) and S-E
                        %(event 12)
                        
                        if sum(shiftdata(t_start:t_start+6*app.drta_data.draq_p.ActualRate)==12)>0.05*app.drta_data.draq_p.ActualRate
                            crej=t_start+find(shiftdata(t_start:end)==12,1,'first');
                            
                            if generate_dio_bits==1
                                app.drta_data.dio_bits(:,trialNo)=app.drta_data.app.drta_data.dio_bits(:,TrialCount(trialNo))-1;
                            end
                            
                            %CR (event 9)
                            if (found_odor_on==1)
                                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+odor_on/app.drta_data.draq_p.ActualRate;
                                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=9;
                                app.drta_data.draq_d.nEvPerType(9)=app.drta_data.draq_d.nEvPerType(9)+1;
                            end
                            
                            %CRE (event 10)
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+crej/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=10;
                            app.drta_data.draq_d.nEvPerType(10)=app.drta_data.draq_d.nEvPerType(10)+1;
                            
                            %S- (event 11)
                            if (found_odor_on==1)
                                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+odor_on/app.drta_data.draq_p.ActualRate;
                                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=11;
                                app.drta_data.draq_d.nEvPerType(11)=app.drta_data.draq_d.nEvPerType(11)+1;
                                
                            end
                            
                            %S-E (event 12)
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+crej/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=12;
                            app.drta_data.draq_d.nEvPerType(12)=app.drta_data.draq_d.nEvPerType(12)+1;
                            
                        end
                        
                        %Find FA (event 13), FAE (event 14), S- (event 11) and S-E
                        %(event 12)
                        
                        if sum(shiftdata(t_start:t_start+6*app.drta_data.draq_p.ActualRate)==14)>0.05*app.drta_data.draq_p.ActualRate
                            false_alarm=t_start+find(shiftdata(t_start:end)==14,1,'first');
                            
                            if generate_dio_bits==1
                                app.drta_data.dio_bits(:,trialNo)=app.drta_data.app.drta_data.dio_bits(:,TrialCount(trialNo))-1;
                            end
                            
                            %FA (event 13)
                            if (found_odor_on==1)
                                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+odor_on/app.drta_data.draq_p.ActualRate;
                                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=13;
                                app.drta_data.draq_d.nEvPerType(13)=app.drta_data.draq_d.nEvPerType(13)+1;
                            end
                            
                            %FAE
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+false_alarm/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=14;
                            app.drta_data.draq_d.nEvPerType(14)=app.drta_data.draq_d.nEvPerType(14)+1;
                            
                            %S- (event 11)
                            if (found_odor_on==1)
                                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+odor_on/app.drta_data.draq_p.ActualRate;
                                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=11;
                                app.drta_data.draq_d.nEvPerType(11)=app.drta_data.draq_d.nEvPerType(11)+1;
                                
                            end
                            
                            %S-E (event 12)
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+false_alarm/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=12;
                            app.drta_data.draq_d.nEvPerType(12)=app.drta_data.draq_d.nEvPerType(12)+1;
                        end
                        
                        %Find reinforcement (event 15)
                        
                        if sum(shiftdata(t_start:t_start+6*app.drta_data.draq_p.ActualRate)==16)>0.02*app.drta_data.draq_p.ActualRate
                            reinf=t_start+find(shiftdata(t_start:end)==16,1,'first');
                            app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                            app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+reinf/app.drta_data.draq_p.ActualRate;
                            app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=15;
                            app.drta_data.draq_d.nEvPerType(15)=app.drta_data.draq_d.nEvPerType(15)+1;
                        end
                        
                        %                     %Find new block
                        %                     blockNoIndx=find(shiftdatablock>19,1,'first');
                        %                     if ~isempty(blockNoIndx)
                        %                         if ~isempty(t_start)
                        %                             %block_per_index=block_per_index+1;
                        %                             app.drta_data.draq_d.block_per_trial(trialNo)=(shiftdata(blockNoIndx)-18)/2;
                        %                         end
                        %                     else
                        %                         empty_new_block=empty_new_block+1
                        %                     end
                        
                        
                        app.drta_data.draq_d.block_per_trial(trialNo)=floor((trialNo-1)/20)+1;
                        
                        
                        
                    end
                end
            else
                app.drta_data.draq_d.noEvents=app.drta_data.draq_d.noEvents+1;
                app.drta_data.draq_d.events(app.drta_data.draq_d.noEvents)=app.drta_data.draq_d.t_trial(TrialCount(trialNo))+(length(shiftdata)/3)/app.drta_data.draq_p.ActualRate;
                app.drta_data.draq_d.eventType(app.drta_data.draq_d.noEvents)=17;
                app.drta_data.draq_d.nEvPerType(17)=app.drta_data.draq_d.nEvPerType(17)+1;
            end

    case 4 % setup for block number
        indxOdorOn=find(strcmp('OdorOn',app.drta_data.draq_d.eventlabels));
        evenTypeIndxOdorOn=find(app.drta_data.draq_d.eventType==indxOdorOn);
        
        szev=size(evenTypeIndxOdorOn);
        numBlocks=ceil(szev(2)/20);
        if numBlocks==0
           numBlocks=1; 
        end
        app.drta_data.draq_d.blocks=zeros(numBlocks,2);
        app.drta_data.draq_d.blocks(1,1)=min(app.drta_data.draq_d.events)-0.001;
        app.drta_data.draq_d.blocks(numBlocks,2)=max(app.drta_data.draq_d.events)+0.001;
        
        for blockNo=2:numBlocks
            app.drta_data.draq_d.blocks(blockNo,1)=((app.drta_data.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20))...
                +app.drta_data.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20+1)))/2)-0.001;
        end
        for blockNo=1:numBlocks-1
            app.drta_data.draq_d.blocks(blockNo,2)=((app.drta_data.draq_d.events(evenTypeIndxOdorOn(blockNo*20))...
                +app.drta_data.draq_d.events(evenTypeIndxOdorOn(blockNo*20+1)))/2)+0.001;
        end
end