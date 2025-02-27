
import os.path
#os.add_dll_directory('C:\ProgramData\Anaconda3\DLLs')
import numpy as np
from pynwb import NWBFile, TimeSeries, NWBHDF5IO
from pynwb.epoch import TimeIntervals
from pynwb.file import Subject
from pynwb.behavior import SpatialSeries, Position
from datetime import datetime
from dateutil import tz
from ConvertIntanToNWB import *

#print(Fname)
pytPath = os.getcwd();
print(pytPath)
print(Fname)
print(Outname)
convert_to_nwb(settings_filename=Fname)



