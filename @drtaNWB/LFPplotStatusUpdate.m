function LFPplotStatusUpdate(app,textUpdate)

%{
This function adds to the output display
%}
textUpdate = string(textUpdate);
OTsize = length(app.LFPOutputText);
Text_size = length(textUpdate);
if Text_size == 1
    app.LFPOutputText((OTsize(1)+1),1) = textUpdate;
else
    app.LFPOutputText((OTsize(1)+1):(OTsize(1)+Text_size),1) = textUpdate;
end
app.StatusLFP_TextArea.Value = app.LFPOutputText;
scroll(app.StatusLFP_TextArea,'bottom');
pause(0.1);