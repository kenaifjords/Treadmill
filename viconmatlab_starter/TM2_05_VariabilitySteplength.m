% TM2_05_VariabilitySteplength
% this code is dependent on TM2_04_forceandimpulseasymmetry
global asym asym_all colors
initialpertstep = 1:5; % 10 steps are included in the computation of intiial perturbation
earlypertstep = 6:30;
latepertstep = 31:200;
endpertstep = 30;
plot_all = 1;
includeblk = 4:6;
grp_list = {'hfirst','lfirst','control','hsecond','lsecond'};
gait_list = {'fast' 'slow'};
met_list = {'step length', 'step width'};
smet = 2; % 1 is steplength 2 is stepwidth
disp(['METRIC is ' met_list{smet} '; last ' num2str(endpertstep) ...
    ' strides of the trial']);
baselineCompare = 1;
%% step length variability
clear slv slvmat bp_slv
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2) % subject.nblk % includeblk %1:subject.nblk
            clear sl0 sl
            if isempty(F(subj).steplengthR{effcond,blk})
                % do nothing
            else
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
                % choose last nsteps of the trial
                nstep = endpertstep;
                if length(sl0) > nstep
                    sl = sl0(:,length(sl0)-nstep:end);
                elseif length(sl0) == nstep
                    sl = sl0;
                end
                % calculate variability
                if ismember(blk,[1 2 3 7]) % blocks with tied belts
                    slv0 = var(sl,[],'all','omitnan');
                else
                    slv0 = var(sl,[],2,'omitnan');
                end
                % store for sorting
                slvmat{effcond,blk}(subj,:) = slv0;
                slvmat{effcond,blk}(slvmat{effcond,blk} == 0) = NaN;
            end
        end
    end
end
%% sort
[slv] = sortbyEffortVisitorder_02(slvmat);
%% BASELINE plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if baselineCompare
for blk = [1 2 3]
    bp_slv = [slv.hfirst{1,blk} slv.lfirst{1,blk} slv.control{1,blk} ...
        slv.hsecond{1,blk} slv.lsecond{1,blk} ];
    figure(100); subplot(1,3,blk); hold on;
    getBarPlot_groupsorted(bp_slv,['step length variance baseline: blk '...
        num2str(blk)],[0 1000]);
end
% compare
% anova and ttests
for blk = [1 2 3] %4 6]
    figure(100); subplot(1,3,blk);
    grpdata = []; vardata =[];
    for grp = 1:3
        varin = eval(['slv.' grp_list{grp} '{1,' num2str(blk) '}']);
        vardata = [vardata; varin];
        grpdata = [grpdata; grp*ones(length(varin),1)];
    end
    [v_panova(blk),v_anovatab{blk}] = anova1(vardata,grpdata,'off');
    text(0.1,100,['Variability anova (three groups) for: p = ' ...
        num2str(v_panova(blk))]);
    title(subject.blockname{blk})
    
    grpdata = []; vardata =[];
    for grp = 4:5
        varin = eval(['slv.' grp_list{grp} '{1,' num2str(blk) '}']);
        vardata = [vardata; varin];
        grpdata = [grpdata; grp*ones(length(varin),1)];
    end
    [v_pa,v_atab] = anova1(vardata,grpdata,'off');
    text(0.1,200,['Variability anova visit2 for: p = ' num2str(v_pa)]);
    % pairwise high low
    grpdata = []; vardata =[];
    for grp = [1 2]
        varin = eval(['slv.' grp_list{grp} '{1,' num2str(blk) '}']);
        vardata = [vardata; varin];
        grpdata = [grpdata; grp*ones(length(varin),1)];
    end
    [v_pa,v_atab] = anova1(vardata,grpdata,'off');
    text(0.1,300,['Variability comparerd between high and low: p = '...
        num2str(v_pa)]);
    % pairwise high control
    grpdata = []; vardata =[];
    for grp = [1 3]
        varin = eval(['slv.' grp_list{grp} '{1,' num2str(blk) '}']);
        vardata = [vardata; varin];
        grpdata = [grpdata; grp*ones(length(varin),1)];
    end
    [v_pa,v_atab] = anova1(vardata,grpdata,'off');
    text(0.1,400,['Variability compared between high and control: p = '...
        num2str(v_pa)]);
    % pairwise control low
    grpdata = []; vardata =[];
    for grp = [3 2]
        varin = eval(['slv.' grp_list{grp} '{1,' num2str(blk) '}']);
        vardata = [vardata; varin];
        grpdata = [grpdata; grp*ones(length(varin),1)];
    end
    [v_pa,v_atab] = anova1(vardata,grpdata,'off');
    text(0.1,500,['Variability compared between control and low: p = '...
        num2str(v_pa)]);
