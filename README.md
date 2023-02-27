
# NWB drta 3.0

This GUI allows the functionality of drta 2.0 and drta 3.0 (updated drta to MATLAB's app designer) along with single and bach processing to convert intan to NWB file structure.


## Installation

Needed libraries:\
NWB for python and Matlab\
Python 8 or 9

If not, install the following:
##### For Windows:
Install Visual Studio Code\
Install NWB python using bash script 
```bash
    sudo apt install pynwb
```
##### Install Matlab NWB
1. Download repo
```bach
	git clone https://github.com/NeurodataWithoutBorders/matnwb.git
```
2. Generate the API using Matlab command prompt\
	cd matnwb\
	addpath(genpath(pwd));\
	generateCore(); % generate the most recent nwb-schema release.
####
##### Links -
VS code: https://code.visualstudio.com/download \
NWB python: https://pynwb.readthedocs.io/en/stable/ \
NWB matlab: https://github.com/NeurodataWithoutBorders/matnwb 
## Features

Files needed:
.rhd and jt_times

##### Intan to NWB conversion
#####
Single file:
1. Select rhd to NWB
2. Check Single File
3. Move to the File settings tab
4. Press Choose File and navigate to the file
5. Press Choose Location and choose where the output fold will be placed
6. Adjust NWB filename if needed
7. Fill out the remaining sections
8. Once all information is entered move back to the drta_load tab
9. Press Convert rhd File
####
Batch files:
1. Select rhd to NWB
2. Check Batch of Files
3. Move to the File settings tab
4. Press Choose File and navigate to the file
5. Press Choose Location and choose where the output fold will be placed
6. Adjust NWB filename if needed
7. Fill out the remaining sections
8. Once all information is entered move back to the drta_load tab
9. Press Create File for Conversion
10. Press the + button to assign another file to be converted
11. Repeat steps 3-10 until all the files are loaded (Note: the output location cannot be changed after the first file)
12. Press Convert rhd File
####
##### View and process .rhd files
#####
drta 2.0

1. Select View and process rhd file
2. Check drta 2.0
3. Press the Choose file button and navigate to the file
4. Select a protocol form the dropdown menu
5. (optional) Edit the dt before order end and trial duration
6. Press the Choose Output Location button and select a folder that the files will be saved
7. Press Load File
After the file has been loaded the browse traces GUI will open and display the results
#####
drta 3.0 (only for dropcspm)
1. Select View and process rhd file
2. Check drta 3.0
3. Press the Choose file button and navigate to the file
4. Select a protocol form the dropdown menu
5. (optional) Edit the dt before order end and trial duration
6. Press the Choose Output Location button and select a folder that the files will be saved
7. Press Load File
8. Once loaded move to the Browse_Traces tab for the results
####
To save either drta 2.0 or 3.0
1. Move to the Save_file tab
2. select which protocol is used during saving
3. Press save file
