% combine the subject mat files into a single data structure
global homepath
subjects = {'RMM'};
conditions = ['LowEffort','HighEffort'];

cd('matData')
for subj = 1:length(subjects)
    name = strcat(subjects(subj), '_TM.mat');
    datain = load(name{1,1});
    TM(subj).subject = subjects(subj);
    for cond = 1:length(conditions)
        TM(subj).Effort(cond) = datain.subjTM.Effort(cond);
        TM(subj).trajdata(cond)= TM(subj).Effort(cond).trajectories(:,3:end);
        trajdataonly = TM(subj).trajdata(cond);
        % FOR LOWER BODY PLUG IN GAIT MODEL
        TM(subj).pLasis(cond) = trajdataonly(:,1:3);
        TM(subj).pRasis(cond) = trajdataonly(:,4:6);
        TM(subj).pLpsis(cond) = trajdataonly(:,7:9);
        TM(subj).pRpsis(cond) = trajdataonly(:,10:12);
        TM(subj).pLthigh(cond) = trajdataonly(:,13:15);
        TM(subj).pLknee(cond) = trajdataonly(:,16:18);
        TM(subj).pLtibia(cond) = trajdataonly(:,19:21);
        TM(subj).pLankle(cond) = trajdataonly(:,22:24);
        TM(subj).pLheel(cond) = trajdataonly(:,25:27);
        TM(subj).pLtoe(cond) = trajdataonly(:,28:30);
        TM(subj).pRthigh(cond) = trajdataonly(:,31:33);
        TM(subj).pRknee(cond) = trajdataonly(:,34:36);
        TM(subj).pRtibia(cond) = trajdataonly(:,37:39);
        TM(subj).pRankle(cond) = trajdataonly(:,40:42);
        TM(subj).pRheel(cond) = trajdataonly(:,43:45);
        TM(subj).pRtoe(cond) = trajdataonly(:,46:48);
end
cd(homepath)
    