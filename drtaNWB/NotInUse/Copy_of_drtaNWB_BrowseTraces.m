
% --- Outputs from this function are returned to the command line.
function varargout = drtaBrowseTraces_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function draqPSWhichChan_CreateFcn(hObject, eventdata, handles)
%{
Not too sure it is related to a drop down menu
%}



% --- Should be called by parent window
function updateHandles(hObject, eventdata, handdrta)

tic


% Setup popup strings
popstr={'all','1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Digital'};
set(handles.drtaPSWhichChan,'String',popstr); %drop down menu popup menu
set(handles.drtaWhichDisplay,'String',popstr); %drop down for choosing which display is shown
set(handles.drtaEditYRange,'String',num2str(handles.draq_p.prev_ylim(1))); % changes the y limits +/-
% NEEDS to be reassinged to new drta3
set(handles.drtaTrialPush,'String',getTrialNo(handles.w.drta));
% set(handles.drtaTrialPush,'String',drta('getTrialNo',handles.w.drta));
set(handles.drtaEditTimeStart,'String',num2str(handles.p.start_display_time)); % trial number
set(handles.drtaEditTimeInterval,'String',num2str(handles.p.display_interval)); % time interval box
set(handles.drtaRadioFilter,'Value',handles.p.do_filter);   % assigning to a deop down menu next to pull threshold
set(handles.drtaLFPmax,'String',num2str(handles.p.lfp.maxLFP))  % text boxes indicating the max on LFP
set(handles.drtaLFPmin,'String',num2str(handles.p.lfp.minLFP))  % text box indicating the min on LFP
%set(handles.drtaBrTr3xSD,'Value',handles.p.do_3xSD);

%Please note that in the old files there is no handles.p.doSubtract
if ~isfield(handles.p,'doSubtract')
   handles.p.doSubtract=0;
   handles.p.subtractCh=zeros(1,16);
end
%sets the button to true or false based on ..p.doSubtract
set(handles.drtaDiff,'Value', handles.p.doSubtract);
%{
Setting all the string text for each drop down next to the figure
Do not think this is needed!!
%}
popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub1,'String',popstr);
set(handles.drtaSub1,'Value',handles.p.subtractCh(1));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub2,'String',popstr);
set(handles.drtaSub2,'Value',handles.p.subtractCh(2));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub3,'String',popstr);
set(handles.drtaSub3,'Value',handles.p.subtractCh(3));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub4,'String',popstr);
set(handles.drtaSub4,'Value',handles.p.subtractCh(4));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub5,'String',popstr);
set(handles.drtaSub5,'Value',handles.p.subtractCh(5));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub6,'String',popstr);
set(handles.drtaSub6,'Value',handles.p.subtractCh(6));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub7,'String',popstr);
set(handles.drtaSub7,'Value',handles.p.subtractCh(7));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub8,'String',popstr);
set(handles.drtaSub8,'Value',handles.p.subtractCh(8));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub9,'String',popstr);
set(handles.drtaSub9,'Value',handles.p.subtractCh(9));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub10,'String',popstr);
set(handles.drtaSub10,'Value',handles.p.subtractCh(10));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub11,'String',popstr);
set(handles.drtaSub11,'Value',handles.p.subtractCh(11));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub12,'String',popstr);
set(handles.drtaSub12,'Value',handles.p.subtractCh(12));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub13,'String',popstr);
set(handles.drtaSub13,'Value',handles.p.subtractCh(13));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub14,'String',popstr);
set(handles.drtaSub14,'Value',handles.p.subtractCh(14));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub15,'String',popstr);
set(handles.drtaSub15,'Value',handles.p.subtractCh(15));

popstr={'1','2', '3','4','5','6','7','8','9','10','11','12','13','14','15','16','Tet','Avg','No'};
set(handles.drtaSub16,'String',popstr);
set(handles.drtaSub16,'Value',handles.p.subtractCh(16));

popstr={'Raw','Wide 4-100','High Theta 6-14','Theta 2-14','Beta 15-36','Gamma1 35-65',...
    'Gamma2 65-95','Gamma 35-95','Spikes 500-5000','Spike var', 'digital'};
%sets this drop down to the values of popstr (1-16 ...)
set(handles.drtaRadioFilter,'String',popstr);
set(handles.drtaRadioFilter,'Value',1);
%lick button setting on or off based on handles.p.exc_sc 
if isfield(handles.p,'exc_sn')
   set(handles.drtaRadioExclSn,'Value',handles.p.exc_sn);
else
    handles.p.exc_sn=0; %false
end

handles.draq_p.auto_thr_sign=1;


toc


% --- Should be called by parent window
function up = getUpdatePreview(hObject)

