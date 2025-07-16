function drta03_GenerateEvents(varargin)
% hObject    handle to drtaThresholdPush (see GCBO)
% app.drta_Data    structure with app.drta_Data and user data (see GUIDATA)
app = varargin{1};

if app.drta_Save.ChannelPreset.MoreTrials.Value == 1
    TrialSaved = app.drta_Save.TrialIndex.STposition.Value:app.drta_Save.TrialIndex.ENposition.Value;
else
    TrialSaved = app.drta_Save.TrialIndex.STposition.Value;
end

if isfield(app.drta_Data,'drtachoices')
    textUpdate = sprintf('Generating events...');
    ReadoutUpdate(app,textUpdate);
end

%Genterates the header information for events, etc saved in jt_times and drg files
generate_dio_bits=0;

% oldTrialNo=app.drta_Data.p.trialNo;

%Events
app.drta_Data.draq_d.noEvents=0;


if ~isfield(app.drta_Data,'drta_p')
    app.drta_Data.drta_p.exc_sn=0;
end

programSwitch(app,1);
% drta03_CreateLables(app);

% find events, determine the type, and assign event labels
% store event information in app.drta_Data.draq_d in the arrays eventlabels (key
% for converting event string to event number), events (time stamps for
% events) and eventType (numeric event numbers corresponding to event time
% stamps)

% empty_new_block=0; % move to where this is needed*************


% if generate_dio_bits==1
%     %For digging out data
    sniffs=zeros(216000,100);
    dio_bits=zeros(216000,100);
% end

%Now get the events
% reset_ii=0;