end
%% compare between fast baseline and slow baseline
for grp = 1:3%5
    blkfast = 2; blkslow = 3;
    [~,pfs] = ttest(eval(['slv.' grp_list{grp} '{1,blkfast}']),...
        eval(['slv.' grp_list{grp} '{1,blkslow}']));
    disp(['Compare fast and slow baseline (paired ttest) ' met_list{smet}...
        ' variability for ' grp_list{grp} ': p = ' num2str(pfs)]);
    figure(400); %subplot(3,1,grp); 
    hold on;
    fst = mean(eval(['slv.' grp_list{grp} '{1,blkfast}']),'omitnan');
    stdfst = std(eval(['slv.' grp_list{grp} '{1,blkfast}']),'omitnan')...
        ./length(eval(['slv.' grp_list{grp} '{1,blkfast}']));
    slw = mean(eval(['slv.' grp_list{grp} '{1,blkslow}']),'omitnan');
    stdslw = std(eval(['slv.' grp_list{grp} '{1,blkslow}']),'omitnan')...
        ./length(eval(['slv.' grp_list{grp} '{1,blkslow}']));
    errorbar([1-grp/9 2+grp/9],[fst,slw],[stdfst,stdslw],':','Color',...
        [colors.all{grp,1},0.6],'LineWidth',3)
    xlim([0.25 2.75])
    plot([1,2],[eval(['slv.' grp_list{grp} '{1,blkfast}']), ...
        eval(['slv.' grp_list{grp} '{1,blkslow}'])],'Color',...
        colors.all{grp,2});
    text(0.8,2000+500*grp,['Compare fast and slow baseline ' met_list{smet}...
        ' variance ' grp_list{grp} ': p = ' num2str(pfs)])
end
title('step length variance')
xticks([1 2]);
xticklabels({'fast','slow'})
beautifyfig
            % fast baseline variability
%% compare within subjects that completed both visits
subji = 1; ihf = 1; ilf = 1;
clear sl_within_mean sl_within_std sl_within_var sl_hf_var sl_lf_var
sl_hf_var = []; sl_lf_var = [];
for subj = 1:subject.n
    if sum(subject.order(subj,:)) > 2 % means they completed both effort
        for blk = [2 3]
            clear sl
            for effcond = 1:2
                % 1 find variability in high effort (fast and slow)
                % 2 find variability in low effort (fast and slow)
                slR = F(subj).steplengthR{effcond,blk}(end-20:end);
                slL = F(subj).steplengthL{effcond,blk}(end-20:end);
                sl0 = [slR slL]; % include both legs in step length
                % variability of the last 20 strides
                sl(effcond,:) = sl0;
            end                
            % compare variabilities between effort conditions within the
            % subject
            [~,p_sl_within(blk-1,subji),ci,stat] = ttest(sl(1,:),sl(2,:));
            % store data for a plot / population comparison
            sl_within_mean(subji,:,blk-1) = [mean(sl(1,:)) mean(sl(2,:))];
            sl_within_std(subji,:,blk-1) = [std(sl(1,:)) std(sl(2,:))];
            sl_within_var(subji,:,blk-1) = [var(sl(1,:)) var(sl(2,:))];
            if subject.order(subj,1) == 1 % high first
                sl_hf_var(ihf,:,blk-1) = [var(sl(1,:)) var(sl(2,:))];
                ihf = ihf + 1;
            else
                sl_lf_var(ilf,:,blk-1) = [var(sl(1,:)) var(sl(2,:))];
                ilf = ilf + 1;
            end
        end
        subjlist(subji) = subj;
        subji = subji  + 1;
    end
