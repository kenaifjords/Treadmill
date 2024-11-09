% TM2_05_steplength_steptime_unilateral
global F p subject

normtoslowbaseline = 0;
normtofastbaseline = 0;
normtoheight = 0;

if normtoslowbaseline
    baseblk = 3;
elseif normtofastbaseline
    baseblk = 2;
end

blkinclude = 4:6;
for subj = 1:subject.n
%     if subject.order(subj,1) ~= 0
%         effuse  = 1:2;
%     elseif subject.order(subj,1) == 0
%         effuse = 3;
%     end
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2) % subject.nblk
            rvalid = F(subj).validstepR{effcond,blk};
            lvalid = F(subj).validstepL{effcond,blk};
            sizevalid(subj,effcond,blk) = min([length(rvalid),length(lvalid)]);
        end
    end
end

sizevalid(sizevalid == 0) = NaN;
%%
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2) % subject.nblk
            trimasym = min(sizevalid(:,effcond,blk)) - 1;
            % steplength
            if normtoslowbaseline || normtofastbaseline
                normr = mean(F(subj).steplengthR{effcond,baseblk},'omitnan');
                norml = mean(F(subj).steplengthL{effcond,baseblk},'omitnan');
            else
                normr = 1; norml = 1;
            end
            rsl = F(subj).steplengthR{effcond,blk};
            lsl = F(subj).steplengthL{effcond,blk};
            if subject.fastleg(subj) == 1 && ~isempty(rsl) && ~isempty(lsl)
                fast_all.steplength{effcond,blk}(subj,:) = rsl(1:trimasym)./normr;
                slow_all.steplength{effcond,blk}(subj,:) = lsl(1:trimasym)./norml;
            elseif ~isempty(rsl) && ~isempty(lsl)
                fast_all.steplength{effcond,blk}(subj,:) = lsl(1:trimasym)./norml;
                slow_all.steplength{effcond,blk}(subj,:) = rsl(1:trimasym)./normr;
            end
            % steptime
            if normtoslowbaseline || normtofastbaseline
                normr = mean(F(subj).steptimeR{effcond,baseblk},'omitnan');
                norml = mean(F(subj).steptimeL{effcond,baseblk},'omitnan');
            elseif normtoheight
                normr = subject.height(subj); norml = subject.height(subj);
            else
                normr = 1; norml = 1;
            end
            rst = F(subj).steptimeR{effcond,blk};
            lst = F(subj).steptimeL{effcond,blk};
            if subject.fastleg(subj) == 1 && ~isempty(rst) && ~isempty(lst)
                fast_all.steptime{effcond,blk}(subj,:) = rst(1:trimasym)./normr;
                slow_all.steptime{effcond,blk}(subj,:) = lst(1:trimasym)./norml;
            elseif ~isempty(rst) && ~isempty(lst)
                fast_all.steptime{effcond,blk}(subj,:) = lst(1:trimasym)./norml;
                slow_all.steptime{effcond,blk}(subj,:) = rst(1:trimasym)./normr;
            end
            % stepwidth
            if normtoslowbaseline || normtofastbaseline
                normr = mean(F(subj).stepwidthR{effcond,baseblk},'omitnan');
                norml = mean(F(subj).stepwidthL{effcond,baseblk},'omitnan');
            elseif normtoheight
                normr = subject.height(subj); norml = subject.height(subj);
            else
                normr = 1; norml = 1;
            end
            rst = F(subj).stepwidthR{effcond,blk};
            lst = F(subj).stepwidthL{effcond,blk};
            if subject.fastleg(subj) == 1 && ~isempty(rst) && ~isempty(lst)
                fast_all.stepwidth{effcond,blk}(subj,:) = rst(1:trimasym)./normr;
                slow_all.stepwidth{effcond,blk}(subj,:) = lst(1:trimasym)./norml;
            elseif ~isempty(rst) && ~isempty(lst)
                fast_all.stepwidth{effcond,blk}(subj,:) = lst(1:trimasym)./norml;
                slow_all.stepwidth{effcond,blk}(subj,:) = rst(1:trimasym)./normr;
            end
        end
    end  