up = handles.p.update_preview;

% --- Should be called by parent window
function ylim = getYlim(hObject)
% hObject    handle to drsDisplaySingle
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles=guidata(hObject);
ylim = handles.p.prev_ylim;





function drtaEditYRange_Callback(hObject, eventdata, handles)
% hObject    handle to drtaEditYRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaEditYRange as text
%        str2double(get(hObject,'String')) returns contents of drtaEditYRange as a double

y_range=str2double(get(hObject,'String'));

v_range=y_range*handles.draq_p.pre_gain*handles.draq_p.daq_gain/1000000;

% if v_range>handles.draq_p.inp_max
%     set(hObject,'String',num2str(1000000*handles.draq_p.inp_max/(handles.draq_p.pre_gain*handles.draq_p.daq_gain)));
% end
            
if (handles.p.which_channel==1)
   %Change for all channels
    for ii=1:handles.draq_p.no_spike_ch
%         if v_range>handles.draq_p.inp_max
%             handles.draq_p.prev_ylim(ii)=1000000*handles.draq_p.inp_max/(handles.draq_p.pre_gain*handles.draq_p.daq_gain);
%         else
            handles.draq_p.prev_ylim(ii)=y_range;
%         end
    end
else
    ii=handles.p.which_channel-1;
%     if v_range>handles.draq_p.inp_max
%         handles.draq_p.prev_ylim(ii)=1000000*handles.draq_p.inp_max(2)/(handles.draq_p.pre_gain*handles.draq_p.daq_gain);
%     else
        handles.draq_p.prev_ylim(ii)=y_range;
%     end
end

% Update all handles structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);


% --- Executes on button press in drtaBackPush.
function drtaBackPush_Callback(hObject, eventdata, handles)
%{
decreases the trial number by one
%}


% NEEDS to be reassigned to new drta3
newTrial = getTrialNo(handles.w.drta) -1;
% newTrial=drta('getTrialNo',handles.w.drta)-1;
handles.p.trialNo = setTrialNo(handles.w.drta,newTrial);
% handles.p.trialNo=drta('setTrialNo',handles.w.drta,newTrial);
%
set(handles.drtaTrialPush,'String', num2str(handles.p.trialNo));
%updateBrowseTraces(hObject);
% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
%
drtaNWB_PlotBrowseTraces(handles);

% --- Executes on button press in drtaForwardPush.
function drtaForwardPush_Callback(hObject, eventdata, handles)
%{
Increases the trial number by one
%}

% NEEDS to be updated to new drta3
newTrial = getTrialNo(handles.w.drta) -1;
% newTrial=drta('getTrialNo',handles.w.drta)-1;
handles.p.trialNo = setTrialNo(handles.w.drta,newTrial);
% handles.p.trialNo=drta('setTrialNo',handles.w.drta,newTrial);
%
set(handles.drtaTrialPush,'String',num2str(handles.p.trialNo));
%updateBrowseTraces(hObject); 
% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);


function drtaTrialPush_Callback(hObject, eventdata, handles)
%{
text box for entering the trial number
%}

handles.p.trialNo=str2double(get(hObject,'String'));
handles.p.trialNo=drta('setTrialNo',handles.w.drta, handles.p.trialNo);
set(handles.drtaTrialPush,'String',num2str(handles.p.trialNo));


% NEEDS to be reassinged to new drta3
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);




% --- Should be called by parent window
function updateBrowseTraces(hObject)
%{
redrawing the figures
%}

drtaNWB_PlotBrowseTraces(handles);
% Update the handles structure
% if handles.w.drtaThresholdSnips~=0
%     drtaThresholdSnips('updateBrowseTraces',handles.w.drtaThresholdSnips);
% end




function drtaEditTimeInterval_Callback(hObject, eventdata, handles)
%{
Time interval used; display box that takes text inputs
%}

time_interval=str2num(get(hObject,'String'));

if(handles.p.start_display_time+time_interval)>handles.draq_p.sec_per_trigger
   time_interval= handles.draq_p.sec_per_trigger-handles.p.start_display_time;
end
    
handles.p.display_interval=time_interval;
set(hObject,'String',num2str(handles.p.display_interval));

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);



function drtaEditTimeStart_Callback(hObject, eventdata, handles)
%{
start time text box
%}

start_time=str2num(get(hObject,'String'));
if start_time<handles.draq_p.acquire_display_start
   start_time= handles.draq_p.acquire_display_start;
end

if (start_time+handles.p.display_interval)>handles.draq_p.sec_per_trigger
   start_time= handles.draq_p.sec_per_trigger-handles.p.display_interval;
end
handles.p.start_display_time=start_time;
set(hObject,'String',num2str(handles.p.start_display_time));

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);



