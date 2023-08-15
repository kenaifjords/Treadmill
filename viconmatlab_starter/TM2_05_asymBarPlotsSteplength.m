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
firsteff = firsteff(firsteff > 0);
secondeff = secondeff(secondeff > 0);


initialpertstep = 1:5; % 10 steps are included in the computation of intiial perturbation
earlypertstep = 6:30;
latepertstep = 31:200;
endpertstep = 30;

% create cell structure for each block (including all subjects)

% sort by exposures
ctrlcount = 1; effcount = 1;
for subj = 1:subject.n
    for blk = 1:subject.nblk
        if subject.order(subj) ~= [0 0]% 1 and 2 here refer to order of visits
            learncurves1_cell{effcount,blk} = asym(subj).steplength{firsteff(subj),blk};
            learncurves2_cell{effcount,blk} = asym(subj).steplength{secondeff(subj),blk};
        else
            learncurvesC_cell{ctrlcount,blk} = asym(subj).steplength{3,blk};
        end
    end
    if subject.order(subj) ~= [0 0]
        effcount = effcount +1;
    else
        ctrlcount = ctrlcount +1;
    end
end
ctrlcount = ctrlcount - 1;
effcount = effcount -1;
% first visit
[split1_curves,~] = alignProfiles2(learncurves1_cell(:,split1blk),ones(effcount,1));
[wash1_curves,~] = alignProfiles2(learncurves1_cell(:,wash1blk),ones(effcount,1));
[split2_curves,~] = alignProfiles2(learncurves1_cell(:,split2blk),ones(effcount,1));
% second visit
[split3_curves,~] = alignProfiles2(learncurves2_cell(:,split1blk),ones(effcount,1));
[wash3_curves,~] = alignProfiles2(learncurves2_cell(:,wash1blk),ones(effcount,1));
[split4_curves,~] = alignProfiles2(learncurves2_cell(:,split2blk),ones(effcount,1));
% control visit
[split1ctrl_curves,~] = alignProfiles2(learncurvesC_cell(:,split1blk),ones(ctrlcount,1));
[washctrl_curves,~] = alignProfiles2(learncurvesC_cell(:,wash1blk),ones(ctrlcount,1));
[split2ctrl_curves,~] = alignProfiles2(learncurvesC_cell(:,split2blk),ones(ctrlcount,1));


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
initialpert = [mean(highsplit1(:,initialpertstep),'all','omitnan') mean(lowsplit1(:,initialpertstep),'all','omitnan');...
    mean(highsplit2(:,initialpertstep), 'all','omitnan') mean(lowsplit2(:,initialpertstep), 'all','omitnan');...
    mean(highsplit3(:,initialpertstep), 'all','omitnan') mean(lowsplit3(:,initialpertstep), 'all','omitnan');...
    mean(highsplit4(:,initialpertstep), 'all','omitnan') mean(lowsplit4(:,initialpertstep), 'all','omitnan')];
earlypert = [mean(highsplit1(:,earlypertstep),'all','omitnan') mean(lowsplit1(:,earlypertstep),'all','omitnan');...
    mean(highsplit2(:,earlypertstep), 'all','omitnan') mean(lowsplit2(:,earlypertstep), 'all','omitnan');...
    mean(highsplit3(:,earlypertstep), 'all','omitnan') mean(lowsplit3(:,earlypertstep), 'all','omitnan');...
    mean(highsplit4(:,earlypertstep), 'all','omitnan') mean(lowsplit4(:,earlypertstep), 'all','omitnan')];
latepert = [mean(highsplit1(:,latepertstep),'all','omitnan') mean(lowsplit1(:,latepertstep),'all','omitnan');...
    mean(highsplit2(:,latepertstep), 'all','omitnan') mean(lowsplit2(:,latepertstep), 'all','omitnan');...
    mean(highsplit3(:,latepertstep), 'all','omitnan') mean(lowsplit3(:,latepertstep), 'all','omitnan');...
    mean(highsplit4(:,latepertstep), 'all','omitnan') mean(lowsplit4(:,latepertstep), 'all','omitnan')];
