% RMM 20 January 2023
%% generate structure of force and traj data for subject
global homepath
% navigation
homepath = pwd;
path = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\csvData';

% data collection device parameters
devicefs = 1000; %1000 Hz for the treadmill, 100Hz for cameras
trajfs = 100; %   100Hz for cameras

% list of subjects
subject.list = {'IHU'}; %
subject.n = length(subject.list);
subject.blocknames = {'HE1' 'HE2' 'LE1' 'LE2'};
for subj = 1:subject.n
    for blk = 1 %:length(subject.blocknames)
        subjpath = [path '\' subject.list{subj}];
        filename = [subject.list{subj} '_' subject.blocknames{blk} '.csv'];
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
        % resample force and force time
        time=resample(timeold,1,10);
        F1=resample(F1old,1,10);
        F2=resample(F2old,1,10);
        % find heel strike : heelstrike forceplate 1, heelstrike
        % forceplate2, toe off forceplate1, toe off forceplate 2
        [hsR,hsL,toR,toL] = getHeelStrikeForce(F1,F2,time);
        
        %% convert trajdata to trajectories
        trajdataraw = trajdata;
        pLasis=trajdata(:,1:3);
        pRasis=trajdata(:,4:6);
        pLpsis=trajdata(:,7:9);
        pRpsis=trajdata(:,10:12);
        pLthigh=trajdata(:,13:15);
        pLknee=trajdata(:,16:18);
        pLtibia=trajdata(:,19:21);
        pLankle=trajdata(:,22:24);
        pLheel=trajdata(:,25:27);
        pLtoe=trajdata(:,28:30);
        pRthigh=trajdata(:,31:33);
        pRknee=trajdata(:,34:36);
        pRtibia=trajdata(:,37:39);
        pRankle=trajdata(:,40:42);
        pRheel=trajdata(:,43:45);
        pRtoe=trajdata(:,46:48);
        % get time
        trajtime = [1:size(trajdata,1)]/trajfs;

                % filter data : datafilt is original:derivative:secondderivative -
                % do we want to filter the camera data ### ?
                % fs = trajfs; % data collection hz
                % fc = 20; % low pass filter frequency cut off
                % dt = 1/fs; % numerical integration time steps
                % [datafilt]=diff23f5(trajdataraw,dt,fc);
        
        % get heel strike and toe off  data from heel marker
        [hsRmarker,hsLmarker,toRmarker,toLmarker] = getHeelStrikeMarker(pRheel,pLheel,trajtime);
        
        % plot to compare heel strike and toe off computed from force
        % plates and from heel marker
        
        % identify cross over
    end
end

%%% FIGURES %%%
% plots for data from force plates
for subj = 1:length(subject.list)
    figure(subj) % vertical force
    subplot(121)
    plot(time,data(1,3),'b.')
    xlabel('Time (s)')
    ylabel('Vertical Force (N)')
    hold on
    subplot(122) % center of pressure
    plot(data(:,7),data(:,8),'b.')
    xlabel('Lateral COP')
    ylabel('Sagittal COP')
    hold on 
end
