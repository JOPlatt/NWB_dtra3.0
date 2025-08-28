function DataSet = Laser_Schoppa_ProgramType(~,varargin)

ProcessType = varargin{1};
DataSet = varargin{2};
%{
uncomment if number of electrode channels is needed and add app where ~
is located in the input arg.
%}
% if app.Flags.SelectCh == 1
%     NumCh = sum(DataSet.SelectedCh);
% else
%     NumCh = DataSet.draq_p.no_spike_ch;
% end

switch ProcessType
    case 1 % generates labels
        DataSet.draq_d.nEvPerType=zeros(1,2);
        DataSet.draq_d.nEventTypes=2;
        DataSet.draq_d.eventlabels=cell(1,2);
        
        DataSet.draq_d.eventlabels{1}='LightOn';
        DataSet.draq_d.eventlabels{2}='LightOn';
    case 2 % trial exclusion and create events
        trialNo = DataSet.TrialsSaved;
        shiftdata = DataSet.shiftdata;
        firstdig=find(shiftdata==26,1,'first');
        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+firstdig/DataSet.draq_p.ActualRate;
        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=1;
        DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;


        DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
        DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+firstdig/DataSet.draq_p.ActualRate;
        DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
        DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;

    case 3 % setup for block number
        DataSet.draq_d.blocks(1,1)=DataSet.draq_d.t_trial(1)-9;
        DataSet.draq_d.blocks(1,2)=DataSet.draq_d.t_trial(end)+9;
end
