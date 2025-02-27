function CprogramChoice(app)

switch app.Cprogrom_DropDown.Value
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

app.drta_handles.p.which_c_program = cpNum;