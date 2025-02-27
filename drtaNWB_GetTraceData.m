% --- Executes on button press in drtaBrowseDraPush.
function [data_this_trial]=drtaNWB_GetTraceData(handles)

%Note: two bytes per sample (uint16)
switch handles.draq_p.dgordra
    case 1
        %{
        This code for dra is old and likely does not work
        %}
        %
        handles.p.fid=fopen(handles.p.fullName,'rb');
        trialNo=handles.p.trialNo;
        offset=handles.draq_p.no_spike_ch*2*(sum(handles.draq_d.samplesPerTrial(1:handles.p.trialNo))-handles.draq_d.samplesPerTrial(handles.p.trialNo));
        fseek(handles.p.fid,offset,'bof');
        data_vec=fread(handles.p.fid,handles.draq_p.no_spike_ch*handles.draq_d.samplesPerTrial(handles.p.trialNo),'uint16');
        szdv=size(data_vec);
        data_this_trial=reshape(data_vec,szdv(1)/handles.draq_p.no_spike_ch,handles.draq_p.no_spike_ch);
        fclose(handles.p.fid);
    case 2
        %{
        For use with dg files structure
        %}
        %
        if handles.p.read_entire_file==1
            data_this_trial=[];
            trialNo=handles.p.trialNo;
            data_this_trial=handles.draq_d.data(floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*(trialNo-1)+1):...
                floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger*handles.draq_p.no_chans*trialNo)-2000);
            data=zeros(floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)-2000,handles.draq_p.no_chans);
            for ii=1:handles.draq_p.no_chans
                data_this_trial(:,ii)=data_this_trial(floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)+1:...
                    floor((ii-1)*handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)...
                    +floor(handles.draq_p.ActualRate*handles.draq_p.sec_per_trigger)-2000);
            end
        else
            handles.p.fid=fopen(handles.p.fullName,'rb');
            trial_no=handles.p.trialNo;
            bytes_per_native=2;     %Note: Native is unit16
            %{
            Note: Since 2013 DT3010 is acquiring at a rate that is not an integer.
            However, the program saves using an integer number of bytes!
            VERY Important!!!
            use uint64(handles.draq_p.ActualRate) below!!! 
            Nick George solved this problem!
            %}
            size_per_ch_bytes=handles.draq_p.sec_per_trigger*uint64(handles.draq_p.ActualRate)*bytes_per_native;
            no_unit16_per_ch=size_per_ch_bytes/bytes_per_native;
            trial_offset=handles.draq_p.no_chans*size_per_ch_bytes*(trial_no-1);
            for ii=1:handles.draq_p.no_chans
                status=fseek(handles.p.fid, (ii-1)*size_per_ch_bytes+trial_offset, 'bof');
                this_trial=[];
                this_trial=fread(handles.p.fid,no_unit16_per_ch,'uint16');
                data_this_trial(1:length(this_trial),ii)=this_trial;
            end
            fclose(handles.p.fid);
        end
    case 3
        %{
        For use with RHD file structure
        %}
        tic;
        fid = fopen(handles.p.fullName, 'r');

        s = dir(handles.p.fullName);
        filesize = s.bytes;

        %{
        Check 'magic number' at beginning of file to make sure 
        this is an Intan Technologies RHD2000 data file.
        %}
        magic_number = fread(fid, 1, 'uint32');
        if magic_number ~= hex2dec('c6912702')
            error('Unrecognized file type.');
        end

        % Read version number.
        data_file_main_version_number = fread(fid, 1, 'int16');
        data_file_secondary_version_number = fread(fid, 1, 'int16');


        if (data_file_main_version_number == 1)
            num_samples_per_data_block = 60;
        else
            num_samples_per_data_block = 128;
        end
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
                board_dig_in_raw(board_dig_in_index:(board_dig_in_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'uint16');
            end

            amplifier_index = amplifier_index + num_samples_per_data_block;
            board_adc_index = board_adc_index + num_samples_per_data_block;
            board_dig_in_index = board_dig_in_index + num_samples_per_data_block;

        end

        % Close data file.
        fclose(fid);

        % Extract digital input channels to separate variables.
        for i=1:handles.draq_d.num_board_dig_in_channels
            mask = 2^(handles.draq_d.board_dig_in_channels(i).native_order) * ones(size(board_dig_in_raw));
            board_dig_in_data(i, :) = (bitand(board_dig_in_raw, mask) > 0);
        end

        if exist('board_adc_data')~=0
            if (handles.draq_d.eval_board_mode == 1)
                board_adc_data = 152.59e-6 * (board_adc_data - 32768); % units = volts
            elseif (handles.draq_d.eval_board_mode == 13) % Intan Recording Controller
                board_adc_data = 312.5e-6 * (board_adc_data - 32768); % units = volts
            else
                board_adc_data = 50.354e-6 * board_adc_data; % units = volts
            end
        end
        % Scale voltage levels appropriately.
        if exist('amplifier_data')~=0
            amplifier_data = 0.195 * (amplifier_data - 32768); % units = microvolts
            szad=size(amplifier_data);

            %Setup the output as used by drta
            %data_this_trial=zeros(length(digital_input),22);
            data_this_trial=zeros(szad(2),22);

            %Enter the electrode recordings
            %{
            Note: for some reason Connor has the 32 channels on....
            %}
            if size(amplifier_data,1)==16
                data_this_trial(:,1:16)=amplifier_data';
            else
                data_this_trial(:,1:16)=amplifier_data(9:24,:)';
            end
        else
            szadc=size(board_adc_data);
            %Setup the output as used by drta
            %data_this_trial=zeros(length(digital_input),22);
            data_this_trial=zeros(szadc(2),22);
        end

        %Enter the four votage inputs: shiff, lick, photodiode and laser trigger
        if exist('board_adc_data')~=0
            szadc=size(board_adc_data);
            data_this_trial(:,18:18+szadc(1)-1)=board_adc_data(1:szadc(1),:)';
            if szadc(1)==8
                data_this_trial(:,21)=board_adc_data(5,:)'; %this is done because the laser was recorded in a different ADC channel by Kira and Daniel
            end
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
                data_this_trial(:,17)=1000*board_dig_in_data(8,:);
            end

            data_this_trial(:,22)=digital_input;
        end
        % data_per_trial = data_this_trial;
    case 4
        %{
        For use with EDF file structure
        %}
        ptr_file=matfile([handles.p.fullName(1:end-4) '_edf.mat']);

        data_this_trial=zeros(handles.draq_p.sec_per_trigger*handles.draq_p.ActualRate,22);
        data_this_trial(:,1:ptr_file.no_columns)=ptr_file.data_out(handles.draq_d.trial_ii_start(handles.p.trialNo):handles.draq_d.trial_ii_end(handles.p.trialNo),:);
        % data_per_trial = data_this_trial;

end
