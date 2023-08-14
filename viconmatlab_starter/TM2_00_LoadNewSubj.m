%TM2_00_readnewsubjCSVtoMAT
tic
clear all
close all
global subject homepath colors F p

homepath = pwd;
path = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\csvData_v2';

% data collection device parameters
devicefs = 1000; %1000 Hz for the treadmill, 100Hz for cameras
trajfs = 100; %   100Hz for cameras
trim_time_end = 100;
% take the mat files for each subject and build a full structure, so that
% we can loop through subjects - PREFER ONE SUBJECT AT A TIME
%% add subject code here and change effort condition(s) in line 32
subject.list =  { 'NVN' 'WSN' 'HKS' }; 

% 'MAC' 'BAN' 'MLL' 'FUM' 'QPQ' 
% 'BAB' 'CFL' 'COM' 'KJC' 'LKT'    
% 'HZO' 'MLU' 'BEO' 'DCU' 'HKS'%
% 'WSN' 'NVN' 'EHC' 'FWN' 'MFT'%
% 'BVL' 'IQM' 'MYP' %
% 'BAX'
subject.blockname = {'base1' 'base2' 'base3' 'split1' 'wash1' 'split2' 'wash2'};
subject.effortcondition = {'high','low','control'};

trimindices = readtable('C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\TM2Subject_TrimIndices.csv');

for subj = 1:length(subject.list)
    savename_force = [subject.list{subj} '_F.mat'];       
    savename_marker = [subject.list{subj} '_p.mat'];
    subjindx = find(ismember(trimindices.subject,subject.list{subj}));

    for effcond = 1:3 %3 %1:3 % high, low, control length(subject.effortcondition)+1 %effort condition: 1 is high
