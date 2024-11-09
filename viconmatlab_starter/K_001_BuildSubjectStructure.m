%K_001_BuildSubjectStructure
tic
homepath = pwd;
% clearvars -except
%% load subject data
subject.list = {'VVS' 'EER' 'MMD' 'NQZ' 'NEP'}; %% remove VVS and EER (not naive)
subject.n = length(subject.list);
subject.list_blockname = {'baseline' 'learning' 'retention' 'washout'...
    'relearning'};
subject.nblk = length(subject.list_blockname);
subject.effortcondition = {'error-dependent (informed)',...
    'error-dependent (uninformed)', 'control_low'};
%% load in subject data
subj_in = readtable([homepath '\kinarm_subject_data.csv']);
subject.errdep_informed = []; subject.errdep_uninformed = [];
subject.control_low = [];
for subj = 1:subject.n
    subjidx = find(ismember(subj_in,subject.list{sub}));
    subject.errdep(subj) = subj_in.errordependent(subjidx);
    subject.informed(subj) = subj_in.informed(subjidx);
    subject.basedamping(subj) = subj_in.basedamping(subjidx);
    % load other subject information in here: age, activity level, etc
    if subject.errdep(subj) == 1
        if subject.informed(subj) == 1
            subject.errdep_informed = ...
                cat(1,subject.errdep_informed, subject.list{subj});
        else
            subject.errdep_uninformed = ...
                cat(1,subject.errdep_uninformed, subject.list{subj});
        end
    else
        subject.control_low = ...
                cat(1,subject.control_low, subject.list{subj});
    end
end
%% loop through subjects to build data files and metrics

% make subject data

