function presetControl(app,event)

tagName = event.Source.Tag;

switch tagName
    case 'PresetChoice'
        Fname = event.Source.Value;
        
        if Fname ~= "Manual"
            % electrode channels
            ChanSize = size(app.drta_Data.p.VisableChannel,1);
            PresetSize = app.drta_Main.LoadedPresets.(Fname).ChShown;
            if ChanSize ~= PresetSize
                app.drta_Data.p.VisableChannel(1:PresetSize) = app.drta_Main.LoadedPresets.(Fname).ChVisable;
            else
                app.drta_Data.p.VisableChannel = app.drta_Main.LoadedPresets.(Fname).ChVisable;
            end
            % digital channels
            ChanSize = size(app.drta_Data.p.VisableDigital,1);
            PresetSize = app.drta_Main.LoadedPresets.(Fname).DigitalShown;
            if ChanSize ~= PresetSize
                app.drta_Data.p.VisableDigital(1:PresetSize) = app.drta_Main.LoadedPresets.(Fname).DigitalVisable;
                app.drta_Main.ChannelNames.Digital(1:PresetSize) = app.drta_Main.LoadedPresets.(Fname).DigitalNames;
            else
                app.drta_Data.p.VisableDigital = app.drta_Main.LoadedPresets.(Fname).DigitalVisable;
                app.drta_Main.ChannelNames.Digital = app.drta_Main.LoadedPresets.(Fname).DigitalNames;
            end
            % analog channels
            ChanSize = size(app.drta_Data.p.VisableAnalog,1);
            PresetSize = app.drta_Main.LoadedPresets.(Fname).AnalogShown;
            if ChanSize ~= PresetSize
                app.drta_Data.p.VisableAnalog(1:PresetSize) = app.drta_Main.LoadedPresets.(Fname).AnalogVisable;
                app.drta_Main.ChannelNames.Analog(1:PresetSize) = app.drta_Main.LoadedPresets.(Fname).AnalogNames;
            else
                app.drta_Data.p.VisableAnalog = app.drta_Main.LoadedPresets.(Fname).AnalogVisable;
                app.drta_Main.ChannelNames.Analog = app.drta_Main.LoadedPresets.(Fname).AnalogNames;
            end
            ChReset.Source.Tag = "PresetCh";
            AllChControl(app,ChReset);
        end
    case 'LoadPresetChSelect'
        [ChosenFile, FileLoc] = uigetfile('*.mat','Select Channel Preset File');
        PresetFile = load(fullfile(FileLoc, ChosenFile));
        insidename = fieldnames(PresetFile.NewPreset);
        ChoiceName = PresetFile.NewPreset.(insidename{:}).PresetTag;
        app.drta_Main.LoadedPresets.(ChoiceName) = PresetFile.NewPreset.(insidename{:});
        DDchoice = app.drta_Main.ChannelPreset.DDchoice.Items;
        DDchoice(end+1) = {ChoiceName};
        app.drta_Main.ChannelPreset.DDchoice.Items = DDchoice;
    case 'CBsavePreset'
        app.drta_Main.ChannelPreset.PresestFileName.Enable = "on";
    case 'PresetSaveName'
        if ~isempty(app.drta_Main.ChannelPreset.PresestFileName.Value)
            app.drta_Main.ChannelPreset.SavePresetButton.Enable = "on";
        end
    case 'SavePreset'
        PresetName = app.drta_Main.ChannelPreset.PresestFileName.Value;
        NewPreset.(PresetName).PresetTag = PresetName;
        % electorde channels
        NewPreset.(PresetName).ChShown = size(app.drta_Data.p.VisableChannel,1);
        NewPreset.(PresetName).ChVisable = app.drta_Data.p.VisableChannel;
        % digital channels
        NewPreset.(PresetName).DigitalShown = size(app.drta_Data.p.VisableDigital,1);
        NewPreset.(PresetName).DigitalVisable = app.drta_Data.p.VisableDigital;
        NewPreset.(PresetName).DigitalNames = app.drta_Main.ChannelNames.Digital;
        % analog channels
        NewPreset.(PresetName).AnalogShown = size(app.drta_Data.p.VisableAnalog,1);
        NewPreset.(PresetName).AnalogVisable = app.drta_Data.p.VisableAnalog;
        NewPreset.(PresetName).AnalogNames = app.drta_Main.ChannelNames.Analog;

        DateNow = datetime('now','Format','dd-MMM-uuuu');
        TimeNowHour = datetime('now','Format','HH');
        TimeNowMin = datetime('now','Format','mm');
        saveFileName = append('ChPreset_',PresetName,'_',string(DateNow),'_',string(TimeNowHour),'h',string(TimeNowMin),'m.mat');
        saveFileName = fullfile(pwd,saveFileName);
        save(saveFileName,"NewPreset",'-v7.3');
        %adding preset to dropdown choice
        app.drta_Main.LoadedPresets.(PresetName) = NewPreset.(PresetName);
        DDchoice = app.drta_Main.ChannelPreset.DDchoice.Items;
        DDchoice(end+1) = {PresetName};
        app.drta_Main.ChannelPreset.DDchoice.Items = DDchoice;
end


