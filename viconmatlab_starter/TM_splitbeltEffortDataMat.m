% read in each subjects two conditions and save mat files
% this will only create subject specific files, run TM_splitbeltStructure
% to generate the structure from these files

global homepath
homepath = 'F:\Users\Rachel\viconmatlab_starter';
subjects = {'RMM'}; % RMM
conditions = {'LowEffort','HighEffort'};
for subj = 1:length(subjects)
    TM(subj).subject = subjects(subj);
    for cond = 1:length(conditions)
        path = 'F:\Users\Rachel\viconmatlab_starter\csvData\';
        filename = strcat(subjects(subj), '_', conditions(cond));
        [forceplate, trajectories] = readviconcsv(path,filename);
%         [TM(subj).Effort(cond).forceplate, TM(subj).Effort(cond).trajectories] = readviconcsv(path,filename);
        subjTM.Effort(cond).forceplate = forceplate; %TM(subj).Effort(cond).forceplate;
        subjTM.Effort(cond).trajectories = trajectories; %TM(subj).Effort(cond).trajectories;
    end
    cd('matData')
    name = strcat(subjects(subj),'_TM','.mat');
    save(name{1,1},'subjTM'); %,-append)
    cd(homepath)
    clear subjTM
end