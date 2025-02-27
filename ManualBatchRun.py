from tkinter import Tk
from tkinter.filedialog import askdirectory
from ConvertIntanToNWB import *
import os
import numpy as np
from pynwb import NWBFile, TimeSeries, NWBHDF5IO
from pynwb.epoch import TimeIntervals
from pynwb.file import Subject
from pynwb.behavior import SpatialSeries, Position
from datetime import datetime
from dateutil import tz

Script_path = os.getcwd()
Batch_path = askdirectory(title='Select Folder') # shows dialog box and return the path
for files in os.listdir(Batch_path):
    if files != ".directory":
#        print(files)
        middle_address = "/"
        BatchFile_loca = Batch_path + middle_address + files
#        print(BatchFile_loca)

        pathType = '.xlsx'
        pathType2 = '.rhd'
        for files in os.listdir(BatchFile_loca):
            if files.endswith(pathType):
                file_excelOld = BatchFile_loca + middle_address + files
                file_excelNew = Script_path + middle_address + files
#                print(file_excelOld)
#                print(file_excelNew)
                os.rename(file_excelOld,file_excelNew)
                file_excelName = files
            elif files.endswith(pathType2):
                file_rhdOld = BatchFile_loca + middle_address + files
                file_rhdNew = Script_path + middle_address + files
#                print(file_rhdOld)
#                print(file_rhdNew)
                os.rename(file_rhdOld,file_rhdNew)
        convert_to_nwb(file_excelName)
        for file in os.listdir(Script_path):
            if file.endswith(".nwb"):
                file_NWBOld = Script_path + middle_address + file
                file_NWBNew = BatchFile_loca + middle_address + file
        os.rename(file_excelNew,file_excelOld)
        os.rename(file_rhdNew,file_rhdOld)
        os.rename(file_NWBOld,file_NWBNew)
