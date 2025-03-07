classdef drtaNWB_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        TabGroup                    matlab.ui.container.TabGroup
        drta_loadTab                matlab.ui.container.Tab
        GridLayoutLoad              matlab.ui.container.GridLayout
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
        Browse_TracesTab            matlab.ui.container.Tab
        GridLayoutTraces            matlab.ui.container.GridLayout
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
        SaveBrowseTracesButton      matlab.ui.control.StateButton
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
        SelectChannelsTab           matlab.ui.container.Tab
        ChannelPanel                matlab.ui.container.Panel
        Channels_GridLayout         matlab.ui.container.GridLayout
        Digital_Traces_Tab          matlab.ui.container.Tab
        DigitalMain_GridLayout      matlab.ui.container.GridLayout
        ControlsLabel               matlab.ui.control.Label
        DigitalTracesLabel          matlab.ui.control.Label
        DigitalControls_Grid        matlab.ui.container.GridLayout
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
        Trigger_Plot                matlab.ui.control.UIAxes
        Sniffing_Plot               matlab.ui.control.UIAxes
        Lick_Plot                   matlab.ui.control.UIAxes
        In_Port_Plot                matlab.ui.control.UIAxes
        Diode_Plot                  matlab.ui.control.UIAxes
        Digital_Plot                matlab.ui.control.UIAxes
    end


    properties (Access = public)
        drta_Main % Links the main application
        drta_handles = struct(); % Description
        drta_Plot % Description
        OutputText % This is the text that is displayed on the GUI
        LFPOutputText = string(); % text that gives status updates for the LFP plots
        FlagAlpha %  Flag is used to indicate the first call to readout
        %         outputTextDisplay % Houses the text for the files that are created
        NWBFileName     % File name that will be used for the NWB file
        OutputLocation % Location of output files
        BatchFiles = struct();% Structure containing all the batch file inforation
        rhd = struct(); % Structure containing current .rhd file
        h % pointer for browse traces
        Flags = struct; % Description
    end

    methods (Access = public)

        open_rhd_Callback(app) % load rhd file
        drtaOpenDG_Callback(app) % load dg file
        VarUpdate(app,Vname,Vupdate) % updates drta variable
        ReadoutUpdate(app,textUpdate) % adds text to output window on GUI
        actualTrialNo = setTrialNo(app,trialNo) % sets the current trial number
        drtaNWB_figureControl(app) % updates the plots
        ElectrodCheckboxCreate(app) % creating electord checkboxes
        AppTypeSwitchStation(app) % switch stations for file type
        drta03_SetPreferences(app) % setting drta specific preferences
        [varargout] = drta03_read_Intan_RHD2000_header(app) % updated function for drta 3.0
        ChooseFileToLoad(app) % choosing which file will be loaded
        LoadingChosenFile(app) % loading the file that was chosen
        ExtraImageOptions(app)
        DropChoiceDropDown(app) % sets the method for how the data is processed
        drta03_ShowDigital(app) % plotting digital figure
        VisualChoice(app) % sets the visual choice dropdown value
        TrialNumChange(app,event) % changes the trial number
        LFPplotChange(app,event) % handles user input changes for LFP plot
        SaveFile(app) % saving output
        drta03_GenerateMClust(app) % runs MClust and saves output
        ShowingDiffCheckbox(app) % creates the structure for dropdown obj
        LFPplotStatusUpdate(app,textUpdate) % status updates for LFP plots
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





        end

        % Value changed function: Yrange_amt
        function Yrange_amtValueChanged(app, event)
            %{
            This function works as intended based on the orignal guide GUI
            %}
            y_range = app.Yrange_amt.Value;
            %             v_range=y_range* app.drta_handles.draq_p.pre_gain* app.drta_handles.draq_p.daq_gain/1000000;


            if (app.drta_handles.p.which_channel==1)
                %Change for all channels
                for ii=1:app.drta_handles.draq_p.no_spike_ch
                    %         if v_range>handles.draq_p.inp_max
                    %             handles.draq_p.prev_ylim(ii)=1000000*handles.draq_p.inp_max/(handles.draq_p.pre_gain*handles.draq_p.daq_gain);
                    %         else
                    app.drta_handles.plot.s_handles(ii)=y_range;
                    app.drta_handles.draq_p.prev_ylim(ii)=y_range;
                    %         end4
                end
            else
                ii=app.drta_handles.p.which_channel-1;
                %     if v_range>handles.draq_p.inp_max
                %         handles.draq_p.prev_ylim(ii)=1000000*handles.draq_p.inp_max(2)/(handles.draq_p.pre_gain*handles.draq_p.daq_gain);
                %     else
                app.drta_handles.plot.s_handles(ii)=y_range;
                app.drta_handles.draq_p.prev_ylim(ii)=y_range;
                %     end
            end
            %             drta(app.drta_handles.w.drta,'drtaUpdateAllHandlespw',app.drta_handles)
            drtaNWB_figureControl(app);
            %             drtaNWB_PlotBrowseTraces(app.drta_handles);
        end

        % Value changed function: Interval_amt
        function Interval_amtValueChanged(app, event)
            switch event.tag
                case 'InterLFP'
                    time_interval = app.Interval_amt.Value;
                case 'InterDigi'
                    time_interval = app.IntervalSecDigit_EditField.Value;
            end

            if(app.drta_handles.p.start_display_time+time_interval)>app.drta_handles.draq_p.sec_per_trigger
                time_interval= app.drta_handles.draq_p.sec_per_trigger-app.drta_handles.p.start_display_time;
            end

            app.drta_handles.p.display_interval=time_interval;
            app.Interval_amt.Value = app.drta_handles.p.display_interval;
            app.IntervalSecDigit_EditField.Value = app.drta_handles.p.display_interval;
            %             set(hObject,'String',num2str(handles.p.display_interval));

            %             % Update all handles.p structures
            %             drta('drtaUpdateAllHandlespw',app.drta_handles.w.drta,app.drta_handles);
            %             drtaPlotBrowseTraces(app.drta_handles);
        end

        % Callback function: Tnum_Larrow, Tnum_Rarrow, Tnum_amt, 
        % ...and 2 other components
        function TrialNum_ButtonPushed(app, event)
            TrialNumChange(app,event)
            textUpdate = ['Updating plot to show tiral ' ...
                num2str(app.TrialNoDigit_EditField.Value)];
            LFPplotStatusUpdate(app,textUpdate)
            VisualChoice(app);
            drtaNWB_figureControl(app);
            drta03_ShowDigital(app);
            textUpdate = ['Plot updated, now showing tiral ' ...
                num2str(app.TrialNoDigit_EditField.Value)];
            LFPplotStatusUpdate(app,textUpdate)
        end

        % Value changed function: MClust_Button
        function MClust_ButtonValueChanged(app, event)
            textUpdate = "Generating MClust files, Please wait.";
            LFPplotStatusUpdate(app,textUpdate)
            app.MClust_Button.Enable = "off";
            drtaGenerateMClust(app.drta_handles);
            textUpdate = "MClust files saved";
            LFPplotStatusUpdate(app,textUpdate)
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

        % Value changed function: SaveBrowseTracesButton
        function SaveBrowseTracesButtonValueChanged(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            %             [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>

            % hObject    handle to drtaThrSaveMat (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            if (isfield(app.drta_handles.draq_d,'snip_samp'))
                try
                    app.drta_handles = rmfield(app.drta_handles.draq_d,'snip_samp');
                catch
                end

                try
                    app.drta_handles = rmfield(app.drta_handles.draq_d,'snip_index');
                catch
                end

                try
                    app.drta_handles = rmfield(app.drta_handles.draq_d,'snips');
                catch
                end
            end

            if (isfield(app.drta_handles.draq_d,'noEvents'))
                app.drta_handles = rmfield(app.drta_handles.draq_d,'noEvents');
                app.drta_handles = rmfield(app.drta_handles.draq_d,'nEvPerType');
                app.drta_handles = rmfield(app.drta_handles.draq_d,'nEventTypes');
                app.drta_handles = rmfield(app.drta_handles.draq_d,'eventlabels');

                try
                    app.drta_handles = rmfield(handles.draq_d,'events');
                    app.drta_handles = rmfield(handles.draq_d,'eventType');
                catch
                end


                try
                    app.drta_handles = rmfield(handles.draq_d,'blocks');
                catch
                end
            end
            % Adding meta data if entered
            if ~isempty(app.MSinput0.Value)
                Subject_MetaData = struct();
                Subject_MetaData.age = app.MSinput0.Value;
                Subject_MetaData.discription = app.MSinput1.Value;
                Subject_MetaData.genotype = app.MSinput2.Value;
                Subject_MetaData.sex = app.MSinput3.Value;
                Subject_MetaData.species = app.MSinput4.Value;
                Subject_MetaData.ID = app.MSinput5.Value;
                Subject_MetaData.weight = app.MSinput6.Value;
                Subject_MetaData.strain = app.MSinput7.Value;
                if app.MSinput8yes == 1
                    Subject_MetaData.DOB.year = app.MSinput9.Value;
                    Subject_MetaData.DOB.month = app.MSinput10.Value;
                    Subject_MetaData.day = app.MSinput11.Value;
                end
                app.drta_handles.p.SubjectMetaData = Subject_MetaData;
            end
            type_DropDownValueChanged(app)
            drtaGenerateEvents(app.drta_handles);
            app.SaveBrowseTracesButton.Value = 0;
        end

        % Value changed function: Load_Button
        function Load_ButtonValueChanged(app, event)
            %{
            Loading the file that the user selected and opening the visual
            GUI for user interaction.
            %}
            LoadingChosenFile(app);
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

        % Callback function: Browse_TracesTab, UpdateLFPPlot_Button
        function Browse_TracesTabButtonDown(app, event)
            textUpdate = "Updating Plot, Please wait.";
            LFPplotStatusUpdate(app,textUpdate)
            if app.Flags.fileLoaded == true
                VisualChoice(app);
                drtaNWB_figureControl(app);
            end
            textUpdate = "Plot Updated";
            LFPplotStatusUpdate(app,textUpdate)
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
            drta03_ShowDigital(app);
        end

        % Button pushed function: Savematfile_Button
        function Savematfile_ButtonPushed(app, event)
            ReadoutUpdate(app,'Saving jt_times file.')
            SaveFile(app)
            ReadoutUpdate(app,'File saved.')
        end

        % Value changed function: Yrange_DropDown
        function Yrange_DropDownValueChanged(app, event)
            value = app.Yrange_DropDown.Value;
            if value ~= "all"
                app.drta_handles.p.which_channel = str2double(value);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [527 219 1100 760];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Scrollable = 'on';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 1099 760];

            % Create drta_loadTab
            app.drta_loadTab = uitab(app.TabGroup);
            app.drta_loadTab.Title = 'drta_load';

            % Create GridLayoutLoad
            app.GridLayoutLoad = uigridlayout(app.drta_loadTab);
            app.GridLayoutLoad.ColumnWidth = {20, 20, 120, 40, 95, 40, 100, 400, '1x'};
            app.GridLayoutLoad.RowHeight = {20, 50, 10, 40, 15, 40, 20, 30, 20, 30, 20, 30, 15, 15, 15, 15, 15, '1x', 20};

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
            app.Savematfile_Button.Layout.Row = [16 17];
            app.Savematfile_Button.Layout.Column = [5 6];
            app.Savematfile_Button.Text = 'Save mat file';

            % Create Cprogrom_DropDown
            app.Cprogrom_DropDown = uidropdown(app.GridLayoutLoad);
            app.Cprogrom_DropDown.Items = {'dropcnsampler', 'dropcspm', 'background', 'spmult', 'mspy', 'osampler', 'spm2mult', 'lighton1', 'lighton5', 'dropcspm_conc', 'Laser-triggered', 'Laser-Merouann', 'dropcspm_hf', 'Working_memoy', 'Continuous', 'Laser-Kira', 'Laser-Schoppa'};
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

            % Create Browse_TracesTab
            app.Browse_TracesTab = uitab(app.TabGroup);
            app.Browse_TracesTab.AutoResizeChildren = 'off';
            app.Browse_TracesTab.Title = 'Browse_Traces';
            app.Browse_TracesTab.ButtonDownFcn = createCallbackFcn(app, @Browse_TracesTabButtonDown, true);

            % Create GridLayoutTraces
            app.GridLayoutTraces = uigridlayout(app.Browse_TracesTab);
            app.GridLayoutTraces.ColumnWidth = {79, 38, '1.95x', 82, '1x', 84, 66, 85, '1x', 84, 50, 50, 50};
            app.GridLayoutTraces.RowHeight = {10, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 19, 10, 40, '1x'};
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
            app.Yrange_Label.Layout.Row = 25;
            app.Yrange_Label.Layout.Column = 10;
            app.Yrange_Label.Text = 'Y Range (uV):';

            % Create Yrange_amt
            app.Yrange_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.Yrange_amt.ValueChangedFcn = createCallbackFcn(app, @Yrange_amtValueChanged, true);
            app.Yrange_amt.HorizontalAlignment = 'center';
            app.Yrange_amt.Layout.Row = 25;
            app.Yrange_amt.Layout.Column = 11;
            app.Yrange_amt.Value = 4000;

            % Create Tnum_Larrow
            app.Tnum_Larrow = uibutton(app.GridLayoutTraces, 'push');
            app.Tnum_Larrow.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.Tnum_Larrow.Tag = 'TnumMinus';
            app.Tnum_Larrow.Layout.Row = 23;
            app.Tnum_Larrow.Layout.Column = 12;
            app.Tnum_Larrow.Text = '<--';

            % Create Tnum_Rarrow
            app.Tnum_Rarrow = uibutton(app.GridLayoutTraces, 'push');
            app.Tnum_Rarrow.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.Tnum_Rarrow.Tag = 'TnumPlus';
            app.Tnum_Rarrow.Layout.Row = 23;
            app.Tnum_Rarrow.Layout.Column = 13;
            app.Tnum_Rarrow.Text = '-->';

            % Create Tnum_amt
            app.Tnum_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.Tnum_amt.ValueChangedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.Tnum_amt.Tag = 'TnumField';
            app.Tnum_amt.HorizontalAlignment = 'center';
            app.Tnum_amt.Layout.Row = 23;
            app.Tnum_amt.Layout.Column = 11;
            app.Tnum_amt.Value = 1;

            % Create Interval_amt
            app.Interval_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.Interval_amt.ValueChangedFcn = createCallbackFcn(app, @Interval_amtValueChanged, true);
            app.Interval_amt.Tag = 'InterLFP';
            app.Interval_amt.HorizontalAlignment = 'center';
            app.Interval_amt.Layout.Row = 27;
            app.Interval_amt.Layout.Column = 11;
            app.Interval_amt.Value = 1;

            % Create Interval_Label
            app.Interval_Label = uilabel(app.GridLayoutTraces);
            app.Interval_Label.Layout.Row = 27;
            app.Interval_Label.Layout.Column = 10;
            app.Interval_Label.Text = 'Interval (sec):';

            % Create Tnum_Label
            app.Tnum_Label = uilabel(app.GridLayoutTraces);
            app.Tnum_Label.Layout.Row = 23;
            app.Tnum_Label.Layout.Column = 10;
            app.Tnum_Label.Text = 'Trial No:';

            % Create Choice_DropDown
            app.Choice_DropDown = uidropdown(app.GridLayoutTraces);
            app.Choice_DropDown.Items = {'Raw', 'User Choice', 'Wide 4-100', 'High Theta 6-14', 'Theta 2-14', 'Beta 15-36', 'Gamma1 35-65', 'Gamma2 65-95', 'Gamma 35-95', 'Spikes 500-5000', 'Spike var'};
            app.Choice_DropDown.Layout.Row = 17;
            app.Choice_DropDown.Layout.Column = [10 11];
            app.Choice_DropDown.Value = 'Raw';

            % Create Yrange_DropDown
            app.Yrange_DropDown = uidropdown(app.GridLayoutTraces);
            app.Yrange_DropDown.Items = {'all', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16'};
            app.Yrange_DropDown.ValueChangedFcn = createCallbackFcn(app, @Yrange_DropDownValueChanged, true);
            app.Yrange_DropDown.FontName = 'Times New Roman';
            app.Yrange_DropDown.Layout.Row = 25;
            app.Yrange_DropDown.Layout.Column = [12 13];
            app.Yrange_DropDown.Value = 'all';

            % Create Licks_CheckBox
            app.Licks_CheckBox = uicheckbox(app.GridLayoutTraces);
            app.Licks_CheckBox.ValueChangedFcn = createCallbackFcn(app, @Licks_CheckBoxValueChanged, true);
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
            app.nxSD_Label.Layout.Row = 15;
            app.nxSD_Label.Layout.Column = 10;
            app.nxSD_Label.Text = 'Set nxSD';

            % Create nxSD_amt
            app.nxSD_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.nxSD_amt.Tag = 'nxSD';
            app.nxSD_amt.HorizontalAlignment = 'center';
            app.nxSD_amt.Layout.Row = 15;
            app.nxSD_amt.Layout.Column = 11;
            app.nxSD_amt.Value = 2.5;

            % Create thr_amt
            app.thr_amt = uieditfield(app.GridLayoutTraces, 'numeric');
            app.thr_amt.Tag = 'Thr';
            app.thr_amt.HorizontalAlignment = 'center';
            app.thr_amt.Layout.Row = 13;
            app.thr_amt.Layout.Column = 11;

            % Create thr_Label
            app.thr_Label = uilabel(app.GridLayoutTraces);
            app.thr_Label.Layout.Row = 13;
            app.thr_Label.Layout.Column = 10;
            app.thr_Label.Text = 'Set thr (uv)';

            % Create SaveBrowseTracesButton
            app.SaveBrowseTracesButton = uibutton(app.GridLayoutTraces, 'state');
            app.SaveBrowseTracesButton.ValueChangedFcn = createCallbackFcn(app, @SaveBrowseTracesButtonValueChanged, true);
            app.SaveBrowseTracesButton.Enable = 'off';
            app.SaveBrowseTracesButton.Visible = 'off';
            app.SaveBrowseTracesButton.Text = 'Save Browse Traces';
            app.SaveBrowseTracesButton.Layout.Row = 31;
            app.SaveBrowseTracesButton.Layout.Column = [10 11];

            % Create TrialOutcome
            app.TrialOutcome = uilabel(app.GridLayoutTraces);
            app.TrialOutcome.HorizontalAlignment = 'center';
            app.TrialOutcome.Layout.Row = [1 2];
            app.TrialOutcome.Layout.Column = 5;
            app.TrialOutcome.Text = 'Trial';

            % Create Plot_Panel
            app.Plot_Panel = uipanel(app.GridLayoutTraces);
            app.Plot_Panel.Layout.Row = [3 34];
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
            app.ExtraFigureOptions_Button.Layout.Row = 29;
            app.ExtraFigureOptions_Button.Layout.Column = [10 11];

            % Create UpdateLFPPlot_Button
            app.UpdateLFPPlot_Button = uibutton(app.GridLayoutTraces, 'push');
            app.UpdateLFPPlot_Button.ButtonPushedFcn = createCallbackFcn(app, @Browse_TracesTabButtonDown, true);
            app.UpdateLFPPlot_Button.Layout.Row = 17;
            app.UpdateLFPPlot_Button.Layout.Column = [12 13];
            app.UpdateLFPPlot_Button.Text = 'Update LFP Plot';

            % Create Data_Shift_Bitand_Label
            app.Data_Shift_Bitand_Label = uilabel(app.GridLayoutTraces);
            app.Data_Shift_Bitand_Label.HorizontalAlignment = 'center';
            app.Data_Shift_Bitand_Label.FontName = 'Times New Roman';
            app.Data_Shift_Bitand_Label.Layout.Row = 19;
            app.Data_Shift_Bitand_Label.Layout.Column = [10 11];
            app.Data_Shift_Bitand_Label.Text = 'Data_Shift_Bitand';

            % Create Shift_dropc_Bitand_Label
            app.Shift_dropc_Bitand_Label = uilabel(app.GridLayoutTraces);
            app.Shift_dropc_Bitand_Label.HorizontalAlignment = 'center';
            app.Shift_dropc_Bitand_Label.FontName = 'Times New Roman';
            app.Shift_dropc_Bitand_Label.Layout.Row = 21;
            app.Shift_dropc_Bitand_Label.Layout.Column = [10 11];
            app.Shift_dropc_Bitand_Label.Text = 'Shift_dropc_Bitand';

            % Create DataShiftBitand_EditField
            app.DataShiftBitand_EditField = uieditfield(app.GridLayoutTraces, 'numeric');
            app.DataShiftBitand_EditField.HorizontalAlignment = 'center';
            app.DataShiftBitand_EditField.Layout.Row = 19;
            app.DataShiftBitand_EditField.Layout.Column = 12;

            % Create ShiftDropcBitand_EditField
            app.ShiftDropcBitand_EditField = uieditfield(app.GridLayoutTraces, 'numeric');
            app.ShiftDropcBitand_EditField.HorizontalAlignment = 'center';
            app.ShiftDropcBitand_EditField.Layout.Row = 21;
            app.ShiftDropcBitand_EditField.Layout.Column = 12;

            % Create StatusLFP_TextArea
            app.StatusLFP_TextArea = uitextarea(app.GridLayoutTraces);
            app.StatusLFP_TextArea.Editable = 'off';
            app.StatusLFP_TextArea.FontName = 'Times New Roman';
            app.StatusLFP_TextArea.Layout.Row = 33;
            app.StatusLFP_TextArea.Layout.Column = [10 12];

            % Create SelectChannelsTab
            app.SelectChannelsTab = uitab(app.TabGroup);
            app.SelectChannelsTab.AutoResizeChildren = 'off';
            app.SelectChannelsTab.Title = 'Select Channels';
            app.SelectChannelsTab.Scrollable = 'on';

            % Create ChannelPanel
            app.ChannelPanel = uipanel(app.SelectChannelsTab);
            app.ChannelPanel.AutoResizeChildren = 'off';
            app.ChannelPanel.BorderType = 'none';
            app.ChannelPanel.Position = [1 1 1097 731];

            % Create Channels_GridLayout
            app.Channels_GridLayout = uigridlayout(app.ChannelPanel);
            app.Channels_GridLayout.ColumnWidth = {80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15, 80, 15};
            app.Channels_GridLayout.RowHeight = {25, 25};
            app.Channels_GridLayout.ColumnSpacing = 5.5;

            % Create Digital_Traces_Tab
            app.Digital_Traces_Tab = uitab(app.TabGroup);
            app.Digital_Traces_Tab.Title = 'Digital_Traces';
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
            app.DigitalPlot_Grid.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x'};
            app.DigitalPlot_Grid.ColumnSpacing = 1;
            app.DigitalPlot_Grid.RowSpacing = 1;
            app.DigitalPlot_Grid.Padding = [1 1 1 1];
            app.DigitalPlot_Grid.Layout.Row = 2;
            app.DigitalPlot_Grid.Layout.Column = 1;

            % Create Digital_Plot
            app.Digital_Plot = uiaxes(app.DigitalPlot_Grid);
            app.Digital_Plot.FontName = 'Times New Roman';
            app.Digital_Plot.Layout.Row = 6;
            app.Digital_Plot.Layout.Column = 1;

            % Create Diode_Plot
            app.Diode_Plot = uiaxes(app.DigitalPlot_Grid);
            app.Diode_Plot.FontName = 'Times New Roman';
            app.Diode_Plot.Layout.Row = 5;
            app.Diode_Plot.Layout.Column = 1;

            % Create In_Port_Plot
            app.In_Port_Plot = uiaxes(app.DigitalPlot_Grid);
            app.In_Port_Plot.FontName = 'Times New Roman';
            app.In_Port_Plot.Layout.Row = 4;
            app.In_Port_Plot.Layout.Column = 1;

            % Create Lick_Plot
            app.Lick_Plot = uiaxes(app.DigitalPlot_Grid);
            app.Lick_Plot.FontName = 'Times New Roman';
            app.Lick_Plot.Layout.Row = 3;
            app.Lick_Plot.Layout.Column = 1;

            % Create Sniffing_Plot
            app.Sniffing_Plot = uiaxes(app.DigitalPlot_Grid);
            app.Sniffing_Plot.FontName = 'Times New Roman';
            app.Sniffing_Plot.Layout.Row = 2;
            app.Sniffing_Plot.Layout.Column = 1;

            % Create Trigger_Plot
            app.Trigger_Plot = uiaxes(app.DigitalPlot_Grid);
            app.Trigger_Plot.FontName = 'Times New Roman';
            app.Trigger_Plot.Layout.Row = 1;
            app.Trigger_Plot.Layout.Column = 1;

            % Create DigitalControls_Grid
            app.DigitalControls_Grid = uigridlayout(app.DigitalMain_GridLayout);
            app.DigitalControls_Grid.ColumnWidth = {100, 40, 70, 70, '1x'};
            app.DigitalControls_Grid.RowHeight = {'1x', 21, 10, 21, 10, 21, 10, 21, 10, 21, 10, 21, 10, 21, '1x'};
            app.DigitalControls_Grid.ColumnSpacing = 8;
            app.DigitalControls_Grid.RowSpacing = 2;
            app.DigitalControls_Grid.Padding = [15 10 10 10];
            app.DigitalControls_Grid.Layout.Row = 2;
            app.DigitalControls_Grid.Layout.Column = 2;

            % Create ExcLicks_CheckBox
            app.ExcLicks_CheckBox = uicheckbox(app.DigitalControls_Grid);
            app.ExcLicks_CheckBox.Text = '';
            app.ExcLicks_CheckBox.FontName = 'Times New Roman';
            app.ExcLicks_CheckBox.Layout.Row = 4;
            app.ExcLicks_CheckBox.Layout.Column = 2;

            % Create ExcLicks_Label
            app.ExcLicks_Label = uilabel(app.DigitalControls_Grid);
            app.ExcLicks_Label.HorizontalAlignment = 'center';
            app.ExcLicks_Label.FontName = 'Times New Roman';
            app.ExcLicks_Label.Layout.Row = 4;
            app.ExcLicks_Label.Layout.Column = 1;
            app.ExcLicks_Label.Text = 'Exclude Licks';

            % Create TrialNoDigit_Label
            app.TrialNoDigit_Label = uilabel(app.DigitalControls_Grid);
            app.TrialNoDigit_Label.HorizontalAlignment = 'center';
            app.TrialNoDigit_Label.FontName = 'Times New Roman';
            app.TrialNoDigit_Label.Layout.Row = 6;
            app.TrialNoDigit_Label.Layout.Column = 1;
            app.TrialNoDigit_Label.Text = 'Trial No.';

            % Create TrialNoDigit_EditField
            app.TrialNoDigit_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.TrialNoDigit_EditField.Tag = 'DigTnumField';
            app.TrialNoDigit_EditField.HorizontalAlignment = 'center';
            app.TrialNoDigit_EditField.FontName = 'Times New Roman';
            app.TrialNoDigit_EditField.Layout.Row = 6;
            app.TrialNoDigit_EditField.Layout.Column = 2;

            % Create TrialNoDigitPrior_Button
            app.TrialNoDigitPrior_Button = uibutton(app.DigitalControls_Grid, 'push');
            app.TrialNoDigitPrior_Button.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.TrialNoDigitPrior_Button.Tag = 'TnumMinus';
            app.TrialNoDigitPrior_Button.Layout.Row = 6;
            app.TrialNoDigitPrior_Button.Layout.Column = 3;
            app.TrialNoDigitPrior_Button.Text = '<--';

            % Create TrialNoDigitNext_Button
            app.TrialNoDigitNext_Button = uibutton(app.DigitalControls_Grid, 'push');
            app.TrialNoDigitNext_Button.ButtonPushedFcn = createCallbackFcn(app, @TrialNum_ButtonPushed, true);
            app.TrialNoDigitNext_Button.Tag = 'TnumPlus';
            app.TrialNoDigitNext_Button.Layout.Row = 6;
            app.TrialNoDigitNext_Button.Layout.Column = 4;
            app.TrialNoDigitNext_Button.Text = '-->';

            % Create IntervalSecDigit_Label
            app.IntervalSecDigit_Label = uilabel(app.DigitalControls_Grid);
            app.IntervalSecDigit_Label.HorizontalAlignment = 'center';
            app.IntervalSecDigit_Label.Layout.Row = 8;
            app.IntervalSecDigit_Label.Layout.Column = 1;
            app.IntervalSecDigit_Label.Text = 'Interval (sec):';

            % Create IntervalSecDigit_EditField
            app.IntervalSecDigit_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.IntervalSecDigit_EditField.Tag = 'InterDigi';
            app.IntervalSecDigit_EditField.HorizontalAlignment = 'center';
            app.IntervalSecDigit_EditField.Layout.Row = 8;
            app.IntervalSecDigit_EditField.Layout.Column = 2;

            % Create UpdateDigitPlots_Button
            app.UpdateDigitPlots_Button = uibutton(app.DigitalControls_Grid, 'push');
            app.UpdateDigitPlots_Button.ButtonPushedFcn = createCallbackFcn(app, @UpdateDigitPlots_ButtonPushed, true);
            app.UpdateDigitPlots_Button.FontName = 'Times New Roman';
            app.UpdateDigitPlots_Button.Layout.Row = 14;
            app.UpdateDigitPlots_Button.Layout.Column = [1 2];
            app.UpdateDigitPlots_Button.Text = 'Update Digital Plots';

            % Create Shiftdropcbitand_Label
            app.Shiftdropcbitand_Label = uilabel(app.DigitalControls_Grid);
            app.Shiftdropcbitand_Label.HorizontalAlignment = 'center';
            app.Shiftdropcbitand_Label.FontName = 'Times New Roman';
            app.Shiftdropcbitand_Label.Layout.Row = 12;
            app.Shiftdropcbitand_Label.Layout.Column = 1;
            app.Shiftdropcbitand_Label.Text = 'Shift dropc bitand';

            % Create ShiftBitand_EditField
            app.ShiftBitand_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.ShiftBitand_EditField.HorizontalAlignment = 'center';
            app.ShiftBitand_EditField.Layout.Row = 12;
            app.ShiftBitand_EditField.Layout.Column = 2;

            % Create Shiftdatabitand_Label
            app.Shiftdatabitand_Label = uilabel(app.DigitalControls_Grid);
            app.Shiftdatabitand_Label.HorizontalAlignment = 'center';
            app.Shiftdatabitand_Label.FontName = 'Times New Roman';
            app.Shiftdatabitand_Label.Layout.Row = 10;
            app.Shiftdatabitand_Label.Layout.Column = 1;
            app.Shiftdatabitand_Label.Text = 'Shift data bitand';

            % Create ShiftDataBitand_EditField
            app.ShiftDataBitand_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.ShiftDataBitand_EditField.HorizontalAlignment = 'center';
            app.ShiftDataBitand_EditField.Layout.Row = 10;
            app.ShiftDataBitand_EditField.Layout.Column = 2;

            % Create Trace_ylimits_Label
            app.Trace_ylimits_Label = uilabel(app.DigitalControls_Grid);
            app.Trace_ylimits_Label.HorizontalAlignment = 'center';
            app.Trace_ylimits_Label.Layout.Row = 2;
            app.Trace_ylimits_Label.Layout.Column = 1;
            app.Trace_ylimits_Label.Text = 'Trace y-limits';

            % Create Trace_ylimitsMin_EditField
            app.Trace_ylimitsMin_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.Trace_ylimitsMin_EditField.HorizontalAlignment = 'center';
            app.Trace_ylimitsMin_EditField.Layout.Row = 2;
            app.Trace_ylimitsMin_EditField.Layout.Column = 3;
            app.Trace_ylimitsMin_EditField.Value = 1500;

            % Create Trace_ylimtsMax_EditField
            app.Trace_ylimtsMax_EditField = uieditfield(app.DigitalControls_Grid, 'numeric');
            app.Trace_ylimtsMax_EditField.HorizontalAlignment = 'center';
            app.Trace_ylimtsMax_EditField.Layout.Row = 2;
            app.Trace_ylimtsMax_EditField.Layout.Column = 4;
            app.Trace_ylimtsMax_EditField.Value = 3000;

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