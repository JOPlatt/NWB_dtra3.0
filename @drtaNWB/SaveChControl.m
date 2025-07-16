function SaveChControl(app,event)

tagName = event.Source.Tag;
if contains(tagName,'E-')
    tagName = 'SingleCh';
elseif contains(tagName,'D-')
    tagName = 'DigitalCh';
elseif contains(tagName,'A-')
    tagName = 'AnalogCh';
end
switch tagName
    case 'SingleCh'
        OneChTag = event.Source.Tag;
        Chnum = str2double(OneChTag(end-2:end));
        app.drta_Save.p.VisableChannel(Chnum+1) = event.Source.Value;
    case 'DigitalCh'
        OneChTag = event.Source.Tag;
        Chnum = str2double(OneChTag(end-2:end));
        app.drta_Save.p.VisableDigital(Chnum+1) = event.Source.Value;
    case 'AnalogCh'
        OneChTag = event.Source.Tag;
        Chnum = str2double(OneChTag(end-2:end));
        app.drta_Save.p.VisableAnalog(Chnum+1) = event.Source.Value;
end