function YrangeChange(app,varargin)

value = app.Yrange_DropDown.Value;
if value == "all"
    for ii = 1:app.drta_handles.draq_p.no_chans
        app.drta_Main.Yrange.rangeVals(ii) = app.Yrange_amt.Value;
    end
else
    jo = str2double(value);
    app.drta_Main.Yrange.rangeVals(jo) = app.Yrange_amt.Value;
end