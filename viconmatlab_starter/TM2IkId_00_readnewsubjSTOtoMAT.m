%TM2IK_00_readnewsubjSTOtoMAT
tic
clear all
close all
global subject homepath ik id

homepath = pwd;
path = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\stoData';
%'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\stoData';
path_save = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\matData_IKID';
%'C:\Users\Vicon-OEM\Desktop\OpenSim_IK_ID_Split-belt\matData_IKID';
% data collection device parameters
ikfs = 100; %1000 Hz for the treadmill, 100Hz for cameras

% take the mat files for each subject and build a full structure, so that
% we can loop through subjects - PREFER ONE SUBJECT AT A TIME
subject.list =  {'MAC'}; % RMM BTT
subject.blockname = {'base1' 'base2' 'base3' 'split1' 'wash1' 'split2' 'wash2'};
subject.effortcondition = {'high','low'};
%% CHANGE LOOP COUNT INDICES WHEN WE HAVE ALL THE DATA
for subj = 1:length(subject.list)
    savename_ik = [subject.list{subj} '_ik.mat'];
    savename_id = [subject.list{subj} '_id.mat']; 
    for effcond = 2 %1:length(subject.effortcondition) %effort condition: 1 is high
        if effcond == 1 % high effort
            %% END CHANGE
                effort_folder = 'High_Effort';
            else % low effort
                effort_folder = 'Low_Effort';
        end
        for blk = 2 %1:length(subject.blockname)
            subjpath = [path '\' subject.list{subj} '\' effort_folder];
            filename = [subject.list{subj} '_' subject.blockname{blk} '_IK.csv'];
            clear devicedata trajdata dataraw trajdataraw
            % load ik
            [ikdata] = readopensimsto_ik(subjpath,filename);
            % load id
            filename = [subject.list{subj} '_' subject.blockname{blk} '_ID.csv'];
            [iddata] = readopensimsto_id(subjpath,filename);
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

% ### ADD INVERSE DYNAMICS HERE to global (id.heading{effcond,blk}
            %% convert id data to torques and ...
            id.idtime{effcond,blk} = iktime(1:end);
            % get pelvis
            id.pelvis_M{effcond,blk} = iddata(1:end,2:4); % tilt list rotation 
            id.pelvis_tF{effcond,blk} = iddata(1:end,5:7); % tx ty tz ### WTH is this?
            % get hip R moments
            id.Rhipflexion_M{effcond,blk} = iddata(1:end,8);
            id.Rhipadduction_M{effcond,blk} = iddata(1:end,9);
            id.Rhiprotation_M{effcond,blk} = iddata(1:end,10);
            % get hip L moments
            id.Lhipflexion_M{effcond,blk} = iddata(1:end,11);
            id.Lhipadduction_M{effcond,blk} = iddata(1:end,12);
            id.Lhiprotation_M{effcond,blk} = iddata(1:end,13);
            % lumbar extention 14, 15, 16
            % get knee R
            id.Rknee_M{effcond,blk} = iddata(1:end,17);
            id.Rknee_beta_F{effcond,blk} = iddata(1:end,18);
            %get L knee
            id.Lknee_M{effcond,blk} = iddata(1:end,19);
            id.Lknee_beta_F{effcond,blk} = iddata(1:end,20);
            % arm 21,22,23,24,25,26
            % get ankle 
            id.Rankle_M{effcond,blk} = iddata(1:end,27);
            id.Lankle_M{effcond,blk} = iddata(1:end,28);
            % elbow 29,30;
            % not enough markers for subtalar angle 31 32, pronation 33 34,
            % mtp angle 35, 36
        end %block
    end %effort condition
    cd(path_save)
    save(savename_ik,'ik');
    save(savename_id,'id');
    cd(homepath)
end
% clearvars -except F p subject homepath
toc