function RunningBachProcess(app)



for oo = 1:app.Flags.DataLoaded
    clear app.drta_data
    
    app.drta_data.FileLoc = app.FileLoc{oo,1};
    app.drta_data.FileName = app.FileLoc{oo,2};
    app.Flags.CurrentNum = oo;
    SettingDrtaPresets(app)
    if app.AllFiles_CheckBox.Value == 1
        switch app.ProcessType_DropDown.Value
            case 'dropcnsampler'
                cpNum = 1;
            case 'dropcspm'
                cpNum = 2;
            case 'background'
                cpNum = 3;
            case 'spmult'
                cpNum = 4;
            case 'mspy'
                cpNum = 5;
            case 'osampler'
                cpNum = 6;
            case 'spm2mult'
                cpNum = 7;
            case 'lighton1'
                cpNum = 8;
            case 'lighton5'
                cpNum = 9;
            case 'dropcspm_conc'
                cpNum = 10;
            case 'Laser-triggered'
                cpNum = 11;
            case 'Laser-Merouann'
                cpNum = 12;
            case 'dropcspm_hf'
                cpNum = 13;
            case 'Working_memory'
                cpNum = 14;
            case 'Continuous'
                cpNum = 15;
            case 'Laser-Kira'
                cpNum = 16;
            case'Laser-Schoppa'
                cpNum = 17;
        end

        app.drta_data.p.which_c_program = cpNum;
        for ii = 1:size(app.FileLoc,1)
            switch app.LoadingProcess_DropDown.Value
                case 'dropcspm'
                    wpNum = 1;
                case 'laser (Ming)'
                    wpNum = 2;
                case 'dropcnsampler'
                    wpNum = 3;
                case 'laser (Merouann)'
                    wpNum = 4;
                case 'dropc_conc'
                    wpNum = 5;
                case 'dropcspm_hf'
                    wpNum = 6;
                case 'continuous'
                    wpNum = 7;
                case 'working_memory'
                    wpNum = 8;
                case 'laser (Schoppa)'
                    wpNum = 9;
            end
            app.FileProcInfo(ii) = wpNum;
        end
    end
    

    filename = fullfile(app.drta_data.FileLoc,app.drta_data.FileName);
    app.drta_data.drtaWhichFile = filename;
    app.drta_data.p.fullName = filename;
    app.drta_data.p.PathName = app.drta_data.FileLoc;
    app.drta_data.p.FileName = app.drta_data.FileName;
    Batch_open_rhd(app);
    BatchSaveJTtimes(app);
    if app.RunMClust_CheckBox.Value == 1
        drta03_GenerateMClust(app);
    end
end