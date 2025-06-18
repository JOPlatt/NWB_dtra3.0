classdef drtaNWB_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        TabGroup                    matlab.ui.container.TabGroup
        drta_loadTab                matlab.ui.container.Tab
        GridLayoutLoad              matlab.ui.container.GridLayout
        CreateNWBfile_Button        matlab.ui.control.Button
        MetaDataProtocolLabel       matlab.ui.control.Label
        DisplayProtocolLabel        matlab.ui.control.Label
        Cprogrom_DropDown           matlab.ui.control.DropDown
        Savematfile_Button          matlab.ui.control.Button
        OutputLocationLabel         matlab.ui.control.Label
        LocationForOutput           matlab.ui.control.TextArea
        ChooseOutputLocationButton  matlab.ui.control.Button
        file_name                   matlab.ui.control.TextArea
        trial_amt                   matlab.ui.control.NumericEditField
        Trial_Label                 matlab.ui.control.Label
        dt_amt                      matlab.ui.control.NumericEditField
        dt_Label                    matlab.ui.control.Label
        protocolDropDown            matlab.ui.control.DropDown
        ProgressReadout             matlab.ui.control.TextArea
        Load_Button                 matlab.ui.control.StateButton
        copyright_Label             matlab.ui.control.Label
        SelectFile_Button           matlab.ui.control.StateButton
        ElectrodChannelsTab         matlab.ui.container.Tab
        GridLayoutTraces            matlab.ui.container.GridLayout
        ElectrodAllPlot_GridLayout  matlab.ui.container.GridLayout
        E_AllPlots_Label            matlab.ui.control.Label
        E_all_CheckBox              matlab.ui.control.CheckBox
        SaveChennels_Button         matlab.ui.control.Button
        Filterorder_EditField       matlab.ui.control.NumericEditField
        Filterorder_Label           matlab.ui.control.Label
        StatusLFP_TextArea          matlab.ui.control.TextArea
        ShiftDropcBitand_EditField  matlab.ui.control.NumericEditField
        DataShiftBitand_EditField   matlab.ui.control.NumericEditField
        Shift_dropc_Bitand_Label    matlab.ui.control.Label
        Data_Shift_Bitand_Label     matlab.ui.control.Label
        UpdateLFPPlot_Button        matlab.ui.control.Button
        ExtraFigureOptions_Button   matlab.ui.control.StateButton
        Plot_Panel                  matlab.ui.container.Panel
        Plot_mainGrid               matlab.ui.container.GridLayout
        figurePlot_UIAxes           matlab.ui.control.UIAxes
        TrialOutcome                matlab.ui.control.Label
        SaveBrowseTracesPlotButton  matlab.ui.control.StateButton
        thr_Label                   matlab.ui.control.Label
        thr_amt                     matlab.ui.control.NumericEditField
        nxSD_amt                    matlab.ui.control.NumericEditField
        nxSD_Label                  matlab.ui.control.Label
        max_amt                     matlab.ui.control.NumericEditField
        max_Label                   matlab.ui.control.Label
        min_Label                   matlab.ui.control.Label
        min_amt                     matlab.ui.control.NumericEditField
        Diff_CheckBox               matlab.ui.control.CheckBox
        MClust_Button               matlab.ui.control.StateButton
        Licks_CheckBox              matlab.ui.control.CheckBox
        Yrange_DropDown             matlab.ui.control.DropDown
        Choice_DropDown             matlab.ui.control.DropDown
        Tnum_Label                  matlab.ui.control.Label
        Interval_Label              matlab.ui.control.Label
        Interval_amt                matlab.ui.control.NumericEditField
        Tnum_amt                    matlab.ui.control.NumericEditField
        Tnum_Rarrow                 matlab.ui.control.Button
        Tnum_Larrow                 matlab.ui.control.Button
        Yrange_amt                  matlab.ui.control.NumericEditField
        Yrange_Label                matlab.ui.control.Label
        uV_Label                    matlab.ui.control.Label
        Digital_Traces_Tab          matlab.ui.container.Tab
        DigitalMain_GridLayout      matlab.ui.container.GridLayout
        ControlsLabel               matlab.ui.control.Label
        DigitalTracesLabel          matlab.ui.control.Label
        DigitalControls_Grid        matlab.ui.container.GridLayout
        DigitalAllPlot_GridLayout   matlab.ui.container.GridLayout
        D_AllPlots_Label            matlab.ui.control.Label
        D_all_CheckBox              matlab.ui.control.CheckBox
        StatusDiff_TextArea         matlab.ui.control.TextArea
        Trace_ylimtsMax_EditField   matlab.ui.control.NumericEditField
        Trace_ylimitsMin_EditField  matlab.ui.control.NumericEditField
        Trace_ylimits_Label         matlab.ui.control.Label
        ShiftDataBitand_EditField   matlab.ui.control.NumericEditField
        Shiftdatabitand_Label       matlab.ui.control.Label
        ShiftBitand_EditField       matlab.ui.control.NumericEditField
        Shiftdropcbitand_Label      matlab.ui.control.Label
        UpdateDigitPlots_Button     matlab.ui.control.Button
        IntervalSecDigit_EditField  matlab.ui.control.NumericEditField
        IntervalSecDigit_Label      matlab.ui.control.Label
        TrialNoDigitNext_Button     matlab.ui.control.Button
        TrialNoDigitPrior_Button    matlab.ui.control.Button
        TrialNoDigit_EditField      matlab.ui.control.NumericEditField
        TrialNoDigit_Label          matlab.ui.control.Label
        ExcLicks_Label              matlab.ui.control.Label
        ExcLicks_CheckBox           matlab.ui.control.CheckBox
        DigitalPlot_Grid            matlab.ui.container.GridLayout
        AnalogChannelsTab           matlab.ui.container.Tab
        Analogmain_GridLayout       matlab.ui.container.GridLayout
        AnalogFigure_GridLayout     matlab.ui.container.GridLayout
        AnalogControl_Panel         matlab.ui.container.Panel
        Analogcontrols_GridLayout   matlab.ui.container.GridLayout
        AllPlotsAnalog_GridLayout   matlab.ui.container.GridLayout
        A_AllPlots_Label            matlab.ui.control.Label
        A_all_CheckBox              matlab.ui.control.CheckBox
        AnalogInterval_EditField    matlab.ui.control.NumericEditField
        AnalogInterval_Label        matlab.ui.control.Label
        AnalogUpdatePlotButton      matlab.ui.control.Button
        Analogupdate_TextArea       matlab.ui.control.TextArea
        TrialNumberLabel            matlab.ui.control.Label
        Analogtrial_EditField       matlab.ui.control.NumericEditField
        AnalognextTrial_Button      matlab.ui.control.Button
        AnalogpriorTrial_Button     matlab.ui.control.Button
        SelectChannelsTab           matlab.ui.container.Tab
        ChannelPanel                matlab.ui.container.Panel
        Channels_GridLayout         matlab.ui.container.GridLayout
    end


    properties (Access = public)
        drta_Main % Links the main application
        drta_handles = struct(); % Description
        drta_Plot % Description
        OutputText % This is the text that is displayed on the GUI
        LFPOutputText = string; % text that gives status updates for the LFP plots
        DiffOutputText = string; % text that give status updates for diff plots
        PIDOutputText = string; % text that give status updates for PID plots
        FlagAlpha %  Flag is used to indicate the first call to readout
        AnalogFigures % houses analog information
        %         outputTextDisplay % Houses the text for the files that are created
        NWBFileName     % File name that will be used for the NWB file
        OutputLocation % Location of output files
        BatchFiles = struct();% Structure containing all the batch file inforation
        rhd = struct(); % Structure containing current .rhd file
        h % pointer for browse traces
        Flags = struct; % Description
        DigitalFigures % houses digital information
    end

    methods (Access = public)

        open_rhd_Callback(app) % load rhd file
        drtaOpenDG_Callback(app) % load dg file
        VarUpdate(app,Vname,Vupdate) % updates drta variable
        actualTrialNo = setTrialNo(app,trialNo) % sets the current trial number
        drtaNWB_figureControl(app) % updates the plots
        ElectrodCheckboxCreate(app) % creating electord checkboxes
        AppTypeSwitchStation(app) % switch stations for file type
        drta03_SetPreferences(app) % setting drta specific preferences
        % [varargout] = drta03_read_Intan_RHD2000_header(app) % updated function for drta 3.0
        ChooseFileToLoad(app) % choosing which file will be loaded
        LoadingChosenFile(app) % loading the file that was chosen
        ExtraImageOptions(app)
        DropChoiceDropDown(app) % sets the method for how the data is processed
        drta03_ShowDigital(app) % plotting digital figure
        VisualChoice(app) % sets the visual choice dropdown value
        TrialNumChange(app,event) % changes the trial number
        LFPplotChange(app,event) % handles user input changes for LFP plot
        SaveFile(app) % saving output
        ShowingDiffCheckbox(app) % creates the structure for dropdown obj
        PlotStatusUpdate(app,textUpdate,WhichOne) % status updates for LFP plots
        FigureSaving(app,varargin) % saving figures
        AllChControl(app,event) % all channel controls
        presetControl(app,event) % channel preset controls
        XintervalControl(app,event) % determines if all plots are at the same x-axis interval
        ElectDataPlotSave(app,varargin) % saves electrode channels data being displayed
        YrangeChange(app,varargin) %Controls the y-range for each electrode plot
    end

        
        


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %{
            This block starts a python env that allows any library to be
            used. The batch file strucutre is started along with
            determining which mode is being requested.
            %}
            % pyenv("ExecutionMode","OutOfProcess")
            % app.BatchFiles.table = table('size',[50,1],'VariableTypes',"cell");
            % app.BatchFiles.amt = 0;
            % app.BatchFiles.totCount = 0;
            %{
            Flags for setting different conditions
            %}
            app.Flags.ChannelSetup = true;
            app.Flags.fileLoaded = false;
            %{
            Setting inital valses for calling this app in other functions
            %}
            % app.drta_handles.output = app;
            % app.drta_handles.w.drta = app;
            app.drta_handles.time_before_FV = 1;
            app.drta_handles.w.drtaBrowseTraces=0;
            app.drta_handles.w.drtaThresholdSnips=0;
            %
            drta03_SetPreferences(app)
            app.Flags.RunningWhat = 2;





        end

        % Value changed function: AnalogInterval_EditField, 
        % ...and 2 other components
        function Interval_amtValueChanged(app, event)
            switch event.Source.Tag
                case 'InterLFP'
                    CH.Source.Tag = "Electrod_All";
                case 'InterDigi'
                    CH.Source.Tag = "Digital_All";
                case 'InterAnalog'
                    CH.Source.Tag = "Analog_All";
            end
            XintervalControl(app,CH);
        end

        % Callback function: AnalognextTrial_Button, 
        % ...and 8 other components
        function TrialNum_ButtonPushed(app, event)
            TrialNumChange(app,event)
            textUpdate = ['Updating plot to show tiral ', ...
                num2str(app.TrialNoDigit_EditField.Value)];
            PlotStatusUpdate(app,textUpdate,1)
            PlotStatusUpdate(app,textUpdate,2)
            PlotStatusUpdate(app,textUpdate,3)
            textUpdate = sprintf('Please wait ');
            PlotStatusUpdate(app,textUpdate,1)
            PlotStatusUpdate(app,textUpdate,2)
            PlotStatusUpdate(app,textUpdate,3)
            VisualChoice(app);
            drtaNWB_figureControl(app);
            drta03_ShowDigital(app);
            GenerateAnalogFigures(app);
            
            textUpdate = ['Plot updated, now showing tiral ' ...
                num2str(app.TrialNoDigit_EditField.Value)];
            PlotStatusUpdate(app,textUpdate,1)
            PlotStatusUpdate(app,textUpdate,2)
            PlotStatusUpdate(app,textUpdate,3)

        end

        % Value changed function: MClust_Button
        function MClust_ButtonValueChanged(app, event)
            textUpdate = "Generating MClust files, Please wait.";
            PlotStatusUpdate(app,textUpdate,1)
            app.MClust_Button.Enable = "off";
            drta03_GenerateMClust(app);
            textUpdate = "MClust files saved";
            PlotStatusUpdate(app,textUpdate,1)
        end

        % Value changed function: Licks_CheckBox
        function Licks_CheckBoxValueChanged(app, event)
            app.drta_handles.p.exc_sn = app.Licks_CheckBox.Value;
            VarUpdate(app,"exc_sn",app.drta_handles.p.exc_sn)
        end

        % Value changed function: min_amt
        function ValueAmt_Changed(app, event)
            LFPplotChange(app,event)
        end

        % Value changed function: SaveBrowseTracesPlotButton
        function SaveBrowseTracesPlotButtonValueChanged(app, event)
            textUpdate = "Saving current figure";
            if event.Source.Tag == "LFPsave"
                CurrentPlot = app.figurePlot_UIAxes;
                PlotStatusUpdate(app,textUpdate,1)
            end
            FigureSaving(app,CurrentPlot,1)
            textUpdate = "Figure saved";
            if event.Source.Tag == "LFPsave"
                PlotStatusUpdate(app,textUpdate,1)
            end
        end

        % Value changed function: Load_Button
        function Load_ButtonValueChanged(app, event)
            %{
            Loading the file that the user selected and opening the visual
            GUI for user interaction.
            %}
            LoadingChosenFile(app);
            app.Tnum_amt.Limits = [1,app.drta_handles.draq_d.noTrials];
            app.TrialNoDigit_EditField.Limits = [1,app.drta_handles.draq_d.noTrials];
            app.Analogtrial_EditField.Limits = [1,app.drta_handles.draq_d.noTrials];
           
        end

        % Value changed function: SelectFile_Button
        function SelectFile_ButtonValueChanged(app, event)
            %{
            Calling a user interface to select the file that needs to be
            opened. The output is the file name and path.
            %}
            ChooseFileToLoad(app);
        end

        % Callback function: ChooseOutputLocationButton, LocationForOutput
        function ChooseOutputLocationButtonPushed(app, event)
            switch event.Source.Tag
                case 'buttonOutput'
                    [Fpath] = uigetdir();
                    app.LocationForOutput.Value = Fpath;
                    app.ChooseOutputLocationButton.Visible = "off";
                    app.OutputLocationLabel.Visible = "on";
                    app.Savematfile_Button.Visible = "on";
                case 'manualOutput'
                    Fpath = app.LocationForOutput.Value;
            end
            app.OutputLocation = Fpath;
            
            
        end

        % Value changed function: Diff_CheckBox
        function Diff_CheckBoxValueChanged(app, event)
            ShowingDiffCheckbox(app)
        end

        % Callback function: ElectrodChannelsTab, UpdateLFPPlot_Button
        function Browse_TracesTabButtonDown(app, event)
            textUpdate = "Updating Plot, Please wait.";
            PlotStatusUpdate(app,textUpdate,1)
            if app.Flags.fileLoaded == true
                VisualChoice(app);
                drtaNWB_figureControl(app);
            end
            textUpdate = "Plot Updated";
            PlotStatusUpdate(app,textUpdate,1)
        end

        % Value changed function: ExtraFigureOptions_Button
        function ExtraFigureOptions_ButtonValueChanged(app, event)
            if app.ExtraFigureOptions_Button.Value == 1
                app.ExtraFigureOptions_Button.Enable = "off";
                ExtraFigOptions(app);
            end
            
        end

        % Callback function: Digital_Traces_Tab, UpdateDigitPlots_Button
        function UpdateDigitPlots_ButtonPushed(app, event)
            textUpdate = "Updating Plot, Please wait.";
            PlotStatusUpdate(app,textUpdate,2);
            drta03_ShowDigital(app);
            textUpdate = "Plot Updated";
            PlotStatusUpdate(app,textUpdate,2);
        end

        % Button pushed function: Savematfile_Button
        function Savematfile_ButtonPushed(app, event)
            ReadoutUpdate(app,'Saving jt_times file.')
            SaveFile(app)
            ReadoutUpdate(app,'File saved.')
        end

        % Value changed function: Yrange_DropDown, Yrange_amt
        function ElectrodeYrangeChange(app, event)
            YrangeChange(app);
            
        end

        % Button pushed function: CreateNWBfile_Button
        function CreateNWBfile(app, event)
            NWBmakefile(app);
        end

        % Callback function: AnalogChannelsTab, AnalogUpdatePlotButton
        function AnalogTab_update(app, event)
                textUpdate = "Updating Plot, Please wait.";
                PlotStatusUpdate(app,textUpdate,3);
                GenerateAnalogFigures(app);
                textUpdate = "Plot Updated";
                PlotStatusUpdate(app,textUpdate,3);
        end

        % Value changed function: A_all_CheckBox, D_all_CheckBox, 
        % ...and 1 other component
        function Xaxis_Interval_control(app, event)
            XintervalControl(app,event);
        end

        % Button pushed function: SaveChennels_Button
        function SaveCurrentElectordPlotData(app, event)
            ElectDataPlotSave(app,event);
            textUpdate = "Selected electrodes have been saved";
            PlotStatusUpdate(app,textUpdate,1)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [527 219 1134 817];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Scrollable = 'on';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 1134 817];

            % Create drta_loadTab
            app.drta_loadTab = uitab(app.TabGroup);
            app.drta_loadTab.Title = 'drta_load';

            % Create GridLayoutLoad
            app.GridLayoutLoad = uigridlayout(app.drta_loadTab);
            app.GridLayoutLoad.ColumnWidth = {20, 20, 120, 40, 95, 40, 100, 400, '1x'};
            app.GridLayoutLoad.RowHeight = {20, 50, 10, 40, 15, 40, 20, 30, 20, 30, 20, 30, 15, 15, 15, 15, 15, 30, '1x', 20};

            % Create SelectFile_Button
            app.SelectFile_Button = uibutton(app.GridLayoutLoad, 'state');
            app.SelectFile_Button.ValueChangedFcn = createCallbackFcn(app, @SelectFile_ButtonValueChanged, true);
            app.SelectFile_Button.Text = 'Choose File (.rhd or .edf)';
            app.SelectFile_Button.Layout.Row = 4;
            app.SelectFile_Button.Layout.Column = [2 4];

            % Create copyright_Label
            app.copyright_Label = uilabel(app.GridLayoutLoad);
            app.copyright_Label.HorizontalAlignment = 'center';
            app.copyright_Label.Layout.Row = 17;
            app.copyright_Label.Layout.Column = 8;
            app.copyright_Label.Text = 'drta version 3.0 copyright Diego Restrepo';

            % Create Load_Button
            app.Load_Button = uibutton(app.GridLayoutLoad, 'state');
            app.Load_Button.ValueChangedFcn = createCallbackFcn(app, @Load_ButtonValueChanged, true);
            app.Load_Button.Visible = 'off';
            app.Load_Button.Text = 'Load File';
            app.Load_Button.Layout.Row = [16 17];
            app.Load_Button.Layout.Column = [3 4];

            % Create ProgressReadout
            app.ProgressReadout = uitextarea(app.GridLayoutLoad);
            app.ProgressReadout.Layout.Row = [2 15];
            app.ProgressReadout.Layout.Column = 8;

            % Create protocolDropDown
            app.protocolDropDown = uidropdown(app.GridLayoutLoad);
            app.protocolDropDown.Items = {'...'};
            app.protocolDropDown.Visible = 'off';
            app.protocolDropDown.FontName = 'Times New Roman';
            app.protocolDropDown.Layout.Row = 8;
            app.protocolDropDown.Layout.Column = [2 3];
            app.protocolDropDown.Value = '...';

            % Create dt_Label
            app.dt_Label = uilabel(app.GridLayoutLoad);
            app.dt_Label.Visible = 'off';
            app.dt_Label.Layout.Row = 10;
            app.dt_Label.Layout.Column = [2 3];
            app.dt_Label.Text = 'dt before odor end (s)';

            % Create dt_amt
            app.dt_amt = uieditfield(app.GridLayoutLoad, 'numeric');
            app.dt_amt.Visible = 'off';
            app.dt_amt.Layout.Row = 10;
            app.dt_amt.Layout.Column = 5;
            app.dt_amt.Value = 6;

            % Create Trial_Label
            app.Trial_Label = uilabel(app.GridLayoutLoad);
            app.Trial_Label.Visible = 'off';
            app.Trial_Label.Layout.Row = 12;
            app.Trial_Label.Layout.Column = [2 3];
            app.Trial_Label.Text = 'Trial duration (s)';

            % Create trial_amt
            app.trial_amt = uieditfield(app.GridLayoutLoad, 'numeric');
            app.trial_amt.Visible = 'off';
            app.trial_amt.Layout.Row = 12;
            app.trial_amt.Layout.Column = 5;
            app.trial_amt.Value = 9;

            % Create file_name
            app.file_name = uitextarea(app.GridLayoutLoad);
            app.file_name.HorizontalAlignment = 'center';
            app.file_name.Layout.Row = 6;
            app.file_name.Layout.Column = [2 6];
            app.file_name.Value = {'No File Selected'};

            % Create ChooseOutputLocationButton
            app.ChooseOutputLocationButton = uibutton(app.GridLayoutLoad, 'push');
            app.ChooseOutputLocationButton.ButtonPushedFcn = createCallbackFcn(app, @ChooseOutputLocationButtonPushed, true);
            app.ChooseOutputLocationButton.Tag = 'buttonOutput';
            app.ChooseOutputLocationButton.Layout.Row = [13 14];
            app.ChooseOutputLocationButton.Layout.Column = [2 3];
            app.ChooseOutputLocationButton.Text = 'Choose Output Location';

            % Create LocationForOutput
            app.LocationForOutput = uitextarea(app.GridLayoutLoad);
            app.LocationForOutput.ValueChangedFcn = createCallbackFcn(app, @ChooseOutputLocationButtonPushed, true);
            app.LocationForOutput.Tag = 'manualOutput';
            app.LocationForOutput.Layout.Row = [13 14];
            app.LocationForOutput.Layout.Column = [4 6];

            % Create OutputLocationLabel
            app.OutputLocationLabel = uilabel(app.GridLayoutLoad);
            app.OutputLocationLabel.Visible = 'off';
            app.OutputLocationLabel.Layout.Row = [13 14];
            app.OutputLocationLabel.Layout.Column = 3;
            app.OutputLocationLabel.Text = 'Output Location';

            % Create Savematfile_Button
            app.Savematfile_Button = uibutton(app.GridLayoutLoad, 'push');
            app.Savematfile_Button.ButtonPushedFcn = createCallbackFcn(app, @Savematfile_ButtonPushed, true);
            app.Savematfile_Button.Enable = 'off';
            app.Savematfile_Button.Layout.Row = [16 17];
            app.Savematfile_Button.Layout.Column = [5 6];
            app.Savematfile_Button.Text = 'Save jt_Time file';

            % Create Cprogrom_DropDown
            app.Cprogrom_DropDown = uidropdown(app.GridLayoutLoad);
            app.Cprogrom_DropDown.Items = {'dropcnsampler', 'dropcspm', 'background', 'spmult', 'mspy', 'osampler', 'spm2mult', 'lighton1', 'lighton5', 'dropcspm_conc', 'Laser-triggered', 'Laser-Merouann', 'dropcspm_hf', 'Working_memory', 'Continuous', 'Laser-Kira', 'Laser-Schoppa'};
            app.Cprogrom_DropDown.Visible = 'off';
            app.Cprogrom_DropDown.Layout.Row = 8;
            app.Cprogrom_DropDown.Layout.Column = [5 6];
            app.Cprogrom_DropDown.Value = 'dropcnsampler';

            % Create DisplayProtocolLabel
            app.DisplayProtocolLabel = uilabel(app.GridLayoutLoad);
            app.DisplayProtocolLabel.HorizontalAlignment = 'center';
            app.DisplayProtocolLabel.FontName = 'Times New Roman';
            app.DisplayProtocolLabel.Visible = 'off';
            app.DisplayProtocolLabel.Layout.Row = 7;
            app.DisplayProtocolLabel.Layout.Column = [2 3];
            app.DisplayProtocolLabel.Text = 'Display Protocol';

            % Create MetaDataProtocolLabel
            app.MetaDataProtocolLabel = uilabel(app.GridLayoutLoad);
            app.MetaDataProtocolLabel.HorizontalAlignment = 'center';
            app.MetaDataProtocolLabel.FontName = 'Times New Roman';
            app.MetaDataProtocolLabel.Visible = 'off';
            app.MetaDataProtocolLabel.Layout.Row = 7;
            app.MetaDataProtocolLabel.Layout.Column = [5 6];
            app.MetaDataProtocolLabel.Text = 'Meta Data Protocol';

            % Create CreateNWBfile_Button
            app.CreateNWBfile_Button = uibutton(app.GridLayoutLoad, 'push');
            app.CreateNWBfile_Button.ButtonPushedFcn = createCallbackFcn(app, @CreateNWBfile, true);
            app.CreateNWBfile_Button.Enable = 'off';
            app.CreateNWBfile_Button.Visible = 'off';
            app.CreateNWBfile_Button.Layout.Row = 18;
            app.CreateNWBfile_Button.Layout.Column = 3;
            app.CreateNWBfile_Button.Text = 'Create NWB file';

            % Create ElectrodChannelsTab
            app.ElectrodChannelsTab = uitab(app.TabGroup);
            app.ElectrodChannelsTab.AutoResizeChildren = 'off';
            app.ElectrodChannelsTab.Title = 'Electrod Channels';
            app.ElectrodChannelsTab.ButtonDownFcn = createCallbackFcn(app, @Browse_TracesTabButtonDown, true);

            % Create GridLayoutTraces
            app.GridLayoutTraces = uigridlayout(app.ElectrodChannelsTab);
            app.GridLayoutTraces.ColumnWidth = {79, 38, '1.95x', 82, '1x', 84, 66, 85, '1x', 84, 50, 50, 50};
            app.GridLayoutTraces.RowHeight = {10, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 40, '1x'};
            app.GridLayoutTraces.ColumnSpacing = 8.93749237060547;
            app.GridLayoutTraces.RowSpacing = 6.24249877929688;
            app.GridLayoutTraces.Padding = [8.93749237060547 6.24249877929688 8.93749237060547 6.24249877929688];

            % Create uV_Label
            app.uV_Label = uilabel(app.GridLayoutTraces);
            app.uV_Label.HorizontalAlignment = 'center';
            app.uV_Label.Layout.Row = [1 2];
            app.uV_Label.Layout.Column = 2;
            app.uV_Label.Text = 'uV';

            % Create Yrange_Label
            app.Yrange_Label = uilabel(app.GridLayoutTraces);
            app.Yrange_Label.Layout.Row = 27;
            app.Yrange_Label.Layout.Column = 10;
            app.Yrange_Label.Text = 'Y Range (uV):';

            % Create Yrange_amt
            app.Yrange_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.Yrange_amt.ValueChangedFcn = createCallbackFcn(app, @ElectrodeYrangeChange, true);
            app.Yrange_amt.HorizontalAlignment = 'center';
            app.Yrange_amt.Layout.Row = 27;
            app.Yrange_amt.Layout.Column = 11;
            app.Yrange_amt.Value = 4000;

            % Create Tnum_Larrow
            app.Tnum_Larrow = uibutton(app.GridLayoutTraces, 'push');
            app.Tnum_Larrow.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.Tnum_Larrow.Tag = 'TnumMinus';
            app.Tnum_Larrow.Layout.Row = 25;
            app.Tnum_Larrow.Layout.Column = 12;
            app.Tnum_Larrow.Text = '<--';

            % Create Tnum_Rarrow
            app.Tnum_Rarrow = uibutton(app.GridLayoutTraces, 'push');
            app.Tnum_Rarrow.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.Tnum_Rarrow.Tag = 'TnumPlus';
            app.Tnum_Rarrow.Layout.Row = 25;
            app.Tnum_Rarrow.Layout.Column = 13;
            app.Tnum_Rarrow.Text = '-->';

            % Create Tnum_amt
            app.Tnum_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.Tnum_amt.ValueChangedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.Tnum_amt.Tag = 'TnumField';
            app.Tnum_amt.HorizontalAlignment = 'center';
            app.Tnum_amt.Layout.Row = 25;
            app.Tnum_amt.Layout.Column = 11;
            app.Tnum_amt.Value = 1;

            % Create Interval_amt
            app.Interval_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.Interval_amt.ValueChangedFcn = createCallbackFcn(app, @Interval_amtValueChanged, true);
            app.Interval_amt.Tag = 'InterLFP';
            app.Interval_amt.HorizontalAlignment = 'center';
            app.Interval_amt.Layout.Row = 29;
            app.Interval_amt.Layout.Column = 11;
            app.Interval_amt.Value = 1;

            % Create Interval_Label
            app.Interval_Label = uilabel(app.GridLayoutTraces);
            app.Interval_Label.Layout.Row = 29;
            app.Interval_Label.Layout.Column = 10;
            app.Interval_Label.Text = 'Interval (sec):';

            % Create Tnum_Label
            app.Tnum_Label = uilabel(app.GridLayoutTraces);
            app.Tnum_Label.Layout.Row = 25;
            app.Tnum_Label.Layout.Column = 10;
            app.Tnum_Label.Text = 'Trial No:';

            % Create Choice_DropDown
            app.Choice_DropDown = uidropdown(app.GridLayoutTraces);
            app.Choice_DropDown.Items = {'Raw', 'User Choice', 'Wide 4-100', 'High Theta 6-14', 'Theta 2-14', 'Beta 15-36', 'Gamma1 35-65', 'Gamma2 65-95', 'Gamma 35-95', 'Spikes 500-5000', 'Spike var'};
            app.Choice_DropDown.Layout.Row = 19;
            app.Choice_DropDown.Layout.Column = [10 11];
            app.Choice_DropDown.Value = 'Raw';

            % Create Yrange_DropDown
            app.Yrange_DropDown = uidropdown(app.GridLayoutTraces);
            app.Yrange_DropDown.Items = {'all', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16'};
            app.Yrange_DropDown.ValueChangedFcn = createCallbackFcn(app, @ElectrodeYrangeChange, true);
            app.Yrange_DropDown.FontName = 'Times New Roman';
            app.Yrange_DropDown.Layout.Row = 27;
            app.Yrange_DropDown.Layout.Column = [12 13];
            app.Yrange_DropDown.Value = 'all';

            % Create Licks_CheckBox
            app.Licks_CheckBox = uicheckbox(app.GridLayoutTraces);
            app.Licks_CheckBox.ValueChangedFcn = createCallbackFcn(app, @Licks_CheckBoxValueChanged, true);
            app.Licks_CheckBox.Enable = 'off';
            app.Licks_CheckBox.Text = 'Exclude Licks';
            app.Licks_CheckBox.Layout.Row = 7;
            app.Licks_CheckBox.Layout.Column = [10 11];

            % Create MClust_Button
            app.MClust_Button = uibutton(app.GridLayoutTraces, 'state');
            app.MClust_Button.ValueChangedFcn = createCallbackFcn(app, @MClust_ButtonValueChanged, true);
            app.MClust_Button.Text = 'MClust';
            app.MClust_Button.Layout.Row = 3;
            app.MClust_Button.Layout.Column = 10;

            % Create Diff_CheckBox
            app.Diff_CheckBox = uicheckbox(app.GridLayoutTraces);
            app.Diff_CheckBox.ValueChangedFcn = createCallbackFcn(app, @Diff_CheckBoxValueChanged, true);
            app.Diff_CheckBox.Text = 'Differential';
            app.Diff_CheckBox.FontName = 'Times New Roman';
            app.Diff_CheckBox.Layout.Row = 5;
            app.Diff_CheckBox.Layout.Column = 10;

            % Create min_amt
            app.min_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.min_amt.ValueChangedFcn = createCallbackFcn(app, @ValueAmt_Changed, true);
            app.min_amt.Tag = 'LFPmin';
            app.min_amt.HorizontalAlignment = 'center';
            app.min_amt.Layout.Row = 9;
            app.min_amt.Layout.Column = 11;
            app.min_amt.Value = 50;

            % Create min_Label
            app.min_Label = uilabel(app.GridLayoutTraces);
            app.min_Label.Layout.Row = 9;
            app.min_Label.Layout.Column = 10;
            app.min_Label.Text = 'LFP min';

            % Create max_Label
            app.max_Label = uilabel(app.GridLayoutTraces);
            app.max_Label.Layout.Row = 11;
            app.max_Label.Layout.Column = 10;
            app.max_Label.Text = 'LFP max';

            % Create max_amt
            app.max_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.max_amt.Tag = 'LFPmax';
            app.max_amt.HorizontalAlignment = 'center';
            app.max_amt.Layout.Row = 11;
            app.max_amt.Layout.Column = 11;
            app.max_amt.Value = 3900;

            % Create nxSD_Label
            app.nxSD_Label = uilabel(app.GridLayoutTraces);
            app.nxSD_Label.Layout.Row = 17;
            app.nxSD_Label.Layout.Column = 10;
            app.nxSD_Label.Text = 'Set nxSD';

            % Create nxSD_amt
            app.nxSD_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.nxSD_amt.Tag = 'nxSD';
            app.nxSD_amt.HorizontalAlignment = 'center';
            app.nxSD_amt.Layout.Row = 17;
            app.nxSD_amt.Layout.Column = 11;
            app.nxSD_amt.Value = 2.5;

            % Create thr_amt
            app.thr_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.thr_amt.Tag = 'Thr';
            app.thr_amt.HorizontalAlignment = 'center';
            app.thr_amt.Layout.Row = 15;
            app.thr_amt.Layout.Column = 11;

            % Create thr_Label
            app.thr_Label = uilabel(app.GridLayoutTraces);
            app.thr_Label.Layout.Row = 15;
            app.thr_Label.Layout.Column = 10;
            app.thr_Label.Text = 'Set thr (uv)';

            % Create SaveBrowseTracesPlotButton
            app.SaveBrowseTracesPlotButton = uibutton(app.GridLayoutTraces, 'state');
            app.SaveBrowseTracesPlotButton.ValueChangedFcn = createCallbackFcn(app, @SaveBrowseTracesPlotButtonValueChanged, true);
            app.SaveBrowseTracesPlotButton.Tag = 'LFPsave';
            app.SaveBrowseTracesPlotButton.Text = 'Save Browse Traces Plot';
            app.SaveBrowseTracesPlotButton.FontName = 'Times New Roman';
            app.SaveBrowseTracesPlotButton.Layout.Row = 33;
            app.SaveBrowseTracesPlotButton.Layout.Column = [10 11];

            % Create TrialOutcome
            app.TrialOutcome = uilabel(app.GridLayoutTraces);
            app.TrialOutcome.HorizontalAlignment = 'center';
            app.TrialOutcome.Layout.Row = [1 2];
            app.TrialOutcome.Layout.Column = 5;
            app.TrialOutcome.Text = 'Trial';

            % Create Plot_Panel
            app.Plot_Panel = uipanel(app.GridLayoutTraces);
            app.Plot_Panel.Layout.Row = [3 36];
            app.Plot_Panel.Layout.Column = [1 9];

            % Create Plot_mainGrid
            app.Plot_mainGrid = uigridlayout(app.Plot_Panel);
            app.Plot_mainGrid.ColumnWidth = {'1x'};
            app.Plot_mainGrid.RowHeight = {'1x'};
            app.Plot_mainGrid.Padding = [1 1 1 1];

            % Create figurePlot_UIAxes
            app.figurePlot_UIAxes = uiaxes(app.Plot_mainGrid);
            app.figurePlot_UIAxes.FontName = 'Times New Roman';
            app.figurePlot_UIAxes.NextPlot = 'replace';
            app.figurePlot_UIAxes.Layout.Row = 1;
            app.figurePlot_UIAxes.Layout.Column = 1;

            % Create ExtraFigureOptions_Button
            app.ExtraFigureOptions_Button = uibutton(app.GridLayoutTraces, 'state');
            app.ExtraFigureOptions_Button.ValueChangedFcn = createCallbackFcn(app, @ExtraFigureOptions_ButtonValueChanged, true);
            app.ExtraFigureOptions_Button.Enable = 'off';
            app.ExtraFigureOptions_Button.Visible = 'off';
            app.ExtraFigureOptions_Button.Text = 'Extra Figure Options';
            app.ExtraFigureOptions_Button.FontName = 'Times New Roman';
            app.ExtraFigureOptions_Button.Layout.Row = 31;
            app.ExtraFigureOptions_Button.Layout.Column = [10 11];

            % Create UpdateLFPPlot_Button
            app.UpdateLFPPlot_Button = uibutton(app.GridLayoutTraces, 'push');
            app.UpdateLFPPlot_Button.ButtonPushedFcn = createCallbackFcn(app, @Browse_TracesTabButtonDown, true);
            app.UpdateLFPPlot_Button.Layout.Row = 19;
            app.UpdateLFPPlot_Button.Layout.Column = [12 13];
            app.UpdateLFPPlot_Button.Text = 'Update LFP Plot';

            % Create Data_Shift_Bitand_Label
            app.Data_Shift_Bitand_Label = uilabel(app.GridLayoutTraces);
            app.Data_Shift_Bitand_Label.HorizontalAlignment = 'center';
            app.Data_Shift_Bitand_Label.FontName = 'Times New Roman';
            app.Data_Shift_Bitand_Label.Enable = 'off';
            app.Data_Shift_Bitand_Label.Visible = 'off';
            app.Data_Shift_Bitand_Label.Layout.Row = 21;
            app.Data_Shift_Bitand_Label.Layout.Column = [10 11];
            app.Data_Shift_Bitand_Label.Text = 'Data_Shift_Bitand';

            % Create Shift_dropc_Bitand_Label
            app.Shift_dropc_Bitand_Label = uilabel(app.GridLayoutTraces);
            app.Shift_dropc_Bitand_Label.HorizontalAlignment = 'center';
            app.Shift_dropc_Bitand_Label.FontName = 'Times New Roman';
            app.Shift_dropc_Bitand_Label.Enable = 'off';
            app.Shift_dropc_Bitand_Label.Visible = 'off';
            app.Shift_dropc_Bitand_Label.Layout.Row = 23;
            app.Shift_dropc_Bitand_Label.Layout.Column = [10 11];
            app.Shift_dropc_Bitand_Label.Text = 'Shift_dropc_Bitand';

            % Create DataShiftBitand_EditField
            app.DataShiftBitand_EditField = uieditfield(app.GridLayoutTraces, 'numeric');
            app.DataShiftBitand_EditField.HorizontalAlignment = 'center';
            app.DataShiftBitand_EditField.Enable = 'off';
            app.DataShiftBitand_EditField.Visible = 'off';
            app.DataShiftBitand_EditField.Layout.Row = 21;
            app.DataShiftBitand_EditField.Layout.Column = 12;

            % Create ShiftDropcBitand_EditField
            app.ShiftDropcBitand_EditField = uieditfield(app.GridLayoutTraces, 'numeric');
            app.ShiftDropcBitand_EditField.HorizontalAlignment = 'center';
            app.ShiftDropcBitand_EditField.Enable = 'off';
            app.ShiftDropcBitand_EditField.Visible = 'off';
            app.ShiftDropcBitand_EditField.Layout.Row = 23;
            app.ShiftDropcBitand_EditField.Layout.Column = 12;

            % Create StatusLFP_TextArea
            app.StatusLFP_TextArea = uitextarea(app.GridLayoutTraces);
            app.StatusLFP_TextArea.Editable = 'off';
            app.StatusLFP_TextArea.FontName = 'Times New Roman';
            app.StatusLFP_TextArea.Layout.Row = 35;
            app.StatusLFP_TextArea.Layout.Column = [10 12];

            % Create Filterorder_Label
            app.Filterorder_Label = uilabel(app.GridLayoutTraces);
            app.Filterorder_Label.Layout.Row = 13;
            app.Filterorder_Label.Layout.Column = 10;
            app.Filterorder_Label.Text = 'Filter order';

            % Create Filterorder_EditField
            app.Filterorder_EditField = uieditfield(app.GridLayoutTraces, 'numeric');
            app.Filterorder_EditField.Limits = [0 Inf];
            app.Filterorder_EditField.HorizontalAlignment = 'center';
            app.Filterorder_EditField.Layout.Row = 13;
            app.Filterorder_EditField.Layout.Column = 11;
            app.Filterorder_EditField.Value = 8;

            % Create SaveChennels_Button
            app.SaveChennels_Button = uibutton(app.GridLayoutTraces, 'push');
            app.SaveChennels_Button.ButtonPushedFcn = createCallbackFcn(app, @SaveCurrentElectordPlotData, true);
            app.SaveChennels_Button.Tag = 'Electrode';
            app.SaveChennels_Button.Layout.Row = 33;
            app.SaveChennels_Button.Layout.Column = [12 13];
            app.SaveChennels_Button.Text = 'Save Chennel(s)';

            % Create ElectrodAllPlot_GridLayout
            app.ElectrodAllPlot_GridLayout = uigridlayout(app.GridLayoutTraces);
            app.ElectrodAllPlot_GridLayout.ColumnWidth = {75, 25};
            app.ElectrodAllPlot_GridLayout.RowHeight = {'1x'};
            app.ElectrodAllPlot_GridLayout.RowSpacing = 5;
            app.ElectrodAllPlot_GridLayout.Padding = [1 1 1 1];
            app.ElectrodAllPlot_GridLayout.Layout.Row = 29;
            app.ElectrodAllPlot_GridLayout.Layout.Column = [12 13];

            % Create E_all_CheckBox
            app.E_all_CheckBox = uicheckbox(app.ElectrodAllPlot_GridLayout);
            app.E_all_CheckBox.ValueChangedFcn = createCallbackFcn(app, @Xaxis_Interval_control, true);
            app.E_all_CheckBox.Tag = 'Electrod_All';
            app.E_all_CheckBox.Text = '';
            app.E_all_CheckBox.Layout.Row = 1;
            app.E_all_CheckBox.Layout.Column = 2;
            app.E_all_CheckBox.Value = true;

            % Create E_AllPlots_Label
            app.E_AllPlots_Label = uilabel(app.ElectrodAllPlot_GridLayout);
            app.E_AllPlots_Label.HorizontalAlignment = 'right';
            app.E_AllPlots_Label.Layout.Row = 1;
            app.E_AllPlots_Label.Layout.Column = 1;
            app.E_AllPlots_Label.Text = 'For All Plots';

            % Create Digital_Traces_Tab
            app.Digital_Traces_Tab = uitab(app.TabGroup);
            app.Digital_Traces_Tab.Title = 'Digital Channels';
            app.Digital_Traces_Tab.ButtonDownFcn = createCallbackFcn(app, @UpdateDigitPlots_ButtonPushed, true);

            % Create DigitalMain_GridLayout
            app.DigitalMain_GridLayout = uigridlayout(app.Digital_Traces_Tab);
            app.DigitalMain_GridLayout.ColumnWidth = {'1x', 340};
            app.DigitalMain_GridLayout.RowHeight = {40, '1x'};
            app.DigitalMain_GridLayout.ColumnSpacing = 5;
            app.DigitalMain_GridLayout.RowSpacing = 4;
            app.DigitalMain_GridLayout.Padding = [1 1 1 1];

            % Create DigitalPlot_Grid
            app.DigitalPlot_Grid = uigridlayout(app.DigitalMain_GridLayout);
            app.DigitalPlot_Grid.ColumnWidth = {'1x'};
            app.DigitalPlot_Grid.RowHeight = {'1x'};
            app.DigitalPlot_Grid.ColumnSpacing = 1;
            app.DigitalPlot_Grid.RowSpacing = 1;
            app.DigitalPlot_Grid.Padding = [1 1 1 1];
            app.DigitalPlot_Grid.Layout.Row = 2;
            app.DigitalPlot_Grid.Layout.Column = 1;

            % Create DigitalControls_Grid
            app.DigitalControls_Grid = uigridlayout(app.DigitalMain_GridLayout);
            app.DigitalControls_Grid.ColumnWidth = {100, 40, 70, 70, '1x'};
            app.DigitalControls_Grid.RowHeight = {'1x', 21, 10, 21, 10, 21, 10, 21, 10, 21, 10, 21, 10, 21, 10, 21, 10, 40, '1x'};
            app.DigitalControls_Grid.ColumnSpacing = 8;
            app.DigitalControls_Grid.RowSpacing = 2;
            app.DigitalControls_Grid.Padding = [15 10 10 10];
            app.DigitalControls_Grid.Layout.Row = 2;
            app.DigitalControls_Grid.Layout.Column = 2;

            % Create ExcLicks_CheckBox
            app.ExcLicks_CheckBox = uicheckbox(app.DigitalControls_Grid);
            app.ExcLicks_CheckBox.Enable = 'off';
            app.ExcLicks_CheckBox.Text = '';
            app.ExcLicks_CheckBox.FontName = 'Times New Roman';
            app.ExcLicks_CheckBox.Layout.Row = 6;
            app.ExcLicks_CheckBox.Layout.Column = 2;

            % Create ExcLicks_Label
            app.ExcLicks_Label = uilabel(app.DigitalControls_Grid);
            app.ExcLicks_Label.HorizontalAlignment = 'center';
            app.ExcLicks_Label.FontName = 'Times New Roman';
            app.ExcLicks_Label.Layout.Row = 6;
            app.ExcLicks_Label.Layout.Column = 1;
            app.ExcLicks_Label.Text = 'Exclude Licks';

            % Create TrialNoDigit_Label
            app.TrialNoDigit_Label = uilabel(app.DigitalControls_Grid);
            app.TrialNoDigit_Label.HorizontalAlignment = 'center';
            app.TrialNoDigit_Label.FontName = 'Times New Roman';
            app.TrialNoDigit_Label.Layout.Row = 8;
            app.TrialNoDigit_Label.Layout.Column = 1;
            app.TrialNoDigit_Label.Text = 'Trial No.';

            % Create TrialNoDigit_EditField
            app.TrialNoDigit_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.TrialNoDigit_EditField.ValueChangedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.TrialNoDigit_EditField.Tag = 'DigTnumField';
            app.TrialNoDigit_EditField.HorizontalAlignment = 'center';
            app.TrialNoDigit_EditField.FontName = 'Times New Roman';
            app.TrialNoDigit_EditField.Layout.Row = 8;
            app.TrialNoDigit_EditField.Layout.Column = 2;

            % Create TrialNoDigitPrior_Button
            app.TrialNoDigitPrior_Button = uibutton(app.DigitalControls_Grid, 'push');
            app.TrialNoDigitPrior_Button.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.TrialNoDigitPrior_Button.Tag = 'TnumMinus';
            app.TrialNoDigitPrior_Button.Icon = fullfile(pathToMLAPP, 'Images', 'leftArrow.png');
            app.TrialNoDigitPrior_Button.Layout.Row = 8;
            app.TrialNoDigitPrior_Button.Layout.Column = 3;
            app.TrialNoDigitPrior_Button.Text = '';

            % Create TrialNoDigitNext_Button
            app.TrialNoDigitNext_Button = uibutton(app.DigitalControls_Grid, 'push');
            app.TrialNoDigitNext_Button.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.TrialNoDigitNext_Button.Tag = 'TnumPlus';
            app.TrialNoDigitNext_Button.Icon = fullfile(pathToMLAPP, 'Images', 'rightArrow.png');
            app.TrialNoDigitNext_Button.Layout.Row = 8;
            app.TrialNoDigitNext_Button.Layout.Column = 4;
            app.TrialNoDigitNext_Button.Text = '';

            % Create IntervalSecDigit_Label
            app.IntervalSecDigit_Label = uilabel(app.DigitalControls_Grid);
            app.IntervalSecDigit_Label.HorizontalAlignment = 'center';
            app.IntervalSecDigit_Label.Layout.Row = 10;
            app.IntervalSecDigit_Label.Layout.Column = 1;
            app.IntervalSecDigit_Label.Text = 'Interval (sec):';

            % Create IntervalSecDigit_EditField
            app.IntervalSecDigit_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.IntervalSecDigit_EditField.ValueChangedFcn = createCallbackFcn(app, @Interval_amtValueChanged, true);
            app.IntervalSecDigit_EditField.Tag = 'InterDigi';
            app.IntervalSecDigit_EditField.HorizontalAlignment = 'center';
            app.IntervalSecDigit_EditField.Layout.Row = 10;
            app.IntervalSecDigit_EditField.Layout.Column = 2;

            % Create UpdateDigitPlots_Button
            app.UpdateDigitPlots_Button = uibutton(app.DigitalControls_Grid, 'push');
            app.UpdateDigitPlots_Button.ButtonPushedFcn = createCallbackFcn(app, @UpdateDigitPlots_ButtonPushed, true);
            app.UpdateDigitPlots_Button.FontName = 'Times New Roman';
            app.UpdateDigitPlots_Button.Layout.Row = 16;
            app.UpdateDigitPlots_Button.Layout.Column = [1 2];
            app.UpdateDigitPlots_Button.Text = 'Update Digital Plots';

            % Create Shiftdropcbitand_Label
            app.Shiftdropcbitand_Label = uilabel(app.DigitalControls_Grid);
            app.Shiftdropcbitand_Label.HorizontalAlignment = 'center';
            app.Shiftdropcbitand_Label.FontName = 'Times New Roman';
            app.Shiftdropcbitand_Label.Layout.Row = 14;
            app.Shiftdropcbitand_Label.Layout.Column = 1;
            app.Shiftdropcbitand_Label.Text = 'Shift dropc bitand';

            % Create ShiftBitand_EditField
            app.ShiftBitand_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.ShiftBitand_EditField.HorizontalAlignment = 'center';
            app.ShiftBitand_EditField.Layout.Row = 14;
            app.ShiftBitand_EditField.Layout.Column = 2;

            % Create Shiftdatabitand_Label
            app.Shiftdatabitand_Label = uilabel(app.DigitalControls_Grid);
            app.Shiftdatabitand_Label.HorizontalAlignment = 'center';
            app.Shiftdatabitand_Label.FontName = 'Times New Roman';
            app.Shiftdatabitand_Label.Layout.Row = 12;
            app.Shiftdatabitand_Label.Layout.Column = 1;
            app.Shiftdatabitand_Label.Text = 'Shift data bitand';

            % Create ShiftDataBitand_EditField
            app.ShiftDataBitand_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.ShiftDataBitand_EditField.HorizontalAlignment = 'center';
            app.ShiftDataBitand_EditField.Layout.Row = 12;
            app.ShiftDataBitand_EditField.Layout.Column = 2;

            % Create Trace_ylimits_Label
            app.Trace_ylimits_Label = uilabel(app.DigitalControls_Grid);
            app.Trace_ylimits_Label.HorizontalAlignment = 'center';
            app.Trace_ylimits_Label.Enable = 'off';
            app.Trace_ylimits_Label.Visible = 'off';
            app.Trace_ylimits_Label.Layout.Row = 2;
            app.Trace_ylimits_Label.Layout.Column = 1;
            app.Trace_ylimits_Label.Text = 'Trace y-limits';

            % Create Trace_ylimitsMin_EditField
            app.Trace_ylimitsMin_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.Trace_ylimitsMin_EditField.HorizontalAlignment = 'center';
            app.Trace_ylimitsMin_EditField.Enable = 'off';
            app.Trace_ylimitsMin_EditField.Visible = 'off';
            app.Trace_ylimitsMin_EditField.Layout.Row = 2;
            app.Trace_ylimitsMin_EditField.Layout.Column = 3;
            app.Trace_ylimitsMin_EditField.Value = 1500;

            % Create Trace_ylimtsMax_EditField
            app.Trace_ylimtsMax_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.Trace_ylimtsMax_EditField.HorizontalAlignment = 'center';
            app.Trace_ylimtsMax_EditField.Enable = 'off';
            app.Trace_ylimtsMax_EditField.Visible = 'off';
            app.Trace_ylimtsMax_EditField.Layout.Row = 2;
            app.Trace_ylimtsMax_EditField.Layout.Column = 4;
            app.Trace_ylimtsMax_EditField.Value = 3000;

            % Create StatusDiff_TextArea
            app.StatusDiff_TextArea = uitextarea(app.DigitalControls_Grid);
            app.StatusDiff_TextArea.Layout.Row = 18;
            app.StatusDiff_TextArea.Layout.Column = [1 3];

            % Create DigitalAllPlot_GridLayout
            app.DigitalAllPlot_GridLayout = uigridlayout(app.DigitalControls_Grid);
            app.DigitalAllPlot_GridLayout.ColumnWidth = {75, 25};
            app.DigitalAllPlot_GridLayout.RowHeight = {'1x'};
            app.DigitalAllPlot_GridLayout.RowSpacing = 5;
            app.DigitalAllPlot_GridLayout.Padding = [1 1 1 1];
            app.DigitalAllPlot_GridLayout.Layout.Row = 10;
            app.DigitalAllPlot_GridLayout.Layout.Column = [3 4];

            % Create D_all_CheckBox
            app.D_all_CheckBox = uicheckbox(app.DigitalAllPlot_GridLayout);
            app.D_all_CheckBox.ValueChangedFcn = createCallbackFcn(app, @Xaxis_Interval_control, true);
            app.D_all_CheckBox.Tag = 'Digital_All';
            app.D_all_CheckBox.Text = '';
            app.D_all_CheckBox.Layout.Row = 1;
            app.D_all_CheckBox.Layout.Column = 2;
            app.D_all_CheckBox.Value = true;

            % Create D_AllPlots_Label
            app.D_AllPlots_Label = uilabel(app.DigitalAllPlot_GridLayout);
            app.D_AllPlots_Label.HorizontalAlignment = 'right';
            app.D_AllPlots_Label.Layout.Row = 1;
            app.D_AllPlots_Label.Layout.Column = 1;
            app.D_AllPlots_Label.Text = 'For All Plots';

            % Create DigitalTracesLabel
            app.DigitalTracesLabel = uilabel(app.DigitalMain_GridLayout);
            app.DigitalTracesLabel.HorizontalAlignment = 'center';
            app.DigitalTracesLabel.FontName = 'Times New Roman';
            app.DigitalTracesLabel.Layout.Row = 1;
            app.DigitalTracesLabel.Layout.Column = 1;
            app.DigitalTracesLabel.Text = 'Digital Traces';

            % Create ControlsLabel
            app.ControlsLabel = uilabel(app.DigitalMain_GridLayout);
            app.ControlsLabel.HorizontalAlignment = 'center';
            app.ControlsLabel.FontName = 'Times New Roman';
            app.ControlsLabel.Layout.Row = 1;
            app.ControlsLabel.Layout.Column = 2;
            app.ControlsLabel.Text = 'Controls';

            % Create AnalogChannelsTab
            app.AnalogChannelsTab = uitab(app.TabGroup);
            app.AnalogChannelsTab.Title = 'Analog Channels';
            app.AnalogChannelsTab.ButtonDownFcn = createCallbackFcn(app, @AnalogTab_update, true);

            % Create Analogmain_GridLayout
            app.Analogmain_GridLayout = uigridlayout(app.AnalogChannelsTab);
            app.Analogmain_GridLayout.RowHeight = {120, '1x'};

            % Create AnalogControl_Panel
            app.AnalogControl_Panel = uipanel(app.Analogmain_GridLayout);
            app.AnalogControl_Panel.Layout.Row = 1;
            app.AnalogControl_Panel.Layout.Column = [1 2];
            app.AnalogControl_Panel.FontName = 'Arial';

            % Create Analogcontrols_GridLayout
            app.Analogcontrols_GridLayout = uigridlayout(app.AnalogControl_Panel);
            app.Analogcontrols_GridLayout.ColumnWidth = {100, 70, 40, 70, 10, 210, '1x'};
            app.Analogcontrols_GridLayout.RowHeight = {26, 25, '1x'};

            % Create AnalogpriorTrial_Button
            app.AnalogpriorTrial_Button = uibutton(app.Analogcontrols_GridLayout, 'push');
            app.AnalogpriorTrial_Button.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.AnalogpriorTrial_Button.Tag = 'TnumMinus';
            app.AnalogpriorTrial_Button.Icon = fullfile(pathToMLAPP, 'Images', 'leftArrow.png');
            app.AnalogpriorTrial_Button.Layout.Row = 1;
            app.AnalogpriorTrial_Button.Layout.Column = 2;
            app.AnalogpriorTrial_Button.Text = '';

            % Create AnalognextTrial_Button
            app.AnalognextTrial_Button = uibutton(app.Analogcontrols_GridLayout, 'push');
            app.AnalognextTrial_Button.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.AnalognextTrial_Button.Tag = 'TnumPlus';
            app.AnalognextTrial_Button.Icon = fullfile(pathToMLAPP, 'Images', 'rightArrow.png');
            app.AnalognextTrial_Button.Layout.Row = 1;
            app.AnalognextTrial_Button.Layout.Column = 4;
            app.AnalognextTrial_Button.Text = '';

            % Create Analogtrial_EditField
            app.Analogtrial_EditField = uieditfield(app.Analogcontrols_GridLayout, 'numeric');
            app.Analogtrial_EditField.ValueChangedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.Analogtrial_EditField.Tag = 'AnalognumField';
            app.Analogtrial_EditField.HorizontalAlignment = 'center';
            app.Analogtrial_EditField.FontName = 'Arial';
            app.Analogtrial_EditField.Layout.Row = 1;
            app.Analogtrial_EditField.Layout.Column = 3;

            % Create TrialNumberLabel
            app.TrialNumberLabel = uilabel(app.Analogcontrols_GridLayout);
            app.TrialNumberLabel.HorizontalAlignment = 'center';
            app.TrialNumberLabel.FontName = 'Arial';
            app.TrialNumberLabel.Layout.Row = 1;
            app.TrialNumberLabel.Layout.Column = 1;
            app.TrialNumberLabel.Text = 'Trial Number:';

            % Create Analogupdate_TextArea
            app.Analogupdate_TextArea = uitextarea(app.Analogcontrols_GridLayout);
            app.Analogupdate_TextArea.Layout.Row = [1 2];
            app.Analogupdate_TextArea.Layout.Column = 6;

            % Create AnalogUpdatePlotButton
            app.AnalogUpdatePlotButton = uibutton(app.Analogcontrols_GridLayout, 'push');
            app.AnalogUpdatePlotButton.ButtonPushedFcn = createCallbackFcn(app, @AnalogTab_update, true);
            app.AnalogUpdatePlotButton.Layout.Row = 2;
            app.AnalogUpdatePlotButton.Layout.Column = 1;
            app.AnalogUpdatePlotButton.Text = 'Update Plot';

            % Create AnalogInterval_Label
            app.AnalogInterval_Label = uilabel(app.Analogcontrols_GridLayout);
            app.AnalogInterval_Label.HorizontalAlignment = 'center';
            app.AnalogInterval_Label.FontName = 'Arial';
            app.AnalogInterval_Label.Layout.Row = 3;
            app.AnalogInterval_Label.Layout.Column = 1;
            app.AnalogInterval_Label.Text = 'Interval (sec):';

            % Create AnalogInterval_EditField
            app.AnalogInterval_EditField = uieditfield(app.Analogcontrols_GridLayout, 'numeric');
            app.AnalogInterval_EditField.ValueChangedFcn = createCallbackFcn(app, @Interval_amtValueChanged, true);
            app.AnalogInterval_EditField.Tag = 'InterAnalog';
            app.AnalogInterval_EditField.FontName = 'Arial';
            app.AnalogInterval_EditField.Layout.Row = 3;
            app.AnalogInterval_EditField.Layout.Column = 2;

            % Create AllPlotsAnalog_GridLayout
            app.AllPlotsAnalog_GridLayout = uigridlayout(app.Analogcontrols_GridLayout);
            app.AllPlotsAnalog_GridLayout.ColumnWidth = {70, 25};
            app.AllPlotsAnalog_GridLayout.RowHeight = {'1x'};
            app.AllPlotsAnalog_GridLayout.RowSpacing = 5;
            app.AllPlotsAnalog_GridLayout.Padding = [1 1 1 1];
            app.AllPlotsAnalog_GridLayout.Layout.Row = 3;
            app.AllPlotsAnalog_GridLayout.Layout.Column = [3 5];

            % Create A_all_CheckBox
            app.A_all_CheckBox = uicheckbox(app.AllPlotsAnalog_GridLayout);
            app.A_all_CheckBox.ValueChangedFcn = createCallbackFcn(app, @Xaxis_Interval_control, true);
            app.A_all_CheckBox.Tag = 'Analog_All';
            app.A_all_CheckBox.Text = '';
            app.A_all_CheckBox.Layout.Row = 1;
            app.A_all_CheckBox.Layout.Column = 2;
            app.A_all_CheckBox.Value = true;

            % Create A_AllPlots_Label
            app.A_AllPlots_Label = uilabel(app.AllPlotsAnalog_GridLayout);
            app.A_AllPlots_Label.HorizontalAlignment = 'right';
            app.A_AllPlots_Label.Layout.Row = 1;
            app.A_AllPlots_Label.Layout.Column = 1;
            app.A_AllPlots_Label.Text = 'For All Plots';

            % Create AnalogFigure_GridLayout
            app.AnalogFigure_GridLayout = uigridlayout(app.Analogmain_GridLayout);
            app.AnalogFigure_GridLayout.ColumnWidth = {'1x'};
            app.AnalogFigure_GridLayout.RowHeight = {'1x'};
            app.AnalogFigure_GridLayout.RowSpacing = 1;
            app.AnalogFigure_GridLayout.Layout.Row = 2;
            app.AnalogFigure_GridLayout.Layout.Column = [1 2];

            % Create SelectChannelsTab
            app.SelectChannelsTab = uitab(app.TabGroup);
            app.SelectChannelsTab.AutoResizeChildren = 'off';
            app.SelectChannelsTab.Title = 'Select Channels';
            app.SelectChannelsTab.Scrollable = 'on';

            % Create ChannelPanel
            app.ChannelPanel = uipanel(app.SelectChannelsTab);
            app.ChannelPanel.AutoResizeChildren = 'off';
            app.ChannelPanel.BorderType = 'none';
            app.ChannelPanel.Position = [1 58 1097 731];

            % Create Channels_GridLayout
            app.Channels_GridLayout = uigridlayout(app.ChannelPanel);
            app.Channels_GridLayout.ColumnWidth = {80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15};
            app.Channels_GridLayout.RowHeight = {25, 25};
            app.Channels_GridLayout.ColumnSpacing = 5.5;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = drtaNWB_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end