function Ptype = ProcessType(Pnum)

switch Pnum
    case 'Loading Screen'
        Ptype = {'...', 'dropcnsampler', 'dropcspm', ...
        'background', 'spmult', 'mspy', 'osampler', 'spm2mult', 'lighton1', ...
        'lighton5', 'dropcspm_conc', 'Laser-triggered', 'Laser-Merouann', ...
        'dropcspm_hf', 'Working_memoy', 'Continuous', 'Laser-Kira', ...
        'Laser-Schoppa'};
    case 'dropcnsampler'
        Ptype = 1;
    case 'dropcspm'
        Ptype = 2;
    case 'background'
        Ptype = 3;
    case 'spmult'
        Ptype = 4;
    case 'mspy'
        Ptype = 5;
    case 'osampler'
        Ptype = 6;
    case 'spm2mult'
        Ptype = 7;
    case 'lighton1'
        Ptype = 8;
    case 'lighton5'
        Ptype = 9;
    case 'dropcspm_conc'
        Ptype = 10;
    case 'Laser-triggered'
        Ptype = 11;
    case 'Laser-Merouann'
        Ptype = 12;
    case 'dropcspm_hf'
        Ptype = 13;
    case 'Working_memory'
        Ptype = 14;
    case 'Continuous'
        Ptype = 15;
    case 'Laser-Kira'
        Ptype = 16;
    case'Laser-Schoppa'
        Ptype = 17;
end