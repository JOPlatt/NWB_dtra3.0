function ReadoutUpdate(app,textUpdate)
%{
This function adds to the output display
%}
textUpdate = string(textUpdate);

OTsize = length(app.OutputText);
Text_size = length(textUpdate);
if Text_size == 1
    app.OutputText((OTsize(1)+1),1) = textUpdate;
else
    app.OutputText((OTsize(1)+1):(OTsize(1)+Text_size),1) = textUpdate;
end
app.ProgressReadout.Value = app.OutputText;
scroll(app.ProgressReadout,'bottom');


pause(.1)