all_licks=[];
% for trialNo=1:TrialSaved
    %showing current trial and starting the timer
    % disp(trialNo);
    % tic
    % %
    % if app.Flags.AllTrials == 0
    %     currentTrial = app.TrialsExported(trialNo);
    % else
    %     currentTrial = trialNo;
    % end
    % app.drta_Data.p.trialNo=currentTrial;
    drtaNWB_GetTraceData(app,TrialSaved);
    % all_licks = nan([size(data,1),TrialCount]);
    NumEch = sum(app.drta_Save.p.VisableChannel);
    NumDch = sum(app.drta_Save.p.VisableDigital);
    NumAch = sum(app.drta_Save.p.VisableAnalog);
    NumDataPts = size(app.drta_Data.Signals.Digital,1);
    ElectrodDataPerTrialtemp = nan([NumDataPts,NumEch]);
    %need to add condition that if the data is >1 or it will be a nxm
    %for both analog and digital
    AnalogDataPerTrialtemp = nan([NumDataPts,NumAch]);
    DigitalDataPerTrialtemp = nan([NumDataPts,NumDch]);

    %     all_licks=data(:,end-5)';
    % else
    %     all_licks=[all_licks data(:,end-5)'];
    
    % all_licks(:,trialNo) = data(:,app.locations.licks);
    AnalogDataPerTrialtemp(:,:) = app.drta_Data.Signals.Analog(:,app.drta_Save.p.VisableAnalog == 1);
    %need if statment for >1 channel
    DigitalDataPerTrialtemp(:,:) = app.drta_Data.Signals.Digital(:,app.drta_Save.p.VisableDigital == 1);
    ElectrodDataPerTrialtemp(:,:) = app.drta_Data.Signals.Electrode(:,app.drta_Save.p.VisableChannel == 1);
    % idxStart = size(AnalogDataPerTrial,1)+1;
    % idxStop = size(data,1);
    % 
    % AnalogDataPerTrial(idxStart:idxStop) = AnalogDataPerTrialtemp;
    % %need if statment for >1 channel
    % DigitalDataPerTrial(idxStart:idxStop) = DigitalDataPerTrialtemp;
    % ElectrodDataPerTrial(idxStart:idxStop) = ElectrodDataPerTrialtemp;
    
    %---%
    % sniffs(:,trialNo)=data(:,1);
    % app.drta_Data.dio_bits(:,trialNo)=data(:,3);

    % needs to be revised!!!
    % if app.drta_Data.draq_p.dgordra==1
    %     %This is a dra file
    %     datavec=DigitalDataPerTrialtemp(:,end-1);
    %     shiftdata=bitshift( bitand(datavec,248), -2);
    % else
    %     %These are dg or rhd files
    %     digi = DigitalDataPerTrialtemp(:,end-1);
    %     laser = DigitalDataPerTrialtemp(:,end-2);
    %     shiftdata=bitand(digi,2+4+8+16);
    %     shiftdatablock=bitand(digi,1+2+4+8+16);
    %     %shiftdatans=bitand(digi,1+2+4+8);
    %     shift_dropc_nsampler=bitand(digi,1+2+4+8+16+32);
    %     %shift_dropc_nsampler=shiftdata(shift_dropc_nsampler<63);
    % 
    % end


    % shiftdata30=shiftdata;
    % shiftdata(1:int64(app.drta_Data.draq_p.ActualRate*app.drta_Data.p.exclude_secs))=0;
    shift_dropc_nsampler(1:int64(app.drta_Data.draq_p.ActualRate*app.drta_Data.p.exclude_secs))=0;
    % 
    % licks=[];
    % licks=AnalogDataPerTrialtemp(:,3);


    %Exclude the trials that are off
    app.drta_Data.TrialsSaved = TrialSaved;
    app.drta_Data.dropCsamples = shift_dropc_nsampler;
    programSwitch(app,2);
    %Enter events
    programSwitch(app,3);


    toc
% end
lick_max=prctile(all_licks,99.9);
lick_min=prctile(all_licks,0.01);
lick_thr=lick_min+0.5*(lick_max-lick_min);

% Setup block numbers
% programSwitch(app,4);

%still needs revisions
% app.drta_Data=drta03_ExcludeBadLFP(app,app.drta_Data);

params=app.drta_Data.draq_p;
drta_p=app.drta_Data.p;
data.Electrode = ElectrodDataPerTrialtemp;
data.Digital = DigitalDataPerTrialtemp;
data.Analog = AnalogDataPerTrialtemp;
data.TrialsNo = TrialSaved;
data.ElectrodesSaved = app.drta_Save.p.VisableChannel;
data.DigitalSaved = app.drta_Save.p.VisableDigital;
data.AnalogSaved = app.drta_Save.p.VisableAnalog;
if app.drta_Data.draq_p.dgordra==2
    %dg
    save([app.drta_Data.p.fullName(1:end-2),'mat'],'data','params','drta_p');
else
    %dra or rhd
    save([app.drta_Data.p.fullName(1:end-3),'mat'],'data','params','drta_p');
end

if isfield(app.drta_Data,'drtachoices')
    textUpdate = spirntf('Saved .mat for %s', app.drta_Data.choicesFileName);
    ReadoutUpdate(app,textUpdate);
    textUpdate = spirntf(' ');
    ReadoutUpdate(app,textUpdate);
else
    switch app.drta_Data.p.which_c_program

        case (1)
            %dropcnsampler
            msgbox('Saved .mat (dropcnsampler)');
        case (2)
            %splussminus
            msgbox('Saved .mat (dropcspm)');
        case (3)
            %background
            msgbox('Saved .mat (background)');
        case (4)
            %spmult
            msgbox('Saved .mat (spmult)');
        case (5)
            %mspy
            msgbox('Saved .mat (mspy)');
        case (6)
            %osampler
            msgbox('Saved .mat (osampler)');
        case (7)
            %ospm2mult
            msgbox('Saved .mat (spm2mult)');
        case (8)
            %lighton one pulse
            msgbox('Saved .mat (lighton1)');
        case (9)
            %lighton five pulses
            msgbox('Saved .mat (lighton5)');
        case (10)
            %dropcspm_conc
            msgbox('Saved .mat (dropcspm_conc)');
        case (11)
            %dropcspm_conc
            msgbox('Saved .mat (Ming laser)');
        case (12)
            %dropcspm_conc
            msgbox('Saved .mat (Merouann laser)');
        case (14)
            %dropcspm_conc
            msgbox('Saved .mat (Working Memory)');
        case (15)
            %dropcspm_conc
            msgbox('Saved .mat (Continuous)');
        case (16)
            %Kira laser
            msgbox('Saved .mat (Kira laser)');
        case (17)
            %Kira laser
            msgbox('Saved .mat (Schoppa laser)');
    end
end

%If the jt_times exists change the app.drta_Data.draq_p and app.drta_Data.p
%This is done so that variables generated by wave_clus are not overwritten

%Do this only if jt_times does exist

if app.drta_Data.draq_p.dgordra==2
    %This is a dg file
    jt_times_file= fullfile(app.drta_Data.p.PathName,['jt_times_',app.drta_Data.p.FileName(1:end-2),'mat']);
else
    %dra or rhd
    jt_times_file=fullfile(app.drta_Data.p.PathName,['jt_times_',app.drta_Data.p.FileName(1:end-3),'mat']);
end

if isfield(app.drta_Data,'drtachoices')
    %Note that drtaBatch overwrites the jt_times file
    cluster_class_per_file=[];
    offset_for_chan=[];
    noSpikes=0;
    all_timestamp_per_file=[];
    draq_p=app.drta_Data.draq_p;
else
    %If drta is being run load jt_times_file
    try
        load(jt_times_file);
    catch
        cluster_class_per_file=[];
        offset_for_chan=[];
        noSpikes=0;
        all_timestamp_per_file=[];
        draq_p=app.drta_Data.draq_p;
    end
end

par.doBehavior=0;

if isfield(drta_p,'tetr_processed')
    app.drta_Data.p.tetr_processed=drta_p.tetr_processed;
end

drta_p=app.drta_Data.p;
draq_d=app.drta_Data.draq_d;
if isfield(draq_d,'data')
    draq_d=rmfield(draq_d,'data');
end

if exist('units_per_tet','var')
    if app.drta_Data.p.which_c_program==8
        save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','units_per_tet');
    else

        if isfield(par,'doBehavior')
            if par.doBehavior==1
                save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','lickbit','dtime','units_per_tet');
            else
                save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','units_per_tet');
            end
        else
            save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','units_per_tet');
        end

    end
else
    if app.drta_Data.p.which_c_program==8
        save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d');
    else

        if isfield(par,'doBehavior')
            if par.doBehavior==1
                save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d','lickbit','dtime');
            else
                save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d');
            end
        else
            save(jt_times_file, 'cluster_class_per_file', 'par', 'offset_for_chan','noSpikes', 'all_timestamp_per_file','drta_p', 'draq_p', 'draq_d');
        end

    end
end

if isfield(app.drta_Data,'drtachoices')
    textUpdate = spirntf('Saved jt_times file for %s', app.drta_Data.choicesFileName);
    ReadoutUpdate(app,textUpdate);
else
    msgbox('Saved jt_times file');
end
