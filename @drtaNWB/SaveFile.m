function SaveFile(app,~)

CprogramChoice(app)
% handles = app.drta_Data;

% if (isfield(handles.draq_d,'snip_samp'))
%     try
%         rmfield(handles.draq_d,'snip_samp');
%     catch
% 
%     end
%     try
%         rmfield(handles.draq_d,'snip_index');
%     catch
%     end
%     try
%         rmfield(handles.draq_d,'snips');
%     catch
%     end
% end
% 
% if (isfield(handles.draq_d,'noEvents'))
%     rmfield(handles.draq_d,'noEvents');
%     rmfield(handles.draq_d,'nEvPerType');
%     rmfield(handles.draq_d,'nEventTypes');
%     rmfield(handles.draq_d,'eventlabels');
% 
%     try
%         rmfield(handles.draq_d,'events');
%         rmfield(handles.draq_d,'eventType');
%     catch
%     end
% 
% 
%     try
%         rmfield(handles.draq_d,'blocks');
%     catch
%     end
% end
Ecount = 1;
Acount = 1;
Dcount = 1;
fnames = fieldnames(app.drta_Save.ChShown);
for ss = 1:length(fnames)
    temp = app.drta_Save.ChShown.(fnames{ss}).Value;
    if contains(fnames,'AnalogCh')
        app.drta_Save.p.VisableAnalog(Acount) = temp;
        Acount = Acount + 1;
    end
    if contains(fnames,'DigitalCh')
        app.drta_Save.p.VisableDigital(Dcount) = temp;
        Dcount = Dcount + 1;
    end
    if contains(fnames,'ChCB')
        app.drta_Save.p.VisableChannel(Ecount) = temp;
        Ecount = Ecount + 1;
    end
end

drta03_GenerateEvents(app);