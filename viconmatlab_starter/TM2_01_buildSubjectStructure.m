% TM2_01_buildSubjectStructure
tic
clearvars -except singleexpfit doubleexpfit fwn_f mft_f
homepath = pwd;
global subject
% make subject data
subject.list = {'MAC' 'BAN' 'MLL' 'FUM' 'QPQ'...
                'BAB' 'CFL' 'COM'...
                'HZO' 'MLU' 'BEO' 'DCU' 'HKS'...
                'NVN' 'EHC' 'FWN' 'MFT'...
                'BVL' 'MYP' 'DXI' 'MGC'...
                'QQX' 'DVN' 'DOT' 'CND' 'KKC'...
                'TWD' 'UKW' 'CBO' 'EPN' 'MKT'...
                'QKQ' 'TKH' 'ECC' 'LYT'...
                'CMT' 'BCT' 'DHB' 'BKJ'...
                'IGK'...
                'EFT' 'LKT' 'QWE' 'IQM' 'KJC'}; % something questionable about data, may remove
                %% removed to check results stability
                % 'EFT' 'LKT' 'QWE' 'IQM' 'KJC'
                %%
                %'ECC' F file does not exist ?}; %
%                 DXI has fastleg left on visit 1 and right on visit 2
                % 'BAX' (effcond 1 blks 4,5 have changing force plate 0)
                % 'WSN' visual outlier 
                % 'LKT' visual outlier (high first)
                % 'KJC' visual outlier (low first)
subject.n = length(subject.list);

% easing up the loops and labeling
subject.effortcondition = {'high','low','control'};
subject.leglabel = {'right' 'left'};
subject.effortlabel = {'high effort learning', 'high effort savings' 'low effort learning' 'low effort savings'};
subject.blockname = {'base1' 'base2' 'base3' 'split1' 'wash1' 'split2' 'wash1'};
subject.nblk = length(subject.blockname);
subject.n = length(subject.list);

%% load in order and fastleg data
% csv has a row for each subject. colums are subject name | 1 for high
% first or 2 for low first | the opposite value (1 or 2) indicating low or 
% high on the second visit | fastleg (right = 1, left = 2)
tm_subj_in = readtable([homepath '\tm_subject_mat.csv']);%'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\tm_subject_mat.csv');
subject.highfirstlist = []; subject.lowfirstlist = []; subject.controllist = [];
subject.lowsecondlist = []; subject.highsecondlist = [];
subject.hfirst =[]; subject.lfirst = []; subject.control = []; subject.hsecond = []; subject.lsecond = [];
for subj = 1:subject.n
    subjindx = find(ismember(tm_subj_in.subject,subject.list{subj}));
    subject.order(subj,:) = [tm_subj_in.order1(subjindx) tm_subj_in.order2(subjindx)];
    if subject.order(subj,1) == 1
        subject.highfirstlist = [subject.highfirstlist subject.list(subj)];
        subject.hfirst  = [subject.hfirst subj];
        if subject.order(subj,2) == 2
            subject.lowsecondlist = [subject.lowsecondlist subject.list(subj)];
            subject.lsecond = [subject.lsecond subj];
        end
    elseif subject.order(subj,1) == 2
        subject.lowfirstlist = [subject.lowfirstlist subject.list(subj)];
        subject.lfirst = [subject.lfirst subj];
        if subject.order(subj,2) == 1
            subject.highsecondlist = [subject.highsecondlist subject.list(subj)];
            subject.hsecond = [subject.hsecond subj];
        end
    elseif subject.order(subj,1) == 0
        subject.controllist = [subject.controllist subject.list(subj)];
        subject.control = [subject.control subj];
    end
    subject.fastleg(subj) = tm_subj_in.fastleg(subjindx);
    subject.mass(subj) = tm_subj_in.mass(subjindx);
    subject.bodyweight(subj) = subject.mass(subj)*9.81;
    subject.height(subj) = tm_subj_in.height(subjindx);
    subject.daysbtw(subj) = tm_subj_in.daysbtw(subjindx);
    subject.leglength(subj) = tm_subj_in.leglength(subjindx);
    subject.lowmass(subj) = tm_subj_in.lowmass(subjindx);
    subject.highmass(subj) = tm_subj_in.highmass(subjindx);
