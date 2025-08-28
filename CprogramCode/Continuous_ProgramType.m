function DataSet = Continuous_ProgramType(~,varargin)

ProcessType = varargin{1};
DataSet = varargin{2};
%{
uncomment if number of electrode channels is needed 
%}
% if app.Flags.SelectCh == 1
%     NumCh = sum(DataSet.SelectedCh);
% else
%     NumCh = DataSet.draq_p.no_spike_ch;
% end

switch ProcessType
    case 1 % generates labels
        DataSet.draq_d.nEventTypes=2;
        DataSet.draq_d.nEvPerType=zeros(1,2);
        DataSet.draq_d.eventlabels=[];
        DataSet.draq_d.eventlabels{1}='Event1';
        DataSet.draq_d.eventlabels{2}='Event1';
    case 2 % trial exclusion and create events
        trialNo = DataSet.TrialsSaved;
        %Event1
        t_start=(3+0.2)*DataSet.draq_p.ActualRate;  %Note: 0.2 is a time pad used for filtering
        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+t_start/DataSet.draq_p.ActualRate;
        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=1;
        DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;

        %Event2
        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+t_start/DataSet.draq_p.ActualRate;
        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
        DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;
    case 3 % setup for block number
        DataSet.draq_d.blocks(1,1)=min(DataSet.draq_d.events)-0.00001;
        DataSet.draq_d.blocks(1,2)=max(DataSet.draq_d.events)+0.00001;
end