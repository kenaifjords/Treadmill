% TM2_05_steplength_steptime_unilateral
global F p subject
normtoslowbaseline = 1;
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
        end
    end  
end

%% unilateral step length
[fastlength.hfirst,fastlength.lfirst,fastlength.hsecond,fastlength.lsecond,fastlength.control] = ...
    sortbyEffortVisitorder(fast_all.steplength);
[slowlength.hfirst,slowlength.lfirst,slowlength.hsecond,slowlength.lsecond,slowlength.control] = ...
    sortbyEffortVisitorder(slow_all.steplength);

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

%% unilateral step time
[fasttime.hfirst,fasttime.lfirst,fasttime.hsecond,fasttime.lsecond,fasttime.control] = ...
    sortbyEffortVisitorder(fast_all.steptime);
[slowtime.hfirst,slowtime.lfirst,slowtime.hsecond,slowtime.lsecond,slowtime.control] = ...
    sortbyEffortVisitorder(slow_all.steptime);

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