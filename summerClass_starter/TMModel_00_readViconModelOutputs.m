
%Extract IK and ID data from Vicon Model Outputs file
clear all, close all
global subject homepath 
tic
homepath = pwd;
path = [homepath '\csvData'];
path_save = [homepath '\matData'];

subject.list = {'DGB'};
subject.blockname = {'barefoot' 'sneaker' 'trainer'};

%Loop through in the hierarchical order

for subj = 1:length(subject.list)
    savename_ik = [subject.list{subj} '_ik.mat'];
    savename_id = [subject.list{subj} '_id.mat'];
        for blk = 1:length(subject.blockname)
            subjpath = [path '\' subject.list{subj}];
            filename = [subject.list{subj} '_' subject.blockname{blk} '_dynamic.csv'];
            [modeldata] = readviconmodelcsv_SC(subjpath,filename);
            ikdata = modeldata(:,3:20);
            iddata = modeldata(:,21:end);
            
            %% time (based on 100Hz frame rate)
            modelframe = modeldata(:,1);
            modeltime = modelframe/100;
            ik.time{blk} = modeltime;
            id.time{blk} = modeltime;
            
            %% joint angles
            ik.Lankleangle{blk} = ikdata(1:end,1);
            ik.Lankleadduction{blk} = ikdata(1:end,2);
            ik.Lanklerotation{blk} = ikdata(1:end,3);
            
            ik.Lhipflexion{blk} = ikdata(1:end,4); 
            ik.Lhipadduction{blk} = ikdata(1:end,5);
            ik.Lhiprotation{blk} = ikdata(1:end,6);
            
            ik.Lkneeangle{blk} = ikdata(1:end,7);
            ik.Lkneeadduction{blk} = ikdata(1:end,8);
            ik.Lkneerotation{blk} = ikdata(1:end,9);

            ik.Rankleangle{blk} = ikdata(1:end,10);
            ik.Rankleadduction{blk} = ikdata(1:end,11);
            ik.Ranklerotation{blk} = ikdata(1:end,12);
            
            ik.Rhipflexion{blk} = ikdata(1:end,13); 
            ik.Rhipadduction{blk} = ikdata(1:end,14);
            ik.Rhiprotation{blk} = ikdata(1:end,15);
            
            ik.Rkneeangle{blk} = ikdata(1:end,16);
            ik.Rkneeadduction{blk} = ikdata(1:end,17);
            ik.Rkneerotation{blk} = ikdata(1:end,18);

            %% joint moments
            id.Lankle_M{blk} = -iddata(1:end,1);
            id.Lankleadduction_M{blk} = iddata(1:end,2);
            id.Lanklerotation_M{blk} = iddata(1:end,3);
            
            id.Lhipflexion_M{blk} = -iddata(1:end,4); 
            id.Lhipadduction_M{blk} = iddata(1:end,5);
            id.Lhiprotation_M{blk} = iddata(1:end,6);
            
            id.Lknee_M{blk} = -iddata(1:end,7);
            id.Lkneeadduction_M{blk} = iddata(1:end,8);
            id.Lkneerotation_M{blk} = iddata(1:end,9);
            
            id.Rankle_M{blk} = -iddata(1:end,10);
            id.Rankleadduction_M{blk} = iddata(1:end,11);
            id.Ranklerotation_M{blk} = iddata(1:end,12);
            
            id.Rhipflexion_M{blk} = -iddata(1:end,13); 
            id.Rhipadduction_M{blk} = iddata(1:end,14);
            id.Rhiprotation_M{blk} = iddata(1:end,15);
            
            id.Rknee_M{blk} = -iddata(1:end,16);
            id.Rkneeadduction_M{blk} = iddata(1:end,17);
            id.Rkneerotation_M{blk} = iddata(1:end,18);    
        end
    cd(path_save)
    save(savename_ik, 'ik');%save structure ik in savename_ik
    save(savename_id, 'id');
    cd(homepath)
end
toc