% TM2_05_asymBarPlotsForces
% this code is dependent on TM2_04_forceandimpulseasymmetry
global asym asym_all colors
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
                break
            end
            % y force
            trimasym = min(asym_all.asymlengthy(:,effcond,blk));
            brk = asym(subj).brakeforcey{effcond,blk};
            psh = asym(subj).pushforcey{effcond,blk};
            imp = asym(subj).pushimpulsey{effcond,blk};
%             [abar.brake{effcond,blk}(subj,1), abar.brake.early{effcond,blk}(subj,2),...
%                 abar.brake{effcond,blk}(subj,3), abar.brake{effcond,blk}(subj,4)]...
%                 = getBarPlotAsymmetryData(brk);

            % bar plot for braking force
            [a, b, c, d] = getBarPlotAsymmetryData(brk);
            abar.brake{effcond,blk}(subj,1) = a; abar.brake{effcond,blk}(subj,2) = b;
            abar.brake{effcond,blk}(subj,3) = c; abar.brake{effcond,blk}(subj,4) = d; 
            % bar plot for push off force
            [a, b, c, d] = getBarPlotAsymmetryData(psh);
            abar.push{effcond,blk}(subj,1) = a; abar.push{effcond,blk}(subj,2) = b;
            abar.push{effcond,blk}(subj,3) = c; abar.push{effcond,blk}(subj,4) = d; 
            % bar plot for push off impulse
            [a, b, c, d] = getBarPlotAsymmetryData(imp);
            abar.impulse{effcond,blk}(subj,1) = a; abar.impulse{effcond,blk}(subj,2) = b;
            abar.impulse{effcond,blk}(subj,3) = c; abar.impulse{effcond,blk}(subj,4) = d; 
            
            % z force
            trimasym = min(asym_all.asymlengthz(:,effcond,blk));
            heel = asym(subj).heelstrikeFz{effcond,blk};
            toe = asym(subj).toeoffFz{effcond,blk};
            minf = asym(subj).minstanceFz{effcond,blk};
            
            % barplot data for z forces 
            % heelstrike 
            [a, b, c, d] = getBarPlotAsymmetryData(heel);
            abar.heel{effcond,blk}(subj,1) = a; abar.heel{effcond,blk}(subj,2) = b;
            abar.heel{effcond,blk}(subj,3) = c; abar.heel{effcond,blk}(subj,4) = d; 
            % minstance 
            [a, b, c, d] = getBarPlotAsymmetryData(minf);
            abar.minstance{effcond,blk}(subj,1) = a; abar.minstance{effcond,blk}(subj,2) = b;
            abar.minstance{effcond,blk}(subj,3) = c; abar.minstance{effcond,blk}(subj,4) = d;
            % toe off
            [a, b, c, d] = getBarPlotAsymmetryData(toe);
            abar.toe{effcond,blk}(subj,1) = a; abar.toe{effcond,blk}(subj,2) = b;
            abar.toe{effcond,blk}(subj,3) = c; abar.toe{effcond,blk}(subj,4) = d;
        end
    end
end
%% FIGURES
if plot_all
% braking
[hf,lf,hs,ls,c] = sortbyEffortVisitorder(abar.brake);
% this plotting function does not yet handle the control group
figure();
getBarPlot_asymmetry(hf,lf,hs,ls,'Braking force Y')
figure();
getBarPlot_asymmetry_andcontrol(hf,lf,hs,ls,c,'Braking force Y',[-0.5 0.5])

% pushing
[hf,lf,hs,ls,c] = sortbyEffortVisitorder(abar.push);
figure();
getBarPlot_asymmetry_andcontrol(hf,lf,hs,ls,c,'Push off force Y',[-0.5 0.5])

% push off impulse
[hf,lf,hs,ls,c] = sortbyEffortVisitorder(abar.impulse);
figure();
getBarPlot_asymmetry_andcontrol(hf,lf,hs,ls,c,'Push off Force Impulse',[-0.5 0.5])

% heel strike z
[hf,lf,hs,ls,c] = sortbyEffortVisitorder(abar.heel);
figure();
getBarPlot_asymmetry_andcontrol(hf,lf,hs,ls,c,'Heel Strike Fz',[-0.5 0.5])

% minstance fz
[hf,lf,hs,ls,c] = sortbyEffortVisitorder(abar.minstance);
figure();
getBarPlot_asymmetry_andcontrol(hf,lf,hs,ls,c,'minstance Fz',[-0.5 0.5])

% toe off z
[hf,lf,hs,ls,c] = sortbyEffortVisitorder(abar.toe);
figure();
getBarPlot_asymmetry_andcontrol(hf,lf,hs,ls,c,'Toe Off Fz',[-0.5 0.5])
end
%%

% splitbeltbarplot(blk,brake)
% brake
% push
% impulse
% heelFz
% toeFz
% minstanceFz

function splitbeltbarplot(blk,input)
%% use superbar CORRECTED first exposure asymmetry
clear colr edgcolr
% first exposure asym
firstasymbar(1,:) = [mean(input.hfirst{blk}(:,initialpertstep),'all') input.lfirst{blk}(:,initialpertstep,'all') input.control(:,initialpertstep,'all')]; % specifies intial
% pert on first exposure (1,) and the two effort levels
firstasymbar(2,:) = [mean(input.hfirst{blk}(:,earlypertstep),'all') input.lfirst{blk}(:,earlypertstep,'all') input.control(:,earlypertstep,'all')];
firstasymbar(3,:) = [mean(input.hfirst{blk}(:,latepertstep),'all') input.lfirst{blk}(:,latepertstep,'all') input.control(:,latepertstep,'all')];
firstasymbar(4,:) = [mean(input.hfirst{blk}(:,end-endpertstep),'all') input.lfirst{blk}(:,earlypertstep,'all') input.control(:,earlypertstep,'all')]; % specifies intial

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
end