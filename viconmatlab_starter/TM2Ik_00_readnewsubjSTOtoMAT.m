%TM2IK_00_readnewsubjSTOtoMAT
tic
clear all
close all
global subject homepath ik

homepath = pwd;
path = 'C:\Users\Vicon-OEM\Desktop\OpenSim_IK_ID_Split-belt\stoData'; %'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\stoData';
path_save = 'C:\Users\Vicon-OEM\Desktop\OpenSim_IK_ID_Split-belt\matData_IK';
% data collection device parameters
ikfs = 100; %1000 Hz for the treadmill, 100Hz for cameras


% take the mat files for each subject and build a full structure, so that
% we can loop through subjects - PREFER ONE SUBJECT AT A TIME
subject.list =  {'MAC'}; % RMM BTT
subject.blockname = {'base1' 'base2' 'base3' 'split1' 'wash1' 'split2' 'wash2'};
subject.effortcondition = {'high','low'};

for subj = 1:length(subject.list)
    savename_ik = [subject.list{subj} '_ik.mat'];      
    for effcond = 2; %1:length(subject.effortcondition) %effort condition: 1 is high
        if effcond == 1 % high effort
                effort_folder = 'High_Effort';
            else % low effort
                effort_folder = 'Low_Effort';
        end
        for blk = 2 %1:length(subject.blockname)
            subjpath = [path '\' subject.list{subj} '\' effort_folder];
            filename = [subject.list{subj} '_' subject.blockname{blk} '_IK.csv'];
            clear devicedata trajdata dataraw trajdataraw
            [ikdata] = readopensimsto(subjpath,filename);

            %% convert ikdata to rotations and angles
            % get time
            iktime = [1:size(ikdata,1)]/ikfs;
            % could also directly pull column1
            ik.iktime{effcond,blk} = iktime(1:end);
            % get pelvis
            ik.pelvis{effcond,blk} = ikdata(1:end,2:4); % tilt list rotation 
            ik.pelvist{effcond,blk} = ikdata(1:end,5:7); % tx ty tz ### WTH is this?
            % get hip R
            ik.Rhipflexion{effcond,blk} = ikdata(1:end,8);
            ik.Rhipadduction{effcond,blk} = ikdata(1:end,9);
            ik.Rhiprotation{effcond,blk} = ikdata(1:end,10);
            % get knee R
            ik.Rkneeangle{effcond,blk} = ikdata(1:end,11);
            ik.Rkneeangle_beta{effcond,blk} = ikdata(1:end,12);
            % get ankle R
            ik.Rankleangle{effcond,blk} = ikdata(1:end,13);
            
            % not valid from our marker set ## is this true?!
%             ik.Rsubtalarangle{effcond,blk} = ikdata(1:end,14);
%             ik.Rmtpangle{effcond,blk} = ikdata(1:end,15);

            % get hip L
            ik.Lhipflexion{effcond,blk} = ikdata(1:end,16);
            ik.Lhipadduction{effcond,blk} = ikdata(1:end,17);
            ik.Lhiprotation{effcond,blk} = ikdata(1:end,18);
            % get knee R
            ik.Lkneeangle{effcond,blk} = ikdata(1:end,19);
            ik.Lkneeangle_beta{effcond,blk} = ikdata(1:end,20);
            % get ankle R
            ik.Lankleangle{effcond,blk} = ikdata(1:end,21);
            
            % not valid from our marker set ## is this true?!
%             ik.Rsubtalarangle{effcond,blk} = ikdata(1:end,22);
%             ik.Rmtpangle{effcond,blk} = ikdata(1:end,23);
        end %block
    end %effort condition
    cd(path_save)
    save(savename_ik,'ik');
    cd(homepath)
end
% clearvars -except F p subject homepath
toc