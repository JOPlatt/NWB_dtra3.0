% --- Executes on button press in drtaBrowseDraPush.
function drtaNWB_GetTraceData(app,Trials)


%Note: two bytes per sample (uint16)
if contains(app.drta_Data.drtaWhichFile,'rhd')
    %{
        For use with RHD file structure
    %}
    tic;
    fid = fopen(app.drta_Data.p.fullName, 'r');

    % s = dir(app.drta_Data.p.fullName);
    % filesize = s.bytes;

    %{
        Check 'magic number' at beginning of file to make sure 
        this is an Intan Technologies RHD2000 data file.
    %}
    magic_number = fread(fid, 1, 'uint32');
    if magic_number ~= hex2dec('c6912702')
        error('Unrecognized file type.');
    end

    % % Read version number.
    % data_file_main_version_number = fread(fid, 1, 'int16');
    % data_file_secondary_version_number = fread(fid, 1, 'int16');
    %
    %
    % if (data_file_main_version_number == 1)
    %     num_samples_per_data_block = 60;
    % else
    %     num_samples_per_data_block = 128;
    % end
    %
    amplifier_index = 1;
    board_adc_index = 1;
    board_dig_in_index = 1;

    num_amplifier_channels=app.drta_Data.draq_d.num_amplifier_channels;
    num_samples_per_data_block=app.drta_Data.draq_d.num_samples_per_data_block;
    num_board_adc_channels=app.drta_Data.draq_d.num_board_adc_channels;
    num_board_dig_in_channels=app.drta_Data.draq_d.num_board_dig_in_channels;

    startIdx = app.drta_Data.draq_d.start_blockNo(Trials(1));
    if size(Trials,2) > 2
        stopIdx = app.drta_Data.draq_d.end_blockNo(Trials(end));
    else
        stopIdx = app.drta_Data.draq_d.end_blockNo(Trials(1));
    end
    %Now read the data
    for i=startIdx:stopIdx
        %{
            NOTES:
            In version 1.2, we moved from saving timestamps as unsigned
            integeters to signed integers to accomidate negative (adjusted)
            timestamps for pretrigger data.
        %}


        %Read amplifier channels
        if (num_amplifier_channels > 0)
            fseek(fid,app.drta_Data.draq_d.offset_start_ch(i),'bof');
            amplifier_data(:, amplifier_index:(amplifier_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_amplifier_channels], 'uint16')';
        end

        if (num_board_adc_channels > 0)
            fseek(fid,app.drta_Data.draq_d.offset_start_adc(i),'bof');
            board_adc_data(:, board_adc_index:(board_adc_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_board_adc_channels], 'uint16')';
        end

        if (num_board_dig_in_channels > 0)
            fseek(fid,app.drta_Data.draq_d.offset_start_dig(i),'bof');
            board_dig_in_raw(:,board_dig_in_index:(board_dig_in_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_board_dig_in_channels], 'uint16')';
        end

        amplifier_index = amplifier_index + num_samples_per_data_block;
        board_adc_index = board_adc_index + num_samples_per_data_block;
        board_dig_in_index = board_dig_in_index + num_samples_per_data_block;

    end

    % Close data file.
    fclose(fid);

    szad=size(amplifier_data);
    analogSize = num_board_adc_channels;
    digitalSize = num_board_dig_in_channels;
    % ColumnTotal = szad(1)+analogSize+digitalSize+2;
    app.drta_Data.Signals.Electrode = zeros([szad(2),szad(1)]);
    app.drta_Data.Signals.Digital = zeros([szad(2),(digitalSize+1)]);
    app.drta_Data.Signals.Analog = zeros([szad(2),analogSize]);
    app.drta_Data.Signals.TrialNum = Trials;
    % data_this_trial=zeros(szad(2),ColumnTotal);
    

    % Scale voltage levels appropriately.
    if exist('amplifier_data','var')
        amplifier_data = 0.195 * (amplifier_data - 32768); % units = microvolts
        %Setup the output as used by drta
        %data_this_trial=zeros(length(digital_input),22);
        app.drta_Data.Signals.Electrode = amplifier_data';
    % else
    %     szadc=size(board_adc_data);
    %     data_this_trial=zeros(szadc(2),szadc(1));
    end
    % adding analog recording(s)
    if ~isempty(app.drta_Data.Signals.Analog)
        % unit conversion
        if (app.drta_Data.draq_d.eval_board_mode == 1)
            board_adc_data = 152.59e-6 * (board_adc_data - 32768); % units = volts
        elseif (app.drta_Data.draq_d.eval_board_mode == 13) % Intan Recording Controller
            board_adc_data = 312.5e-6 * (board_adc_data - 32768); % units = volts
        else
            board_adc_data = 50.354e-6 * board_adc_data; % units = volts
        end
        % adding data
        app.drta_Data.Signals.Analog = board_adc_data';
    end
    % adding digital recording(s)
    if ~isempty(app.drta_Data.Signals.Digital)
        % Extract digital input channels to separate variables.
        app.drta_Data.Signals.Digital(:,1:digitalSize) = board_dig_in_raw';
        % processing digital data
        bdirsz = size(board_dig_in_raw,2);
        nbdicsz = app.drta_Data.draq_d.num_board_dig_in_channels;
        board_dig_in_data = false([nbdicsz bdirsz]);
        for i=1:app.drta_Data.draq_d.num_board_dig_in_channels
            mask = 2^(app.drta_Data.draq_d.board_dig_in_channels(i).native_order) * ones([1,size(board_dig_in_raw,2)]);
            board_dig_in_data(i, :) = (bitand(board_dig_in_raw(i,:), mask) > 0);
        end
        for ii=1:app.drta_Data.draq_d.num_board_dig_in_channels
            if ii==1
                digital_input=board_dig_in_data(1,:);
            else
                digital_input=digital_input+(2^(ii-1))*board_dig_in_data(ii,:);
            end
        end
        app.drta_Data.Signals.Digital(:,end)=digital_input;
        if app.drta_Data.draq_d.num_board_dig_in_channels>=8
            app.drta_Data.Signals.Digital(:,end+1) = 1000*board_dig_in_data(8,:);
        end
    end
    % if app.drta_Data.draq_d.num_board_dig_in_channels>0
    %     %Enter the digital input channel
    %     %     digital_input=board_dig_in_data(1,:)+2*board_dig_in_data(2,:)+4*board_dig_in_data(3,:)...
    %     %         +8*board_dig_in_data(4,:)+16*board_dig_in_data(5,:)+32*board_dig_in_data(6,:)...
    %     %         +64*board_dig_in_data(7,:);
    % 
    % 
    % 
    %     %Enter the trigger (bit 8)
    %     if app.drta_Data.draq_d.num_board_dig_in_channels>=8
    %         data_this_trial(:,szad(1)+1)=1000*board_dig_in_data(8,:);
    %     end
    % 
    % end
% else
%     %{
%         For use with EDF file structure
%     %}
%     ptr_file=matfile([app.drta_Data.p.fullName(1:end-4) '_edf.mat']);
% 
%     data_this_trial=zeros(app.drta_Data.draq_p.sec_per_trigger*app.drta_Data.draq_p.ActualRate,22);
%     data_this_trial(:,1:ptr_file.no_columns)=ptr_file.data_out(app.drta_Data.draq_d.trial_ii_start(app.drta_Data.p.trialNo):app.drta_Data.draq_d.trial_ii_end(app.drta_Data.p.trialNo),:);
    % data_per_trial = data_this_trial;

end
