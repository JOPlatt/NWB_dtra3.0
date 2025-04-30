function addSubProperty(app)

subject = types.core.Subject( ...
    'subject_id', app.SubID_EditField.Value, ...
    'species', app.Species_EditField.Value, ...
    'sex', app.SubSex_DropDown.Value);
% Adding subject description if supplied
if ~isempty(app.SubDescrp_EditField.Value)
    subject.description = app.SubDescrp_EditField.Value;
end
% Adding subject weight if supplied
if ~isempty(app.SubWeight_EditField.Value)
    subject.weight = app.SubWeight_EditField.Value;
end
% Adding either subject DOB or age
if app.DOB_YesButton.Value == 1
    DOByear = app.DOByear_EditField.Value;
    DOBmonth = app.DOBmonth_EditField.Value;
    DOBday = app.DOBday_EditField.Value;
    SubDOB = datetime([DOByear,'-' ,DOBmonth,'-', DOBday],'Format','uuuu-MM-dd');
    subject.date_of_birth = SubDOB;
else
    subject.age = app.SubAge_EditField.Value;
end
% Adding subject strain if supplied
if ~isempty(app.SubStrain_EditField.Value)
    subject.strain = app.SubStrain_EditField.Value;
end
% Adding subject genotype if supplied
if ~isempty(app.SubGenotype_EditField.Value)
    subject.genotype = app.SubGenotype_EditField.Value;
end
% placing subject container within the NWB structure
app.nwb.general_subject = subject;