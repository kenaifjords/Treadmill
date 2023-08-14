% TM2Ik_01_buildSubjectStructureIK
% eventually combine in subject structure code overall
tic
homepath = pwd;
% make subject data
subject.list = {'DGB'};
subject.n = length(subject.list);

% easing up the loops and labeling
subject.blockname = {'barefoot' 'sneaker' 'trainer'};
subject.nblk = length(subject.blockname);
subject.n = length(subject.list);

% create force and marker position data
for subj = 1:subject.n
    file_ik = [subject.list{subj} '_ik.mat'];
    file_id = [subject.list{subj} '_id.mat'];
    cd([homepath '\matData'])
    a = load(file_ik);
    b = load(file_id);
    IK(subj) = a.ik;
    ID(subj) = b.id;
end
cd(homepath)
clearvars -except IK subject homepath colors ID F p
toc