effcount0 = 1; ctrlcount = 1;
for subj = 1:subject.n 
    if subject.order(subj) ~= [0 0]
        lastH1 = find(~isnan(highsplit1(subj,:)),1,'last');
        lastL1 = find(~isnan(lowsplit1(subj,:)),1,'last');
        lastH2 = find(~isnan(highsplit2(subj,:)),1,'last');
        lastL2 = find(~isnan(lowsplit2(subj,:)),1,'last');
        lastH3 = find(~isnan(highsplit3(subj,:)),1,'last');
        lastL3 = find(~isnan(lowsplit3(subj,:)),1,'last');
        lastH4 = find(~isnan(highsplit4(subj,:)),1,'last');
        lastL4 = find(~isnan(lowsplit4(subj,:)),1,'last');
        endpert0(:,:,effcount0) = [mean(highsplit1(subj, lastH1-endpertstep:lastH1),'all','omitnan') mean(lowsplit1(subj, lastL1-endpertstep:lastL2),'all','omitnan');...
            mean(highsplit2(subj, lastH2-endpertstep:lastH2), 'all','omitnan') mean(lowsplit2(subj, lastL2-endpertstep:lastL2), 'all','omitnan');...
            mean(highsplit3(subj, lastH3-endpertstep:lastH3), 'all','omitnan') mean(lowsplit3(subj, lastL3-endpertstep:lastL3), 'all','omitnan');...
            mean(highsplit4(subj, lastH4-endpertstep:lastH4), 'all','omitnan') mean(lowsplit4(subj, lastL4-endpertstep:lastL4), 'all','omitnan')];
        effcount0 = effcount0 + 1;
    end
end
endpert = mean(endpert0,3,'omitnan');
% To get standard deviations
initialpert_subj = [mean(highsplit1(:,initialpertstep),2,'omitnan'), mean(lowsplit1(:,initialpertstep),2,'omitnan'),...
    mean(highsplit2(:,initialpertstep), 2,'omitnan'), mean(lowsplit2(:,initialpertstep), 2,'omitnan'),...
    mean(highsplit3(:,initialpertstep), 2,'omitnan'), mean(lowsplit3(:,initialpertstep), 2,'omitnan'),...
    mean(highsplit4(:,initialpertstep), 2,'omitnan'), mean(lowsplit4(:,initialpertstep), 2,'omitnan')];
earlypert_subj = [mean(highsplit1(:,earlypertstep),2,'omitnan') mean(lowsplit1(:,earlypertstep),2,'omitnan'),...
    mean(highsplit2(:,earlypertstep), 2,'omitnan') mean(lowsplit2(:,earlypertstep), 2,'omitnan'),...
    mean(highsplit3(:,earlypertstep), 2,'omitnan') mean(lowsplit3(:,earlypertstep), 2,'omitnan'),...
    mean(highsplit4(:,earlypertstep), 2,'omitnan') mean(lowsplit4(:,earlypertstep), 2,'omitnan')];
latepert_subj = [mean(highsplit1(:,latepertstep),2,'omitnan') mean(lowsplit1(:,latepertstep),2,'omitnan'),...
    mean(highsplit2(:,latepertstep), 2,'omitnan') mean(lowsplit2(:,latepertstep), 2,'omitnan'),...
    mean(highsplit3(:,latepertstep), 2,'omitnan') mean(lowsplit3(:,latepertstep), 2,'omitnan'),...
    mean(highsplit4(:,latepertstep), 2,'omitnan') mean(lowsplit4(:,latepertstep), 2,'omitnan')];



stderrinitial = std(initialpert_subj,[],1,'omitnan')./sqrt(sum(~isnan(initialpert_subj),1));
stderrearly = std(earlypert_subj,[],1,'omitnan')./sqrt(sum(~isnan(earlypert_subj),1));
stderrlate = std(latepert_subj,[],1,'omitnan')./sqrt(sum(~isnan(latepert_subj),1));
stderrend0 = std(endpert0,[],3,'omitnan')./sqrt(sum(~isnan(endpert0),3));
stderrend = stderrend0(:);
%% via barmod
% % barmod variables (x,ar,bo,bgo,xlimo,ylimo,labels)
% % x will be data
% ar = 0.75; % aspect ratio
% bo = 0; % bar offset
% bgo = 0.2; % bar offset for bar groups
% xlimo = bgo; % offset of bar from axes and end of plot
% ylimo = bgo;% offset of bar from top / bottom of the chart
% labels = ["Exposure 1","Exposure 2", "Exposure 3", "Exposure 4"];
% % conditions across the 4 exposures
% figure; hold on;
% bar_ip = barmod(initialpert,[],ar,bo,bgo,xlimo,ylimo,labels); %bar_ip = bar(initialpert);
% %Color Declaration
% clrs = cell(1);
% for i = 1:size(initialpert,2) %indexed first to call rand's three times, not six
%     clrs{i} = colors.all{i,1};
%     for j = 1:size(initialpert,1)
%         bar_ip(j,i).FaceColor = clrs{i};
%     end
% end
% ylabel('steplength asymmetry (average of first 10 strides)'); xlabel('split belt exposure')

