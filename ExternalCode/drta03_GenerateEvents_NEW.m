function drta03_GenerateEvents(varargin)
% hObject    handle to drtaThresholdPush (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
app = varargin{1};
handles = varargin{2};

if app.Flags.AllTrials == 1
    TrialCount = app.drta_handles.draq_d.noTrials;
else
    TrialCount = size(app.TrilesExported,1);
end

if isfield(app.drta_handles,'drtachoices')
    textUpdate = sprintf('Generating events...');
    ReadoutUpdate(app,textUpdate);
end

%Genterates the header information for events, etc saved in jt_times and drg files
generate_dio_bits=0;

oldTrialNo=app.drta_handles.p.trialNo;

%Events
app.drta_handles.draq_d.noEvents=0;


if ~isfield(app.drta_handles,'drta_p')
    app.drta_handles.drta_p.exc_sn=0;
end

drta03_CreateLables(app);

% find events, determine the type, and assign event labels
% store event information in handles.draq_d in the arrays eventlabels (key
% for converting event string to event number), events (time stamps for
% events) and eventType (numeric event numbers corresponding to event time
% stamps)

empty_new_block=0; % move to where this is needed*************


if generate_dio_bits==1
    %For digging out data
    sniffs=zeros(216000,100);
    dio_bits=zeros(216000,100);
end

%Now get the events
% reset_ii=0;

all_licks=[];
for trialNo=1:TrialCount
    if app.Flags.AllTrials == 0
        currentTrial = app.TrialsExported(trialNo);
    else
        currentTrial = trialNo;
    end
    app.drta_handles.p.trialNo=currentTrial;
    data=drtaNWB_GetTraceData(app.drta_handles);
    if trialNo==1
        all_licks=data(:,end-5)';
    else
        all_licks=[all_licks data(:,end-5)'];
    end
end
lick_max=prctile(all_licks,99.9);
lick_min=prctile(all_licks,0.01);
lick_thr=lick_min+0.5*(lick_max-lick_min);



for trialNo=1:TrialCount

    %Overwrite for debugging
    %     trialNo=157;

    if ~isfield(handles,'drtachoices')
        disp(trialNo);
    end
    tic

    if app.Flags.AllTrials == 0
        currentTrial = app.TrialsExported(trialNo);
    else
        currentTrial = trialNo;
    end

    app.drta_handles.p.trialNo=currentTrial;

    [data]=drtaNWB_GetTraceData(app.drta_handles);


    %For digging out data
    sniffs(:,trialNo)=data(:,1);
    app.drta_handles.dio_bits(:,trialNo)=data(:,3);

    if handles.draq_p.dgordra==1
        %This is a dra file
        datavec=data(:,end-1);
        shiftdata=bitshift( bitand(datavec,248), -2);
    else
        %These are dg or rhd files
        digi = data(:,end-1);
        laser = data(:,end-4);
        shiftdata=bitand(digi,2+4+8+16);
        shiftdatablock=bitand(digi,1+2+4+8+16);
        %shiftdatans=bitand(digi,1+2+4+8);
        shift_dropc_nsampler=bitand(digi,1+2+4+8+16+32);
        %shift_dropc_nsampler=shiftdata(shift_dropc_nsampler<63);

    end


    shiftdata30=shiftdata;
    shiftdata(1:int64(app.drta_handles.draq_p.ActualRate*app.drta_handles.p.exclude_secs))=0;
    shift_dropc_nsampler(1:int64(app.drta_handles.draq_p.ActualRate*app.drta_handles.p.exclude_secs))=0;

    licks=[];
    licks=data(:,end-5);

    %Exclude the trials that are off
    switch app.drta_handles.p.which_c_program

        case (1)
            %dropcnsampler
            dropcnsampler_ProgramType(app,2,trialNo,shift_dropc_nsampler,shiftdata);
        case (2)
            % dropcspm
            dropcspm_ProgramType(app,2);
        case (3)
            %background
            background_ProgramType(app,2);
        case (4)
            %spmult
            spmult_ProgramType(app,2);
        case (5)
            %mspy
            mspy_ProgramType(app,2);
        case (6)
            %osampler
            osampler_ProgramType(app,2);
        case (7)
            %ospm2mult
            spm2mult_ProgramType(app,2);
        case(8)
            %lighton one pulse
            lighton1_ProgramType(app,2,data,trialNo);
        case (9)
            %lighton five pulses
            lighton5_ProgramType(app,2,data,trialNo);
        case (10)
            %dropcspm_conc
            dropcspm_conc_ProgramType(app,2,trialNo,shift_dropc_nsampler);
        case (11)
            %Ming laser
            LaserTriggered_ProgramType(app,2);
        case (12)
            %Merouann laser
            LaserMerouann_ProgramType(app,2);
        case (13)
            %dropcspm hf
            dropcspm_hf_ProgramType(app,2);
        case (14)
            %Working memory
            Working_memory_ProgramType(app,2);
        case (15)
            %Continuous
            Continuous_ProgramType(app,2);
        case (16)
            %Laser Kira
            Laser_Kira_ProgramType(app,2);
        case (17)
            %Laser Schoppa
            Laser_Schoppa_ProgramType(app,2);
    end





    %Enter events
    switch (handles.p.which_c_program)

        case (1)
            %dropcnsampler
            dropcnsampler_ProgramType(app,3,trialNo,shift_dropc_nsampler);
        case (2)
            dropcspm_ProgramType(app,3,shiftdata,trialNo,generate_dio_bits);
        case (3)
            %backgound
            background_ProgramType(app,3);
        case (4)
            %spmult
            spmult_ProgramType(app,3,shiftdata,trialNo);
        case(5)
            %mspy
            mspy_ProgramType(app,3,shiftdata,trialNo);
        case (6)
            %osampler
            osampler_ProgramType(app,3,shiftdata,trialNo);
        case (7)
            %spm2mult
            spm2mult_ProgramType(app,3,shiftdata,trialNo);
        case (8)
            %lighton
            lighton1_ProgramType(app,3,data,trialNo);
        case (9)
            %lighton 5
            lighton5_ProgramType(app,3,data,trialNo);
        case (10)
            %dropcspm conc
            dropcspm_conc_ProgramType(app,3,trialNo,shift_dropc_nsampler);
        case (11)
            %Ming laser
            LaserTriggered_ProgramType(app,3,data,trialNo);
        case (12)
            %Merouann laser
            LaserMerouann_ProgramType(app,3,data,trialNo);
        case (13)
            %dropcspm_hf
            dropcspm_hf_ProgramType(app,3,shiftdata,trialNo);
        case (14)
            %Working memory
            Working_memory_ProgramType(app,3,trialNo,shift_dropc_nsampler);
        case (15)
            %Continuous
            Continuous_ProgramType(app,3,trialNo);
        case (16)
            Laser_Kira_ProgramType(app,3,shiftdata,trialNo,dio_bits,generate_dio_bits);
        case (17)
            %Schoppa laser
            Laser_Schoppa_ProgramType(app,3,shiftdata,trialNo);
    end %switch

    if ~isfield(handles,'drtachoices')
        toc
    end
end %for


% Setup block numbers
switch handles.p.which_c_program
    case (1)
        %dropcnsampler
        dropcnsampler_ProgramType(app,4);
    case (2)
        %dropcspm
        dropcspm_ProgramType(app,4);
    case (3)
        %background
        background_ProgramType(app,4);
    case (4)
        %spmult
        spmult_ProgramType(app,4);
    case (5)
        %nsampler
        mspy_ProgramType(app,4);
    case (6)
        %osampler
        osampler_ProgramType(app,4);
    case (7)
        %spm2mult
        spm2mult_ProgramType(app,4);
    case (8)
        %lighton1
        lighton1_ProgramType(app,4);
    case (9)
        %lighton5
        lighton5_ProgramType(app,4);
    case (10)
        %dropcspm_conc
        dropcspm_conc_ProgramType(app,4);
    case (11)
        %Ming laser
        LaserTriggered_ProgramType(app,4);
    case (12)
        %Merouann laser
        LaserMerouann_ProgramType(app,4);
    case (13)
        %dropcspm_hf
        dropcspm_hf_ProgramType(app,4);
    case (14)
        %Working memory
        Working_memory_ProgramType(app,4);
    case (15)
        %Continuous
        Continuous_ProgramType(app,4);
    case (16)
        %Kira laser
        Laser_Kira_ProgramType(app,4);
    case (17)
        %Laser Schoppa
        Laser_Schoppa_ProgramType(app,4);
end

try
    drta('setTrialNo',handles.w.drta,oldTrialNo);
catch
end

handles=drta03_ExcludeBadLFP(app,handles);

%Now update the .mat file
data=handles.draq_d;
if isfield(data,'data')
    data=rmfield(data,'data');
end
params=handles.draq_p;
drta_p=handles.p;

if handles.draq_p.dgordra==2
    %dg
    save([handles.p.fullName(1:end-2),'mat'],'data','params','drta_p');
else
    %dra or rhd
    save([handles.p.fullName(1:end-3),'mat'],'data','params','drta_p');
end

if isfield(handles,'drtachoices')
    textUpdate = spirntf('Saved .mat for %s', handles.choicesFileName);
    ReadoutUpdate(app,textUpdate);
    textUpdate = spirntf(' ');
    ReadoutUpdate(app,textUpdate);
else
    switch handles.p.which_c_program

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

%If the jt_times exists change the handles.draq_p and handles.p
%This is done so that variables generated by wave_clus are not overwritten

%Do this only if jt_times does exist

if handles.draq_p.dgordra==2
    %This is a dg file
    jt_times_file= fullfile(handles.p.PathName,['jt_times_',handles.p.FileName(1:end-2),'mat']);
else
    %dra or rhd
    jt_times_file=fullfile(handles.p.PathName,['jt_times_',handles.p.FileName(1:end-3),'mat']);
end

if isfield(handles,'drtachoices')
    %Note that drtaBatch overwrites the jt_times file
    cluster_class_per_file=[];
    offset_for_chan=[];
    noSpikes=0;
    all_timestamp_per_file=[];
    draq_p=handles.draq_p;
else
    %If drta is being run load jt_times_file
    try
        load(jt_times_file);
    catch
        cluster_class_per_file=[];
        offset_for_chan=[];
        noSpikes=0;
        all_timestamp_per_file=[];
        draq_p=handles.draq_p;
    end
end

par.doBehavior=0;

if isfield(drta_p,'tetr_processed')
    handles.p.tetr_processed=drta_p.tetr_processed;
end

drta_p=handles.p;


draq_d=handles.draq_d;
if isfield(draq_d,'data')
    draq_d=rmfield(draq_d,'data');
end

if exist('units_per_tet','var')
    if handles.p.which_c_program==8
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
    if handles.p.which_c_program==8
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

if isfield(handles,'drtachoices')
    textUpdate = spirntf('Saved jt_times file for %s', handles.choicesFileName);
    ReadoutUpdate(app,textUpdate);
else
    msgbox('Saved jt_times file');
end

handles.p.trialNo=oldTrialNo;