end

if 0
%% unilateral step length
[fastlength.hfirst,fastlength.lfirst,fastlength.hsecond,fastlength.lsecond,fastlength.control] = ...
    sortbyEffortVisitorder(fast_all.steplength);
[slowlength.hfirst,slowlength.lfirst,slowlength.hsecond,slowlength.lsecond,slowlength.control] = ...
    sortbyEffortVisitorder(slow_all.steplength);
%% baseline step lengths
figure(99); hold on; title('Baseline Steplength')
plotFastSlowCompareCurves([2:3],'steplength in baseline',fastlength,slowlength);
% step lengths
grp_list = {'hfirst' 'lfirst' 'control' 'hsecond' 'lsecond'};
for blk = 2:3
    disp(' '); disp(['BLOCK: ' num2str(blk)]);
    for grp = 1:3
        for subji = 1:size(eval(['fastlength.' grp_list{grp} '{1,' num2str(blk) '}']))
            % calculate mean
            sl1 = eval(['fastlength.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
            sl2 = eval(['slowlength.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
            s = cat(1,sl1,sl2);
            as = (sl1 - sl2)./(sl1 + sl2);
            sl0(subji,grp) = mean(s(end-30:end));
            asl0(subji,grp) = mean(as(end-30:end));
        end
        % last 30 strides
        meansl = nanmean(sl0(:,grp));
        meanasl = nanmean(asl0(:,grp));
        [~,psl_asym] = ttest(asl0(:,grp));
        % calculate stderr
        stderrsl = nanstd(sl0(:,grp))./sqrt(subji);
        stderrasl = nanstd(asl0(:,grp))./sqrt(subji);
        % display
        disp(['Baseline step length: ' grp_list{grp} ' blk: ' num2str(blk) ': ' num2str(meansl) ...
            ' +/- ' num2str(stderrsl) ' mm'])
%         disp(['Baseline step length asymmetry: ' grp_list{grp} ' blk: '...
%             num2str(blk) ': ' num2str(meanasl) ...
%             ' +/- ' num2str(stderrasl) ' mm'])
        disp(['baseline asymmetry for ' grp_list{grp} ' blk: ' num2str(blk)...
            ' zero mean ttest: p = ' num2str(psl_asym)])
    end
    psl_base = anova1(sl0);
    disp(['ANOVA steplength between groups: ' num2str(psl_base)]);
end
    
%% plot unilateral step length

figure(101); hold on;
plotFastSlowCompareCurves(blkinclude,'steplength (/ baseline slow)',...
    fastlength,slowlength);
figure(1010); hold on;
plotFastSlowCompareCurves(4,'steplength',...
    fastlength,slowlength); % normed to baseline slow step length (division)
figure(110);
plotFastSlowCompareCurves(6,'steplength',...
    fastlength,slowlength); % normed to baseline slow step length (division)
end % if 0

if 1
%% unilateral step time
[fasttime.hfirst,fasttime.lfirst,fasttime.hsecond,fasttime.lsecond,fasttime.control] = ...
    sortbyEffortVisitorder(fast_all.steptime);
[slowtime.hfirst,slowtime.lfirst,slowtime.hsecond,slowtime.lsecond,slowtime.control] = ...
    sortbyEffortVisitorder(slow_all.steptime);

%% baseline step times
figure(99); hold on; title('Baseline steptimes')
plotFastSlowCompareCurves([2:3],'step time in baseline',fasttime,slowtime);
% step lengths
grp_list = {'hfirst' 'lfirst' 'control' 'hsecond' 'lsecond'};
clear sl s1
for blk = 2:3
    for grp = 1:3
        for subji = 1:size(eval(['fasttime.' grp_list{grp} '{1,' num2str(blk) '}']))
            % calculate mean
            sl1 = eval(['fasttime.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
            sl2 = eval(['slowtime.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
            s = cat(1,sl1,sl2);
            as = (sl1 - sl2)./(sl1 + sl2);
            sl0(subji,grp) = mean(s(end-30:end));
            asl0(subji,grp) = mean(as(end-30:end));
        end
        % last 30 strides
        meansl = nanmean(sl0(:,grp));
        meanasl = nanmean(asl0(:,grp));
        [~,psl_asym] = ttest(asl0(:,grp));
        % calculate stderr
        stderrsl = nanstd(sl0(:,grp))./sqrt(subji);
        stderrasl = nanstd(asl0(:,grp))./sqrt(subji);
        % display
        disp(['Baseline step time: ' grp_list{grp} ' blk: ' num2str(blk) ': ' num2str(meansl) ...
            ' +/- ' num2str(stderrsl) ' s'])
%         disp(['Baseline step length asymmetry: ' grp_list{grp} ' blk: '...
%             num2str(blk) ': ' num2str(meanasl) ...
%             ' +/- ' num2str(stderrasl) ' mm'])
        disp(['baseline step time asymmetry for ' grp_list{grp} ' blk: ' num2str(blk)...
            ' zero mean ttest: p = ' num2str(psl_asym)])
    end
    pst_base = anova1(sl0);
    s1(:,:,blk-1) = sl0;
    disp(['ANOVA comparing steptime across effort groups in block ' ...
        num2str(blk) ': p = ' num2str(pst_base)]);
    % compare between blocks
    [~, ph] = ttest(sl0(:,1),sl0(:,2));
    [~, pl] = ttest(sl0(:,1),sl0(:,3));
    [~, pc] = ttest(sl0(:,2),sl0(:,3));
    disp(['between different groups HL p = ' num2str(ph) ' HC p = ' ...
        num2str(pl) ' LC p = ' num2str(pc)])
    disp([' '])
end
% compare between baseline blocks
for grp = 1:3
    [~,pbc] = ttest(s1(:,grp,1),s1(:,grp,2));
    disp(['Compare step times within ' grp_list{grp}...
        ' during baseline: p = ' num2str(pbc)])
end
%% plot unilateral step time
figure(102); hold on;
plotFastSlowCompareCurves(blkinclude,'steptime (norm to baseline slow)',...
    fasttime,slowtime);
figure(1020); hold on;
plotFastSlowCompareCurves(4,'steptime (norm to baseline slow)',...
    fasttime,slowtime);
% plot curves for individuals sorted by group
figure(1021); hold on; blki = 4;
% plot(fasttime.hfirst{1,blki}','Color',colors.high,'HandleVisibility','off');
% plot(fasttime.lfirst{1,blki}','Color',colors.low,'HandleVisibility','off');
plot(fasttime.control{1,blki}');
legend(subject.controllist)
title('fast leg step times, individuals in first exposure')
end % if 0

if 0
%% unilateral step width
[fastwidth.hfirst,fastwidth.lfirst,fastwidth.hsecond,fastwidth.lsecond,fastwidth.control] = ...
    sortbyEffortVisitorder(fast_all.stepwidth);
[slowwidth.hfirst,slowwidth.lfirst,slowwidth.hsecond,slowwidth.lsecond,slowwidth.control] = ...
    sortbyEffortVisitorder(slow_all.stepwidth);

%% plot unilateral step width
figure(800); hold on;
plotFastSlowCompareCurves(2:7,'step width ',...
    fastwidth,slowwidth); % baseline slow norm step width',
figure(802); hold on;
plotFastSlowCompareCurves(4,'step width',...
    fastwidth,slowwidth);
% plot curves for individuals sorted by group
figure(803); hold on; blki = 4;
subplot(211); hold on;
plot(fastwidth.hfirst{1,blki}','Color',colors.high,'HandleVisibility','off');
plot(fastwidth.lfirst{1,blki}','Color',colors.low,'HandleVisibility','off');
plot(fastwidth.control{1,blki}','Color',colors.control,'HandleVisibility','off');
subplot(212); hold on;
plot(slowwidth.hfirst{1,blki}','Color',colors.high,'LineStyle','-.','HandleVisibility','off');
plot(slowwidth.lfirst{1,blki}','Color',colors.low,'LineStyle','-.','HandleVisibility','off');
plot(slowwidth.control{1,blki}','Color',colors.control,'LineStyle','-.','HandleVisibility','off');
legend(subject.controllist)
sgtitle('fast leg step width, individuals in first exposure')
%% compare unilateral step widths
% baseline steplength
clear sw swvar
figure(86); hold on; title('Baseline stepwidth')
plotFastSlowCompareCurves([2:3],'stepwidth in baseline',fastwidth,slowwidth);
% step lengths
grp_list = {'hfirst' 'lfirst' 'control' 'hsecond' 'lsecond'};
for blk = 2:4
    disp(' '); disp(['BLOCK ' num2str(blk)]);
    clear s sl0 asl0 swvar0
    for grp = 1:3
        for subji = 1:size(eval(['fastwidth.' grp_list{grp} '{1,' num2str(blk) '}']))
            % calculate mean
            sl1 = eval(['fastwidth.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
            sl2 = eval(['slowwidth.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
            
            % interleave steps LRLR
            s = [sl1;sl2];
            s = s(:)';
            
            as = (sl1 - sl2)./(sl1 + sl2);
            sl0(subji,grp) = mean(s(end-30:end));
            asl0(subji,grp) = mean(as(end-30:end));
            swvar0(subji,grp) = var(s(end-30:end));
        end
        % last 30 strides
        meansw = mean(sl0(:,grp),'omitnan');
        meanasl = mean(asl0(:,grp));
        meansvar = mean(swvar0(:,grp),'omitnan');
        
        [~,psl_asym] = ttest(asl0(:,grp));
        % calculate stderr
        stderrsw = std(sl0(:,grp),[],'omitnan')./sqrt(subji);
        stderrasl = std(asl0(:,grp))./sqrt(subji);
        stderrsvar = std(swvar0(:,grp),[],'omitnan')./sqrt(subji);
        
        % display
        disp(['Step width: ' grp_list{grp} ' blk: ' num2str(blk) ': ' num2str(meansw) ...
            ' +/- ' num2str(stderrsw) ' mm'])
        disp(['Variability: ' num2str(meansvar) ' +/- ' num2str(stderrsvar)]);
        if blk == 3
            nsw = meansw;
        elseif blk == 4
            disp([num2str(meansw/nsw) ' percent of slow baseline step width'])
        end
    end
    % compare between groups
    psl_base = anova1(sl0);
    disp(['ANOVA between groups: p = ' num2str(psl_base)]);
    % compare low - high
    [~,phl] = ttest2(sl0(1,:),sl0(2,:));
    % compare control - high
    [~,phc] = ttest2(sl0(1,:),sl0(3,:));
    % compare control - low
    [~,pcl] = ttest2(sl0(3,:),sl0(2,:));
    disp(['pairwise: HL p = ' num2str(phl) '; HC p = ' num2str(phc)...
        '; CL p = ' num2str(pcl)]);
    sw(:,:,blk) = sl0;
    
    pvar = anova1(swvar0);
    disp(['ANOVA variability: ' num2str(pvar)]);
    % compare low - high
    [~,phl] = ttest2(swvar0(1,:),swvar0(2,:));
    % compare control - high
    [~,phc] = ttest2(swvar0(1,:),swvar0(3,:));
    % compare control - low
    [~,pcl] = ttest2(swvar0(3,:),swvar0(2,:));
    disp(['pairwise: HL p = ' num2str(phl) '; HC p = ' num2str(phc)...
        '; CL p = ' num2str(pcl)]);
    swvar(:,:,blk) = swvar0;
end
disp([' '])
% compare between blocks
[~, ph] = ttest(sw(:,1,2),sw(:,1,3));
[~, pl] = ttest(sw(:,2,2),sw(:,2,3));
[~, pc] = ttest(sw(:,3,2),sw(:,3,3));
disp(['between fast and slow baseline H p = ' num2str(ph) ' L p = ' ...
    num2str(pl) ' C p = ' num2str(pc)])
% compare between blocks
[~, ph] = ttest(sw(:,1,4),sw(:,1,3));
[~, pl] = ttest(sw(:,2,4),sw(:,2,3));
[~, pc] = ttest(sw(:,3,4),sw(:,3,3));
disp(['between learning and slow baseline H p = ' num2str(ph) ' L p = ' ...
    num2str(pl) ' C p = ' num2str(pc)])
disp([' '])
% compare between blocks
[~, ph] = ttest(swvar(:,1,2),swvar(:,1,3));
[~, pl] = ttest(swvar(:,2,2),swvar(:,2,3));
[~, pc] = ttest(swvar(:,3,2),swvar(:,3,3));
disp(['VARIABILITY between fast and slow baseline H p = ' num2str(ph) ' L p = ' ...
    num2str(pl) ' C p = ' num2str(pc)])
% compare between blocks
[~, ph] = ttest(swvar(:,1,4),swvar(:,1,3));
[~, pl] = ttest(swvar(:,2,4),swvar(:,2,3));
[~, pc] = ttest(swvar(:,3,4),swvar(:,3,3));
disp(['VARIABILITY between learning and slow baseline H p = ' num2str(ph) ' L p = ' ...
    num2str(pl) ' C p = ' num2str(pc)])
[~, ph] = ttest(swvar(:,1,4),swvar(:,1,2));
%% compare step widths between legs for all groups DURING LEARNING
blk = 4; clear sw
for grp = 1:3
    for subji = 1:size(eval(['fastwidth.' grp_list{grp} '{1,' num2str(blk) '}']))
        % calculate mean
        sl1 = eval(['fastwidth.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
        sl2 = eval(['slowwidth.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
        sw(subji,:) = [sl1(end-30:end),sl2(end-30:end)];
    end
    [~, pleg] = ttest(sw(:,1),sw(:,2));
    disp([grp_list{grp} ' between fast and slow legs p = ' num2str(pleg)])
end
%% compare step widths between early and late learning
blk = 4; clear sw swvar
for grp = 1:3
    for subji = 1:size(eval(['fastwidth.' grp_list{grp} '{1,' num2str(blk) '}']))
        % calculate mean
        sl1 = eval(['fastwidth.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
        sl2 = eval(['slowwidth.' grp_list{grp} '{1,' num2str(blk) '}(' num2str(subji) ',:)']);
        swinit = mean([sl1(1:5),sl2(1:5)],'omitnan');
        swvarinit = var([sl1(1:30) ,sl2(1:30)],[],'omitnan');
        swend = mean([sl1(end-30:end),sl2(end-30:end)],'omitnan');
        swvarend = var([sl1(end-30:end),sl2(end-30:end)],[],'omitnan');
        sw(subji,:) = [swinit,swend];
        swvar(subji,:) = [swvarinit,swvarend];
    end
    [~, pearlylate] = ttest(sw(:,1),sw(:,2));
    disp([grp_list{grp} ' between initial and late learning p = ' num2str(pearlylate)])
    [~,pearlyvar] = ttest(swvar(:,1),swvar(:,2));
    disp([grp_list{grp} ' sw variability between initial and late learning p = ' num2str(pearlyvar)])

end      
end % if stepwidth