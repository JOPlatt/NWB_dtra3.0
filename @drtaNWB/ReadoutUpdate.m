function ReadoutUpdate(app,textUpdate)
%{
This function adds to the output display
%}
OTsize = length(app.OutputText);
Text_size = length(textUpdate);
if Text_size == 1
    app.OutputText((OTsize(1)+1),1) = textUpdate;
else
    app.OutputText((OTsize(1)+1):(OTsize(1)+Text_size),1) = textUpdate;
end
app.ProgressReadout.Value = app.OutputText;
scroll(app.ProgressReadout,'bottom');

% TextPrint = textUpdate;
% OTsize = size(app.OutputText);
% if app.FlagAlpha == true
%     app.OutputText{1,1} = append(app.OutputText{1,1},textUpdate);
%     app.FlagAlpha = false;
% else
%     app.OutputText{(OTsize(1)+1),1} = TextPrint;
% end
% app.ProgressReadout.Value = app.OutputText;
pause(.1)
