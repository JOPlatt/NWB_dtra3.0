function LoadData(app)

switch app.Flags.LoadMethod
    case 1
        MainFilePath = uigetdir(pwd,'Choose folder that contains all files.');
        FileInfo = dir(fullfile(MainFilePath,'*.rhd'));
        FileNum = size(FileInfo,1);
        FilePath = cell([FileNum,1]);
        FileName = cell([FileNum,1]);
        for aa = 1:FileNum
            FilePath{aa,1} = FileInfo(aa).folder;
            FileName{aa,1} = FileInfo(aa).name;
        end
        app.DataLoc_TextArea.Value = MainFilePath;
    case 2
        [FileName,FilePath] = uigetfile('*.xlx');
        ExcelTable = readtable(fullfile(FilePath,FileName));
        FileNum = size(ExcelTable,2);
    case 3
        [FileName,FilePath] = uigetfile('*.rhd');
        FileNum = 1;
end

if app.Flags.LoadMethod ~=3 && isempty(app.DataLoc_Button.Tag)
    app.DataLoc_Button.Text = 'Undo Choice';
    app.DataLoc_Button.Tag = 'UndoNeeded';
elseif app.Flags.LoadMethod ~= 3 && app.DataLoc_Button.Tag == "UndoNeeded"
    app.Flags.DataLoaded = 0;
end

app.UIFigure.focus;

if app.Flags.DataLoaded == 0
    % app.FileLoc = cell([FileNum,2]);
    app.Flags.DataLoaded = FileNum;
    for ss = 1:FileNum
        fname = sprintf('drtaFile%.3d',ss);
        app.data_files.(fname) = app.drta_Data;
        app.data_files.(fname).p.fullName = fullfile(FilePath{ss},FileName{ss});
        app.data_files.(fname).p.FileName = FileName{ss}; 
        app.data_files.(fname).p.PathName = FilePath{ss};
    end

else
    RowNum = app.Flags.DataLoaded + 1;
    app.Flags.DataLoaded = app.Flags.DataLoaded + 1;
    fname = sprintf('drtaFile%.3d',RowNum);
    app.data_files.(fname) = app.drta_Data;
    app.data_files.(fname).p.fullName = fullfile(FilePath,FileName);
    app.data_files.(fname).p.FileName = FileName; 
    app.data_files.(fname).p.PathName = FilePath;
end

app.drta_Main.digitalPlots.presetDone = false;
app.LoadChosenFilesButton.Enable = "on";