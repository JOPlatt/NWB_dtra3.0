function BatchSave_GenerateEvents(varargin)
% hObject    handle to drtaThresholdPush (see GCBO)
% app.drta_Data    structure with app.drta_Data and user data (see GUIDATA)
app = varargin{1};
FileNum = varargin{2};
fname = sprintf('drtaFile%.3d',FileNum);
app.data_files.(fname)

%Events
app.data_files.(fname).draq_d.noEvents=0;

if ~isfield(app.data_files.(fname),'drta_p')
    app.data_files.(fname).drta_p.exc_sn=0;
end
app.data_files.(fname).generate_dio_bits=0;
programSwitch(app,1,FileNum);

% find events, determine the type, and assign event labels
% store event information in app.drta_Data.draq_d in the arrays eventlabels (key
% for converting event string to event number), events (time stamps for
% events) and eventType (numeric event numbers corresponding to event time
% stamps)
if app.data_files.(fname).generate_dio_bits == 1
    sniffs= zeros([216000,100]);
    dio_bits= zeros(216000,100);
end


TrialTemp = app.data_files.(fname).trials.start:app.data_files.(fname).trials.stop;

trialPass = 1;
all_licks=[];
for trialNo = TrialTemp
    %showing current trial and starting the timer
    disp(trialNo);
    tic

    drtaNWB_GetTraceData(app,trialNo,FileNum);

    NumDataPts = size(app.data_files.(fname).Signals.Digital,1);
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
    ElectrodDataPerTrialtemp(:,:) = app.data_files.(fname).Signals.Electrode(:,app.drta_Save.p.VisableChannel == 1);
    ElecCollected(1:NumDataPts,:,trialPass) = ElectrodDataPerTrialtemp;
    if NumAch > 1
        AnalogDataPerTrialtemp = nan([NumDataPts,NumAch]);
        AnalogDataPerTrialtemp(:,:) = app.data_files.(fname).Signals.Analog(:,app.drta_Save.p.VisableAnalog == 1);
        AnalogCollected(1:NumDataPts,:,trialPass) = AnalogDataPerTrialtemp(:,:);
        app.data_files.(fname).AlogData = AnalogDataPerTrialtemp;
    end
    if NumDch > 1
        DigitalDataPerTrialtemp = nan([NumDataPts,NumDch]);
        DigitalDataPerTrialtemp(:,:) = app.data_files.(fname).Signals.Digital(:,app.drta_Save.p.VisableDigital == 1);
        DitalCollected(1:NumDataPts,:,trialPass) = DigitalDataPerTrialtemp(:,:);
    end
    TrialIdx(trialPass,:) = [app.data_files.(fname).draq_d.start_blockNo(trialNo) app.data_files.(fname).draq_d.end_blockNo(trialNo)];
    %{
    Need to revise and make a call to the bitand that are used
    %}

    % needs to be revised!!!
    if app.data_files.(fname).draq_p.dgordra==1
        %This is a dra file
        datavec=DigitalDataPerTrialtemp(:,2);
        shiftdata=bitshift( bitand(datavec,248), -2);
    else
        %These are dg or rhd files
        if NumDch >= 2
            digi = DigitalDataPerTrialtemp(:,2);
        end
        if NumDch >= 8
            laser = DigitalDataPerTrialtemp(:,end-2);
        end
        shiftdata=bitand(digi,2+4+8+16);
        shiftdatablock=bitand(digi,1+2+4+8+16);
        shiftdatans=bitand(digi,1+2+4+8);
        shift_dropc_nsampler=bitand(digi,1+2+4+8+16+32);
        shift_dropc_nsampler=shiftdata(shift_dropc_nsampler<63);

    end

    app.data_files.(fname).sniffs(:,trialPass) = AnalogDataPerTrialtemp(:,1);
    app.data_files.(fname).dio_bits(:,trialPass) = AnalogDataPerTrialtemp(:,3);
    app.data_files.(fname).laser(:,trialPass) = AnalogDataPerTrialtemp(:,6);
    shiftdata30=shiftdata;
    shiftdata(1:int64(app.data_files.(fname).draq_p.ActualRate*app.data_files.(fname).p.exclude_secs))=0;
    shift_dropc_nsampler(1:int64(app.data_files.(fname).draq_p.ActualRate*app.data_files.(fname).p.exclude_secs))=0;

    %Exclude the trials that are off
    app.data_files.(fname).shiftdata30 = shiftdata30;
    app.data_files.(fname).TrialsSaved = trialNo;
    app.data_files.(fname).dropCsamples = shift_dropc_nsampler;
    app.data_files.(fname).shiftdata = shiftdata;
    
    programSwitch(app,2,FileNum);
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
programSwitch(app,3,FileNum);

%still needs revisions; this is a parfor that need to already have all the
%data in a cell array
% app.data_files.(fname)=drta03_ExcludeBadLFP(app,app.data_files.(fname));

app.data_files.(fname).final.Electorde = ElecCollected;
if NumAch > 1
    app.data_files.(fname).final.Analog = AnalogCollected;
end
if NumDch > 1
    app.data_files.(fname).final.Digital = DitalCollected;
end
app.data_files.(fname).final.Idx = TrialIdx;
app.data_files.(fname).final.Lick_thr = lick_thr;
