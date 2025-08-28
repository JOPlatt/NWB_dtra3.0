function DataSet = background_ProgramType(~,varargin)

ProcessType = varargin{1};
DataSet = varargin{2};

switch ProcessType
    case 1 % generates labels
        DataSet.draq_d.nEvPerType=zeros(1,9);
        DataSet.draq_d.nEventTypes=9;
        DataSet.draq_d.eventlabels=cell(1,9);
        DataSet.draq_d.eventlabels{1}='OdorA';
        DataSet.draq_d.eventlabels{2}='OdorB';
        DataSet.draq_d.eventlabels{3}='OdorAB';
        DataSet.draq_d.eventlabels{4}='BkgA';
        DataSet.draq_d.eventlabels{5}='BkgB';
        DataSet.draq_d.eventlabels{6}='OdorBBkgA';
        DataSet.draq_d.eventlabels{7}='OdorABkgB';
        DataSet.draq_d.eventlabels{8}='OdorBBkgB';
        DataSet.draq_d.eventlabels{9}='OdorABkgA';
    case 2 % trial exclusion and create events
        shiftdata = DataSet.shiftdata;
        trialNo = DataSet.TrialsSaved;
        % create events
        for ii=2:2:18
            t_start=find(shiftdata==ii,1,'first');
            if ~isempty(t_start)
                DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
                DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(TrialCount(trialNo))+t_start/DataSet.draq_p.ActualRate;
                DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=ii/2;
                DataSet.draq_d.nEvPerType(ii/2)=DataSet.draq_d.nEvPerType(ii/2)+1;
            end
        end
        
    case 3 % setup for block number
        DataSet.draq_d.blocks(1,1)=min(DataSet.draq_d.events)-0.00001;
        DataSet.draq_d.blocks(1,2)=max(DataSet.draq_d.events)+0.00001;
end