end
for fs = 1:2 % between high and low effort
    [~,pp(fs)] = ttest(sl_within_var(:,1,fs),sl_within_var(:,2,fs));
    [~,phf(fs)] = ttest(sl_hf_var(:,1,fs),sl_hf_var(:,2,fs));
    [~,plf(fs)] = ttest(sl_lf_var(:,1,fs),sl_lf_var(:,2,fs));

    % figure
    markerlist = {'o','d'}; base_list = {'fast','slow'};
    figure(77); subplot(1,2,fs); hold on;
    title([{['baseline ' met_list{smet} ' variance in ' base_list{fs}...
        ' baseline']} {['(p var) = ', num2str(pp(fs))]}])
    subji = 1;
    for subj = subjlist
    %     errorbar(sl_within_mean(subji,:),sl_within_std(subji,:),'Color',...
    %         colors.all{subject.order(subj,1),1},'Marker',...
    %         markerlist{subject.order(subj,1)});
        plot(sl_within_var(subji,:,fs),'Color',...
            [colors.all{subject.order(subj,1),1},0.5],'Marker',...
            markerlist{subject.order(subj,1)});
        subji = subji + 1;
    end
    xavg = [1.1 1.9];
    errorbar(xavg, mean(sl_within_var(:,:,fs)),...
        std(sl_within_var(:,:,fs))./sqrt(size(sl_within_var,1)),'k','LineWidth',2);
    errorbar(xavg, mean(sl_hf_var(:,:,fs)),...
        std(sl_hf_var(:,:,fs))./sqrt(size(sl_hf_var,1)),'Color',colors.high,'LineWidth',2);
    errorbar(xavg, mean(sl_lf_var(:,:,fs)),...
        std(sl_lf_var(:,:,fs))./sqrt(size(sl_lf_var,1)),'Color',colors.low,'LineWidth',2);
    xticks([1 2])
    xticklabels({'high','low'});
    beautifyfig
    xlim([0.5 2.5]); ylim([0 2500])
    text(1.5,2000,['p_{hf} = ' num2str(phf(fs))])
    text(1.5,1500,[' p_{lf} = ' num2str(plf(fs))]);
end
% ylabel('step length(m) +/- stdeviation')
subplot(121);ylabel('step length variability')

%% compare slow baseline in blk 1 to slow baseline in blk 3
grpdata = []; vardata = []; blkdata = [];
for grp = 1:5
    varin1 = eval(['slv.' grp_list{grp} '{1,1}']);
    varin3 = eval(['slv.' grp_list{grp} '{1,3}']);
    disp( grp_list{grp})
    [~,p0] = ttest(varin1,varin3);
    disp(['Paired t-test comparing slow walking baseline variability: p = ' num2str(p0)])
end
% t = table(vardata,grpdata,blkdata,'VariableNames',{'variance','group','block'});

%                 % bar plot for step length asymmetry
%                 [a, b, c, d] = getBarPlotVariability(sla);
%                 abar.sla{effcond,blk}(subj,1) = a; abar.sla{effcond,blk}(subj,2) = b;
%                 abar.sla{effcond,blk}(subj,3) = c; abar.sla{effcond,blk}(subj,4) = d; 
%                 abar.sla{effcond,blk}(abar.sla{effcond,blk} == 0) = NaN;
%                 % bar plot for step time asymmetry
%                 [a, b, c, d] = getBarPlotVariability(sta);
%                 abar.sta{effcond,blk}(subj,1) = a; abar.sta{effcond,blk}(subj,2) = b;
%                 abar.sta{effcond,blk}(subj,3) = c; abar.sta{effcond,blk}(subj,4) = d; 
%                 abar.sta{effcond,blk}(abar.sta{effcond,blk} == 0) = NaN;
%             end
%         end
%     end
% end
end % of Baseline Comparisons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LEARNING
disp('LEARNING + WASHOUT + RELEARING BLOCKS')
%% step length variability in learning
plotbp = 1;
for blk = [4 5 6]
    disp(['BLOCK ' num2str(blk)]); % disp(' ');
    bp_slvFast = [slv.hfirst{1,blk}(:,1) slv.lfirst{1,blk}(:,1) ...
        slv.control{1,blk}(:,1) slv.hsecond{1,blk}(:,1)...
        slv.lsecond{1,blk}(:,1)];
    bp_slvSlow = [slv.hfirst{1,blk}(:,2) slv.lfirst{1,blk}(:,2) ...
        slv.control{1,blk}(:,2) slv.hsecond{1,blk}(:,2)...
        slv.lsecond{1,blk}(:,2)];
    bp_slv = cat(3, bp_slvFast, bp_slvSlow); % subj x grp x fastorslow
    if plotbp
        figure(200); subplot(3,1,blk-3); hold on;
        text(3,900,['block ' num2str(blk)]);
        getBarPlot_groupsorted_separatelegs(bp_slv,[met_list{smet} ...
            ' variance baseline: blk ' num2str(blk)],[0 1000]);
        ylabel('variability (mm2)')
        sgtitle([met_list{smet} ' variability ']) 
    end
end
%% check for differences in variability between two legs
for blk = [4 5 6]
    disp(' '); disp(['BLOCK: ' num2str(blk)]);
    for grp = 1:length(grp_list)
        fastv = bp_slv(:,grp,1); slowv = bp_slv(:,grp,2);
        % paired ttest
        [~,p0] = ttest(fastv,slowv);
        disp([grp_list{grp} ...
            ' step variance between fast and slow leg: ttest p = ' ...
            num2str(p0)])
    end
