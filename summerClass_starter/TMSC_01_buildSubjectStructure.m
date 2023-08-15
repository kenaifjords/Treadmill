%% TM2_01_buildSubjectStructure
% This code loads each of the subject's mat files for force and saves them 
% in a structure called F. If the subject.list is {'ABC' 'XYZ'}, the force
% data structures for those two subjects can be accessed in F(1) and F(2)
% respectively. This script builds the same kind of structure for the
% marker position data, building the structure p. Run this code at the
% beginning of a matlab session to load the data in an accessible format
tic
clear all
homepath = pwd;

% make subject data
subject.list = {'ABC' 'XYZ'};
subject.n = length(subject.list);

% easing up the loops and labeling
subject.blockname = {'HSplit1' 'fastbaseline'}; % {'test1' 'collect1' 'collect2'};
subject.nblk = length(subject.blockname);
subject.n = length(subject.list);
% fast leg specification is important for asymetry measures in split belt
% walking fastleg ==1 indicates RIGHT fast
subject.fastleg = [1 1]; 
%% create force and marker position data
for subj = 1:subject.n
    file_force = [subject.list{subj} '_F.mat'];
    file_marker = [subject.list{subj} '_p.mat'];
    
    cd([homepath '\matData'])
    a = load(file_force);
    b = load(file_marker);

    F(subj) = a.f;
    p(subj) = b.pp;
    
end
cd(homepath)
clearvars -except F p subject homepath colors ID IK
toc