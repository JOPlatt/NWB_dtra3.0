function BatchSaveJTtimes(app,FileNum)

needRemvoed = {'snip_samp'; 'snip_index'; 'snips'; 'noEvents'; ...
    'nEvPerType'; 'nEventTypes'; 'eventlabels'; 'events';  ...
    'eventType'; 'blocks'};

fname = sprintf('drtaFile%.3d',FileNum);
app.data_files.(fname)

for r = 1:height(needRemvoed)
    if (isfield(app.data_files.(fname).draq_d,needRemvoed{r}))
        try
            app.data_files.(fname).draq_d = rmfield(app.data_files.(fname).draq_d,needRemvoed{r});
        catch
            textUpdate = spirntf('Unable to remove %s field',needRemvoed{r});
            ReadoutUpdate(app,textUpdate);
        end
    end
end

