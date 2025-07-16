function programSwitch(app,varargin)

procesMethod = varargin{1};
switch app.drta_Data.p.which_c_program

    case (1)
        %dropcnsampler
        dropcnsampler_ProgramType(app,procesMethod,trialNo,shift_dropc_nsampler,shiftdata);
    case (2)
        % dropcspm
        dropcspm_ProgramType(app,procesMethod);
    case (3)
        %background
        background_ProgramType(app,procesMethod);
    case (4)
        %spmult
        spmult_ProgramType(app,procesMethod);
    case (5)
        %mspy
        mspy_ProgramType(app,procesMethod);
    case (6)
        %osampler
        osampler_ProgramType(app,procesMethod);
    case (7)
        %ospm2mult
        spm2mult_ProgramType(app,procesMethod);
    case(8)
        %lighton one pulse
        lighton1_ProgramType(app,procesMethod,data,trialNo);
    case (9)
        %lighton five pulses
        lighton5_ProgramType(app,procesMethod,data,trialNo);
    case (10)
        %dropcspm_conc
        dropcspm_conc_ProgramType(app,procesMethod,trialNo,shift_dropc_nsampler);
    case (11)
        %Ming laser
        LaserTriggered_ProgramType(app,procesMethod);
    case (12)
        %Merouann laser
        LaserMerouann_ProgramType(app,procesMethod);
    case (13)
        %dropcspm hf
        dropcspm_hf_ProgramType(app,procesMethod);
    case (14)
        %Working memory
        Working_memory_ProgramType(app,procesMethod);
    case (15)
        %Continuous
        Continuous_ProgramType(app,procesMethod);
    case (16)
        %Laser Kira
        Laser_Kira_ProgramType(app,procesMethod);
    case (17)
        %Laser Schoppa
        Laser_Schoppa_ProgramType(app,procesMethod);
end