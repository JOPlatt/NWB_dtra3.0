function LoadingTypeUsed(app,event)

LoadType = event.Source.Tag;

switch LoadType
    case 'FolderLoad'
        app.DataLoc_Button.Text = 'Choose Folder';
        app.FolderLoc_Label.Text = 'Folder Location';
        app.Flags.LoadMethod = 1;
    case 'MakeList'
        app.DataLoc_Button.Text = 'Choose File';
        app.FolderLoc_Label.Text = 'File Location';
        app.Flags.LoadMethod = 2;
    case 'LoadExcel'
        app.DataLoc_Button.Text = 'Choose File';
        app.FolderLoc_Label.Text = 'Excel file Location';
        app.Flags.LoadMethod = 3;
end