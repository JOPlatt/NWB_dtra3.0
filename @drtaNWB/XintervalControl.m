function XintervalControl(app,event)

switch event.Source.Tag
    case "Electrod_All"
        time_interval = app.Interval_amt.Value;
        if(app.drta_Data.p.start_display_time+time_interval)>app.drta_Data.draq_p.sec_per_trigger
            time_interval= app.drta_Data.draq_p.sec_per_trigger-app.drta_Data.p.start_display_time;
        end
        if app.E_all_CheckBox.Value == 1
            app.drta_Data.p.display_interval=time_interval;
            if app.D_all_CheckBox.Value == 1
                app.IntervalSecDigit_EditField.Value=time_interval;
            end
            if app.A_all_CheckBox.Value == 1
                app.AnalogInterval_EditField.Value=time_interval;
            end
        end
        app.drta_Main.Xinterval.electrod = time_interval;
        app.Interval_amt.Value = time_interval;
    case "Digital_All"
        time_interval = app.IntervalSecDigit_EditField.Value;
        if(app.drta_Data.p.start_display_time+time_interval)>app.drta_Data.draq_p.sec_per_trigger
            time_interval= app.drta_Data.draq_p.sec_per_trigger-app.drta_Data.p.start_display_time;
        end
        if app.D_all_CheckBox.Value == 1
            app.drta_Data.p.display_interval=time_interval;
            if app.A_all_CheckBox.Value == 1
                app.AnalogInterval_EditField.Value=time_interval;
            end
            if app.E_all_CheckBox.Value == 1
                app.Interval_amt.Value=time_interval;
            end
        end
        app.drta_Main.Xinterval.digital = time_interval;
        app.IntervalSecDigit_EditField.Value = time_interval;
    case "Analog_All"
        time_interval = app.AnalogInterval_EditField.Value;
        if(app.drta_Data.p.start_display_time+time_interval)>app.drta_Data.draq_p.sec_per_trigger
            time_interval= app.drta_Data.draq_p.sec_per_trigger-app.drta_Data.p.start_display_time;
        end
        if app.A_all_CheckBox.Value == 1
            app.drta_Data.p.display_interval=time_interval;
            if app.D_all_CheckBox.Value == 1
                app.IntervalSecDigit_EditField.Value=time_interval;
            end
            if app.E_all_CheckBox.Value == 1
                app.Interval_amt.Value=time_interval;
            end
        end
        app.drta_Main.Xinterval.analog = time_interval;
        app.AnalogInterval_EditField.Value = time_interval;
end