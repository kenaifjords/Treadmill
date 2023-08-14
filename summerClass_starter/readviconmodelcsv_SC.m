function[devicedata,trajdata] = readviconcsv_rmmV2(path,filename)
global homepath
% mfile function to load .csv vicon files
cd(path)
csvpath = fullfile(path,filename);
%% Find and open csv
if isfile(csvpath)
    fid = fopen(csvpath);
else
    fprintf('File not found: %s. \n',filename);
    devicedata = [];
    trajdata = [];
    cd(homepath)
    return
end

%% Read the CSV
% Start reading line by line
% Look for lines with 'Devices' and 'Trajectories'
% First line that follows: Sampling frequency
% Second line that follows: ForcePlate # or Marker Name (not every column)
% Third line that follows: Frame/Subframe/Axis (every column)
% Fourth line that follows: units (not first two columns)
% Fifth line that follows: Numeric data 

Ndev = 38; % #Device Columns

%% Find rows where device data ends and trajectories start
i=1;
while ~feof(fid) %1
    config{i} = fgets(fid);
    if i==2 devicefss=deblank(config{i});
        elseif i==3 forceplates=config{i};
        elseif i==4 devicelabels=config{i};
        elseif i==5 deviceunits=config{i};
        elseif strncmp(config{i},'Trajectories',12)==1 
            devrowend= i-2; 
            break
    end
    devrowend = i;
    i=i+1;
end
%% Angles and Moments
devicedata=readmatrix(csvpath,'Range',[5 1 devrowend Ndev]);

if isempty(findstr(devicefss,','))
    devicefs=str2num(devicefss);
else
    devicefs=str2num(devicefss(1:min(findstr(devicefss,','))-1));
end

fclose(fid);       
fprintf('File processed successfully:  %s.\n',filename);
cd(homepath)
end