%% use superbar
% figure(); hold on;
% colr = [colors.high; colors.low];
% edgcolr = nan(4,2,3);
% edgcolr(1,1,:) = [colors.high]; edgcolr(1,2,:) = [colors.low];
% edgcolr(2,1,:) = [colors.high]; edgcolr(2,2,:) = [colors.low];
% edgcolr(3,1,:) = [colors.low]; edgcolr(3,2,:) = [colors.high];
% edgcolr(4,1,:) = [colors.low]; edgcolr(4,2,:) = [colors.high];
% 
% superbar(1:4, initialpert,'E',stderrpert,'BarFaceColor', permute(colr,[3 1 2]),...
%     'BarEdgeColor',edgcolr,'ErrorbarStyle','|')
% set(gca, 'XAxisLocation', 'top')
% ylabel('steplength asymetry (first 10 strides)');
% xticks(1:4)
% xlabel('Split Belt Exposure')
%% use superbar CORRECTED initial perturbation at each exposure
figure(); hold on;
clear colr
colr(1,1,:) = colors.high; colr(1,2,:) = colors.low;
colr(2,1,:) = colors.high; colr(2,2,:) = colors.low; 
colr(3,1,:) = colors.low; colr(3,2,:) = colors.high;
colr(4,1,:) = colors.low; colr(4,2,:) = colors.high;
edgcolr = nan(4,2,3);
edgcolr(1,1,:) = [colors.high]; edgcolr(1,2,:) = [colors.low];
edgcolr(2,1,:) = [colors.high]; edgcolr(2,2,:) = [colors.low];
edgcolr(3,1,:) = [colors.high]; edgcolr(3,2,:) = [colors.low];
edgcolr(4,1,:) = [colors.high]; edgcolr(4,2,:) = [colors.low];

superbar(1:4, initialpert,'E',stderrinitial,'BarFaceColor', colr,...
    'BarEdgeColor',edgcolr,'ErrorbarStyle','|')
set(gca, 'XAxisLocation', 'top')
ylabel('steplength asymetry (first 10 strides)');
xticks(1:4)
xlabel('Split Belt Exposure')
title('Initial Perturbation in each exposure')
%% use superbar CORRECTED first exposure asymmetry
clear colr edgcolr
% first exposure asym
firstasymbar(1,:) = [initialpert(1,1) initialpert(1,2)]; % specifies intial
% pert on first exposure (1,) and the two effort levels
firstasymbar(2,:) = [earlypert(1,1) earlypert(1,2)];
firstasymbar(3,:) = [latepert(1,1) latepert(1,2)];
firstasymbar(4,:) = [endpert(1,1) endpert(1,2)];

firstasymstderr = [stderrinitial(1) stderrinitial(2);...
    stderrearly(1) stderrearly(2);...
    stderrlate(1) stderrlate(2);...
    stderrend(1) stderrend(2)];

figure(); hold on;
colr = nan(4,2,3);
colr(1,1,:) = colors.high; colr(1,2,:) = colors.low;
colr(2,1,:) = colors.high; colr(2,2,:) = colors.low; 
colr(3,1,:) = colors.high; colr(3,2,:) = colors.low;
colr(4,1,:) = colors.high; colr(4,2,:) = colors.low;
edgcolr = nan(4,2,3);
edgcolr(1,1,:) = [colors.high]; edgcolr(1,2,:) = [colors.low];
edgcolr(2,1,:) = [colors.high]; edgcolr(2,2,:) = [colors.low];
edgcolr(3,1,:) = [colors.high]; edgcolr(3,2,:) = [colors.low];
edgcolr(4,1,:) = [colors.high]; edgcolr(4,2,:) = [colors.low];

superbar(1:4, firstasymbar,'E',firstasymstderr,'BarFaceColor', colr,...
    'BarEdgeColor',edgcolr,'ErrorbarStyle','|')
set(gca, 'XAxisLocation', 'top')
ylabel('steplength asymetry');
xticks(1:4)
xticklabels({'initial','early','late','plateau'})
title('steplength asymmetry in first exposure')