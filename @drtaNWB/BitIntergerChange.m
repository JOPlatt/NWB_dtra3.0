function BitIntergerChange(app,~)
%{
This function adjusts the logic of which bit intergers are used to process
the digital input data and the channels used.
%}

pName = app.DigitalChChoice_DropDown.Value;
bitsUsed = zeros([8 1]);
for bb = 1:size(bitsUsed,1)
    boxName = sprintf('CheckBox_%d',bb);
    bitsUsed(bb) = app.(boxName).Value;
end
app.drta_Main.digitalPlots.(pName).bitUsed = bitsUsed;
% checking to see what channel(s) are going to be used
ChannelUsed = zeros([app.drta_Data.draq_d.num_board_dig_in_channels 1]);
fdNames = fieldnames(app.drta_Main.digitalPlots);
digNames = contains(fdNames,'DigitalCh');
fdNames = fdNames(digNames);
for cc = 1:sum(digNames)
    ChannelUsed(cc) = app.drta_Main.digitalPlots.(fdNames{cc}).Value ;
end
app.drta_Main.digitalPlots.Digital_Input.ChUsed = ChannelUsed;
if pName == "Digital_Input"
    chanName = sprintf('DigitalCh02');
else
end
chfNames = fieldnames(app.DigitalFigures.DigiFig);
pcheck = contains(chfNames,chanName);
if sum(pcheck) ~= 0
    board_dig_in_raw = app.drta_Data.Signals.Digital(:,3:app.drta_Data.draq_d.num_board_dig_in_channels+2)';
    board_dig_in_raw = board_dig_in_raw(ChannelUsed == 1,:);
    dataSize = size(board_dig_in_raw);
    board_dig_in_data = zeros([app.drta_Data.draq_d.num_board_dig_in_channels dataSize(2)]);
    for i=1:app.drta_Data.draq_d.num_board_dig_in_channels
        mask = 2^(app.drta_Data.draq_d.board_dig_in_channels(i).native_order) * ones(size(board_dig_in_raw(1,:)));
        board_dig_in_data(i, :) = (bitand(board_dig_in_raw(1,:), mask) > 0);
    end

    for ii=1:app.drta_Data.draq_d.num_board_dig_in_channels
        if ii==1
            digital_input=board_dig_in_data(1,:);
        else
            digital_input=digital_input+(2^(ii-1))*board_dig_in_data(ii,:);
        end
    end
    pChLoc = cellfun(@(x) contains(x,pName),app.drta_Main.digitalPlots.plotNames);
    % adding processed digital input
    app.drta_Data.Signals.Digital(:,pChLoc)=digital_input;
    chN = app.drta_Main.digitalPlots.plotNames{pChLoc};
    bitValues = bitsUsed;
    bit_indices = [0,1,2,3,4,5,6,7];
    bit_mask = sum(2.^(bit_indices(bitValues == 1)));
    data_shown = digital_input;
    data_shown = bitand(data_shown,bit_mask);
    app.drta_Data.Signals.BitAndDigital.(chN) = data_shown;
    drta03_ShowDigital(app);

end

        