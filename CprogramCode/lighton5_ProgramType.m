function lighton5_ProgramType(app,varargin)

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
        data = varargin{2};
        trialNo = varargin{3};
        digidata=data(:,21);

        %This is a bit safer way to get min and max
        minmin_y=min(digidata);
        maxmax_y=max(digidata);
        max_y=mean(digidata(digidata>(minmin_y+(maxmax_y-minmin_y)/2)));
        min_y=mean(digidata(digidata<(minmin_y+(maxmax_y-minmin_y)/2)));

        if (max_y-min_y)>200
            timeBefore=str2double(get(app.drta_handles.timeBeforeFV,'String'));
            firstLightOn=find(digidata>(min_y+(max_y-min_y)/2),1,'first')/app.drta_handles.draq_p.ActualRate;
            if firstLightOn<timeBefore
                app.drta_handles.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
                app.drta_handles.p.trial_allch_processed(trialNo)=0;
            end
        else
            app.drta_handles.p.trial_ch_processed(1:NumCh,trialNo)=zeros(NumCh,1);
            app.drta_handles.p.trial_allch_processed(trialNo)=0;
        end
    case 3 % create events
        data = varargin{2};
        trialNo = varargin{3};
        %21 digital input
        digidata=data(:,21);

        %This is a bit safer way to get min and max
        minmin_y=min(digidata);
        maxmax_y=max(digidata);
        max_y=mean(digidata(digidata>(minmin_y+(maxmax_y-minmin_y)/2)));
        min_y=mean(digidata(digidata<(minmin_y+(maxmax_y-minmin_y)/2)));

        bad_trial=0;

        if (max_y-min_y)>200

            %Find out how many pulses are here
            pulses_found=0;
            pulse_found=1;
            ii=1;
            while pulse_found==1
                firstdig=find(digidata(ii:end)>min_y+0.5*(max_y-min_y),1,'first');
                if ~isempty(firstdig)
                    %Found a pulse
                    pulses_found=pulses_found+1;
                    deltadig=find(digidata(firstdig+ii-1:end)<min_y+0.5*(max_y-min_y),1,'first');
                    deltat=find(digidata(firstdig+ii-1:end)<min_y+0.5*(max_y-min_y),1,'first')/app.drta_handles.draq_p.ActualRate;
                    ii=ii+firstdig+deltadig;
                else
                    pulse_found=0;
                end
            end

            if pulses_found>=5

                firstdig=find(digidata>min_y+0.5*(max_y-min_y),1,'first');
                %deltadig=find(digidata(firstdig+ii-1:end)<min_y+0.5*(max_y-min_y),1,'first');
                deltat=find(digidata(firstdig:end)<min_y+0.5*(max_y-min_y),1,'first')/app.drta_handles.draq_p.ActualRate;

                %The first two are odor on
                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+firstdig/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=1;
                app.drta_handles.draq_d.nEvPerType(1)=app.drta_handles.draq_d.nEvPerType(1)+1;

                app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+firstdig/app.drta_handles.draq_p.ActualRate;
                app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=2;
                app.drta_handles.draq_d.nEvPerType(2)=app.drta_handles.draq_d.nEvPerType(2)+1;


                if (deltat>0.005)&(deltat<0.015)
                    %10 msec
                    app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                    app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+firstdig/app.drta_handles.draq_p.ActualRate;
                    app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=3;
                    app.drta_handles.draq_d.nEvPerType(3)=app.drta_handles.draq_d.nEvPerType(3)+1;
                end



                if (deltat>0.02)&(deltat<0.04)
                    %30 msec
                    app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                    app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+firstdig/app.drta_handles.draq_p.ActualRate;
                    app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=4;
                    app.drta_handles.draq_d.nEvPerType(4)=app.drta_handles.draq_d.nEvPerType(4)+1;
                end

                if (deltat>0.05)&(deltat<0.07)
                    %60 msec
                    app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                    app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+firstdig/app.drta_handles.draq_p.ActualRate;
                    app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=5;
                    app.drta_handles.draq_d.nEvPerType(5)=app.drta_handles.draq_d.nEvPerType(5)+1;
                end

                if (deltat>0.090)&(deltat<0.110)
                    app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                    app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+firstdig/app.drta_handles.draq_p.ActualRate;
                    app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=6;
                    app.drta_handles.draq_d.nEvPerType(6)=app.drta_handles.draq_d.nEvPerType(6)+1;
                end

                if (deltat>0.190)&(deltat<0.210)
                    app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
                    app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+firstdig/app.drta_handles.draq_p.ActualRate;
                    app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=7;
                    app.drta_handles.draq_d.nEvPerType(7)=app.drta_handles.draq_d.nEvPerType(7)+1;
                end


            end   %while pulse found==1

        else
            bad_trial=1;
        end  %if (max_y-min_y)>200

        if bad_trial==1
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

            app.drta_handles.draq_d.noEvents=app.drta_handles.draq_d.noEvents+1;
            app.drta_handles.draq_d.events(app.drta_handles.draq_d.noEvents)=app.drta_handles.draq_d.t_trial(trialNo)+2;
            app.drta_handles.draq_d.eventType(app.drta_handles.draq_d.noEvents)=2;
            app.drta_handles.draq_d.nEvPerType(2)=app.drta_handles.draq_d.nEvPerType(2)+1;

        end


    case 4 % setup for block number
        app.drta_handles.draq_d.blocks(1,1)=app.drta_handles.draq_d.t_trial(1)-9;
        app.drta_handles.draq_d.blocks(1,2)=app.drta_handles.draq_d.t_trial(end)+9;
end