function DropChoiceDropDown(app)

switch DropChoice
    case 'Raw'
        app.drta_handles.p.whichPlot = 1;
    case 'User Choice'
        app.drta_handles.p.whichPlot = 2;
    case 'Wide 4-100'
        app.drta_handles.p.whichPlot = 3;
    case 'High Theta 6-14'
        app.drta_handles.p.whichPlot = 4;
    case 'Theta 2-14'
        app.drta_handles.p.whichPlot = 5;
    case 'Beta 15-36'
        app.drta_handles.p.whichPlot = 6;
    case 'Gamma1 35-65'
        app.drta_handles.p.whichPlot = 7;
    case 'Gamma2 65-95'
        app.drta_handles.p.whichPlot = 8;
    case 'Gamma 35-95'
        app.drta_handles.p.whichPlot = 9;
    case 'Spikes 500-5000'
        app.drta_handles.p.whichPlot = 10;
    case 'Spike var'
        app.drta_handles.p.whichPlot = 11;
    case 'Digital'
        app.drta_handles.p.whichPlot = 12;
end

