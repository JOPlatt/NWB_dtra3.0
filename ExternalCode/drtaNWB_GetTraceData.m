% --- Executes on button press in drtaBrowseDraPush.
function drtaNWB_GetTraceData(app,varargin)

Trials = varargin{1};
if nargin == 3
    FileNum = varargin{2};
    fname = sprintf('drtaFile%.3d',FileNum);
    DataSet = app.data_files.(fname);
    hasPlots = false;
else
    DataSet = app.drta_Data;
    hasPlots = true;
end
%Note: two bytes per sample (uint16)
if contains(DataSet.drtaWhichFile,'rhd')
    %{
        For use with RHD file structure
    %}
    tic;
    fid = fopen(DataSet.p.fullName, 'r');

    % s = dir(DataSet.p.fullName);
    % filesize = s.bytes;

    %{
        Check 'magic number' at beginning of file to make sure 
        this is an Intan Technologies RHD2000 data file.
    %}
    magic_number = fread(fid, 1, 'uint32');
    if magic_number ~= hex2dec('c6912702')
        error('Unrecognized file type.');
    end

    amplifier_index = 1;
    board_adc_index = 1;
    board_dig_in_index = 1;

    num_amplifier_channels=DataSet.draq_d.num_amplifier_channels;
    num_samples_per_data_block=DataSet.draq_d.num_samples_per_data_block;
    num_board_adc_channels=DataSet.draq_d.num_board_adc_channels;
    num_board_dig_in_channels=DataSet.draq_d.num_board_dig_in_channels;

    startIdx = DataSet.draq_d.start_blockNo(Trials(1));
    if size(Trials,2) >= 2
        stopIdx = DataSet.draq_d.end_blockNo(Trials(end));
    else
        stopIdx = DataSet.draq_d.end_blockNo(Trials(1));
    end
    %Now read the data
    for i=startIdx:stopIdx
        %Read amplifier channels
        if (num_amplifier_channels > 0)
            fseek(fid,DataSet.draq_d.offset_start_ch(i),'bof');
            amplifier_data(:, amplifier_index:(amplifier_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_amplifier_channels], 'uint16')';
        end

        if (num_board_adc_channels > 0)
            fseek(fid,DataSet.draq_d.offset_start_adc(i),'bof');
            board_adc_data(:, board_adc_index:(board_adc_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_board_adc_channels], 'uint16')';
        end

        if (num_board_dig_in_channels > 0)
            fseek(fid,DataSet.draq_d.offset_start_dig(i),'bof');
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
    DataSet.Signals.Electrode = zeros([szad(2),szad(1)]);
    DataSet.Signals.Digital = zeros([szad(2),(digitalSize+2)]);
    DataSet.Signals.Analog = zeros([szad(2),analogSize]);
    DataSet.Signals.TrialNum = Trials;
    % data_this_trial=zeros(szad(2),ColumnTotal);
    

    % Scale voltage levels appropriately.
    if exist('amplifier_data','var')
        amplifier_data = 0.195 * (amplifier_data - 32768); % units = microvolts
        %Setup the output as used by drta
        %data_this_trial=zeros(length(digital_input),22);
        DataSet.Signals.Electrode = amplifier_data';
    % else
    %     szadc=size(board_adc_data);
    %     data_this_trial=zeros(szadc(2),szadc(1));
    end
    % adding analog recording(s)
    if ~isempty(DataSet.Signals.Analog)
        % unit conversion
        if (DataSet.draq_d.eval_board_mode == 1)
            board_adc_data = 152.59e-6 * (board_adc_data - 32768); % units = volts
        elseif (DataSet.draq_d.eval_board_mode == 13) % Intan Recording Controller
            board_adc_data = 312.5e-6 * (board_adc_data - 32768); % units = volts
        else
            board_adc_data = 50.354e-6 * board_adc_data; % units = volts
        end
        % adding data
        DataSet.Signals.Analog = board_adc_data';
    end
    % adding digital recording(s)
    if ~isempty(DataSet.Signals.Digital)
        if hasPlots == true
            if app.drta_Main.digitalPlots.presetDone == false
                % AddDigitalPlot(app,sprintf('Trigger'));
                app.drta_Main.digitalPlots.plotNames(1) = {sprintf('Trigger')};
                AddDigitalPlot(app,sprintf('Digital_Input'));
                for kk = 1:DataSet.draq_d.num_board_dig_in_channels
                    app.drta_Main.digitalPlots.plotNames(kk+2) = {sprintf('DigitalCh%.3d',kk+1)};
                end
                app.drta_Main.digitalPlots.presetDone = true;
            end
        end
        % Extract digital input channels to separate variables.
        DataSet.Signals.Digital(:,3:end) = board_dig_in_raw';
        dataSize = size(board_dig_in_raw);
        board_dig_in_data = zeros([dataSize(1) dataSize(2)]);
        for i=1:DataSet.draq_d.num_board_dig_in_channels
            mask = 2^(DataSet.draq_d.board_dig_in_channels(i).native_order) * ones(size(board_dig_in_raw(1,:)));
            board_dig_in_data(i, :) = (bitand(board_dig_in_raw(1,:), mask) > 0);
        end
        for ii=1:DataSet.draq_d.num_board_dig_in_channels
            if ii==1
                digital_input=board_dig_in_data(1,:);
            else
                digital_input=digital_input+(2^(ii-1))*board_dig_in_data(ii,:);
            end
        end
        % adding processed digital input
        DataSet.Signals.Digital(:,2)=digital_input;
        % this adds the trigger processed data resultes
        if DataSet.draq_d.num_board_dig_in_channels >= 8
            DataSet.Signals.Digital(:,1) = 1000*board_dig_in_data(8,:);
        end
    end

end
if nargin == 3
    FileNum = varargin{2};
    fname = sprintf('drtaFile%.3d',FileNum);
    app.data_files.(fname) = DataSet;
else
    app.drta_Data = DataSet;
end