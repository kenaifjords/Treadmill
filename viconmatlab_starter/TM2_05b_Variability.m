% TM2_05b_Variability
% TM2_05_VariabilitySteplength
% this code is dependent on TM2_04_forceandimpulseasymmetry
global asym asym_all colors
initialpertstep = [1,5]; % 10 steps are included in the computation of intiial perturbation
earlypertstep = [6,30];
latepertstep = [31,200];
bin = [initialpertstep; earlypertstep; latepertstep];
endpertstep = 30;
plot_all = 1;
includeblk = 4:6;

bin_list = {'initial','early','late','final'};
grp_list = {'hfirst','lfirst','control','hsecond','lsecond'};
gait_list = {'fast' 'slow'};
met_list = {'step length', 'step width'};
markerlist = {'o','d'};

baselineCompare = 0;
plotbarplot = 0;
plotAsymVariance = 1;

for smet = 1 % 1:2
    disp(['METRIC is ' met_list{smet} '; last ' num2str(endpertstep) ...
        ' strides of the trial']);
    %% calculate variability
    clear slv slvmat bp_slv
    for subj = 1:subject.n
        for effcond = 1:size(F(subj).R,1)
            for blk = 1:size(F(subj).R,2) % subject.nblk % includeblk %1:subject.nblk
                clear sl0 sl
                    if isempty(F(subj).steplengthR{effcond,blk})
                        % do nothing
                    else
                        % get metric
                        if smet == 1
                            rsl = F(subj).steplengthR{effcond,blk};
                            lsl = F(subj).steplengthL{effcond,blk};
                        elseif smet == 2
                            rsl = F(subj).stepwidthR{effcond,blk};
                            lsl = F(subj).stepwidthL{effcond,blk};
                        end
                        % get fastleg;slowleg
                        if subject.fastleg == 1
                            sl0 = [rsl;lsl];
                        else
                            sl0 = [lsl;rsl];
                        end
                        % get different bins of the trial (initial, early,
                        % late, final)
                        for ibin = 1:3 % initial, early, late
                            clear sl slv0
                            if length(sl0) > bin(ibin,2)
                                sl = sl0(:,bin(ibin,1):bin(ibin,2));
                                slv0 = var(sl,[],2,'omitnan');
                            else
                                slv0 = NaN;
                            end
                            % store the innermost structure has columns for
                            % bin1fast,bin1slow, bin2fast, bin2slow, etc...
                            slvmat{effcond,blk}(subj,(ibin*2-1):ibin*2)...
                                = slv0;
                        end % ibin
                        % get final bin
                        istart = length(sl0)-endpertstep;
                        if istart < 1
                            istart = 1;
                        end
                        sl = sl0(:,istart:end);
                        slv0 = var(sl,[],2,'omitnan');
                        slvmat{effcond,blk}(subj,7:8) = slv0;
                        % clear zeros / unfilled indices
                        slvmat{effcond,blk}(slvmat{effcond,blk} == 0) = NaN;
                    end % isempty
            end % blk
        end % effcond
    end % subj
    [slv] = sortbyEffortVisitorder_02(slvmat);
    fasti = [1:2:7]; slowi = [2:2:8];
    %% compare baseline
    % see TM2_05_VariabilitySteplength
    %% compare learning, washout, relearning
