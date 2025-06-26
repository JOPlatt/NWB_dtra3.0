function spmult_ProgramType(app,varargin)

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
        prompt = {'Enter the number of odors used as S+:'};
        dlg_title = 'Input for spmult';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_spmult_odors=str2num(answer{1});
        app.drta_handles.draq_d.nsp_odors = num_spmult_odors;
        
        app.drta_handles.draq_d.nEvPerType=zeros(1,9+num_spmult_odors*3);
        app.drta_handles.draq_d.nEventTypes=9+num_spmult_odors*3;
        app.drta_handles.draq_d.eventlabels=cell(1,9+num_spmult_odors*3);
        app.drta_handles.draq_d.eventlabels{1}='TStart';
        app.drta_handles.draq_d.eventlabels{2}='OdorOn';
        app.drta_handles.draq_d.eventlabels{3}='CR';
        app.drta_handles.draq_d.eventlabels{4}='S-';
        app.drta_handles.draq_d.eventlabels{5}='FA';
        app.drta_handles.draq_d.eventlabels{6}='Reinf';
        app.drta_handles.draq_d.eventlabels{7}='S+';
        app.drta_handles.draq_d.eventlabels{8}='Hit';
        app.drta_handles.draq_d.eventlabels{9}='Miss';
        
        for odNum=1:num_spmult_odors
            app.drta_handles.draq_d.eventlabels{9+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S+'];
            app.drta_handles.draq_d.eventlabels{9+3*(odNum-1)+2}=['Odor' num2str(odNum) '-Hit'];
            app.drta_handles.draq_d.eventlabels{9+3*(odNum-1)+3}=['Odor' num2str(odNum) '-Miss'];
        end
    case 2 % trial exclusion
    case 3 % create events
        shiftdata = varargin{2};
        trialNo = varargin{3};
        %Find trial start time (event 1)
        %Note: This is the same as FINAL_VALVE
        t_start=find(shiftdata==6,1,'first');
        if ~isempty(t_start)
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

            %Then add this one
            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+2;
            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=1;
            app.drta_handles.draq_d.nEvPerType(1)=app.drta_handles.draq_d.nEvPerType(1)+1;
        end

        %Find odor on (event 2)
        odor_on=find(shiftdata==18,1,'first');
        found_odor_on=0;
        if ~isempty(odor_on)
            found_odor_on=1;
            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=2;
            app.drta_handles.draq_d.nEvPerType(2)=app.drta_handles.draq_d.nEvPerType(2)+1;
        else
            %It is extremely important, every single trial must have an
            %accompanying t_start and odor_on

            %First exclude this weird trial
            app.drta_handles.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            app.drta_handles.p.trial_allch_processed(trialNo)=0;

            %Then add this one
            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+2;
            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=2;
            app.drta_handles.draq_d.nEvPerType(1)=app.drta_handles.draq_d.nEvPerType(2)+1;
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

            %Hit (event number 8 and number 9+3*(odNum-1)+2)
            if (found_odor_on==1)
                % add a Hit event (event 8)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=8;
                app.drta_handles.draq_d.nEvPerType(8)=app.drta_handles.draq_d.nEvPerType(8)+1;
                % add an OdorNoX-Hit event (event 9+3*(odNum-1)+2)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=9+3*(odNum-1)+2;
                app.drta_handles.draq_d.nEvPerType(9+3*(odNum-1)+2)=app.drta_handles.draq_d.nEvPerType(9+3*(odNum-1)+2)+1;
            end

            %S+ (event 7 and event 9+3*(odNum-1)+1)
            if (found_odor_on==1)
                % add an S+ event (event 7)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=7;
                app.drta_handles.draq_d.nEvPerType(7)=app.drta_handles.draq_d.nEvPerType(7)+1;
                % add an OdorX-S+ event for this odor (event 9+3*(odNum-1)+1)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=9+3*(odNum-1)+1;
                app.drta_handles.draq_d.nEvPerType(9+3*(odNum-1)+1)=app.drta_handles.draq_d.nEvPerType(9+3*(odNum-1)+1)+1;
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

            %Miss (event 9+3*(odNum-1)+3)
            if (found_odor_on==1)
                % add a miss (event 9)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=9;
                app.drta_handles.draq_d.nEvPerType(9)=app.drta_handles.draq_d.nEvPerType(9)+1;
                % add an OdorNoX-Miss event (event number 9+3*(odNum-1)+3)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=9+3*(odNum-1)+3;
                app.drta_handles.draq_d.nEvPerType(9+3*(odNum-1)+3)=app.drta_handles.draq_d.nEvPerType(9+3*(odNum-1)+3)+1;
            end

            %S+ (event 7 and event 9+3*(odNum-1)+1)
            if (found_odor_on==1)
                % add an S+ event (event 7)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=7;
                app.drta_handles.draq_d.nEvPerType(7)=app.drta_handles.draq_d.nEvPerType(7)+1;
                % add an OdorX-S+ event (event number 9+3*(odNum-1)+1)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=9+3*(odNum-1)+1;
                app.drta_handles.draq_d.nEvPerType(9+3*(odNum-1)+1)=app.drta_handles.draq_d.nEvPerType(9+3*(odNum-1)+1)+1;
            end


        end

        %Find CR (event 9), CRE (event 10), S- (event 11) and S-E
        %(event 12)
        crej=find(shiftdata==12,1,'first');
        if ~isempty(crej)

            %CR (event 3)
            if (found_odor_on==1)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=3;
                app.drta_handles.draq_d.nEvPerType(3)=app.drta_handles.draq_d.nEvPerType(3)+1;
            end

            %S- (event 4)
            if (found_odor_on==1)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=4;
                app.drta_handles.draq_d.nEvPerType(4)=app.drta_handles.draq_d.nEvPerType(4)+1;
            end

        end

        %Find FA (event 13), FAE (event 14), S- (event 11) and S-E
        %(event 12)
        false_alarm=find(shiftdata==14,1,'first');
        if ~isempty(false_alarm)

            %FA (event 5)
            if (found_odor_on==1)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=5;
                app.drta_handles.draq_d.nEvPerType(5)=app.drta_handles.draq_d.nEvPerType(5)+1;
            end

            %S- (event 4)
            if (found_odor_on==1)
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+odor_on/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=4;
                app.drta_handles.draq_d.nEvPerType(4)=app.drta_handles.draq_d.nEvPerType(4)+1;
            end


        end

        %Find reinforcement (event 6)
        reinf=find(shiftdata==16,1,'first');
        if ~isempty(reinf)
            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+reinf/app.drta_handles.draq_p.ActualRate;
            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=6;
            app.drta_handles.draq_d.nEvPerType(6)=app.drta_handles.draq_d.nEvPerType(6)+1;
        end

        %             %Find new block (event 10)
        %
        %             new_block=find(shiftdata>19,1,'first');
        %             if ~isempty(new_block)
        %                if ~isempty(t_start)
        %                 block_per_index=block_per_index+1;
        %                 trial_start_time(block_per_index)=app.drta_handles.draq_d.t_trial(trialNo)+t_start/app.drta_handles.draq_p.ActualRate;
        %                 block_per_trial(block_per_index)=(shiftdata(new_block)-18)/2;
        %                end
        %             else
        %                 empty_new_block=empty_new_block+1
        %             end
    case 4 % setup for block number
        app.drta_handles.draq_d.blocks(1,1)=min(app.drta_handles.draq_d.events)-0.00001;
        app.drta_handles.draq_d.blocks(1,2)=max(app.drta_handles.draq_d.events)+0.00001;
end