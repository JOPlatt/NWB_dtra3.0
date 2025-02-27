function LFPplotChange(app,event)

switch event.Source.Tag
    case "LFPmin"
        app.drta_handles.p.lfp.minLFP = app.min_amt.Value;
        VarUpdate(app,"minLFP",app.drta_handles.p.lfp.minLFP)
    case "LFPmax"
        app.drta_handles.p.lfp.maxLFP = app.max_amt.Value;
        VarUpdate(app,"maxLFP",app.drta_handles.p.lfp.maxLFP)
    case "Thr"
        app.drta_handles.p.thrToSet = app.thr_amt.Value;
        VarUpdate(app,"thrToSet",app.drta_handles.p.thrToSet)
        if app.drta_handles.p.setThr ~= 1
            app.drta_handles.p.setThr=1;
            VarUpdate(app,"setThr",app.drta_handles.p.setThr)
        end
    case "nxSD"
        app.drta_handles.p.nxSD = app.nxSD_amt.Value;
        app.drta_handles.p.setnxSD=1;
        drtaNWB_figureControl(app);
        %                     drtaNWB_PlotBrowseTraces(app.drta_handles);
        app.drta_handles.p.setnxSD=0;
        VarUpdate(app,Vname,Vupdate)
end