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

Ndev = 32; % #Device Columns
Ntraj = 50; % #Traj columns: Ntraj=Nmarkers*3 + 2 = 16*3+2
trajrowstart = 1;

%% Find rows where device data ends and trajectories start
i=1;
while ~feof(fid) %1
    config{i} = fgets(fid);
    if i==2 devicefss=deblank(config{i});
        elseif i==3 forceplates=config{i};
        elseif i==4 devicelabels=config{i};
        elseif i==5 deviceunits=config{i};
        elseif strncmp(config{i},'Trajectories',12)==1 
            trajrowstart = i; 
            devrowend= i-2; 
            break
    end
    devrowend = i;
    i=i+1;
end
%% Forces
devicedata=readmatrix(csvpath,'Range',[5 1 devrowend Ndev]);

if isempty(findstr(devicefss,','))
    devicefs=str2num(devicefss);
else
    devicefs=str2num(devicefss(1:min(findstr(devicefss,','))-1));
end
%% Trajectories
if trajrowstart>1
    for i=trajrowstart+1:trajrowstart+4
        config{i}=fgets(fid);
        if i == trajrowstart+1
            trajfss=deblank(config{i});
            elseif i==trajrowstart+2
                markers=config{i};
            elseif i==trajrowstart+3
                trajlabels=config{i};
            elseif i==trajrowstart+4
                trajunits=config{i};
        end
    end
    
    trajdata=readmatrix(csvpath,'Range',trajrowstart+5);
    
    if isempty(findstr(trajfss,','))
        trajfs=str2num(trajfss);
    else
        trajfs=str2num(trajfss(1:min(findstr(trajfss,','))-1));
    end
    
end

fclose(fid);       
fprintf('File processed successfully:  %s.\n',filename);
cd(homepath)
end