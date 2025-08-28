function Loadtype = LoadProcess(TypeNum)

switch TypeNum
    case 'Loading Screen'
        Loadtype = {'...', ...
            'dropcspm', ...
            'laser (Ming)', ...
            'dropcnsampler', ...
            'laser (Merouann)', ...
            'dropc_conc', ...
            'dropcspm_hf', ...
            'continuous', ...
            'working_memory', ...
            'laser (Schoppa)'};
    case 'dropcspm'
        Loadtype = 1;
    case 'laser (Ming)'
        Loadtype = 2;
    case 'dropcnsampler'
        Loadtype = 3;
    case 'laser (Merouann)'
        Loadtype = 4;
    case 'dropc_conc'
        Loadtype = 5;
    case 'dropcspm_hf'
        Loadtype = 6;
    case 'continuous'
        Loadtype = 7;
    case 'working_memory'
        Loadtype = 8;
    case 'laser (Schoppa)'
        Loadtype = 9;
    
end