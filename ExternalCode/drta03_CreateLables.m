function drta03_CreateLables(varargin)

app = varargin{1};

% determine program type and set up event labels
switch app.drta_handles.p.which_c_program
    case 1
        %dropcnsampler
        dropcnsampler_ProgramType(app,1)
    case 2
        dropcspm_ProgramType(app,1)
    case {13}
        %dropcspm, dropcspm_hf
        app.drta_handles.draq_d.nEvPerType=zeros(1,17);
        app.drta_handles.draq_d.nEventTypes=17;
        app.drta_handles.draq_d.eventlabels=cell(1,17);
        app.drta_handles.draq_d.eventlabels{1}='TStart';
        app.drta_handles.draq_d.eventlabels{2}='OdorOn';
        app.drta_handles.draq_d.eventlabels{3}='Hit';
        app.drta_handles.draq_d.eventlabels{4}='HitE';
        app.drta_handles.draq_d.eventlabels{5}='S+';
        app.drta_handles.draq_d.eventlabels{6}='S+E';
        app.drta_handles.draq_d.eventlabels{7}='Miss';
        app.drta_handles.draq_d.eventlabels{8}='MissE';
        app.drta_handles.draq_d.eventlabels{9}='CR';
        app.drta_handles.draq_d.eventlabels{10}='CRE';
        app.drta_handles.draq_d.eventlabels{11}='S-';
        app.drta_handles.draq_d.eventlabels{12}='S-E';
        app.drta_handles.draq_d.eventlabels{13}='FA';
        app.drta_handles.draq_d.eventlabels{14}='FAE';
        app.drta_handles.draq_d.eventlabels{15}='Reinf';
        app.drta_handles.draq_d.eventlabels{16}='Short';
        app.drta_handles.draq_d.eventlabels{17}='Inter';
        
    case(3)
        %background
        app.drta_handles.draq_d.nEvPerType=zeros(1,9);
        app.drta_handles.draq_d.nEventTypes=9;
        app.drta_handles.draq_d.eventlabels=cell(1,9);
        app.drta_handles.draq_d.eventlabels{1}='OdorA';
        app.drta_handles.draq_d.eventlabels{2}='OdorB';
        app.drta_handles.draq_d.eventlabels{3}='OdorAB';
        app.drta_handles.draq_d.eventlabels{4}='BkgA';
        app.drta_handles.draq_d.eventlabels{5}='BkgB';
        app.drta_handles.draq_d.eventlabels{6}='OdorBBkgA';
        app.drta_handles.draq_d.eventlabels{7}='OdorABkgB';
        app.drta_handles.draq_d.eventlabels{8}='OdorBBkgB';
        app.drta_handles.draq_d.eventlabels{9}='OdorABkgA';
    case(4)
        %spmult
        prompt = {'Enter the number of odors used as S+:'};
        dlg_title = 'Input for spmult';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_spmult_odors=str2num(answer{1});
        app.drta_handles.draq_d.nsp_odors = num_spmult_odors;
        
        app.drta_handles.draq_d.nEvPerType=zeros(1,9+num_spmult_odors*3);
        app.drta_handles.draq_d.nEventTypes=9+num_spmult_odors*3;
        app.drta_handles.draq_d.eventlabels=cell(1,9+num_spmult_odors*3);
        app.drta_handles.draq_d.eventlabels{1}='TStart';
        app.drta_handles.draq_d.eventlabels{2}='OdorOn';
        app.drta_handles.draq_d.eventlabels{3}='CR';
        app.drta_handles.draq_d.eventlabels{4}='S-';
        app.drta_handles.draq_d.eventlabels{5}='FA';
        app.drta_handles.draq_d.eventlabels{6}='Reinf';
        app.drta_handles.draq_d.eventlabels{7}='S+';
        app.drta_handles.draq_d.eventlabels{8}='Hit';
        app.drta_handles.draq_d.eventlabels{9}='Miss';
        
        for odNum=1:num_spmult_odors
            app.drta_handles.draq_d.eventlabels{9+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S+'];
            app.drta_handles.draq_d.eventlabels{9+3*(odNum-1)+2}=['Odor' num2str(odNum) '-Hit'];
            app.drta_handles.draq_d.eventlabels{9+3*(odNum-1)+3}=['Odor' num2str(odNum) '-Miss'];
        end
    case (5)
        %mspy
        [FileName,PathName] = uigetfile('*.*','Enter location of keys.dat file');
        fullName=[PathName,FileName];
        fid=fopen(fullName);
        sec_post_trigger=textscan(fid,'%d',1);
        num_keys=textscan(fid,'%d',1);
        key_names=textscan(fid,'%s',num_keys{1});
        fclose(fid)
        for ii=1:num_keys{1}
            app.drta_handles.draq_d.eventlabels{ii}=key_names{1}(ii);
        end
        app.drta_handles.draq_d.nEvPerType=zeros(1,num_keys{1});
        app.drta_handles.draq_d.nEventTypes=num_keys{1};
    case (6)
        %osampler
        prompt = {'Enter the number of odors used:'};
        dlg_title = 'Input for osampler';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_spmult_odors=str2num(answer{1});
        app.drta_handles.draq_d.nsp_odors = num_spmult_odors;
        
        app.drta_handles.draq_d.nEvPerType=zeros(1,5+num_spmult_odors*3);
        app.drta_handles.draq_d.nEventTypes=5+num_spmult_odors*3;
        app.drta_handles.draq_d.eventlabels=cell(1,5+num_spmult_odors*3);
        app.drta_handles.draq_d.eventlabels{1}='TStart';
        app.drta_handles.draq_d.eventlabels{2}='OdorOn';
        app.drta_handles.draq_d.eventlabels{3}='Reinf';
        app.drta_handles.draq_d.eventlabels{4}='Hit';
        app.drta_handles.draq_d.eventlabels{5}='Miss';
        
        for odNum=1:num_spmult_odors
            app.drta_handles.draq_d.eventlabels{5+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S+'];
            app.drta_handles.draq_d.eventlabels{5+3*(odNum-1)+2}=['Odor' num2str(odNum) '-Hit'];
            app.drta_handles.draq_d.eventlabels{5+3*(odNum-1)+3}=['Odor' num2str(odNum) '-Miss'];
        end
        
    case(7)
        %spm2mult
        prompt = {'Enter the number of odors used as S+:'};
        dlg_title = 'Input for spm2mult';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_splus_odors=str2num(answer{1});
        app.drta_handles.draq_d.nsp_odors = num_splus_odors;
        
        prompt = {'Enter the number of odors used as S-:'};
        dlg_title = 'Input for spm2mult';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines);
        num_sminus_odors=str2num(answer{1});
        
        num_spmult_odors=num_sminus_odors+num_splus_odors;
        
        app.drta_handles.draq_d.nEvPerType=zeros(1,3+num_spmult_odors*3);
        app.drta_handles.draq_d.nEventTypes=3+num_spmult_odors*3;
        app.drta_handles.draq_d.eventlabels=cell(1,3+num_spmult_odors*3);
        app.drta_handles.draq_d.eventlabels{1}='TStart';
        app.drta_handles.draq_d.eventlabels{2}='OdorOn';
        app.drta_handles.draq_d.eventlabels{3}='Reinf';
        
        for odNum=1:num_splus_odors
            app.drta_handles.draq_d.eventlabels{3+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S+'];
            app.drta_handles.draq_d.eventlabels{3+3*(odNum-1)+2}=['Odor' num2str(odNum) '-Hit'];
            app.drta_handles.draq_d.eventlabels{3+3*(odNum-1)+3}=['Odor' num2str(odNum) '-Miss'];
        end
        
        for odNum=num_splus_odors+1:num_spmult_odors
            app.drta_handles.draq_d.eventlabels{3+3*(odNum-1)+1}=['Odor' num2str(odNum) '-S-'];
            app.drta_handles.draq_d.eventlabels{3+3*(odNum-1)+2}=['Odor' num2str(odNum) '-CR'];
            app.drta_handles.draq_d.eventlabels{3+3*(odNum-1)+3}=['Odor' num2str(odNum) '-FA'];
        end
        
    case {8,17}
        %lighton1
        app.drta_handles.draq_d.nEvPerType=zeros(1,2);
        app.drta_handles.draq_d.nEventTypes=2;
        app.drta_handles.draq_d.eventlabels=cell(1,2);
        
        app.drta_handles.draq_d.eventlabels{1}='LightOn';
        app.drta_handles.draq_d.eventlabels{2}='LightOn';
        
    case (9)
        %lighton5
        app.drta_handles.draq_d.nEvPerType=zeros(1,7);
        app.drta_handles.draq_d.nEventTypes=7;
        app.drta_handles.draq_d.eventlabels=cell(1,7);
        
        app.drta_handles.draq_d.eventlabels{1}='LightOn';
        app.drta_handles.draq_d.eventlabels{2}='LightOn';
        app.drta_handles.draq_d.eventlabels{3}='10';
        app.drta_handles.draq_d.eventlabels{4}='30';
        app.drta_handles.draq_d.eventlabels{5}='60';
        app.drta_handles.draq_d.eventlabels{6}='100';
        app.drta_handles.draq_d.eventlabels{7}='200';
        
    case (10)
        %dropcspm_conc
        app.drta_handles.draq_d.nEvPerType=zeros(1,23);
        app.drta_handles.draq_d.nEventTypes=23;
        app.drta_handles.draq_d.eventlabels=cell(1,23);
        app.drta_handles.draq_d.eventlabels{1}='TStart';
        app.drta_handles.draq_d.eventlabels{2}='OdorOn';
        app.drta_handles.draq_d.eventlabels{3}='Hit';
        app.drta_handles.draq_d.eventlabels{4}='HitE';
        app.drta_handles.draq_d.eventlabels{5}='S+';
        app.drta_handles.draq_d.eventlabels{6}='S+E';
        app.drta_handles.draq_d.eventlabels{7}='Miss';
        app.drta_handles.draq_d.eventlabels{8}='MissE';
        app.drta_handles.draq_d.eventlabels{9}='CR';
        app.drta_handles.draq_d.eventlabels{10}='CRE';
        app.drta_handles.draq_d.eventlabels{11}='S-';
        app.drta_handles.draq_d.eventlabels{12}='S-E';
        app.drta_handles.draq_d.eventlabels{13}='FA';
        app.drta_handles.draq_d.eventlabels{14}='FAE';
        app.drta_handles.draq_d.eventlabels{15}='Reinf';
        app.drta_handles.draq_d.eventlabels{16}='Hi Od1'; %Highest concentration
        app.drta_handles.draq_d.eventlabels{17}='Hi Od2';
        app.drta_handles.draq_d.eventlabels{18}='Hi Od3';
        app.drta_handles.draq_d.eventlabels{19}='Low Od4';
        app.drta_handles.draq_d.eventlabels{20}='Low Od5';
        app.drta_handles.draq_d.eventlabels{21}='Low Od6'; %Lowest concentration
        app.drta_handles.draq_d.eventlabels{22}='Short';
        app.drta_handles.draq_d.eventlabels{23}='Inter';
    case (11)
        %Ming laser
        app.drta_handles.draq_d.nEvPerType=zeros(1,3);
        app.drta_handles.draq_d.nEventTypes=3;
        app.drta_handles.draq_d.eventlabels=cell(1,3);
        app.drta_handles.draq_d.eventlabels{1}='Laser';
        app.drta_handles.draq_d.eventlabels{2}='All';
        app.drta_handles.draq_d.eventlabels{3}='Inter';
    case (12)
        %Merouann laser
        app.drta_handles.draq_d.nEvPerType=zeros(1,3);
        app.drta_handles.draq_d.nEventTypes=3;
        app.drta_handles.draq_d.eventlabels=cell(1,3);
        app.drta_handles.draq_d.eventlabels{1}='Laser';
        app.drta_handles.draq_d.eventlabels{2}='All';
        app.drta_handles.draq_d.eventlabels{3}='Inter';
        
    case {14}
        %Working memory
        app.drta_handles.draq_d.nEvPerType=zeros(1,15);
        app.drta_handles.draq_d.nEventTypes=15;
        app.drta_handles.draq_d.eventlabels=cell(1,15);
        app.drta_handles.draq_d.eventlabels{1}='TStart';
        app.drta_handles.draq_d.eventlabels{2}='OdorOn';
        app.drta_handles.draq_d.eventlabels{3}='NM_Hit';
        app.drta_handles.draq_d.eventlabels{4}='AB';
        app.drta_handles.draq_d.eventlabels{5}='NonMatch';
        app.drta_handles.draq_d.eventlabels{6}='BA';
        app.drta_handles.draq_d.eventlabels{7}='NM_Miss';
        app.drta_handles.draq_d.eventlabels{8}='Blank';
        app.drta_handles.draq_d.eventlabels{9}='M_CR';
        app.drta_handles.draq_d.eventlabels{10}='AA';
        app.drta_handles.draq_d.eventlabels{11}='Match';
        app.drta_handles.draq_d.eventlabels{12}='BB';
        app.drta_handles.draq_d.eventlabels{13}='M_FA';
        app.drta_handles.draq_d.eventlabels{14}='Blank';
        app.drta_handles.draq_d.eventlabels{15}='Reinf';
        
    case(15)
        %Continuous
        app.drta_handles.draq_d.nEventTypes=2;
        app.drta_handles.draq_d.nEvPerType=zeros(1,2);
        app.drta_handles.draq_d.eventlabels=[];
        app.drta_handles.draq_d.eventlabels{1}='Event1';
        app.drta_handles.draq_d.eventlabels{2}='Event1';

    case (16)
        %Kira's laser
        %dropcspm, dropcspm_hf
        app.drta_handles.draq_d.nEvPerType=zeros(1,17);
        app.drta_handles.draq_d.nEventTypes=17;
        app.drta_handles.draq_d.eventlabels=cell(1,17);
        app.drta_handles.draq_d.eventlabels{1}='TStart';
        app.drta_handles.draq_d.eventlabels{2}='OdorOn';
        app.drta_handles.draq_d.eventlabels{3}='Hit';
        app.drta_handles.draq_d.eventlabels{4}='HitL';
        app.drta_handles.draq_d.eventlabels{5}='S+';
        app.drta_handles.draq_d.eventlabels{6}='S+L';
        app.drta_handles.draq_d.eventlabels{7}='Miss';
        app.drta_handles.draq_d.eventlabels{8}='MissL';
        app.drta_handles.draq_d.eventlabels{9}='CR';
        app.drta_handles.draq_d.eventlabels{10}='CRL';
        app.drta_handles.draq_d.eventlabels{11}='S-';
        app.drta_handles.draq_d.eventlabels{12}='S-L';
        app.drta_handles.draq_d.eventlabels{13}='FA';
        app.drta_handles.draq_d.eventlabels{14}='FAL';
        app.drta_handles.draq_d.eventlabels{15}='Reinf';
        app.drta_handles.draq_d.eventlabels{16}='Laser';
        app.drta_handles.draq_d.eventlabels{17}='Int';
        
end