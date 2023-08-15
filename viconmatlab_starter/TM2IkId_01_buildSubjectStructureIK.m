% TM2Ik_01_buildSubjectStructureIK
% eventually combine in subject structure code overall
tic
homepath = pwd;
% make subject data
subject.list = {'MAC'}; %{'RMM' 'BTT' 'MAC'};
subject.n = length(subject.list);

% plot appearance details
colors.high = [248,118,102]/255; % coral-ly orange
colors.low = [75,143,140]/255; %teal-y
colors.high_light = cat(2,[248,118,102]/255,0.3); % coral-ly orange
colors.low_light = cat(2,[75,143,140]/255,0.4); %teal-y
colors.all{1,1} = colors.high; colors.all{1,2} = colors.high_light;
colors.all{2,1} = colors.low; colors.all{2,2} = colors.low_light;

% easing up the loops and labeling
subject.effortcondition = {'high','low'};
subject.leglabel = {'right' 'left'};
subject.effortlabel = {'high effort learning', 'high effort savings' 'low effort learning' 'low effort savings'};
subject.blockname = {'base1' 'base2' 'base3' 'split1' 'wash1' 'split2' 'wash1'};
subject.nblk = length(subject.blockname);
subject.n = length(subject.list);
% order of blocks 1 2 indicates high first;2 1 indicates low first. Add
% rows in the order that subjects are listed - ### make this cleaner
subject.order = [2 1]; %[1 2; 2 1; 2 1];
% fastleg order right is 1, left is 2 and the column index refers to block.
% Add rows in the order that subjects are listed - ### make this cleaner
subject.fastleg = [2 2]; %[2 1; 1 1; 2 2];

% create force and marker position data
for subj = 1:subject.n
    file_ik = [subject.list{subj} '_ik.mat'];
    file_id = [subject.list{subj} '_id.mat'];
    cd([homepath '\matData_IKID'])
    a = load(file_ik);
    b = load(file_id);
    IK(subj) = a.ik;
    ID(subj) = b.id;
end
cd(homepath)
clearvars -except IK subject homepath colors ID
toc