end
%% differences between groups in each block for fast and slow legs
for blk = [4 5 6]
    clear vardat grpdat
    vardat = []; grpdat = [];
    for fs = 1:2
        for grp = 1:3
            varin = eval(['slv.' grp_list{grp} '{1,' num2str(blk) '}(:,'...
                num2str(fs) ')']);
            vardat = [vardat; varin];
            grpdat = [grpdat; grp*ones(length(varin),1)];
        end
        [v_p,v_at] = anova1(vardat,grpdat,'off');
        if plotbp
            figure(200); subplot(3,1,blk-3);
            text(0.1,2100 + 200 * fs,[ gait_list{fs} ...
                'leg variability anova (three groups) for: p = ' ...
                num2str(v_p)]);
        else
            disp([gait_list{fs} 'leg ' met_list{smet} ...
                ' variability anova (three groups) for blk ' num2str(blk)...
                ': p = ' num2str(v_p)])
        end
    end
end

%% differences between groups in each block variability (legs combined)
for blk = [4 5 6]
    clear vardat grpdat
    vardat = []; grpdat = [];
    for grp = 1:3
        for fs = 1:2
            varin0 = eval(['slv.' grp_list{grp} '{1,' num2str(blk) '}']);
            varin = cat(1,varin0(:,1),varin0(:,2));
            vardat = [vardat; varin];
            grpdat = [grpdat; grp*ones(length(varin),1)];
        end
    end
    [v_p,v_at] = anova1(vardat,grpdat,'off');
        if plotbp
            figure(200); subplot(3,1,blk-3);
            text(0.1,2100 + 200 * 3,['combined leg variability anova (three groups) for: p = ' ...
                num2str(v_p)]);
        end
end
%% step length ASYMMETRY variability
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2) % subject.nblk % includeblk %1:subject.nblk
            if isempty(F(subj).R{effcond,blk})
            else
                % y force
    %             trimasym = min(asym_all.asymlengthy(:,effcond,blk));
                sla = asym(subj).steplength{effcond,blk};
                sta = asym(subj).steptime{effcond,blk};

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
            end
        end
    end
end
%% check symmetryy in plateau
[vsla] = sortbyEffortVisitorder_02(abar.sla);
[vsta] = sortbyEffortVisitorder_02(abar.sta);

%% FIGURES
if plot_all
    figure();
    getBarPlot_asymmetry_andcontrol(vsla.hfirst,vsla.lfirst,vsla.hsecond,...
        vsla.lsecond,vsla.control,[met_list{smet} ' asym variability'],[0 0.5])
    getBarPlot_asymmetry_andcontrol_individual_fig(vsla.hfirst,vsla.lfirst,vsla.hsecond,...
        vsla.lsecond,vsla.control,[met_list{smet} ' asym variability'],[0 0.5])
end
%% anova to compare final variability
% prepare for ANOVA
grp_list = {'hfirst','lfirst','control','hsecond','lsecond'};

for blk = [1 2 3 4 5 6 7]
    grpdata = []; vardata =[];
    for grp = 1:3
        varin = eval(['vsla.' grp_list{grp} '{1,' num2str(blk) '}(:,4)']);
        vardata = [vardata; varin];
        grpdata = [grpdata; grp*ones(length(varin),1)];
    end
    [v_panova(blk),v_anovatab{blk}] = anova1(vardata,grpdata,'off');
    disp(['Variability anova for ' subject.blockname{blk} ': p = '...
        num2str(v_panova(blk))]);
    
    % pairwise high low
    grpdata = []; vardata =[];
    for grp = [1 2]
        varin = eval(['vsla.' grp_list{grp} '{1,' num2str(blk) '}(:,4)']);
        vardata = [vardata; varin];
        grpdata = [grpdata; grp*ones(length(varin),1)];
    end
    [v_pa,v_atab] = anova1(vardata,grpdata,'off');
    disp(['Variability comparerd between high and low: p = ' num2str(v_pa)]);
    
    % pairwise high control
    grpdata = []; vardata =[];
    for grp = [1 3]
        varin = eval(['vsla.' grp_list{grp} '{1,' num2str(blk) '}(:,4)']);
        vardata = [vardata; varin];
        grpdata = [grpdata; grp*ones(length(varin),1)];
    end
    [v_pa,v_atab] = anova1(vardata,grpdata,'off');
    disp(['Variability comparerd between high and control: p = ' num2str(v_pa)]);
    
    % pairwise control low
    grpdata = []; vardata =[];
    for grp = [3 2]
        varin = eval(['vsla.' grp_list{grp} '{1,' num2str(blk) '}(:,4)']);
        vardata = [vardata; varin];
        grpdata = [grpdata; grp*ones(length(varin),1)];
    end
    [v_pa,v_atab] = anova1(vardata,grpdata,'off');
    disp(['Variability comparerd between control and low: p = ' num2str(v_pa)]);
end    
        

