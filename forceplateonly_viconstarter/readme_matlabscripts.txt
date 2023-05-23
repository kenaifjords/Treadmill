
The numbers in the script names indicate the order in which they should be run. TMSC_00 is run once for each subject to create mat files from the csv. TMSC_01 is run at the start of a matlab session to load the data for processing and analysis

%%TM2_00_readnewsubjCSVtoMAT
This script takes a csv data file for motion capture (with force plate data) and generates two .mat data files containing the forces (in a structure called f) and marker positions (in a structure called pp). This will need to be run once when loading in a subject and their data collection files.

Uses: readviconcsv_SC

% csv naming conventions %
 csv need to be saved in the csvData folder in the same directory as this script. the file is loaded in according to the strings in "subject.list" and the strings in "subject.blockname" which will be combined into names, that are separated by an underscore. For every string in subject list, the code will load files for all strings in "subject.blockname" (or warn you that they don't exist).
For example, if subject.list = {'ABC' 'XYZ'}; and subject.blockname = {'test1' 'collect1' 'collect2'}, the code will load
       ABC_test1.csv
       ABC_collect1.csv
       ABC_collect2.csv
       XYZ_test1.csv
       XYZ_collect1.csv
       XYZ_collect2.csv
All files for each subject will be saved into a .mat file for postion and a .mat file for force plate data. These will be in the matData folder
       ABC_F.mat     ABC_p.mat
       XYZ_F.mat     XYZ_p.mat


%% TM2_01_buildSubjectStructure
This code loads each of the subject's mat files for force and saves them in a structure called F. If the subject.list is {'ABC' 'XYZ'}, the force data structures for those two subjects can be accessed in F(1) and F(2) respectively. This script builds the same kind of structure for the marker position data, building the structure p. Run this code at the beginning of a matlab session to load the data in an accessible format

Uses: findvalidHS_v2 and getHeelStrikeForce_SC

%% TM2_02_identifyHeelStrikes
This script identifies heel strikes and toe off gait events using data from the force plates and includes some additional step validation procedure to limit spurious heel strikes. Some data cleaning specific to your data or to specific files may still be required.


%% TM2_03_getLearningCurves_v2
this script uses valid heelstrikes to determine step lengths and step times over the course of strides in the experiment. These values are used to determine asymmetry measures and the script includes a testing plot