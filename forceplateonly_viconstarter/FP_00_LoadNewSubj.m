%%TM2_00_readnewsubjCSVtoMAT

% This script takes a csv data file for motion capture (with force plate
% data) and generates two .mat data files containing the forces (in a
% structure called f) and marker positions (in a structure called pp). This
% will need to be run once when loading in a subject and their data
% collection files.

%% csv naming conventions
% csv need to be saved in the csvData folder in the same directory as this
% script. the file is loaded in according to the strings in "subject.list"
% and the strings in "subject.blockname" which will be combined into names,
% that are separated by an underscore. For every string in subject list,
% the code will load files for all strings in "subject.blockname" (or warn
% you that they don't exist).
% For example, if subject.list = {'ABC' 'XYZ'}; and subject.blockname =
% {'test1' 'collect1' 'collect2'}, the code will load
%       ABC_test1.csv
%       ABC_collect1.csv
%       ABC_collect2.csv
%       XYZ_test1.csv
%       XYZ_collect1.csv
%       XYZ_collect2.csv
% All files for each subject will be saved into a .mat file for postion and
% a .mat file for force plate data. These will be in the matData folder
%       ABC_F.mat     ABC_p.mat
%       XYZ_F.mat     XYZ_p.mat
%
%% start of script
tic
clear all
close all
global homepath

homepath = pwd;
path = [homepath '\csvData'];

% data collection device parameters
devicefs = 1000; %1000 Hz for the treadmill, 100Hz for cameras
trajfs = 100; %   100Hz for cameras
itrim = 50; %50; % trim the first 50/100ths of a second from both 
trim_time = 1;
% take the mat files for each subject and build a full structure, so that
% we can loop through subjects - PREFER ONE SUBJECT AT A TIME
subject.list =  {'ABC' 'XYZ'}; % {'ABC' 'XYZ'};
subject.blockname = {'HSplit1' 'fastbaseline'}%'; HSplit1'}; % noCameras01'}; % {'test1' 'collect1' 'collect2'};

for subj = 1:length(subject.list)
    savename_force = [subject.list{subj} '_FP.mat'];       
    for blk = 1:length(subject.blockname)
        subjpath = [path '\' subject.list{subj}];
        filename = [subject.list{subj} '_' subject.blockname{blk} '.csv'];
        clear devicedata trajdata dataraw trajdataraw
        [devicedata] = readviconcsv_SC(subjpath,filename);
        if isempty(devicedata)
            % do nothing
            disp('readvicon output devicedata is empty')
        else
        %% convert devicedata to forces
        % Forecplate1 (Left)  Z is up/down b/c COP is zero;
        % Y is in the direction of motion
        % Make forces and moments negative so they represent forces acting
        % on the subject rather than on the forceplatform
        if trim_time >1
            trim_timeforce = trim_time * 10;
        else
            trim_timeforce = 1;
        end
        dataraw=devicedata(trim_timeforce:end,:);
        if size(dataraw,2) < 30
%                 dataraw = cat(2,dataraw,nan(size(dataraw,1), 30 - size(dataraw,2)));
            disp(['PINS probably missing. INCOMPLETE CSV, NaNs added. block: ' num2str(blk)]);
            dataraw(:,[3:5 6:8 12:14 15:17])=-dataraw(:,[3:5 6:8 12:14 15:17]);
            % Select only (16 col)
            % F1xF1yF1zM1xM1yM1zCOP1xCOP1yF2xF2yF2zM2xM2yM2zCOP2xCOP2y
            dataraw = dataraw(:,[3:10 12:19]);
            fs = devicefs; % data collection hz
            fc = 20; % low pass filter frequency cut off
            dt = 1/fs; % numerical integration time steps
            % get time
            time = [1:size(dataraw,1)]/fs;
            dataraw(isnan(dataraw))=0;
            % filter data : datafilt is original:derivative:secondderivative
            [datafilt]=diff23f5(dataraw,dt,fc);
            data=datafilt(:,1:size(dataraw,2)); %filtered data, not derivatives
            %Forecplate1 (Right)
            F1 = [data(:,1) data(:,2) data(:,3)];  %N - force
            M1 = [data(:,4) data(:,5) data(:,6)];  %Nmm - moment
            COP1 = [data(:,7) data(:,8) ]; %mm - center of pressure
            %Forecplate2 (Left)
            F2 = [data(:,9) data(:,10) data(:,11)];  %N, 
            M2 = [data(:,12) data(:,13) data(:,14)];  %Nmm
            COP2 = [data(:,15) data(:,16) ]; %mm
        else
            dataraw(:,[3:5 6:8 18:20 21:23])=-dataraw(:,[3:5 6:8 18:20 21:23]);
            % Select only (16 col)
            % F1xF1yF1zM1xM1yM1zCOP1xCOP1yF2xF2yF2zM2xM2yM2zCOP2xCOP2y
            dataraw = dataraw(:,[3:10 18:25]);
            fs = devicefs; % data collection hz
            fc = 20; % low pass filter frequency cut off
            dt = 1/fs; % numerical integration time steps
            % get time
            time = [1:size(dataraw,1)]/fs;
            dataraw(isnan(dataraw))=0;
            % filter data : datafilt is original:derivative:secondderivative
            [datafilt]=diff23f5(dataraw,dt,fc);
            data=datafilt(:,1:size(dataraw,2)); %filtered data, not derivatives
            %Forecplate1 (Right)
            F1 = [data(:,1) data(:,2) data(:,3)];  %N - force
            M1 = [data(:,4) data(:,5) data(:,6)];  %Nmm - moment
            COP1 = [data(:,7) data(:,8) ]; %mm - center of pressure
            %Forecplate2 (Left)
            F2 = [data(:,9) data(:,10) data(:,11)];  %N, 
            M2 = [data(:,12) data(:,13) data(:,14)];  %Nmm
            COP2 = [data(:,15) data(:,16) ]; %mm
        end

        % save forces since they will be resampled to identify heel strikes
        F1old=F1;
        F2old=F2;
        timeold=time;
        M1old = M1;
        M2old = M2;
        COP1old = COP1;
        COP2old = COP2;
        % resample force and force time
        time=resample(timeold,1,10);
        F1=resample(F1old,1,10);
        F2=resample(F2old,1,10);
        M1 = resample(M1old,1,10);
        M2 = resample(M2old,1,10);
        COP1 = resample(COP1old,1,10);
        COP2 = resample(COP2old,1,10);
        % save to force structure, trimming off the first 60s
        f.R{blk} = F1(itrim:end,:);
        f.L{blk} = F2(itrim:end,:);
        f.time{blk} = time(itrim:end);
        f.MR{blk} = M1(itrim:end,:);
        f.COPR{blk} = COP1(itrim:end,:);
        f.ML{blk} = M2(itrim:end,:);
        f.COPL{blk} = COP2(itrim:end,:);


        end % isempty
    end %end blk
    cd([homepath '\matData'])
    save(savename_force,'f');
    cd(homepath)
end
% clearvars -except F p subject homepath
toc
        



% clearvars -except subject homepath colors F p