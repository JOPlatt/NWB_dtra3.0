function RunningBachProcess(app,FileNum)

if nargin == 1
    for oo = 1:app.Flags.DataLoaded
        RunningBachProcess(app,oo)
    end
end
fname = sprintf('drtaFile%.3d',FileNum);
app.Flags.CurrentNum = FileNum;
SettingDrtaPresets(app,FileNum);
% drta_data = app.drta_Data;
if app.AllFiles_CheckBox.Value == 1
    app.data_files.(fname).p.which_c_program = ProcessType(app.ProcessType_DropDown.Value);
    app.data_files.(fname).p.which_protocol = LoadProcess(app.LoadingProcess_DropDown.Value);

end
if sum(app.drta_Save.p.VisableChannel) == app.data_files.(fname).draq_p.no_spike_ch
    app.Flags.SelectCh = 0;
else
    app.Flags.SelectCh = 1;
    app.data_files.(fname).SelectedCh = app.drta_Save.p.VisableChannel;
    app.data_files.(fname).SelectedAlogCh = app.drta_Save.p.VisableAnalog;
    app.data_files.(fname).SelectedDigCh  = app.drta_Save.p.VisableDigital;
end
app.data_files.(fname).trials.start = app.drta_Main.ChShown.InitialTrialAmt.Value;
app.data_files.(fname).trials.stop = app.drta_Main.ChShown.FinalTrialAmt.Value;
app.data_files.(fname).drtaWhichFile = app.data_files.(fname).p.fullName;

if FileNum > 1
    Batch_open_rhd(app,FileNum);
end
BatchSaveJTtimes(app,FileNum);
BatchSave_GenerateEvents(app,FileNum);
BatchSaving(app,app.data_files.(fname))

if app.RunMClust_CheckBox.Value == 1
    drta03_GenerateMClust(app);
end
