% align asymmetry by steps and average across subjects to get curves
% first sort by all four groups, then combine fastleg different groups (so
% that we are comparing low first to high first
split1blk = 4;
wash1blk = 5;
split2blk = 6;

ninitialstep = 40;
% create binary vector to identify group high first or low first
firsteff = subject.order(:,1);
secondeff = subject.order(:,2);
% create cell structure for each block (including all subjects)

% sort by exposures
for subj = 1:subject.n
    for blk = 1:subject.nblk
        % 1 and 2 here refer to order of visits
        learncurves1_cell{subj,blk} = asym(subj).asymlength{firsteff(subj),blk};
        learncurves2_cell{subj,blk} = asym(subj).asymlength{secondeff(subj),blk};
    end
end
[split1_curves,~] = alignProfiles2(learncurves1_cell(:,split1blk),ones(subject.n,1));
[wash1_curves,~] = alignProfiles2(learncurves1_cell(:,wash1blk),ones(subject.n,1));
[split2_curves,~] = alignProfiles2(learncurves1_cell(:,split2blk),ones(subject.n,1));

[split3_curves,~] = alignProfiles2(learncurves2_cell(:,split1blk),ones(subject.n,1));
[wash3_curves,~] = alignProfiles2(learncurves2_cell(:,wash1blk),ones(subject.n,1));
[split4_curves,~] = alignProfiles2(learncurves2_cell(:,split2blk),ones(subject.n,1));

% trim off the pad NaNs added by the align function
split1_curves = split1_curves(:,2:end-1);
wash1_curves = wash1_curves(:,2:end-1);
split2_curves = split2_curves(:,2:end-1);

split3_curves = split3_curves(:,2:end-1);
wash3_curves = wash3_curves(:,2:end-1);
split3_curves = split3_curves(:,2:end-1);

% multiply matrix of learning curves by binary vector and remove zeros to 
% generate matrices for each group
% sort by groups (high first and low first - ignoring fast leg for now)
highfirst = double(firsteff < 2); highfirst(highfirst == 0) = NaN;
lowfirst = double(firsteff > 1); lowfirst(lowfirst == 0) = NaN;

highsplit1 = split1_curves.*highfirst;
lowsplit1 = split1_curves.*lowfirst;
highsplit3 = split3_curves.*lowfirst; 
lowsplit3 = split3_curves.*highfirst; % split 3 refers to the third exposure
% during the second visit to the lab, as such it is in the second
% collection, lowfirst implies highsecond

highwash1 = wash1_curves.*highfirst;
lowwash1 = wash1_curves.*lowfirst;
highwash3 = wash3_curves.*lowfirst; % see above
lowwash3 = wash3_curves.*highfirst;

highsplit2 = split2_curves.*highfirst;
lowsplit2 = split2_curves.*lowfirst;
highsplit4 = split4_curves.*lowfirst; % see above
lowsplit4 = split4_curves.*highfirst;

%% BARPLOT for initial perturbation (first 10 strides) for two effort
initialpert = [mean(highsplit1(:,1:10),'all','omitnan') mean(lowsplit1(:,1:10),'all','omitnan');...
    mean(highsplit2(:,1:10), 'all','omitnan') mean(lowsplit2(:,1:10), 'all','omitnan');...
    mean(highsplit3(:,1:10), 'all','omitnan') mean(lowsplit3(:,1:10), 'all','omitnan');...
    mean(highsplit4(:,1:10), 'all','omitnan') mean(lowsplit4(:,1:10), 'all','omitnan')];
initialpert_subj = [mean(highsplit1(:,1:10),2,'omitnan'), mean(lowsplit1(:,1:10),2,'omitnan'),...
    mean(highsplit2(:,1:10), 2,'omitnan'), mean(lowsplit2(:,1:10), 2,'omitnan'),...
    mean(highsplit3(:,1:10), 2,'omitnan'), mean(lowsplit3(:,1:10), 2,'omitnan'),...
    mean(highsplit4(:,1:10), 2,'omitnan'), mean(lowsplit4(:,1:10), 2,'omitnan')];
stderrpert = std(initialpert_subj,[],1,'omitnan')./sqrt(sum(~isnan(initialpert_subj),1));
%% via barmod
% barmod variables (x,ar,bo,bgo,xlimo,ylimo,labels)
% x will be data
ar = 0.75; % aspect ratio
bo = 0; % bar offset
bgo = 0.2; % bar offset for bar groups
xlimo = bgo; % offset of bar from axes and end of plot
ylimo = bgo;% offset of bar from top / bottom of the chart
labels = ["Exposure 1","Exposure 2", "Exposure 3", "Exposure 4"];
% conditions across the 4 exposures
figure; hold on;
bar_ip = barmod(initialpert,[],ar,bo,bgo,xlimo,ylimo,labels); %bar_ip = bar(initialpert);
%Color Declaration
clrs = cell(1);
for i = 1:size(initialpert,2) %indexed first to call rand's three times, not six
    clrs{i} = colors.all{i,1};
    for j = 1:size(initialpert,1)
        bar_ip(j,i).FaceColor = clrs{i};
    end
end
ylabel('steplength asymmetry (average of first 10 strides)'); xlabel('split belt exposure')

%% use superbar
figure(); hold on;
colr = [colors.high; colors.low];
edgcolr = nan(4,2,3);
edgcolr(1,1,:) = [colors.high]; edgcolr(1,2,:) = [colors.low];
edgcolr(2,1,:) = [colors.high]; edgcolr(2,2,:) = [colors.low];
edgcolr(3,1,:) = [colors.low]; edgcolr(3,2,:) = [colors.high];
edgcolr(4,1,:) = [colors.low]; edgcolr(4,2,:) = [colors.high];

superbar(1:4, initialpert,'E',stderrpert,'BarFaceColor', permute(colr,[3 1 2]),...
    'BarEdgeColor',edgcolr,'ErrorbarStyle','|')
set(gca, 'XAxisLocation', 'top')
ylabel('steplength asymetry (first 10 strides)');
xticks(1:4)
xlabel('Split Belt Exposure')