% --- Executes on button press in drtaFwdStartTimePush.
function drtaFwdStartTimePush_Callback(hObject, eventdata, handles)
%{
Increase the time interval
%}

if (handles.p.start_display_time+handles.p.display_interval)<handles.draq_p.sec_per_trigger
   handles.p.start_display_time= handles.p.start_display_time+handles.p.display_interval;
end
set(handles.drtaEditTimeStart,'String',num2str(handles.p.start_display_time));

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);


% --- Executes on button press in drtaBackStartTimePush.
function drtaBackStartTimePush_Callback(hObject, eventdata, handles)
%{
Decrease the time interval
%}

if (handles.p.start_display_time-handles.p.display_interval)>handles.draq_p.acquire_display_start
   handles.p.start_display_time= handles.p.start_display_time-handles.p.display_interval;
end
set(handles.drtaEditTimeStart,'String',num2str(handles.p.start_display_time));

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);


% --- Executes on selection change in drtaWhichDisplay.
function drtaWhichDisplay_Callback(hObject, eventdata, handles)
%{
Sets the display from the drop down menu
%}
handles.p.which_display=get(hObject,'Value');

if handles.p.which_display==1
   for (ii=1:handles.draq_p.no_spike_ch) 
        handles.draq_p.fig_max(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5)+0.92*0.85/handles.draq_p.no_spike_ch;
        handles.draq_p.fig_min(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(ii-0.5);
   end
else
   ii=handles.p.which_display-1;
   handles.draq_p.fig_max(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(handles.draq_p.no_spike_ch-0.5)+0.92*0.85/handles.draq_p.no_spike_ch;
   handles.draq_p.fig_min(ii)=0.12+(0.80/handles.draq_p.no_spike_ch)*(1-0.5);
end

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);











function drtaEditExCh_Callback(hObject, eventdata, handles)
%{
Conditional statement to prevent incorrect channel settings. If the channel
requested is over 16 the value is set to 16 if less than 1 say 0 the value
is set to 1. Should have the ability to set a range for this value in the
builder
%}
handles.p.exc_sn_ch=str2num(get(hObject,'String'));
%set(hObject,'String',num2str(handles.p.exc_sn_thr_9to16));

if handles.p.exc_sn_ch>16
    handles.p.exc_sn_ch=16;
end

if handles.p.exc_sn_ch<1
    handles.p.exc_sn_ch=1;
end



% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);


% --- Executes on button press in drtaBrowseDraPush.
function setTrialsOutcome(hObject,trialsOutcome)
%{
Text filed above the figures that shows the trial information
%}

handles=guidata(gcbo);
handlesb=guidata(handles.w.drtaBrowseTraces);
try
set(handlesb.trialOutcome,'String',trialsOutcome);
catch
end

% Update handles structure
%guidata(hObject, handles);




% --- Executes on button press in drtaMClust.
function drtaMClust_Callback(hObject, eventdata, handles)
%{
This only calls another funtion
%}
drtaGenerateMClust(hObject, handles);








function drtaSetnxSD_Callback(hObject, eventdata, handles)
%{
Need to look up why setnxSD is changing after updating
%} 
handles.p.setnxSD=1;
handles.p.nxSD=str2double(get(hObject,'String'));
% Update handles structure
handles=drtaNWB_PlotBrowseTraces(handles)
handles.p.setnxSD=0;
% Update handles structure
guidata(hObject, handles);






% --- Executes on button press in pullThr.
function pullThr_Callback(hObject, eventdata, handles)
% hObject    handle to pullThr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fullName=handles.p.fullName;
FileName=handles.p.FileName;
PathName=handles.p.PathName;
trialNo=handles.p.trialNo;
start_display_time=handles.p.start_display_time;
display_interval=handles.p.display_interval;
which_channel=handles.p.which_channel;
which_display=handles.p.which_display;
trial_ch_processed=handles.p.trial_ch_processed;
trial_allch_processed=handles.p.trial_allch_processed;
if isfield(handles.p,'tetr_processed')
    tetr_processed=handles.p.tetr_processed;
else
    tetr_processed=[0 0 0 0];
end

handles.p=drtaPullThreshold;

handles.p.fullName=fullName;
handles.p.FileName=FileName;
handles.p.PathName=PathName;
handles.p.trialNo=trialNo;
handles.p.start_display_time=start_display_time;
handles.p.display_interval=display_interval;
handles.p.which_channel=which_channel;
handles.p.which_display=which_display;
handles.p.trial_ch_processed=trial_ch_processed;
handles.p.trial_allch_processed=trial_allch_processed;
handles.p.tetr_processed=tetr_processed;

drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);
