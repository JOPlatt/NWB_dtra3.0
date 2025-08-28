function ChannelsSaved(app)

channel_total = app.drta_Data.draq_d.num_amplifier_channels;
digital_total = app.drta_Data.draq_d.num_board_dig_in_channels + 2;
analog_total = app.drta_Data.draq_d.num_board_adc_channels;

app.drta_Save.p.VisableChannel = zeros([channel_total,1]);
for ct = 1:channel_total
    CurrentChNum = sprintf('ChCB%.3d',ct-1);
    app.drta_Save.p.VisableChannel(ct) = app.drta_Main.ChShown.(CurrentChNum).Value;
end

app.drta_Save.p.VisableDigital = zeros([digital_total,1]);
for dch = 1:digital_total
    if dch == 1
        digitalName2 = sprintf('Trigger');
    elseif dch == 2
        digitalName2 = sprintf('Dig_Input');
    else
        digitalName2 = sprintf('D_%.3d',dch-3);
    end
    app.drta_Save.p.VisableDigital(dch) = app.drta_Main.ChShown.(digitalName2).Value;
end

app.drta_Save.p.VisableAnalog = zeros([analog_total,1]);
for ach = 1:analog_total
CurrentChNum = sprintf('AnalogChCB%.3d',ach-1);
app.drta_Save.p.VisableAnalog(ach) = app.drta_Main.ChShown.(CurrentChNum).Value;
end

% digitalName2 = sprintf('bitand_%.2d',dch);
% app.drta_Main.digitalBitand.(digitalName2).Value