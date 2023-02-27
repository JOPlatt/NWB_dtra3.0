
Dlist = "Hello"; % [{"this is one"},{"this is two"},{"this is three"}];
Dlist = py.numpy.int64(2);
pyrunfile('NWBConvert.py',A=Dlist)
