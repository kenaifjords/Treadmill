% TM0_ProcessSubjBuildCSV
% RMM 23 January 2023
%% generate structure of force and traj data for subject
global homepath
global subject
global F
global p
% navigation
homepath = pwd;
path = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\csvData';

% data collection device parameters
devicefs = 1000; %1000 Hz for the treadmill, 100Hz for cameras
trajfs = 100; %   100Hz for cameras

tic

% list of subjects
subject.list = {'IHU' 'EDC'}; % 'DAT'
subject.n = length(subject.list);
subject.blockname = {'HE1' 'HE2' 'LE1' 'LE2'};
for subj = 1:subject.n
    for blk = 1:length(subject.blockname)
        savename_force = [subject.list{subj} '_' subject.blockname{blk} '_F.mat'];       
        savename_marker = [subject.list{subj} '_' subject.blockname{blk} '_p.mat'];
        subjpath = [path '\' subject.list{subj}];
        filename = [subject.list{subj} '_' subject.blockname{blk} '.csv'];
        [devicedata,trajdata] = readviconcsv_rmm(subjpath,filename);
        %% convert devicedata to forces
        % Forecplate1 (Left)  Z is up/down b/c COP is zero;
        % Y is in the direction of motion
        % Make forces and moments negative so they represent forces acting
        % on the subject rather than on the forceplatform
        dataraw=devicedata;
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
        % save to force structure
        F{subj}.R{blk} = F1;
        F{subj}.L{blk} = F2;
        F{subj}.time{blk} = time;
        F{subj}.MR{blk} = M1;
        F{subj}.COPR{blk} = COP1;
        F{subj}.ML{blk} = M2;
        F{subj}.COPL{blk} = COP2;
        
        %% convert trajdata to trajectories
        trajdataraw = trajdata;
        p{subj}.Lasis{blk} = trajdata(:,1:3);
        p{subj}.Rasis{blk} = trajdata(:,4:6);
        p{subj}.Lpsis{blk} = trajdata(:,7:9);
        p{subj}.Rpsis{blk} = trajdata(:,10:12);
        p{subj}.Lthigh{blk} = trajdata(:,13:15);
        p{subj}.Lknee{blk} = trajdata(:,16:18);
        p{subj}.Ltibia{blk} = trajdata(:,19:21);
        p{subj}.Lankle{blk} = trajdata(:,22:24);
        p{subj}.Lheel{blk} = trajdata(:,25:27);
        p{subj}.Ltoe{blk} = trajdata(:,28:30);
        p{subj}.Rthigh{blk} = trajdata(:,31:33);
        p{subj}.Rknee{blk} = trajdata(:,34:36);
        p{subj}.Rtibia{blk} =trajdata(:,37:39);
        p{subj}.Rankle{blk} = trajdata(:,40:42);
        p{subj}.Rheel{blk} = trajdata(:,43:45);
        p{subj}.Rtoe{blk} = trajdata(:,46:48);
        % get time
        p{subj}.trajtime{blk} = [1:size(trajdata,1)]/trajfs;
    end
    cd(homepath)
%      save(savename_force,F);
%      save(savename_marker,p);
end
clearvars -except F p subject homepath
toc