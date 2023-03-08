from tkinter import Tk
from tkinter.filedialog import askdirectory
from ConvertIntanToNWB import *
import os
import numpy as np

Script_path = os.getcwd()
Batch_path = askdirectory(title='Select Folder') # shows dialog box and return the path
for files in os.listdir(Batch_path):
    if files != ".directory":
        print(files)
        middle_address = "/"
        BatchFile_loca = Batch_path + middle_address + files
        print(BatchFile_loca)

        pathType = '.xlsx'
        pathType2 = '.rhd'
        for files in os.listdir(BatchFile_loca):
            if files.endswith(pathType):
                file_excelOld = BatchFile_loca + middle_address + files
                file_excelNew = Script_path + middle_address + files
                print(file_excelOld)
                print(file_excelNew)
                os.rename(file_excelOld,file_excelNew)
            elif files.endswith(pathType2):
                file_rhdOld = BatchFile_loca + middle_address + files
                file_rhdNew = Script_path + middle_address + files
                print(file_rhdOld)
                print(file_rhdNew)
        #        convert_to_nwb(files)
  
