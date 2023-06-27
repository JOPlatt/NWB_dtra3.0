


% --- Should be called by parent window
function setUpdatePreview(hObject,up)
% hObject    handle to drsDisplaySingle
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles=guidata(hObject);
handles.p.update_preview=up;

% Update the handles structure
guidata(hObject, handles);

% --- Executes on button press in drtaRadioFilter.
function drtaRadioFilter_Callback(hObject, eventdata, handles)
%{
Sets the filter choise to which plot in handles
%}

%This one allows changing the plot
handles.p.whichPlot=get(hObject,'Value');


% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes on button press in drtaBrTr3xSD.
function drtaBrTr3xSD_Callback(hObject, eventdata, handles)
%{
Not used in this app but it is used in another to collect and update the
value.
%}

handles.p.do_3xSD=get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes on selection change in drtaPSWhichChan.
function drtaPSWhichChan_Callback(hObject, eventdata, handles)
%{
setting the channel being used from the drop down menu
%}

% Hints: contents = get(hObject,'String') returns drtaPSWhichChan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaPSWhichChan

handles.p.which_channel=get(hObject,'Value');

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);



% --- Executes on button press in drtaRadioExclSn.
function drtaRadioExclSn_Callback(hObject, eventdata, handles)
%{
Updates the T/F for if the exclude licks was clicked
%}

% Hint: get(hObject,'Value') returns toggle state of drtaRadioExclSn
handles.p.exc_sn=get(hObject,'Value');
%set(hObject,'String',num2str(handles.p.display_interval));

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);

% --- Executes on selection change in drtaSub1.
function drtaSub1_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub1

handles.p.subtractCh(1)=get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes on selection change in drtaSub5.
function drtaSub5_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub5

handles.p.subtractCh(5)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes on selection change in drtaSub9.
function drtaSub9_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub9
handles.p.subtractCh(9)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes on selection change in drtaSub13.
function drtaSub13_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub13

handles.p.subtractCh(13)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes on button press in drtaDiff.
function drtaDiff_Callback(hObject, eventdata, handles)
% hObject    handle to drtaDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of drtaDiff

if get(hObject,'Value')==1
    handles.p.doSubtract=1;
else
    handles.p.doSubtract=0;
end
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes on selection change in drtaSub2.
function drtaSub2_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub2
handles.p.subtractCh(2)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes on selection change in drtaSub3.
function drtaSub3_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub3
handles.p.subtractCh(3)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes on selection change in drtaSub4.
function drtaSub4_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub4
handles.p.subtractCh(4)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes on selection change in drtaSub6.
function drtaSub6_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub6
handles.p.subtractCh(6)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes on selection change in drtaSub7.
function drtaSub7_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub7
handles.p.subtractCh(7)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes on selection change in drtaSub8.
function drtaSub8_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub8
handles.p.subtractCh(8)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);



% --- Executes on selection change in drtaSub10.
function drtaSub10_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub10
handles.p.subtractCh(10)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes on selection change in drtaSub11.
function drtaSub11_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub11
handles.p.subtractCh(11)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);


% --- Executes on selection change in drtaSub12.
function drtaSub12_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub12
handles.p.subtractCh(12)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);



% --- Executes on selection change in drtaSub14.
function drtaSub14_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub14
handles.p.subtractCh(14)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);



% --- Executes on selection change in drtaSub15.
function drtaSub15_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub15
handles.p.subtractCh(15)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

% --- Executes on selection change in drtaSub16.
function drtaSub16_Callback(hObject, eventdata, handles)
% hObject    handle to drtaSub16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns drtaSub16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from drtaSub16
handles.p.subtractCh(16)=get(hObject,'Value');
drtaThresholdSnips('update_p',handles.w.drtaThresholdSnips,handles);
% Update handles structure
guidata(hObject, handles);
updateBrowseTraces(hObject);

function drtaLFPmin_Callback(hObject, eventdata, handles)
% hObject    handle to drtaLFPmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaLFPmin as text
%        str2double(get(hObject,'String')) returns contents of drtaLFPmin as a double
handles.p.lfp.minLFP=str2num(get(hObject,'String'));

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);


function drtaLFPmax_Callback(hObject, eventdata, handles)
% hObject    handle to drtaLFPmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of drtaLFPmax as text
%        str2double(get(hObject,'String')) returns contents of drtaLFPmax as a double
handles.p.lfp.maxLFP=str2num(get(hObject,'String'));

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);


function setThr_Callback(hObject, eventdata, handles)
% hObject    handle to setThr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setThr as text
%        str2double(get(hObject,'String')) returns contents of setThr as a double
handles.p.setThr=1;
handles.p.thrToSet=str2double(get(hObject,'String'));
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);






