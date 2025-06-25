% --- Executes on button press in drtaBrowseDraPush.
function [data_this_trial]=drtaNWB_GetTraceData(handles)


%Note: two bytes per sample (uint16)
if contains(handles.drtaWhichFile,'rhd')
    %{
        For use with RHD file structure
    %}
    tic;
    fid = fopen(handles.p.fullName, 'r');

    % s = dir(handles.p.fullName);
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

    num_amplifier_channels=handles.draq_d.num_amplifier_channels;
    num_samples_per_data_block=handles.draq_d.num_samples_per_data_block;
    num_board_adc_channels=handles.draq_d.num_board_adc_channels;
    num_board_dig_in_channels=handles.draq_d.num_board_dig_in_channels;

    %Now read the data
    for i=handles.draq_d.start_blockNo(handles.p.trialNo):handles.draq_d.end_blockNo(handles.p.trialNo)
        %{
            NOTES:
            In version 1.2, we moved from saving timestamps as unsigned
            integeters to signed integers to accomidate negative (adjusted)
            timestamps for pretrigger data.
        %}


        %Read amplifier channels
        if (num_amplifier_channels > 0)
            fseek(fid,handles.draq_d.offset_start_ch(i),'bof');
            amplifier_data(:, amplifier_index:(amplifier_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_amplifier_channels], 'uint16')';
        end

        if (num_board_adc_channels > 0)
            fseek(fid,handles.draq_d.offset_start_adc(i),'bof');
            board_adc_data(:, board_adc_index:(board_adc_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_board_adc_channels], 'uint16')';
        end

        if (num_board_dig_in_channels > 0)
            fseek(fid,handles.draq_d.offset_start_dig(i),'bof');
            board_dig_in_raw(board_dig_in_index:(board_dig_in_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'uint16')';
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
    ColumnTotal = szad(1)+analogSize+digitalSize+2;
    data_this_trial=zeros(szad(2),ColumnTotal);
    % Extract digital input channels to separate variables.
    bdirsz = size(board_dig_in_raw,2);
    nbdicsz = handles.draq_d.num_board_dig_in_channels;
    board_dig_in_data = false([nbdicsz bdirsz]);
    for i=1:handles.draq_d.num_board_dig_in_channels
        mask = 2^(handles.draq_d.board_dig_in_channels(i).native_order) * ones(size(board_dig_in_raw));
        board_dig_in_data(i, :) = (bitand(board_dig_in_raw, mask) > 0);
    end

    if exist('board_adc_data','var')
        if (handles.draq_d.eval_board_mode == 1)
            board_adc_data = 152.59e-6 * (board_adc_data - 32768); % units = volts
        elseif (handles.draq_d.eval_board_mode == 13) % Intan Recording Controller
            board_adc_data = 312.5e-6 * (board_adc_data - 32768); % units = volts
        else
            board_adc_data = 50.354e-6 * board_adc_data; % units = volts
        end
    end
    % Scale voltage levels appropriately.
    if exist('amplifier_data','var')
        amplifier_data = 0.195 * (amplifier_data - 32768); % units = microvolts
        %Setup the output as used by drta
        %data_this_trial=zeros(length(digital_input),22);
        
        data_this_trial(:,1:szad(1))=amplifier_data';

        
    else
        szadc=size(board_adc_data);
        data_this_trial=zeros(szadc(2),szadc(1));
    end
    % adding all digital recording to data matrix
    if exist('board_adc_data','var')
        szadc2=size(board_adc_data);
        if szadc2(1) == 6
            for bb = 1:4
                data_this_trial(:,szad(1)+1+bb) = board_adc_data(bb,:)';
            end
            for hh = 1:szadc2(1)-4
                plc = szad(1)+2+bb;
                data_this_trial(:,plc+hh) = board_adc_data(bb+hh,:)';
            end
        else
            for bb = 1:szadc2(1)
                data_this_trial(:,szad(1)+1+bb) = board_adc_data(bb,:)';
                plc = szad(1)+2+bb;
            end
        end
        % fullChsize = szadc2(1) + szad(1)+2;
        % data_this_trial(:,szad(1)+2:fullChsize-1) = board_adc_data';
        % if szadc2(1)==8
        %     data_this_trial(:,fullChsize-3)=board_adc_data(5,:)'; %this is done because the laser was recorded in a different ADC channel by Kira and Daniel
        % end
    else
        plc = szad(1)+handles.draq_d.num_board_dig_in_channels;
    end

    if handles.draq_d.num_board_dig_in_channels>0
        %Enter the digital input channel
        %     digital_input=board_dig_in_data(1,:)+2*board_dig_in_data(2,:)+4*board_dig_in_data(3,:)...
        %         +8*board_dig_in_data(4,:)+16*board_dig_in_data(5,:)+32*board_dig_in_data(6,:)...
        %         +64*board_dig_in_data(7,:);

        for ii=1:handles.draq_d.num_board_dig_in_channels
            if ii==1
                digital_input=board_dig_in_data(1,:);
            else
                digital_input=digital_input+(2^(ii-1))*board_dig_in_data(ii,:);
            end
        end

        %Enter the trigger (bit 8)
        if handles.draq_d.num_board_dig_in_channels>=8
            data_this_trial(:,szad(1)+1)=1000*board_dig_in_data(8,:);
        end
        data_this_trial(:,plc)=digital_input;
    end
else
    %{
        For use with EDF file structure
    %}
    ptr_file=matfile([handles.p.fullName(1:end-4) '_edf.mat']);

    data_this_trial=zeros(handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate,22);
    data_this_trial(:,1:ptr_file.no_columns)=ptr_file.data_out(handles.draq_d.trial_ii_start(handles.p.trialNo):handles.draq_d.trial_ii_end(handles.p.trialNo),:);
    % data_per_trial = data_this_trial;

end
