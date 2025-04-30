function StartupNWB(app,varargin)
% collecting recorded information
Recording = varargin{:,:};
app.drta = Recording{1, 1}.drta_handles;

app.DisplayInterval_EditField.Value = app.drta.trial_duration;
app.SampleRate_EditField.Value = app.drta.draq_p.ActualRate;
% adding suggested file name
app.nwbFileName_EditField.Value = app.drta.p.FileName(1:end-4);