%     slvfast = NaN(max(subject.ncond),4,length(grp_list));
    for blk = [5]% 4 5 6]
        disp(' '); disp(['BLOCK ' num2str(blk)]);
        slvfast = cat(3, slv.hfirst{1,blk}(:,fasti),...
            slv.lfirst{1,blk}(:,fasti), slv.control{1,blk}(:,fasti), ...
            slv.hsecond{1,blk}(:,fasti), slv.lsecond{1,blk}(:,fasti));
        slvslow = cat(3, slv.hfirst{1,blk}(:,slowi),...
            slv.lfirst{1,blk}(:,slowi), slv.control{1,blk}(:,slowi), ...
            slv.hsecond{1,blk}(:,slowi), slv.lsecond{1,blk}(:,slowi));
        % make the super matrix
        slv_bar = cat(4,slvfast,slvslow); % subj x bin x grp x fastslow
        for ibin = 2:4 % 1:4
            figure(11 * smet + blk); subplot(1,3,ibin-1); hold on;
            text(3, 2000, ['bin ' num2str(ibin)]);
            bin_slv_bar = squeeze(slv_bar(:,ibin,:,:));
            getBarPlot_groupsorted_separatelegs(bin_slv_bar,' ',[0 10000]);
            ylabel('variance (mm2)')
        end
        sgtitle([met_list{smet} ' variability in block ' num2str(blk)]);
        x0 = 10;
        y0 = 50;
        width = 950;
        height = 500;
        set(gcf,'position',[x0,y0,width,height])
    
    %% check for differences between the fast and slow legs
    
        disp(' '); disp('CHECK FOR DIFFERENCES BETWEEN LEGS');
        for grp = 1:length(grp_list)
            disp(grp_list{grp});
            for ibin = 1:4
                bin_slv_bar = squeeze(slv_bar(:,ibin,:,:));
                fastv = bin_slv_bar(:,grp,1); 
                slowv = bin_slv_bar(:,grp,2);
                % paired ttest
                [~,p0] = ttest(fastv,slowv);
                disp([bin_list{ibin} ...
                    ' variance between legs: ttest p = ' ...
                    num2str(p0)])
            end
        end
    
    %% check for differences between groups in the fast/slow leg
    
        disp(' '); disp('CHECK FOR DIFFERENCES BETWEEN GROUPS ON EACH LEG'); 
        clear vardat grpdat
        vardat = []; grpdat = [];
        for ibin = 1:4
            disp(bin_list{ibin});
            bin_slv_bar = squeeze(slv_bar(:,ibin,:,:));
            for ifs = 1:2 % fast or slow
                for grp = 1:3
                    varin = bin_slv_bar(:,grp,ifs);
                    vardat = [vardat; varin];
                    grpdat = [grpdat; grp*ones(length(varin),1)];
                end
                [v_p(ibin,ifs),v_at] = anova1(vardat,grpdat,'off');
                disp([gait_list{ifs} ' leg variance; ANOVA p = '...
                    num2str(v_p(ibin,ifs))])
            end
        end
        
        %% since there is no difference between legs, combine and repeat
        disp(' '); disp('CHECK FOR DIFFERENCES BETWEEN GROUPS ON Combined LEGS'); 
        clear vardat grpdat v_p
        vardat = []; grpdat = [];
        for ibin = 1:4
            disp(bin_list{ibin});
            bin_slv_bar = squeeze(slv_bar(:,ibin,:,:));
            svb = mean(bin_slv_bar,3);
            for grp = 1:3
                varin = svb(:,grp); % fast and slow
                vardat = [vardat; varin];
                grpdat = [grpdat; grp*ones(length(varin),1)];
            end
            [v_p(ibin),v_at] = anova1(vardat,grpdat,'off');
            disp(['step length (both legs) variance; ANOVA p = '...
                num2str(v_p(ibin))])
            [~,phl] = ttest2(svb(:,1),svb(:,2));
            [~,phc] = ttest2(svb(:,1),svb(:,3));
            [~,plc] = ttest2(svb(:,3),svb(:,2));
            disp(['pairwise step length variance: HL p = '...
                num2str(phl) '; HC p = ' num2str(phc) '; LC p = ' ...
                num2str(plc)]);
            if ibin == 4
                clear gb gbase
                % determine if the groups return to baseline variability
                % during the plateau block
                % get baseline stuff (use slow baseline)
                for gi = 1:3
                    gb = eval(['slv.' grp_list{gi} '{1,3}(:,7:8)']);
                    gbase(:,gi)  = mean(gb,2);
                end
                [~,ph] = ttest(svb(:,1),gbase(:,1));
                [~,pl] = ttest(svb(:,2),gbase(:,2));
                [~,pc] = ttest(svb(:,3),gbase(:,3));
                disp(['does step length variance return to baseline: H p = '...
                num2str(ph) '; L p = ' num2str(pl) '; C p = ' ...
                num2str(pc)]);
            end

        end
    end % blk    
end % metric
%% VARIANCE IN ASYMMETRY
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
                [a, b, c, d] = getBarPlotVariability(sla);
                abar.sla{effcond,blk}(subj,1) = a; abar.sla{effcond,blk}(subj,2) = b;
                abar.sla{effcond,blk}(subj,3) = c; abar.sla{effcond,blk}(subj,4) = d; 
                abar.sla{effcond,blk}(abar.sla{effcond,blk} == 0) = NaN;
                % bar plot for step time asymmetry
                [a, b, c, d] = getBarPlotVariability(sta);
                abar.sta{effcond,blk}(subj,1) = a; abar.sta{effcond,blk}(subj,2) = b;
                abar.sta{effcond,blk}(subj,3) = c; abar.sta{effcond,blk}(subj,4) = d; 
                abar.sta{effcond,blk}(abar.sta{effcond,blk} == 0) = NaN;
                % bar plot for step width asymmetry
                [a, b, c, d] = getBarPlotVariability(sta);
                abar.swa{effcond,blk}(subj,1) = a; abar.swa{effcond,blk}(subj,2) = b;
                abar.swa{effcond,blk}(subj,3) = c; abar.swa{effcond,blk}(subj,4) = d; 
                abar.swa{effcond,blk}(abar.swa{effcond,blk} == 0) = NaN;
            end
        end
    end
end
%% sort
[vsla] = sortbyEffortVisitorder_02(abar.sla);
[vsta] = sortbyEffortVisitorder_02(abar.sta);
[vswa] = sortbyEffortVisitorder_02(abar.swa);
%% steplength
if plotAsymVariance
    figure();
%     getBarPlot_asymmetry_andcontrol(vsla.hfirst,vsla.lfirst,vsla.hsecond,...
%         vsla.lsecond,vsla.control,[met_list{smet} ...
%         ' asymmetry variability'],[0 0.5])
    getBarPlot_asymmetry_andcontrol_individual_fig(vsla.hfirst,...
        vsla.lfirst,vsla.hsecond,vsla.lsecond,vsla.control,...
        ['steplength asymmetry variability'],[0 0.5])
end