end
subject.groupname = {'high first' 'low first' 'control' 'high second' 'low second'};
subject.group = {'hfirst' 'lfirst' 'control' 'hsecond' 'lsecond'};

subject.grpcond = [1 2 3 1 2];
% % order of blocks 1 2 indicates high first;2 1 indicates low first. Add
% % rows in the order that subjects are listed - ### make this cleaner
% subject.order = [2 1; 2 1; 1 2; 1 2; 2 1; 1 2]; %[1 2; 2 1; 2 1; 2 1; 1 2]; 
% % fastleg order right is 1, left is 2 and the column index refers to block.
% % Add rows in the order that subjects are listed - ### make this cleaner
% subject.fastleg = [2; 1; 2; 1; 2; 2;]; %[2 1; 1 1; 2 2; 1 1; 2 2]; (SWITch from 2 to 1 colum

[subject.sorted] = sortsubjlist(subject.list);

%% plot appearance details
colors.high = [248,118,102]/255; % coral-ly orange
colors.low = [75,143,140]/255; %teal-y
colors.high_light = cat(2,[248,118,102]/255,0.3); % coral-ly orange
colors.low_light = cat(2,[75,143,140]/255,0.4); %teal-y
colors.high2 = [213 94 50]/255; %[255,76,52]/255; % burnt orange
colors.low2 = [78,130,109]/255; % [0 158 95]/255; %[49, 156, 189]/255;  % emerald
colors.control = [166, 178, 200]/255; % [112,128,144]/255;
colors.control_light = cat(2,[112,128,144]/255,0.3);
colors.control2 = [96,88,144]/255;
colors.all{1,1} = colors.high; colors.all{1,2} = colors.high_light; colors.all{1,3} = colors.high2;
colors.all{2,1} = colors.low; colors.all{2,2} = colors.low_light; colors.all{2,3} = colors.low2;
colors.all{3,1} = colors.control; colors.all{3,2} = colors.control_light; colors.all{3,3} = colors.control2;
colors.fastleg = [245,39,150] / 255; %[0 1/(blk/2) 0];
colors.slowleg = [87,104,254] / 255;
%% create force and marker position data
for subj = 1:subject.n
    clear a b file_force file_marker
    file_force = [subject.list{subj} '_F.mat'];
    file_marker = [subject.list{subj} '_p.mat'];
    file_ik = [subject.list{subj} '_ik.mat'];
    file_id = [subject.list{subj} '_id.mat'];
    
    cd([homepath '\matData_v2']);%'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\matData_v2')
    a = load(file_force);
%     a.f.R{3,4}(1:20)
    b = load(file_marker);
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
% clearvars -except F p subject homepath colors ID IK
%% print out
disp(['Total subjects: ' num2str(subject.n) '; High first group: ' ...
    num2str(length(subject.highfirstlist)) '; Low first group: '...
    num2str(length(subject.lowfirstlist)) '; Control group: '...
    num2str(length(subject.controllist)) '; High second group: ' ...
    num2str(length(subject.highsecondlist)) '; Low second group: '...
    num2str(length(subject.lowsecondlist))]);
disp(['Total right leg fast: ' num2str(sum(subject.fastleg == 1)) ...
    '; Total left leg fast: ' num2str(sum(subject.fastleg == 2))]);
disp(['n high right: ' num2str(sum((subject.order(:,1) == 1).*(subject.fastleg == 1)'))...
    '; n high left: ' num2str(sum((subject.order(:,1) == 1).*(subject.fastleg == 2)'))...
    '; n low right: ' num2str(sum((subject.order(:,1) == 2).*(subject.fastleg == 1)'))...
    '; n low left: ' num2str(sum((subject.order(:,1) == 2).*(subject.fastleg == 2)'))...
    '; n control right: ' num2str(sum((subject.order(:,1) == 0).*(subject.fastleg == 1)'))...
    '; n control left: ' num2str(sum((subject.order(:,1) == 0).*(subject.fastleg == 2)'))]);
toc