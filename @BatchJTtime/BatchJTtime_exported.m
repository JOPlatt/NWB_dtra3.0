classdef BatchJTtime_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        Main_GridLayout            matlab.ui.container.GridLayout
        Save_GridLayout            matlab.ui.container.GridLayout
        RunBatch_Button            matlab.ui.control.Button
        ProgressReadout            matlab.ui.control.TextArea
        UpdatesText_Label          matlab.ui.control.Label
        ProcesMethod_GridLayout    matlab.ui.container.GridLayout
        Savemethod_Label           matlab.ui.control.Label
        LoadingProcess_DropDown    matlab.ui.control.DropDown
        LoadMethodAll_CheckBox     matlab.ui.control.CheckBox
        MClustCurrentFile_Label    matlab.ui.control.Label
        RunMClust_CheckBox         matlab.ui.control.CheckBox
        IncludeMClust_Label        matlab.ui.control.Label
        SaveChoice_Button          matlab.ui.control.Button
        FileChoice_DropDown        matlab.ui.control.DropDown
        AllFiles_CheckBox          matlab.ui.control.CheckBox
        ProcessType_DropDown       matlab.ui.control.DropDown
        fileProcess_Label          matlab.ui.control.Label
        AllFiles_Label             matlab.ui.control.Label
        Processmethod_Label        matlab.ui.control.Label
        FileChoice_GridLayout      matlab.ui.container.GridLayout
        LoadingFile_GridLayout     matlab.ui.container.GridLayout
        DataLoc_TextArea           matlab.ui.control.TextArea
        DataLoc_Button             matlab.ui.control.Button
        FolderLoc_Label            matlab.ui.control.Label
        LoadingMethod_ButtonGroup  matlab.ui.container.ButtonGroup
        ExcelChoice_Button         matlab.ui.control.RadioButton
        ListChoice_Button          matlab.ui.control.RadioButton
        FolderChoice_Button        matlab.ui.control.RadioButton
        Method_Label               matlab.ui.control.Label
        LoadedFiles_GridLayout     matlab.ui.container.GridLayout
        FileList_TextArea          matlab.ui.control.TextArea
        Filesloaded_Label          matlab.ui.control.Label
    end

    
    properties (Access = public)
        FileLoc % Location of all files (cell array [Loc,Name])
        ProcesType % Process type for each file (num array)
        MCinclud % Include MClust (logic array)
        FileProcInfo % Information on all files being processed
        Flags % flags used in code processing
        drta_data % data loaded from the file
        OutputText 
    end

    methods (Access = public)
        BatchJTtimeStartUp(app) % startup function
        LoadingTypeUsed(app,event) % loading type radio button choice
        LoadData(app) % data loading function
        RunningBachProcess(app) % running batch process
        Batch_open_rhd(app) % loading rhd file
        BatchSaveJTtimes(app) % saving JTtime
        SettingDrtaPresests(app) % setting preset values created for drta
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            BatchJTtimeStartUp(app);
        end

        % Selection changed function: LoadingMethod_ButtonGroup
        function FileLoadingMethod(app, event)
            LoadingTypeUsed(app,event);
        end

        % Button pushed function: DataLoc_Button
        function LoadingData_Button(app, event)
            LoadData(app);
        end

        % Button pushed function: RunBatch_Button
        function RunBatchProcess(app, event)
            RunningBachProcess(app)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 641 497];
            app.UIFigure.Name = 'MATLAB App';

            % Create Main_GridLayout
            app.Main_GridLayout = uigridlayout(app.UIFigure);
            app.Main_GridLayout.ColumnWidth = {'1x'};
            app.Main_GridLayout.RowHeight = {200, 130, 125};

            % Create FileChoice_GridLayout
            app.FileChoice_GridLayout = uigridlayout(app.Main_GridLayout);
            app.FileChoice_GridLayout.ColumnWidth = {325, '1x'};
            app.FileChoice_GridLayout.RowHeight = {'1x'};
            app.FileChoice_GridLayout.ColumnSpacing = 1;
            app.FileChoice_GridLayout.RowSpacing = 1;
            app.FileChoice_GridLayout.Padding = [1 1 1 1];
            app.FileChoice_GridLayout.Layout.Row = 1;
            app.FileChoice_GridLayout.Layout.Column = 1;

            % Create LoadedFiles_GridLayout
            app.LoadedFiles_GridLayout = uigridlayout(app.FileChoice_GridLayout);
            app.LoadedFiles_GridLayout.ColumnWidth = {'1x'};
            app.LoadedFiles_GridLayout.RowHeight = {30, '1x'};
            app.LoadedFiles_GridLayout.RowSpacing = 5;
            app.LoadedFiles_GridLayout.Layout.Row = 1;
            app.LoadedFiles_GridLayout.Layout.Column = 2;

            % Create Filesloaded_Label
            app.Filesloaded_Label = uilabel(app.LoadedFiles_GridLayout);
            app.Filesloaded_Label.HorizontalAlignment = 'center';
            app.Filesloaded_Label.FontName = 'Arial';
            app.Filesloaded_Label.Layout.Row = 1;
            app.Filesloaded_Label.Layout.Column = 1;
            app.Filesloaded_Label.Text = 'Files loaded and Processing type';

            % Create FileList_TextArea
            app.FileList_TextArea = uitextarea(app.LoadedFiles_GridLayout);
            app.FileList_TextArea.Editable = 'off';
            app.FileList_TextArea.FontName = 'Arial';
            app.FileList_TextArea.Layout.Row = 2;
            app.FileList_TextArea.Layout.Column = 1;

            % Create LoadingFile_GridLayout
            app.LoadingFile_GridLayout = uigridlayout(app.FileChoice_GridLayout);
            app.LoadingFile_GridLayout.ColumnWidth = {90, '1x'};
            app.LoadingFile_GridLayout.RowHeight = {30, 40, 25, 35, '1x'};
            app.LoadingFile_GridLayout.Layout.Row = 1;
            app.LoadingFile_GridLayout.Layout.Column = 1;

            % Create Method_Label
            app.Method_Label = uilabel(app.LoadingFile_GridLayout);
            app.Method_Label.HorizontalAlignment = 'center';
            app.Method_Label.FontName = 'Arial';
            app.Method_Label.Layout.Row = 1;
            app.Method_Label.Layout.Column = [1 2];
            app.Method_Label.Text = 'Method for loading files';

            % Create LoadingMethod_ButtonGroup
            app.LoadingMethod_ButtonGroup = uibuttongroup(app.LoadingFile_GridLayout);
            app.LoadingMethod_ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @FileLoadingMethod, true);
            app.LoadingMethod_ButtonGroup.Layout.Row = 2;
            app.LoadingMethod_ButtonGroup.Layout.Column = [1 2];

            % Create FolderChoice_Button
            app.FolderChoice_Button = uiradiobutton(app.LoadingMethod_ButtonGroup);
            app.FolderChoice_Button.Tag = 'FolderLoad';
            app.FolderChoice_Button.Text = 'Folder';
            app.FolderChoice_Button.FontName = 'Arial';
            app.FolderChoice_Button.Position = [34 9 58 22];
            app.FolderChoice_Button.Value = true;

            % Create ListChoice_Button
            app.ListChoice_Button = uiradiobutton(app.LoadingMethod_ButtonGroup);
            app.ListChoice_Button.Tag = 'MakeList';
            app.ListChoice_Button.Visible = 'off';
            app.ListChoice_Button.Text = 'List';
            app.ListChoice_Button.FontName = 'Arial';
            app.ListChoice_Button.Position = [127 9 65 22];

            % Create ExcelChoice_Button
            app.ExcelChoice_Button = uiradiobutton(app.LoadingMethod_ButtonGroup);
            app.ExcelChoice_Button.Tag = 'LoadExcel';
            app.ExcelChoice_Button.Visible = 'off';
            app.ExcelChoice_Button.Text = 'Excel';
            app.ExcelChoice_Button.FontName = 'Arial';
            app.ExcelChoice_Button.Position = [217 9 65 22];

            % Create FolderLoc_Label
            app.FolderLoc_Label = uilabel(app.LoadingFile_GridLayout);
            app.FolderLoc_Label.HorizontalAlignment = 'center';
            app.FolderLoc_Label.FontName = 'Arial';
            app.FolderLoc_Label.Layout.Row = 3;
            app.FolderLoc_Label.Layout.Column = 2;
            app.FolderLoc_Label.Text = 'Folder Location';

            % Create DataLoc_Button
            app.DataLoc_Button = uibutton(app.LoadingFile_GridLayout, 'push');
            app.DataLoc_Button.ButtonPushedFcn = createCallbackFcn(app, @LoadingData_Button, true);
            app.DataLoc_Button.FontName = 'Arial';
            app.DataLoc_Button.Layout.Row = 4;
            app.DataLoc_Button.Layout.Column = 1;
            app.DataLoc_Button.Text = 'Choose Folder';

            % Create DataLoc_TextArea
            app.DataLoc_TextArea = uitextarea(app.LoadingFile_GridLayout);
            app.DataLoc_TextArea.Editable = 'off';
            app.DataLoc_TextArea.FontName = 'Arial';
            app.DataLoc_TextArea.Layout.Row = [4 5];
            app.DataLoc_TextArea.Layout.Column = 2;

            % Create ProcesMethod_GridLayout
            app.ProcesMethod_GridLayout = uigridlayout(app.Main_GridLayout);
            app.ProcesMethod_GridLayout.ColumnWidth = {175, 40, 35, 20, 38, 175, 15, 40, 35, 20};
            app.ProcesMethod_GridLayout.RowHeight = {25, 30, 25, 30};
            app.ProcesMethod_GridLayout.ColumnSpacing = 1;
            app.ProcesMethod_GridLayout.RowSpacing = 5;
            app.ProcesMethod_GridLayout.Padding = [1 1 1 1];
            app.ProcesMethod_GridLayout.Layout.Row = 2;
            app.ProcesMethod_GridLayout.Layout.Column = 1;

            % Create Processmethod_Label
            app.Processmethod_Label = uilabel(app.ProcesMethod_GridLayout);
            app.Processmethod_Label.HorizontalAlignment = 'center';
            app.Processmethod_Label.FontName = 'Arial';
            app.Processmethod_Label.Layout.Row = 1;
            app.Processmethod_Label.Layout.Column = 1;
            app.Processmethod_Label.Text = 'Processing method';

            % Create AllFiles_Label
            app.AllFiles_Label = uilabel(app.ProcesMethod_GridLayout);
            app.AllFiles_Label.HorizontalAlignment = 'center';
            app.AllFiles_Label.FontName = 'Arial';
            app.AllFiles_Label.Visible = 'off';
            app.AllFiles_Label.Layout.Row = 1;
            app.AllFiles_Label.Layout.Column = [2 4];
            app.AllFiles_Label.Text = 'For all Files';

            % Create fileProcess_Label
            app.fileProcess_Label = uilabel(app.ProcesMethod_GridLayout);
            app.fileProcess_Label.HorizontalAlignment = 'center';
            app.fileProcess_Label.FontName = 'Arial';
            app.fileProcess_Label.Layout.Row = 1;
            app.fileProcess_Label.Layout.Column = 6;
            app.fileProcess_Label.Text = 'Apply process to file:';

            % Create ProcessType_DropDown
            app.ProcessType_DropDown = uidropdown(app.ProcesMethod_GridLayout);
            app.ProcessType_DropDown.FontName = 'Arial';
            app.ProcessType_DropDown.Layout.Row = 4;
            app.ProcessType_DropDown.Layout.Column = 1;

            % Create AllFiles_CheckBox
            app.AllFiles_CheckBox = uicheckbox(app.ProcesMethod_GridLayout);
            app.AllFiles_CheckBox.Visible = 'off';
            app.AllFiles_CheckBox.Text = '';
            app.AllFiles_CheckBox.Layout.Row = 4;
            app.AllFiles_CheckBox.Layout.Column = 3;
            app.AllFiles_CheckBox.Value = true;

            % Create FileChoice_DropDown
            app.FileChoice_DropDown = uidropdown(app.ProcesMethod_GridLayout);
            app.FileChoice_DropDown.FontName = 'Arial';
            app.FileChoice_DropDown.Layout.Row = 2;
            app.FileChoice_DropDown.Layout.Column = 6;

            % Create SaveChoice_Button
            app.SaveChoice_Button = uibutton(app.ProcesMethod_GridLayout, 'push');
            app.SaveChoice_Button.FontName = 'Arial';
            app.SaveChoice_Button.Layout.Row = 2;
            app.SaveChoice_Button.Layout.Column = [8 10];
            app.SaveChoice_Button.Text = 'Save Choice';

            % Create IncludeMClust_Label
            app.IncludeMClust_Label = uilabel(app.ProcesMethod_GridLayout);
            app.IncludeMClust_Label.HorizontalAlignment = 'right';
            app.IncludeMClust_Label.FontName = 'Arial';
            app.IncludeMClust_Label.Layout.Row = 4;
            app.IncludeMClust_Label.Layout.Column = [6 7];
            app.IncludeMClust_Label.Text = 'Include MClust';

            % Create RunMClust_CheckBox
            app.RunMClust_CheckBox = uicheckbox(app.ProcesMethod_GridLayout);
            app.RunMClust_CheckBox.Text = '';
            app.RunMClust_CheckBox.FontName = 'Arial';
            app.RunMClust_CheckBox.Layout.Row = 4;
            app.RunMClust_CheckBox.Layout.Column = 9;

            % Create MClustCurrentFile_Label
            app.MClustCurrentFile_Label = uilabel(app.ProcesMethod_GridLayout);
            app.MClustCurrentFile_Label.HorizontalAlignment = 'center';
            app.MClustCurrentFile_Label.FontName = 'Arial';
            app.MClustCurrentFile_Label.Layout.Row = 3;
            app.MClustCurrentFile_Label.Layout.Column = [8 10];
            app.MClustCurrentFile_Label.Text = 'All File';

            % Create LoadMethodAll_CheckBox
            app.LoadMethodAll_CheckBox = uicheckbox(app.ProcesMethod_GridLayout);
            app.LoadMethodAll_CheckBox.Visible = 'off';
            app.LoadMethodAll_CheckBox.Text = '';
            app.LoadMethodAll_CheckBox.FontName = 'Arial';
            app.LoadMethodAll_CheckBox.Layout.Row = 2;
            app.LoadMethodAll_CheckBox.Layout.Column = 3;
            app.LoadMethodAll_CheckBox.Value = true;

            % Create LoadingProcess_DropDown
            app.LoadingProcess_DropDown = uidropdown(app.ProcesMethod_GridLayout);
            app.LoadingProcess_DropDown.Layout.Row = 2;
            app.LoadingProcess_DropDown.Layout.Column = 1;

            % Create Savemethod_Label
            app.Savemethod_Label = uilabel(app.ProcesMethod_GridLayout);
            app.Savemethod_Label.HorizontalAlignment = 'center';
            app.Savemethod_Label.FontName = 'Arial';
            app.Savemethod_Label.Layout.Row = 3;
            app.Savemethod_Label.Layout.Column = 1;
            app.Savemethod_Label.Text = 'Save method';

            % Create Save_GridLayout
            app.Save_GridLayout = uigridlayout(app.Main_GridLayout);
            app.Save_GridLayout.ColumnWidth = {160, '1x'};
            app.Save_GridLayout.RowHeight = {25, 33, '1x'};
            app.Save_GridLayout.RowSpacing = 1;
            app.Save_GridLayout.Layout.Row = 3;
            app.Save_GridLayout.Layout.Column = 1;

            % Create UpdatesText_Label
            app.UpdatesText_Label = uilabel(app.Save_GridLayout);
            app.UpdatesText_Label.HorizontalAlignment = 'center';
            app.UpdatesText_Label.FontName = 'Arial';
            app.UpdatesText_Label.Layout.Row = 1;
            app.UpdatesText_Label.Layout.Column = 2;
            app.UpdatesText_Label.Text = 'Updates';

            % Create ProgressReadout
            app.ProgressReadout = uitextarea(app.Save_GridLayout);
            app.ProgressReadout.FontName = 'Arial';
            app.ProgressReadout.Layout.Row = [2 3];
            app.ProgressReadout.Layout.Column = 2;

            % Create RunBatch_Button
            app.RunBatch_Button = uibutton(app.Save_GridLayout, 'push');
            app.RunBatch_Button.ButtonPushedFcn = createCallbackFcn(app, @RunBatchProcess, true);
            app.RunBatch_Button.FontName = 'Arial';
            app.RunBatch_Button.Layout.Row = 2;
            app.RunBatch_Button.Layout.Column = 1;
            app.RunBatch_Button.Text = 'Run Batch Processing';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = BatchJTtime_exported

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