function BatchSaveJTtimes(app)



handles = app.drta_data;

if (isfield(handles.draq_d,'snip_samp'))
    try
        rmfield(handles.draq_d,'snip_samp');
    catch

    end
    try
        rmfield(handles.draq_d,'snip_index');
    catch
    end
    try
        rmfield(handles.draq_d,'snips');
    catch
    end
end

if (isfield(handles.draq_d,'noEvents'))
    rmfield(handles.draq_d,'noEvents');
    rmfield(handles.draq_d,'nEvPerType');
    rmfield(handles.draq_d,'nEventTypes');
    rmfield(handles.draq_d,'eventlabels');

    try
        rmfield(handles.draq_d,'events');
        rmfield(handles.draq_d,'eventType');
    catch
    end


    try
        rmfield(handles.draq_d,'blocks');
    catch
    end
end

drta03_GenerateEvents(app,handles);