function[iddata] = readopensimsto_id(fpath,filename)
global homepath
% mfile function to load .csv vicon files
cd(fpath)
sto_path = fullfile(fpath,filename);
%% Find and open csv
if isfile(sto_path)
    fid = fopen(sto_path);
else
    fprintf('File not found: %s. \n',filename);
    return
end

%% Read the CSV
% Start reading line by line

Nkin = 36; %40; % #kin columns - there are 40 in the file, but the columns after
% 23 refer to the torso and arms and are not relevant or calculatable with
% the Plug-In gait marker set

%% Forces
iddata0 = readmatrix(sto_path);
iddata = iddata0(8:end,:);

fclose(fid);      
fprintf('File processed successfully:  %s.\n',filename);
cd(homepath)
end