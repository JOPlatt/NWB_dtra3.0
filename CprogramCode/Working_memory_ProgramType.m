function DataSet = Working_memory_ProgramType(app,varargin)

ProcessType = varargin{1};
DataSet = varargin{2};
%{
uncomment if number of electrode channels is needed 
%}
% if app.Flags.SelectCh == 1
%     NumCh = sum(DataSet.SelectedCh);
% else
%     NumCh = DataSet.draq_p.no_spike_ch;
% end

switch ProcessType
    case 1 % generates labels
        DataSet.draq_d.nEvPerType=zeros(1,15);
        DataSet.draq_d.nEventTypes=15;
        DataSet.draq_d.eventlabels=cell(1,15);
        DataSet.draq_d.eventlabels{1}='TStart';
        DataSet.draq_d.eventlabels{2}='OdorOn';
        DataSet.draq_d.eventlabels{3}='NM_Hit';
        DataSet.draq_d.eventlabels{4}='AB';
        DataSet.draq_d.eventlabels{5}='NonMatch';
        DataSet.draq_d.eventlabels{6}='BA';
        DataSet.draq_d.eventlabels{7}='NM_Miss';
        DataSet.draq_d.eventlabels{8}='Blank';
        DataSet.draq_d.eventlabels{9}='M_CR';
        DataSet.draq_d.eventlabels{10}='AA';
        DataSet.draq_d.eventlabels{11}='Match';
        DataSet.draq_d.eventlabels{12}='BB';
        DataSet.draq_d.eventlabels{13}='M_FA';
        DataSet.draq_d.eventlabels{14}='Blank';
        DataSet.draq_d.eventlabels{15}='Reinf';
    case 2 % trial exclusion and create events
        AlltrialNo = DataSet.TrialsSaved;
        shift_dropc_nsampler = DataSet.dropCsamples;
        %             figure(1)
        %             plot(shift_dropc_nsampler)

        start_ii=1;
        end_ii=DataSet.draq_p.sec_per_trigger*DataSet.draq_p.ActualRate;
        for nn = 1:size(AlltrialNo,2)
            trialNo  = AlltrialNo(nn);
            if ~isempty(find(shift_dropc_nsampler>=1,1,'first'))
    
    
                %Find trial start time (event 1)
                %Note: This is FINAL_VALVE
    
                t_start=find(shift_dropc_nsampler(start_ii:end_ii)==1,1,'first')+start_ii;
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+t_start/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=1;
                DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;
    
    
                %Find the first odor
                ii_first2=find(shift_dropc_nsampler(start_ii:end_ii)==2,1,'first');
                ii_first4=find(shift_dropc_nsampler(start_ii:end_ii)==4,1,'first');
                ii_reinf=find(shift_dropc_nsampler(start_ii:end_ii)==16,1,'first');
    
                %Find the odor on off times
                ii_odor1=find(shift_dropc_nsampler(start_ii:end_ii)>1,1,'first');
                delta_ii_odor1=find(shift_dropc_nsampler(start_ii+ii_odor1:end_ii)==0,1,'first');
                delta_ii_odor12=find(shift_dropc_nsampler(start_ii+ii_odor1+delta_ii_odor1:end_ii)>0,1,'first');
                delta_ii_odor2=find(shift_dropc_nsampler(start_ii+ii_odor1+delta_ii_odor1+delta_ii_odor12:end_ii)==0,1,'first');
    
                DataSet.draq_d.delta_ii_odor1(trialNo)=delta_ii_odor1;
                DataSet.draq_d.delta_ii_odor12(trialNo)=delta_ii_odor12;
                DataSet.draq_d.delta_ii_odor2(trialNo)=delta_ii_odor2;
    
                if (~isempty(ii_first2))&(~isempty(ii_first4))
                    %Non match
                    ii_odor_on=min([ii_first2 ii_first4]);
    
                    %OdorOn
                    DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                    DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                    DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
                    DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;
    
                    %NonMatch
                    DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                    DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                    DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=5;
                    DataSet.draq_d.nEvPerType(5)=DataSet.draq_d.nEvPerType(5)+1;
    
    
                    if ~isempty(find(shift_dropc_nsampler(start_ii:end_ii)==16,1,'first'))
                        %NonMatchHit
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=3;
                        DataSet.draq_d.nEvPerType(3)=DataSet.draq_d.nEvPerType(3)+1;
                    else
                        %NonMatchMiss
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=7;
                        DataSet.draq_d.nEvPerType(7)=DataSet.draq_d.nEvPerType(7)+1;
                    end
    
                    if ii_first2<ii_first4
                        %AB
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=4;
                        DataSet.draq_d.nEvPerType(4)=DataSet.draq_d.nEvPerType(4)+1;
                    else
                        %BA
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=6;
                        DataSet.draq_d.nEvPerType(6)=DataSet.draq_d.nEvPerType(6)+1;
                    end
                else
                    if (~isempty(ii_first2))
                        ii_odor_on=ii_first2;
                    else
                        ii_odor_on=ii_first4;
                    end
    
                    %OdorOn
                    DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                    DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                    DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
                    DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;
    
                    %Match
                    DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                    DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                    DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=11;
                    DataSet.draq_d.nEvPerType(11)=DataSet.draq_d.nEvPerType(11)+1;
    
                    %Did the animal lick
                    %Note: Here I assume the user entered 4 RAs with 0.5
                    %sec each
                    these_licks=zeros(1,4);
                    delta_RA=0.5*DataSet.draq_p.ActualRate;
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
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=13;
                        DataSet.draq_d.nEvPerType(13)=DataSet.draq_d.nEvPerType(13)+1;
                    else
                        %MatchCR
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=9;
                        DataSet.draq_d.nEvPerType(9)=DataSet.draq_d.nEvPerType(9)+1;
                    end
    
                    if ~isempty(ii_first2)
                        %AA
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=10;
                        DataSet.draq_d.nEvPerType(10)=DataSet.draq_d.nEvPerType(10)+1;
                    else
                        %BB
                        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+ii_odor_on/DataSet.draq_p.ActualRate;
                        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=12;
                        DataSet.draq_d.nEvPerType(12)=DataSet.draq_d.nEvPerType(12)+1;
                    end
    
                end
            end
        end
    case 3 % setup for block number
        indxOdorOn=find(strcmp('OdorOn',DataSet.draq_d.eventlabels));
        evenTypeIndxOdorOn=find(DataSet.draq_d.eventType==indxOdorOn);

        szev=size(evenTypeIndxOdorOn);
        numBlocks=ceil(szev(2)/20);
        if numBlocks==0
            numBlocks=1;
        end
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


        textUpdate = sprintf('Delta odor 1 = %d sec', mean(DataSet.draq_d.delta_ii_odor1)/DataSet.draq_p.ActualRate);
        ReadoutUpdate(app,textUpdate);
        textUpdate = sprintf('Delta odor 12 = %d sec', mean(DataSet.draq_d.delta_ii_odor12)/DataSet.draq_p.ActualRate);
        ReadoutUpdate(app,textUpdate);
        textUpdate = spirntf('Delta odor 2 = %d sec', mean(DataSet.draq_d.delta_ii_odor2)/DataSet.draq_p.ActualRate);
        ReadoutUpdate(app,textUpdate);
end
