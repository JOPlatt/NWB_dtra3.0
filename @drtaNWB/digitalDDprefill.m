function digitalDDprefill(app,event)
%{
This function prefills any bit intergers that have been selected along with
any digital channels used (defult is all channels)

Created by Jonathan Platt
%}

if class(event) == "matlab.ui.eventdata.ValueChangedData"
    fName = event.Value;
    if fName == "..."
        app.UpdateSelectedCh_Button.Visible = "off";
    else
        bitsUsed = app.drta_Main.digitalPlots.(fName).bitUsed;
        for bb = 1:size(bitsUsed,1)
            boxName = sprintf('CheckBox_%d',bb);
            app.(boxName).Value = bitsUsed(bb);
        end
        ChannelUsed = app.drta_Main.digitalPlots.(fName).ChUsed;
        fdNames = fieldnames(app.drta_Main.digitalPlots);
        digNames = contains(fdNames,'DigitalCh');
        fdNames = fdNames(digNames);
        for cc = 1:sum(digNames)
            app.drta_Main.digitalPlots.(fdNames{cc}).Value = ChannelUsed(cc);
        end
        % adding dataset
        % processing digital data
       
        app.UpdateSelectedCh_Button.Visible = "on";
    end
else
    fName = event;
    switch fName
        case "Digital_Input"
            app.drta_Main.digitalPlots.(fName).bitUsed = ones([8 1]);
            notUsed = [1 7 8];
            app.drta_Main.digitalPlots.(fName).bitUsed(notUsed) = 0;
            digChAmt = app.drta_Data.draq_d.num_board_dig_in_channels;
            app.drta_Main.digitalPlots.(fName).ChUsed = zeros([digChAmt 1]);
            app.drta_Main.digitalPlots.(fName).ChUsed(1) = 1;
            app.drta_Main.digitalPlots.plotNames(2) = {'Digital_Input'};
        otherwise
            app.drta_Main.digitalPlots.(fName).bitUsed = zeros([8 1]);
            digChAmt = app.drta_Data.draq_d.num_board_dig_in_channels;
            app.drta_Main.digitalPlots.(fName).ChUsed = ones([digChAmt 1]);
            app.drta_Main.digitalPlots.plotNames(end+1) = {fName};
    end
end
