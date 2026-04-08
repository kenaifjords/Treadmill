% TM2_05_asymBarPlotsForces
% this code is dependent on TM2_04_forceandimpulseasymmetry
global asym asym_all colors
close all
initialpertstep = 1:5; % 10 steps are included in the computation of intiial perturbation
earlypertstep = 6:30;
latepertstep = 31:200;
endpertstep = 30;
plot_all = 1;
includeblk = 4:6;

for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2) % subject.nblk % includeblk %1:subject.nblk
            if isempty(F(subj).R{effcond,blk})
            else
                % y force
    %             trimasym = min(asym_all.asymlengthy(:,effcond,blk));
                sla = asym(subj).steplength{effcond,blk};
                sta = asym(subj).steptime{effcond,blk};
                swa = asym(subj).stepwidth{effcond,blk};
                % bar plot for step length asymmetry
                [a, b, c, d] = getBarPlotAsymmetryData(sla);
                abar.sla{effcond,blk}(subj,1) = a; abar.sla{effcond,blk}(subj,2) = b;
                abar.sla{effcond,blk}(subj,3) = c; abar.sla{effcond,blk}(subj,4) = d; 
                abar.sla{effcond,blk}(abar.sla{effcond,blk} == 0) = NaN;
                % bar plot for step time asymmetry
                [a, b, c, d] = getBarPlotAsymmetryData(sta);
                abar.sta{effcond,blk}(subj,1) = a; abar.sta{effcond,blk}(subj,2) = b;
                abar.sta{effcond,blk}(subj,3) = c; abar.sta{effcond,blk}(subj,4) = d; 
                abar.sta{effcond,blk}(abar.sta{effcond,blk} == 0) = NaN;
                % bar plot for step time asymmetry
                [a, b, c, d] = getBarPlotAsymmetryData(swa);
                abar.swa{effcond,blk}(subj,1) = a; abar.swa{effcond,blk}(subj,2) = b;
                abar.swa{effcond,blk}(subj,3) = c; abar.swa{effcond,blk}(subj,4) = d; 
                abar.swa{effcond,blk}(abar.swa{effcond,blk} == 0) = NaN;
            end
        end
    end
end
%% check symmetryy in plateau
[sla] = sortbyEffortVisitorder_02(abar.sla);
[sta] = sortbyEffortVisitorder_02(abar.sta);
[swa] = sortbyEffortVisitorder_02(abar.swa);

for blk = 6 %1:size(F(subj).R,2)
    disp(' ');
    disp(['BLOCK: ' num2str(blk)])
    
    % high
    disp(['high plateau asym: ' num2str(mean(sla.hfirst{1,blk}(:,4))) ' +/-'...
        num2str(std(sla.hfirst{1,blk}(:,4))./size(sla.hfirst{1,blk},1))])
    [~,p,ci,stat] = ttest(sla.hfirst{1,blk}(:,4));
    disp(['high; ttest against 0: ' 't(' num2str(stat.df) ') = ' num2str(stat.tstat) ', p = ' num2str(p)])
    disp(' ');
    
    % low
    disp(['low plateau asym: ' num2str(nanmean(sla.lfirst{1,blk}(:,4))) ' +/-'...
        num2str(nanstd(sla.lfirst{1,blk}(:,4))./size(sla.lfirst{1,blk},1))])
    [~,p,ci,stat] = ttest(sla.lfirst{1,blk}(:,4));
    disp(['low; ttest against 0: ' 't(' num2str(stat.df) ') = ' num2str(stat.tstat) ', p = ' num2str(p)])
    
    disp(' ');
    
    % control
    disp(['control plateau asym: ' num2str(nanmean(sla.control{1,blk}(:,4))) ' +/-'...
        num2str(nanstd(sla.control{1,blk}(:,4))./size(sla.control{1,blk},1))])
    [~,p,ci,stat] = ttest(sla.control{1,blk}(:,4));
    disp(['control; ttest against 0: ' 't(' num2str(stat.df) ') = ' num2str(stat.tstat) ', p = ' num2str(p)])
    
    disp(' ');
    
    % high
    [~,p,ci,stat] = ttest(sla.hfirst{1,blk}(:,4),sla.hfirst{1,3}(:,4));
    disp(['high; ttest against baseline: ' 't(' num2str(stat.df) ') = ' num2str(stat.tstat) ', p = ' num2str(p)])
    
    % low
    [~,p,ci,stat] = ttest(sla.lfirst{1,blk}(:,4),sla.lfirst{1,3}(:,4));
    disp(['low; ttest against baseline: ' 't(' num2str(stat.df) ') = ' ...
        num2str(stat.tstat) ', p = ' num2str(p)])
    
    % control
    [~,p,ci,stat] = ttest(sla.control{1,blk}(:,4),sla.control{1,3}(:,4));
    disp(['control; ttest against baseline: ' 't(' num2str(stat.df) ') = ' num2str(stat.tstat) ', p = ' num2str(p)])
