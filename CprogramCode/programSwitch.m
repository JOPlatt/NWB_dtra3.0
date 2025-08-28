function programSwitch(app,varargin)

procesMethod = varargin{1};
if nargin == 3
    FileNum = varargin{2};
    fname = sprintf('drtaFile%.3d',FileNum);
    DataSet = app.data_files.(fname);
else
    DataSet = app.drta_Data;
end

switch app.drta_Data.p.which_c_program
    case (1)
        %dropcnsampler; trialNo,shift_dropc_nsampler,shiftdata
        DataSet = dropcnsampler_ProgramType(app,procesMethod,DataSet);
    case (2)
        % dropcspm
        DataSet = dropcspm_ProgramType(app,procesMethod,DataSet);
    case (3)
        %background
        DataSet = background_ProgramType(app,procesMethod,DataSet);
    case (4)
        %spmult
        DataSet = spmult_ProgramType(app,procesMethod,DataSet);
    case (5)
        %mspy
        DataSet = mspy_ProgramType(app,procesMethod,DataSet);
    case (6)
        %osampler
        DataSet = osampler_ProgramType(app,procesMethod,DataSet);
    case (7)
        %ospm2mult
        DataSet = spm2mult_ProgramType(app,procesMethod,DataSet);
    case(8)
        %lighton one pulse
        DataSet = lighton1_ProgramType(app,procesMethod,DataSet);
    case (9)
        %lighton five pulses
        DataSet = lighton5_ProgramType(app,procesMethod,DataSet);
    case (10)
        %dropcspm_conc 
        DataSet = dropcspm_conc_ProgramType(app,procesMethod,DataSet);
    case (11)
        %Ming laser
        DataSet = LaserTriggered_ProgramType(app,procesMethod,DataSet);
    case (12)
        %Merouann laser
        DataSet = LaserMerouann_ProgramType(app,procesMethod,DataSet);
    case (13)
        %dropcspm hf
        DataSet = dropcspm_hf_ProgramType(app,procesMethod,DataSet);
    case (14)
        %Working memory
        DataSet = Working_memory_ProgramType(app,procesMethod,DataSet);
    case (15)
        %Continuous
        DataSet = Continuous_ProgramType(app,procesMethod,DataSet);
    case (16)
        %Laser Kira
        DataSet = Laser_Kira_ProgramType(app,procesMethod,DataSet);
    case (17)
        %Laser Schoppa
        DataSet = Laser_Schoppa_ProgramType(app,procesMethod,DataSet);
end

if nargin == 3
    FileNum = varargin{2};
    fname = sprintf('drtaFile%.3d',FileNum);
    app.data_files.(fname) = DataSet;
else
    app.drta_Data = DataSet;
end