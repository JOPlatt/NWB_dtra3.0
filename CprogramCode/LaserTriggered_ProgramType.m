function DataSet = LaserTriggered_ProgramType(~,varargin)

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
        DataSet.draq_d.nEvPerType=zeros(1,3);
        DataSet.draq_d.nEventTypes=3;
        DataSet.draq_d.eventlabels=cell(1,3);
        DataSet.draq_d.eventlabels{1}='Laser';
        DataSet.draq_d.eventlabels{2}='All';
        DataSet.draq_d.eventlabels{3}='Inter';
    case 2 % trial exclusion and create events
        trialNo = DataSet.TrialsSaved;
        if sum(DataSet.laser>(DataSet.draq_d.min_laser+(DataSet.draq_d.max_laser-DataSet.draq_d.min_laser)/2))==0
            %This is an inter trial
            t_start=3*DataSet.draq_p.ActualRate;
            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+t_start/DataSet.draq_p.ActualRate;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=2;
            DataSet.draq_d.nEvPerType(2)=DataSet.draq_d.nEvPerType(2)+1;

        else
            %This is a laser trial
            k=find(DataSet.laser(ceil(2.5*DataSet.draq_p.ActualRate):end,1)>(DataSet.draq_d.min_laser+(DataSet.draq_d.max_laser-DataSet.draq_d.min_laser)/2),1,'first');
            t_start=ceil(2.5*DataSet.draq_p.ActualRate)+k-1;
            DataSet.draq_d.noEvents=DataSet.draq_d.noEvents+1;
            DataSet.draq_d.events(DataSet.draq_d.noEvents)=DataSet.draq_d.t_trial(trialNo)+t_start/DataSet.draq_p.ActualRate;
            DataSet.draq_d.eventType(DataSet.draq_d.noEvents)=1;
            DataSet.draq_d.nEvPerType(1)=DataSet.draq_d.nEvPerType(1)+1;
        end
    case 3 % setup for block number
        DataSet.draq_d.blocks(1,1)=min(DataSet.draq_d.events)-0.00001;
        DataSet.draq_d.blocks(1,2)=max(DataSet.draq_d.events)+0.00001;
end