%%
close all 
clear all 

%% Read in vicon data from CSV file

readviconcsv

%%
dataraw=devicedata;
dataraw(:,[3:5 6:8 18:20 21:23])=-dataraw(:,[3:5 6:8 18:20 21:23]);