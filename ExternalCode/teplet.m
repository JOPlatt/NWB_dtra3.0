%{
This is a templet for adding new processing methods to either the batch
processing or the drta visualize channels n' save GUI.

Written by:
Jonathan P. Platt jonathan.p.o.platt@gmail.com

To use this templet -
1. copy with name of processing method; example "newname"_ProgramType.
(remove the ", but for consistency use the ending _ProgramType)
2. Put the new file inside the CprogramCode folder.
3. Add name of process to the ProcessType .m file within the ExternalCode
folder. This will need to be added to the first 'Loading Screen' case and a
new switch case will need to be added at the end of the list. 
example:
case 'newname'
    Ptype = ##; %note ## is the next number in line
4. Add process method into the new ProgramType file (see other program
types for examples)

%}

ProcessType = varargin{1};
DataSet = varargin{2};
if app.Flags.SelectCh == 1
    NumCh = sum(DataSet.SelectedCh);
else
    NumCh = DataSet.draq_p.no_spike_ch;
end

switch ProcessType
    case 1 % generates labels
    case 2 % trial exclusion and create events
    case 3 % setup for block number
end