end
%% STEPLENGTH pairwise ttests
disp(' ');
disp('STEP LENGTH')
snap_title = {'initial','early','late','plateau'};
for blk = [4 5 6]
    disp(['BLK ' num2str(blk)])
    for snap = 1:4
        % high v low
        [~,p] = ttest2(sla.hfirst{1,blk}(:,snap),sla.lfirst{1,blk}(:,snap));
        disp(['pairwise ttest, high v low: ' snap_title{snap} ': '...
            num2str(p)]);
        % high v control
        [~,p] = ttest2(sla.hfirst{1,blk}(:,snap),sla.control{1,blk}(:,snap));
        disp(['pairwise ttest, high v control: ' snap_title{snap} ': '...
            num2str(p)]);
        % low v control
        [~,p] = ttest2(sla.lfirst{1,blk}(:,snap),sla.control{1,blk}(:,snap));
        disp(['pairwise ttest, low v control: ' snap_title{snap} ': '...
            num2str(p)]);
    end
end
%% STEP TIME pairwise ttests
disp(' ');
disp('STEP TIME')
snap_title = {'initial','early','late','plateau'};
for blk = [4 6]
    disp(['BLK ' num2str(blk)])
    for snap = 1:4
        % high v low
        [~,p] = ttest2(sta.hfirst{1,blk}(:,snap),sta.lfirst{1,blk}(:,snap));
        disp(['pairwise ttest, high v low: ' snap_title{snap} ': '...
            num2str(p)]);
        % high v control
        [~,p] = ttest2(sta.hfirst{1,blk}(:,snap),sta.control{1,blk}(:,snap));
        disp(['pairwise ttest, high v control: ' snap_title{snap} ': '...
            num2str(p)]);
        % low v control
        [~,p] = ttest2(sta.lfirst{1,blk}(:,snap),sta.control{1,blk}(:,snap));
        disp(['pairwise ttest, low v control: ' snap_title{snap} ': '...
            num2str(p)]);
    end
end

%% STEP WIDTH pairwise ttests
disp(' ');
disp('STEP WIDTH')
snap_title = {'initial','early','late','plateau'};
for blk = [4 6]
    disp(['BLK ' num2str(blk)])
    for snap = 1:4
        % high v low
        [~,p] = ttest2(swa.hfirst{1,blk}(:,snap),swa.lfirst{1,blk}(:,snap));
        disp(['pairwise ttest, high v low: ' snap_title{snap} ': '...
            num2str(p)]);
        % high v control
        [~,p] = ttest2(swa.hfirst{1,blk}(:,snap),swa.control{1,blk}(:,snap));
        disp(['pairwise ttest, high v control: ' snap_title{snap} ': '...
            num2str(p)]);
        % low v control
        [~,p] = ttest2(swa.lfirst{1,blk}(:,snap),swa.control{1,blk}(:,snap));
        disp(['pairwise ttest, low v control: ' snap_title{snap} ': '...
            num2str(p)]);
    end