%         if effcond == 1
%             savename_force = [subject.list{subj} '_HF.mat'];       
%             savename_marker = [subject.list{subj} '_Hp.mat'];
%         else
%             savename_force = [subject.list{subj} '_LF.mat'];       
%             savename_marker = [subject.list{subj} '_Lp.mat'];% select folder for path
%         end
        if effcond == 1 % high effort
            effort_folder = 'High_Effort';
            tableef = 'high';
        elseif effcond == 2 % low effort
            effort_folder = 'Low_Effort';
            tableef = 'low';
        else
            effort_folder = 'control';
            tableef = 'control';
        end
        for blk = 1:length(subject.blockname)
            subjpath = [path '\' subject.list{subj} '\' effort_folder];
            tableloc = ['trimindices.' tableef  num2str(blk)];
            
            filename = [subject.list{subj} '_' subject.blockname{blk} '.csv'];
            clear devicedata trajdata0 dataraw trajdataraw
            
            if isfolder(subjpath) 
                [devicedata,trajdata0] = readviconcsv_rmmV2(subjpath,filename);
            else
                devicedata = []; trajdata0 = [];
            end
            
            trim_time = eval([tableloc '(subjindx)']);

            if isempty(devicedata) || isempty(trajdata0)
                % do nothing
            else
            %% convert devicedata to forces
            % Forecplate1 (Left)  Z is up/down b/c COP is zero;
            % Y is in the direction of motion
            % Make forces and moments negative so they represent forces acting
            % on the subject rather than on the forceplatform
            if trim_time > 1
                trim_timeforce = trim_time * 10;
            else
                trim_timeforce = 1;
            end
            if trim_time_end > 1
                trim_time_endforce = trim_time_end * 10;
            else
                trim_time_endforce = 1;
            end
            % trimming the data
            dataraw = devicedata(trim_timeforce:end,:);
            trajdata = trajdata0(trim_time:end,:);
%             dataraw=devicedata(trim_timeforce:end-trim_time_endforce,:);
%             trajdata = trajdata0(trim_time:end-trim_time_end,:);
            
            if size(dataraw,2) < 30
%                 dataraw = cat(2,dataraw,nan(size(dataraw,1), 30 - size(dataraw,2)));
                disp(['PINS probably missing. INCOMPLETE CSV, NaNs added. Effort condition: ' num2str(effcond) ' block: ' num2str(blk)]);
                dataraw(:,[3:5 6:8 12:14 15:17])=-dataraw(:,[3:5 6:8 12:14 15:17]);
                % get time
                fs = devicefs; % data collection hz
                fc = 20; % low pass filter frequency cut off
                dt = 1/fs; % numerical integration time steps
                time = (1:size(dataraw,1))/fs;
                
                % F1xF1yF1zM1xM1yM1zCOP1xCOP1yF2xF2yF2zM2xM2yM2zCOP2xCOP2y
                % Select only (16 col)
                dataraw = dataraw(:,[3:10 12:19]);
                
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
                time = (1:size(dataraw,1))/fs;
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
            
                            % data correction for BEO
                            if strcmp(subject.list(subj),'BEO')
                                if effcond == 2
                                    if blk == 3
                                        F1(:,3) = F1(:,3) + 300;
                                        F2(:,3) = F2(:,3) + 250;
                                    elseif blk == 4
                                        F1(:,3) = F1(:,3) + 240;
                                        F2(:,3) = F2(:,3) + 270;
                                    end
                                end
                            end
                            
                            % data correction for CFL
                            if strcmp(subject.list(subj),'FUM')
                                if effcond == 1
                                    if blk == 1
                                        F1(:,3) = F1(:,3) + 385;
                                        F2(:,3) = F2(:,3) + 380;
                                    end
                                end
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
            % resampled time caused time "oscillations" time=resample(timeold,1,10);
            F1=resample(F1old,1,10);
            F2=resample(F2old,1,10);
            M1 = resample(M1old,1,10);
            M2 = resample(M2old,1,10);
            COP1 = resample(COP1old,1,10);
            COP2 = resample(COP2old,1,10);
            time = (1:size(F1,1))./(fs/10);
            % save to force structure, trimming off the first 60s
            f.R{effcond,blk} = F1(:,:);
            f.L{effcond,blk} = F2(:,:);
            f.time{effcond,blk} = time(:);
            f.MR{effcond,blk} = M1(:,:);
            f.COPR{effcond,blk} = COP1(:,:);
            f.ML{effcond,blk} = M2(:,:);
            f.COPL{effcond,blk} = COP2(:,:);

            %% convert trajdata to trajectories
            trajdataraw = trajdata(:);
            trajdata=trajdata(:,3:end);
            % get time and trim first 60 s
            trajtime = [1:size(trajdata,1)]/trajfs;
            pp.trajtime{effcond,blk} = trajtime(:);
            pp.Lasis{effcond,blk} = trajdata(:,1:3);
            pp.Rasis{effcond,blk} = trajdata(:,4:6);
            pp.Lpsis{effcond,blk} = trajdata(:,7:9);
            pp.Rpsis{effcond,blk} = trajdata(:,10:12);
            pp.Lthigh{effcond,blk} = trajdata(:,13:15);
            pp.Lknee{effcond,blk} = trajdata(:,16:18);
            pp.Ltibia{effcond,blk} = trajdata(:,19:21);
            pp.Lankle{effcond,blk} = trajdata(:,22:24);
            pp.Lheel{effcond,blk} = trajdata(:,25:27);
            pp.Ltoe{effcond,blk} = trajdata(:,28:30);
            pp.Rthigh{effcond,blk} = trajdata(:,31:33);
            pp.Rknee{effcond,blk} = trajdata(:,34:36);
            pp.Rtibia{effcond,blk} =trajdata(:,37:39);
            pp.Rankle{effcond,blk} = trajdata(:,40:42);
            pp.Rheel{effcond,blk} = trajdata(:,43:45);
            pp.Rtoe{effcond,blk} = trajdata(:,46:48);
            end % isempty
        end %block
    end %effort condition
    cd('C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\matData_v2')
    save(savename_force,'f');
    save(savename_marker,'pp');
    cd(homepath)
end
% clearvars -except F p subject homepath
toc
        



% clearvars -except subject homepath colors F p