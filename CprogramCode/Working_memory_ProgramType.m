function Working_memory_ProgramType(app,varargin)

ProcessType = varargin{1};

if app.Flags.SelectCh == 1
    NumCh = size(app.SelectedCh,1);
else
    NumCh = app.drta_Data.draq_p.no_spike_ch;
end

if app.Flags.AllTrials == 1
    TrialCount = app.drta_Data.draq_d.noTrials;
else
    TrialCount = size(app.TrilesExported,1);
end

switch ProcessType
    case 1 % generates labels
        app.drta_Data.draq_d.nEvPerType=zeros(1,15);
        app.drta_Data.draq_d.nEventTypes=15;
        app.drta_Data.draq_d.eventlabels=cell(1,15);
        app.drta_Data.draq_d.eventlabels{1}='TStart';
        app.drta_Data.draq_d.eventlabels{2}='OdorOn';
        app.drta_Data.draq_d.eventlabels{3}='NM_Hit';
        app.drta_Data.draq_d.eventlabels{4}='AB';
        app.drta_Data.draq_d.eventlabels{5}='NonMatch';
        app.drta_Data.draq_d.eventlabels{6}='BA';
        app.drta_Data.draq_d.eventlabels{7}='NM_Miss';
        app.drta_Data.draq_d.eventlabels{8}='Blank';
        app.drta_Data.draq_d.eventlabels{9}='M_CR';
        app.drta_Data.draq_d.eventlabels{10}='AA';
        app.drta_Data.draq_d.eventlabels{11}='Match';
        app.drta_Data.draq_d.eventlabels{12}='BB';
        app.drta_Data.draq_d.eventlabels{13}='M_FA';
        app.drta_Data.draq_d.eventlabels{14}='Blank';
        app.drta_Data.draq_d.eventlabels{15}='Reinf';
    case 2 % trial exclusion
    case 3 % create events
        AlltrialNo = app.drta_Data.TrialsSaved;
        shift_dropc_nsampler = app.drta_Data.dropCsamples;
        %             figure(1)
        %             plot(shift_dropc_nsampler)

        start_ii=1;
        end_ii=app.drta_Data.draq_p.sec_per_trigger*app.drta_Data.draq_p.ActualRate;
        for nn = 1:size(AlltrialNo,2)
            trialNo  = AlltrialNo(nn);
            if ~isempty(find(shift_dropc_nsampler>=1,1,'first'))
    
    
                %Find trial start time (event 1)
                %Note: This is FINAL_VALVE
    
                t_start=find(shift_dropc_nsampler(start_ii:end_ii)==1,1,'first')+start_ii;
                app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+t_start/app.drta_Data.draq_p.ActualRate;
                app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=1;
                app.drta_Data.draq_d.nEvPerType(1)=app.drta_Data.draq_d.nEvPerType(1)+1;
    
    
                %Find the first odor
                ii_first2=find(shift_dropc_nsampler(start_ii:end_ii)==2,1,'first');
                ii_first4=find(shift_dropc_nsampler(start_ii:end_ii)==4,1,'first');
                ii_reinf=find(shift_dropc_nsampler(start_ii:end_ii)==16,1,'first');
    
                %Find the odor on off times
                ii_odor1=find(shift_dropc_nsampler(start_ii:end_ii)>1,1,'first');
                delta_ii_odor1=find(shift_dropc_nsampler(start_ii+ii_odor1:end_ii)==0,1,'first');
                delta_ii_odor12=find(shift_dropc_nsampler(start_ii+ii_odor1+delta_ii_odor1:end_ii)>0,1,'first');
                delta_ii_odor2=find(shift_dropc_nsampler(start_ii+ii_odor1+delta_ii_odor1+delta_ii_odor12:end_ii)==0,1,'first');
    
                app.drta_Data.draq_d.delta_ii_odor1(trialNo)=delta_ii_odor1;
                app.drta_Data.draq_d.delta_ii_odor12(trialNo)=delta_ii_odor12;
                app.drta_Data.draq_d.delta_ii_odor2(trialNo)=delta_ii_odor2;
    
                if (~isempty(ii_first2))&(~isempty(ii_first4))
                    %Non match
                    ii_odor_on=min([ii_first2 ii_first4]);
    
                    %OdorOn
                    app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                    app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                    app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=2;
                    app.drta_Data.draq_d.nEvPerType(2)=app.drta_Data.draq_d.nEvPerType(2)+1;
    
                    %NonMatch
                    app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                    app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                    app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=5;
                    app.drta_Data.draq_d.nEvPerType(5)=app.drta_Data.draq_d.nEvPerType(5)+1;
    
    
                    if ~isempty(find(shift_dropc_nsampler(start_ii:end_ii)==16,1,'first'))
                        %NonMatchHit
                        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=3;
                        app.drta_Data.draq_d.nEvPerType(3)=app.drta_Data.draq_d.nEvPerType(3)+1;
                    else
                        %NonMatchMiss
                        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=7;
                        app.drta_Data.draq_d.nEvPerType(7)=app.drta_Data.draq_d.nEvPerType(7)+1;
                    end
    
                    if ii_first2<ii_first4
                        %AB
                        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=4;
                        app.drta_Data.draq_d.nEvPerType(4)=app.drta_Data.draq_d.nEvPerType(4)+1;
                    else
                        %BA
                        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=6;
                        app.drta_Data.draq_d.nEvPerType(6)=app.drta_Data.draq_d.nEvPerType(6)+1;
                    end
                else
                    if (~isempty(ii_first2))
                        ii_odor_on=ii_first2;
                    else
                        ii_odor_on=ii_first4;
                    end
    
                    %OdorOn
                    app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                    app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                    app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=2;
                    app.drta_Data.draq_d.nEvPerType(2)=app.drta_Data.draq_d.nEvPerType(2)+1;
    
                    %Match
                    app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                    app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                    app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=11;
                    app.drta_Data.draq_d.nEvPerType(11)=app.drta_Data.draq_d.nEvPerType(11)+1;
    
                    %Did the animal lick
                    %Note: Here I assume the user entered 4 RAs with 0.5
                    %sec each
                    these_licks=zeros(1,4);
                    delta_RA=0.5*app.drta_Data.draq_p.ActualRate;
                    this_ii=start_ii+ii_odor1+delta_ii_odor1+delta_ii_odor12+delta_ii_odor2-1;
                    for ii_RA=1:4
                        if sum(licks(this_ii:this_ii+delta_RA)>lick_thr)>0
                            these_licks(ii_RA)=1;
                        end
                        this_ii=this_ii+delta_RA;
                    end
    
                    if sum(these_licks)==4
                        licked=1;
                    else
                        licked=0;
                    end
    
                    if licked==1
                        %MatchFA
                        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=13;
                        app.drta_Data.draq_d.nEvPerType(13)=app.drta_Data.draq_d.nEvPerType(13)+1;
                    else
                        %MatchCR
                        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=9;
                        app.drta_Data.draq_d.nEvPerType(9)=app.drta_Data.draq_d.nEvPerType(9)+1;
                    end
    
                    if ~isempty(ii_first2)
                        %AA
                        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=10;
                        app.drta_Data.draq_d.nEvPerType(10)=app.drta_Data.draq_d.nEvPerType(10)+1;
                    else
                        %BB
                        app.drta_Data.draq_d.noEvents=app.drta_Data.draq_d.noEvents+1;
                        app.drta_Data.draq_d.events(app.drta_Data.draq_d.noEvents)=app.drta_Data.draq_d.t_trial(trialNo)+ii_odor_on/app.drta_Data.draq_p.ActualRate;
                        app.drta_Data.draq_d.eventType(app.drta_Data.draq_d.noEvents)=12;
                        app.drta_Data.draq_d.nEvPerType(12)=app.drta_Data.draq_d.nEvPerType(12)+1;
                    end
    
                end
            end
        end
    case 4 % setup for block number
        indxOdorOn=find(strcmp('OdorOn',app.drta_Data.draq_d.eventlabels));
        evenTypeIndxOdorOn=find(app.drta_Data.draq_d.eventType==indxOdorOn);

        szev=size(evenTypeIndxOdorOn);
        numBlocks=ceil(szev(2)/20);
        if numBlocks==0
            numBlocks=1;
        end
        app.drta_Data.draq_d.blocks=zeros(numBlocks,2);
        app.drta_Data.draq_d.blocks(1,1)=min(app.drta_Data.draq_d.events)-0.001;
        app.drta_Data.draq_d.blocks(numBlocks,2)=max(app.drta_Data.draq_d.events)+0.001;

        for blockNo=2:numBlocks
            app.drta_Data.draq_d.blocks(blockNo,1)=((app.drta_Data.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20))...
                +app.drta_Data.draq_d.events(evenTypeIndxOdorOn((blockNo-1)*20+1)))/2)-0.001;
        end
        for blockNo=1:numBlocks-1
            app.drta_Data.draq_d.blocks(blockNo,2)=((app.drta_Data.draq_d.events(evenTypeIndxOdorOn(blockNo*20))...
                +app.drta_Data.draq_d.events(evenTypeIndxOdorOn(blockNo*20+1)))/2)+0.001;
        end


        textUpdate = sprintf('Delta odor 1 = %d sec', mean(app.drta_Data.draq_d.delta_ii_odor1)/app.drta_Data.draq_p.ActualRate);
        ReadoutUpdate(app,textUpdate);
        textUpdate = sprintf('Delta odor 12 = %d sec', mean(app.drta_Data.draq_d.delta_ii_odor12)/app.drta_Data.draq_p.ActualRate);
        ReadoutUpdate(app,textUpdate);
        textUpdate = spirntf('Delta odor 2 = %d sec', mean(app.drta_Data.draq_d.delta_ii_odor2)/app.drta_Data.draq_p.ActualRate);
        ReadoutUpdate(app,textUpdate);
end
