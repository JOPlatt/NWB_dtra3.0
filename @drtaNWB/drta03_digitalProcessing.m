function drta03_digitalProcessing(app)
%{
This function processes the digital inputs based on specified channels and
bitand intergers.

Created by Jonathan Platt
%}

shiftdata30=bitand(digi,2+4+8+16);
shift_dropc_nsampler=bitand(digi,1+2+4+8+16+32);


%Please note that there are problems with the start of the trial.
%Because of this we start looking 2 sec and beyond
shiftdata30(1:handles.draq_p.ActualRate*handles.p.exclude_secs)=0;
%     shift_dropc_nsampler(1:handles.draq_p.ActualRate*handles.p.exclude_secs)=0;

odor_on=[];
switch handles.p.which_protocol
    case {1,6}
        %dropcspm
        odor_on=find(shiftdata30==18,1,'first');
    case 5
        %dropcspm conc
        t_start=find(shift_dropc_nsampler==1,1,'first');
        if (sum((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7))>2.4*handles.draq_p.ActualRate)&...
                ~isempty(find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first'))
            %                         odor_on=find((shift_dropc_nsampler>=2)&(shift_dropc_nsampler<=7),1,'first');
            odor_on=t_start+find((shift_dropc_nsampler(t_start:end)>=2)&(shift_dropc_nsampler(t_start:end)<=7),1,'first')-1;
        end
end


