% TM2_01_buildSubjectStructure
tic
clear all
homepath = pwd;

% make subject data
subject.list = {'MAC' 'BAN' 'MLL' 'FUM' 'QPQ' 'BAB' 'CFL' 'COM' 'KJC' 'LKT' 'HZO' 'MLU' 'BEO'}; %{'RMM' 'BTT' 'MAC' 'BAN' 'MLL'};
subject.n = length(subject.list);

% easing up the loops and labeling
subject.effortcondition = {'high','low'};
subject.leglabel = {'right' 'left'};
subject.effortlabel = {'high effort learning', 'high effort savings' 'low effort learning' 'low effort savings'};
subject.blockname = {'base1' 'base2' 'base3' 'split1' 'wash1' 'split2' 'wash1'};
subject.nblk = length(subject.blockname);
subject.n = length(subject.list);
%% load in order and fastleg data
% csv has a row for each subject. colums are subject name | 1 for high
% first or 2 for low first | the opposite value (1 or 2) indicating low or 
% high on the second visit | fastleg (right = 1, left = 2)
tm_subj_in = readtable('C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\tm_subject_mat.csv');

for subj = 1:subject.n
    subjindx = find(ismember(tm_subj_in.subject,subject.list{subj}));
    subject.order(subj,:) = [tm_subj_in.order1(subjindx) tm_subj_in.order2(subjindx)];
    subject.fastleg(subj) = tm_subj_in.fastleg(subjindx);
    subject.mass(subj) = tm_subj_in.mass(subjindx);
    subject.bodyweight(subj) = subject.mass(subj)*9.81;
end
% % order of blocks 1 2 indicates high first;2 1 indicates low first. Add
% % rows in the order that subjects are listed - ### make this cleaner
% subject.order = [2 1; 2 1; 1 2; 1 2; 2 1; 1 2]; %[1 2; 2 1; 2 1; 2 1; 1 2]; 
% % fastleg order right is 1, left is 2 and the column index refers to block.
% % Add rows in the order that subjects are listed - ### make this cleaner
% subject.fastleg = [2; 1; 2; 1; 2; 2;]; %[2 1; 1 1; 2 2; 1 1; 2 2]; (SWITch from 2 to 1 colum

%% plot appearance details
colors.high = [248,118,102]/255; % coral-ly orange
colors.low = [75,143,140]/255; %teal-y
colors.high_light = cat(2,[248,118,102]/255,0.3); % coral-ly orange
colors.low_light = cat(2,[75,143,140]/255,0.4); %teal-y
colors.high2 = [213 94 50]/255; %[255,76,52]/255; % burnt orange
colors.low2 = [78,130,109]/255; % [0 158 95]/255; %[49, 156, 189]/255;  % emerald
colors.all{1,1} = colors.high; colors.all{1,2} = colors.high_light; colors.all{1,3} = colors.high2;
colors.all{2,1} = colors.low; colors.all{2,2} = colors.low_light; colors.all{2,3} = colors.low2;
%% create force and marker position data
for subj = 1:subject.n
    file_force = [subject.list{subj} '_F.mat'];
    file_marker = [subject.list{subj} '_p.mat'];
    
    cd('C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\matData_v2')
    a = load(file_force);
    b = load(file_marker);
    file_ik = [subject.list{subj} '_ik.mat'];
    file_id = [subject.list{subj} '_id.mat'];
    F(subj) = a.f;
    p(subj) = b.pp;
    cd('C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\matData_IKID')
    if isfile(file_ik)
        c = load(file_ik);
        IK(subj) = c.ik;
    end
    if isfile(file_id)
        d = load(file_id);
        ID(subj) = d.id;
    end
end
cd(homepath)
clearvars -except F p subject homepath colors ID IK
toc