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
app.drta_Data.generate_dio_bits =0;

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
if app.drta_Data.generate_dio_bits == 1
    sniffs= zeros([216000,100]);
    dio_bits= zeros(216000,100);
end
TrialTemp = TrialSaved;
%Now get the events
% reset_ii=0;
trialPass = 1;
all_licks=[];

for trialNo = TrialTemp
    %showing current trial and starting the timer
    disp(trialNo);
    tic

    drtaNWB_GetTraceData(app,trialNo);

    NumDataPts = size(app.drta_Data.Signals.Digital,1);
    if trialPass == 1
        NumEch = sum(app.drta_Save.p.VisableChannel);
        NumDch = sum(app.drta_Save.p.VisableDigital);
        NumAch = sum(app.drta_Save.p.VisableAnalog);
        NumTrial = width(TrialTemp);
        ElecCollected = nan([NumDataPts,NumEch,NumTrial]);
        if NumDch > 1
            DitalCollected = nan([NumDataPts,NumDch,NumTrial]);
        end
        if NumAch > 1
            AnalogCollected = nan([NumDataPts,NumAch,NumTrial]); 
        end
        TrialIdx = zeros([NumTrial,2]);
    end
    ElectrodDataPerTrialtemp = nan([NumDataPts,NumEch]);
    ElectrodDataPerTrialtemp(:,:) = app.drta_Data.Signals.Electrode(:,app.drta_Save.p.VisableChannel == 1);
    ElecCollected(1:NumDataPts,:,trialPass) = ElectrodDataPerTrialtemp;
    if NumAch > 1
        AnalogDataPerTrialtemp = nan([NumDataPts,NumAch]);
        AnalogDataPerTrialtemp(:,:) = app.drta_Data.Signals.Analog(:,app.drta_Save.p.VisableAnalog == 1);
        AnalogCollected(1:NumDataPts,:,trialPass) = AnalogDataPerTrialtemp(:,:);
        app.drta_Data.AlogData = AnalogDataPerTrialtemp;
    end
    if NumDch > 1
        DigitalDataPerTrialtemp = nan([NumDataPts,NumDch]);
        DigitalDataPerTrialtemp(:,:) = app.drta_Data.Signals.Digital(:,app.drta_Save.p.VisableDigital == 1);
        DitalCollected(1:NumDataPts,:,trialPass) = DigitalDataPerTrialtemp(:,:);
    end
    TrialIdx(trialPass,:) = [app.drta_Data.draq_d.start_blockNo(trialNo) app.drta_Data.draq_d.end_blockNo(trialNo)];
    %{
    Need to revise and make a call to the bitand that are used
    %}

    % needs to be revised!!!
    if app.drta_Data.draq_p.dgordra==1
        %This is a dra file
        datavec=DigitalDataPerTrialtemp(:,2);
        shiftdata=bitshift( bitand(datavec,248), -2);
    else
        %These are dg or rhd files
        if NumDch >= 2
        digi = DigitalDataPerTrialtemp(:,2);
        end
        if NumDch > 8
            laser = DigitalDataPerTrialtemp(:,end-2);
        end
        shiftdata=bitand(digi,2+4+8+16);
        shiftdatablock=bitand(digi,1+2+4+8+16);
        shiftdatans=bitand(digi,1+2+4+8);
        shift_dropc_nsampler=bitand(digi,1+2+4+8+16+32);
        shift_dropc_nsampler=shiftdata(shift_dropc_nsampler<63);

    end

    app.drta_Data.sniffs(:,trialPass) = AnalogDataPerTrialtemp(:,1);
    app.drta_Data.dio_bits(:,trialPass) = AnalogDataPerTrialtemp(:,3);
    app.drta_Data.laser(:,trialPass) = AnalogDataPerTrialtemp(:,6);
    shiftdata30=shiftdata;
    shiftdata(1:int64(app.drta_Data.draq_p.ActualRate*app.drta_Data.p.exclude_secs))=0;
    shift_dropc_nsampler(1:int64(app.drta_Data.draq_p.ActualRate*app.drta_Data.p.exclude_secs))=0;

    %Exclude the trials that are off
    app.drta_Data.shiftdata30 = shiftdata30;
    app.drta_Data.TrialsSaved = trialNo;
    app.drta_Data.dropCsamples = shift_dropc_nsampler;
    app.drta_Data.shiftdata = shiftdata;
    
    programSwitch(app,2);
    toc
    trialPass = trialPass + 1;
end
if NumAch > 1
    all_licks = reshape(AnalogCollected(:,1,:),[width(AnalogCollected(:,1,1)),height(AnalogCollected(:,1,:))*length(AnalogCollected(1,1,:))]);
    lick_max=prctile(all_licks,99.9);
    lick_min=prctile(all_licks,0.01);
    lick_thr=lick_min+0.5*(lick_max-lick_min);
end
% Setup block numbers
programSwitch(app,3);

%still needs revisions; this is a parfor that need to already have all the
%data in a cell array
% app.drta_Data = drta03_ExcludeBadLFP(app,app.drta_Data);

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
