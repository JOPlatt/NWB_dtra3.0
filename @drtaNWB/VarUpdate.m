function VarUpdate(app,Vname,Vupdate)
%{
            This funciton serves to replace the following
            setUpdatePreview
            drtaRadioFilter_Callback
            drtaBrTr3xSD_Callback
            drtaPSWhichChan_Callback
            drtaRadioExclSn_Callback
            drtaSub1_Callback
            drtaSub5_Callback
            drtaSub9_Callback
            drtaSub13_Callback
            drtaDiff_Callback 
            drtaSub2_Callback
            drtaSub3_Callback
            drtaSub4_Callback
            drtaSub6_Callback
            drtaSub7_Callback
            drtaSub8_Callback
            drtaSub10_Callback
            drtaSub11_Callback
            drtaSub12_Callback
            drtaSub14_Callback
            drtaSub15_Callback
            drtaSub16_Callback
            drtaLFPmin_Callback
            drtaLFPmax_Callback
            setThr_Callback
            updateBrowseTraces
%}
app.drta_handles.p.(Vname) = Vupdate;
drtaNWB_figureControl(app);
%             app.drta_handles = drtaNWB_PlotBrowseTraces(app.drta_handles);

