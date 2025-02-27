function VisualChoice(app)
%{
Raw
User Choice
Wide 4-100
High Theta 6-14
Theta 2-14
Beta 15-36
Gamma1 35-65
Gamma2 65-95
Gamma 35-95
Spikes 500-5000
Spike var
Digital
%}
DropChoice = app.Choice_DropDown.Value;

switch DropChoice
    case 'Raw'
        app.Flags.DataShownAs = 1;
    case 'User Choice'
        app.Flags.DataShownAs = 2;
    case 'Wide 4-100'
        app.Flags.DataShownAs = 3;
    case 'High Theta 6-14' 
        app.Flags.DataShownAs = 4;
    case 'Theta 2-14'
        app.Flags.DataShownAs = 5;
    case 'Beta 15-36'
        app.Flags.DataShownAs = 6;
    case 'Gamma1 35-65'
        app.Flags.DataShownAs = 7;
    case 'Gamma2 65-95'
        app.Flags.DataShownAs = 8;
    case 'Gamma 35-95'
        app.Flags.DataShownAs = 9;
    case 'Spikes 500-5000'
        app.Flags.DataShownAs = 10;
    case 'Spike var'
        app.Flags.DataShownAs = 11;
    case 'Digital'
        app.Flags.DataShownAs = 12;
end
app.drta_handles.p.whichPlot = app.Flags.DataShownAs;

