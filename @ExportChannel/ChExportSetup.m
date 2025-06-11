function ChExportSetup(app,drtaAPP)

ChAmt = drtaAPP.drta_handles.draq_p.no_spike_ch;
ChList = app.Ch_DropDown.Items;

for ii = 1:ChAmt
    ChList(1,ii+1) = sprintf('Channel %.2d', ii-1);
end
app.Ch_DropDown.Items = ChList;

app.MainApp = drtaApp;

app.OutputText = sprintf('Exporting data\n');
