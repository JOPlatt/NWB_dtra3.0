











%this should be called during setup










function drtaEditExcSn_Callback(hObject, eventdata, handles)

handles.p.exc_sn_thr=str2num(get(hObject,'String'));
%set(hObject,'String',num2str(handles.p.display_interval));

if ~isfield(handles.p,'exc_sn_ch')
    handles.p.exc_sn_ch=1;
    set(handles.drtaEditExCh,'String',num2str(handles.p.exc_sn_ch));
end

% Update all handles.p structures
drtaUpdateAllHandlespw(handles.w.drta, handles)
% drta('drtaUpdateAllHandlespw',handles.w.drta,handles);
drtaNWB_PlotBrowseTraces(handles);