end
%% FIGURES
if plot_all
    figure();
    getBarPlot_asymmetry_andcontrol(sla.hfirst,sla.lfirst,sla.hsecond,...
        sla.lsecond,sla.control,'step length asymmetry',[-0.6 0.2])
    getBarPlot_asymmetry_andcontrol_individual_fig(sla.hfirst,sla.lfirst,sla.hsecond,...
        sla.lsecond,sla.control,'step length asymmetry',[-0.6 0.2])
    
    figure();
    getBarPlot_asymmetry_andcontrol(sta.hfirst,sta.lfirst,sta.hsecond,...
        sta.lsecond,sta.control,'step time asymmetry',[-0.2 0.6])
    getBarPlot_asymmetry_andcontrol_individual_fig(sta.hfirst,sta.lfirst,sta.hsecond,...
        sta.lsecond,sta.control,'step time asymmetry',[-0.2 0.6])
    
    figure();
    getBarPlot_asymmetry_andcontrol_individual_fig(swa.hfirst,swa.lfirst,swa.hsecond,...
        swa.lsecond,swa.control,'step width asymmetry',[-0.6 0.6])
end
%% two way repeated measures
[p_2wRR] = get2wayRepeatedMeasuresANOVA(abar.sla);
[p_2wRR_sw] = get2wayRepeatedMeasuresANOVA(abar.swa);
%%

% function splitbeltbarplot(blk,input)
% %% use superbar CORRECTED first exposure asymmetry
% clear colr edgcolr
% % first exposure asym
% firstasymbar(1,:) = [mean(input.hfirst{blk}(:,initialpertstep),'all') input.lfirst{blk}(:,initialpertstep,'all') input.control(:,initialpertstep,'all')]; % specifies intial
% % pert on first exposure (1,) and the two effort levels
% firstasymbar(2,:) = [mean(input.hfirst{blk}(:,earlypertstep),'all') input.lfirst{blk}(:,earlypertstep,'all') input.control(:,earlypertstep,'all')];
% firstasymbar(3,:) = [mean(input.hfirst{blk}(:,latepertstep),'all') input.lfirst{blk}(:,latepertstep,'all') input.control(:,latepertstep,'all')];
% firstasymbar(4,:) = [mean(input.hfirst{blk}(:,end-endpertstep),'all') input.lfirst{blk}(:,earlypertstep,'all') input.control(:,earlypertstep,'all')]; % specifies intial
% 
% firstasymstderr = [stderrinitial(1) stderrinitial(2);...
%     stderrearly(1) stderrearly(2);...
%     stderrlate(1) stderrlate(2);...
%     stderrend(1) stderrend(2)];
% 
% figure(); hold on;
% colr = nan(4,2,3);
% colr(1,1,:) = colors.high; colr(1,2,:) = colors.low;
% colr(2,1,:) = colors.high; colr(2,2,:) = colors.low; 
% colr(3,1,:) = colors.high; colr(3,2,:) = colors.low;
% colr(4,1,:) = colors.high; colr(4,2,:) = colors.low;
% edgcolr = nan(4,2,3);
% edgcolr(1,1,:) = [colors.high]; edgcolr(1,2,:) = [colors.low];
% edgcolr(2,1,:) = [colors.high]; edgcolr(2,2,:) = [colors.low];
% edgcolr(3,1,:) = [colors.high]; edgcolr(3,2,:) = [colors.low];
% edgcolr(4,1,:) = [colors.high]; edgcolr(4,2,:) = [colors.low];
% 
% superbar(1:4, firstasymbar,'E',firstasymstderr,'BarFaceColor', colr,...
%     'BarEdgeColor',edgcolr,'ErrorbarStyle','|')
% set(gca, 'XAxisLocation', 'top')
% ylabel('steplength asymetry');
% xticks(1:4)
% xticklabels({'initial','early','late','plateau'})
% title('steplength asymmetry in first exposure')
% end