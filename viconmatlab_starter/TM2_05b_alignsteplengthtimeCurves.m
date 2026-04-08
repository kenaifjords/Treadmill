% TM2_05b_alignstepslowtimeCurves
global asym F p colors subject
normtobase = 1; normtoheight = 0;
normblk = 3; % 3 for slow baseline; 2 for fast baseline
plotsubj = 0; transp = 0.3;
grplist = {'hfirst' 'lfirst' 'control' 'hsecond' 'lsecond'};
clear asym_all
%% Prepare Data
for subj = 1:subject.n
    if subject.order(subj,1) == 0
        effuse = 3;
    else
        if size(F(subj).R,1) < 2
            effuse = 1;
        else
            effuse = 1:2;
        end
    end
    for effcond = effuse
        for blk = 1:subject.nblk
            if blk <= size(F(subj).R,2)
                asymsl = asym(subj).steplength{effcond,blk};
                asymst = asym(subj).steptime{effcond,blk};
                if ~isempty(asymsl)
                    asymlength(subj,effcond,blk) = length(asymsl);
                end
                if ~isnan(asymst)
                    asymlengthtime(subj,effcond,blk) = length(asymst);
                end
    %             asymsw = asym(subj).stepwidth{effcond,blk};
    %             asymlengthwidth(subj,effcond,blk) = length(asymsw);
            end
        end
    end
end
asymlength(asymlength == 0) = NaN;
asymlengthtime(asymlengthtime == 0) = NaN;
% asymlengthwidth(asymlengthwidth < 5) = NaN;

% build asymmetry matrix
for subj = 1:subject.n
    if subject.order(subj,1) == 0
        effuse = 3;
    else
        if size(F(subj).R,1) < 2
            effuse = 1;
        else
            effuse = 1:2;
        end
    end
    for effcond = effuse
        for blk = 1:subject.nblk
            if blk <= size(F(subj).R,2)
                trimsl = min(asymlength(:,:,blk),[],'all'); 
                trimst = min(asymlength(:,:,blk),[],'all');
                asymsl = asym(subj).steplength{effcond,blk};
                asymst = asym(subj).steptime{effcond,blk};
    %             asymsw = asym(subj).stepwidth{effcond,blk};

                if ~isempty(asymsl)
                    asym_all.steplength{effcond,blk}(subj,:) = asymsl(1:trimsl);
                else
                    asym_all.steplength{effcond,blk}(subj,:) = NaN;
                end
                if ~isempty(asymst)
                    asym_all.steptime{effcond,blk}(subj,:) = asymst(1:trimst);
                else
                    asym_all.steptime{effcond,blk}(subj,:) = NaN;
                end
    %             if ~isempty(asymsw)
    %                 asym_all.stepwidth{effcond,blk}(subj,:) = asymsw(1:trimsw);
    %             else
    %                 asym_all.stepwidth{effcond,blk}(subj,:) = NaN;
    %             end
            end
        end
    end
end
%% sort into effort condition and visit order
[slength.hfirst,slength.lfirst,slength.hsecond,slength.lsecond,slength.control] = ...
    sortbyEffortVisitorder(asym_all.steplength);
[stime.hfirst,stime.lfirst,stime.hsecond,stime.lsecond,stime.control] = ...
    sortbyEffortVisitorder(asym_all.steptime);
% [swidth.hfirst,swidth.lfirst,swidth.hsecond,swidth.lsecond,swidth.control] = ...
%     sortbyEffortVisitorder(asym_all.stepwidth);
%% plot
blkinclude = 4:6;

figure(555);
plotAsymmetryCurves(blkinclude,'step length symmetry',slength);
% add start plateau data
if exist('firstplat','var')
    for blk = 4:6
        for i = 1:5
            subplot(1,3,blk-3)
            k = mod(i,3);
            if k ==0
                k = 3;
            end
            fp = eval(['firstplat.' grplist{i} '{1,' num2str(blk) '}']);
    %         plot(fp,-0.2-i/20*ones(length(fp),1),'.','Color',colors.all{i,1},'MarkerSize',5);
            if blk == 4 || blk == 6
                plot(mean(fp,'omitnan'),0.1+i/20,'s','Color',colors.all{k,1},'MarkerSize',10,'HandleVisibility','off');
                m = mean(fp,'omitnan');
                range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
                plot(range, +0.1+i/20*ones(2,1),'Color',colors.all{k,1},'HandleVisibility','off');
            else
                plot(mean(fp,'omitnan'),-0.1-i/20,'s','Color',colors.all{k,1},'MarkerSize',10,'HandleVisibility','off');
                m = mean(fp,'omitnan');
                range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
                plot(range, -0.1-i/20*ones(2,1),'Color',colors.all{k,1},'HandleVisibility','off');
            end
        end
    end
end

% figure(655);
% plotAsymmetryCurves(blkinclude,'step length symmetry',slength);
% for sp = 1:3
%     subplot(3,1,sp); xlim([0 50]);
% end
%% Plot each block (4,5,6) for the first visit
figure(556);
plotAsymmetryCurves_time(blkinclude,'step time symmetry',stime);
%%
figure(665); hold on; blk = 4;
ylabel('asymmetry'); xlabel('strides'); title('Learning (1st visit)')
ylim([-1 0.5])
if plotsubj
    plot(slength.hfirst{blk}','Color',[colors.high transp])
    plot(slength.lfirst{blk}','Color',[colors.low transp])
    plot(slength.control{blk}','Color',[colors.control transp])
end
plot_with_stderr(0,slength.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lfirst{blk},colors.all{2,1})
plot_with_stderr(0,slength.control{blk},colors.all{3,1})
% xlim([0 200])
beautifyfig

if exist('firstplat','var')
    for i = 1:3
        fp = eval(['firstplat.' grplist{i} '{1,4}']);
%         plot(fp,-0.2-i/20*ones(length(fp),1),'.','Color',colors.all{i,1},'MarkerSize',5);
        plot(mean(fp,'omitnan'),-0.1-i/20,'s','Color',colors.all{i,1},'MarkerSize',10);
        m = mean(fp,'omitnan');
        range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
        plot(range, -0.1-i/20*ones(2,1),'Color',colors.all{i,1});
    end
end
%%
figure(667); hold on; blk = 5;
ylabel('asymmetry'); xlabel('strides'); title('Washout (1st visit)')
ylim([0.0 0.60])
plot_with_stderr(0,slength.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lfirst{blk},colors.all{2,1})
plot_with_stderr(0,slength.control{blk},colors.all{3,1})
% xlim([0 200])

figure(6697); hold on; blk = 6;
ylabel('asymmetry'); xlabel('strides'); title('Relearning (1st visit)')
% ylim([0.0 0.60])
plot_with_stderr(0,slength.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lfirst{blk},colors.all{2,1})
plot_with_stderr(0,slength.control{blk},colors.all{3,1})
% xlim([0 200])
if exist('firstplat','var')
    for i = 1:3
        fp = eval(['firstplat.' grplist{i} '{1,6}']);
%         plot(fp,-0.2-i/20*ones(length(fp),1),'.','Color',colors.all{i,1},'MarkerSize',5);
        plot(mean(fp,'omitnan'),-0.1-i/20,'s','Color',colors.all{i,1},'MarkerSize',10);
        m = mean(fp,'omitnan');
        range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
        plot(range, -0.1-i/20*ones(2,1),'Color',colors.all{i,1});
    end
end
% %% plot each block (4,5,6) for the second visit
% figure(695); hold on; blk = 4;
% ylabel('asymmetry'); xlabel('strides'); title('Learning (2nd visit)')
% ylim([-0.4 0.1])
% plot_with_stderr(0,slength.hsecond{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
% plot_with_stderr(0,slength.lsecond{blk},colors.all{2,1})
% 
% 
%                 
% %%
% % xlim([0 200])
% 
% figure(696); hold on; blk = 5;
% ylabel('asymmetry'); xlabel('strides'); title('Washout (2nd visit)')
% ylim([-0.1 0.40])
% plot_with_stderr(0,slength.hsecond{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
% plot_with_stderr(0,slength.lsecond{blk},colors.all{2,1})
% % xlim([0 200])
% 
% figure(697); hold on; blk = 6;
% ylabel('asymmetry'); xlabel('strides'); title('Relearning (2nd visit)')
% ylim([-0.4 0.1])
% plot_with_stderr(0,slength.hsecond{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
% plot_with_stderr(0,slength.lsecond{blk},colors.all{2,1})
% % xlim([0 200])
% if exist('firstplat','var')
%     for i = 1:2
%         fp = eval(['firstplat.' grplist{i+3} '{1,6}']);
% %         plot(fp,-0.2-i/20*ones(length(fp),1),'.','Color',colors.all{i,1},'MarkerSize',5);
%         plot(mean(fp,'omitnan'),-0.1-i/20,'s','Color',colors.all{i,1},'MarkerSize',10);
%         m = mean(fp,'omitnan');
%         range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
%         plot(range, -0.1-i/20*ones(2,1),'Color',colors.all{i,1});
%     end
% end
%% plot individuals
blk = 4;
figure(33);
subplot(231); hold on; ylim([-1 0.5]);
plot(slength.hfirst{blk}','Color',[colors.high transp*2])
plot_with_stderr(0,slength.hfirst{blk},[0 0 0])
subplot(232); hold on; ylim([-1 0.5]);
plot(slength.lfirst{blk}','Color',[colors.low transp*2])
plot_with_stderr(0,slength.lfirst{blk},[0 0 0])
subplot(233); hold on; ylim([-1 0.5]);
plot(slength.control{blk}','Color',[colors.control transp*2])
plot_with_stderr(0,slength.control{blk},[0 0 0])
% together
subplot(212); hold on;
plot(slength.hfirst{blk}','Color',colors.high)
plot(slength.lfirst{blk}','Color',colors.low)
plot(slength.control{blk}','Color',colors.control)
beautifyfig

blk = 4;
figure(37);
subplot(311); hold on; ylim([-1 0.5]);
plot(slength.hfirst{blk}','Color',[colors.high transp*2])
plot_with_stderr(0,slength.hfirst{blk},[0 0 0])
subplot(312); hold on; ylim([-1 0.5]);
plot(slength.lfirst{blk}','Color',[colors.low transp*2])
plot_with_stderr(0,slength.lfirst{blk},[0 0 0])
subplot(313); hold on; ylim([-1 0.5]);
plot(slength.control{blk}','Color',[colors.control transp*2])
plot_with_stderr(0,slength.control{blk},[0 0 0])

beautifyfig
%%
figure(77); 
subplot(311); title('high first'); hold on;
plot(slength.hfirst{blk}');
legend(subject.sorted.hfirst)
ylim([-1 0.4])
% figure();
subplot(312); title('low first'); hold on;
plot(slength.lfirst{blk}')
legend(subject.sorted.lfirst);
ylim([-1 0.4])
% figure();
subplot(313); title('control'); hold on;
plot(slength.control{blk}')
legend(subject.sorted.control);
ylim([-1 0.4])
%%
thesla46plot
thewashoutplot
thesecondvisitplot
%% THE SLA PLOT
% figure(2024); hold on; blk = 6;
% ylabel('asymmetry'); xlabel('strides'); title('Learning (1st visit)')
% % ylim([-0.6 0.0])
% plot_with_stderr(0,slength.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
% plot_with_stderr(0,slength.lfirst{blk},colors.all{2,1})
% plot_with_stderr(0,slength.control{blk},colors.all{3,1})
% % xlim([0 200])
% blk = 4;
% plot_with_stderr_linetype(0,slength.hfirst{blk},colors.all{1,1},':') %% these need to be trimmed to shortest ###
% plot_with_stderr_linetype(0,slength.lfirst{blk},colors.all{2,1},':')
% plot_with_stderr_linetype(0,slength.control{blk},colors.all{3,1},':')
% 
% j = 1; markerlist = {'s','d'};
% for blk = [4 6]
%     if exist('firstplat','var')
%         for i = 1:3
%             fp = eval(['firstplat.' grplist{i} '{1,' num2str(blk) '}']);
%     %         plot(fp,-0.2-i/20*ones(length(fp),1),'.','Color',colors.all{i,1},'MarkerSize',5);
%             plot(mean(fp,'omitnan'),-0.3-i/20,markerlist{j},'Color',colors.all{i,1},'MarkerSize',10);
%             m = mean(fp,'omitnan');
%             range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
%             plot(range, -0.3-i/20*ones(2,1),'Color',colors.all{i,1}); 
%         end
%     end
%     j = j + 1;
% end
% 
% plot([0 400],[0 0],'k:')
% 
% ylim([-0.6 0.1])
% beautifyfig
% x0 = 10;
% y0 = 50;
% width = 1200;
% height = 500;
% set(gcf,'position',[x0,y0,width,height])
%% THE WASHOUT PLOT
% figure(2025); hold on; blk = 6;
% ylabel('asymmetry'); xlabel('strides'); title('Learning (1st visit)')
% % ylim([-0.6 0.0])
% plot_with_stderr(0,slength.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
% plot_with_stderr(0,slength.lfirst{blk},colors.all{2,1})
% plot_with_stderr(0,slength.control{blk},colors.all{3,1})
% % xlim([0 200])
% blk = 4;
% plot_with_stderr_linetype(0,slength.hfirst{blk},colors.all{1,1},':') %% these need to be trimmed to shortest ###
% plot_with_stderr_linetype(0,slength.lfirst{blk},colors.all{2,1},':')
% plot_with_stderr_linetype(0,slength.control{blk},colors.all{3,1},':')
% 
% j = 1; markerlist = {'s','d'};
% for blk = [4 6]
%     if exist('firstplat','var')
%         for i = 1:3
%             fp = eval(['firstplat.' grplist{i} '{1,' num2str(blk) '}']);
%     %         plot(fp,-0.2-i/20*ones(length(fp),1),'.','Color',colors.all{i,1},'MarkerSize',5);
%             plot(mean(fp,'omitnan'),-0.3-i/20,markerlist{j},'Color',colors.all{i,1},'MarkerSize',10);
%             m = mean(fp,'omitnan');
%             range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
%             plot(range, -0.3-i/20*ones(2,1),'Color',colors.all{i,1}); 
%         end
%     end
%     j = j + 1;
% end
% 
% plot([0 400],[0 0],'k:')
% 
% ylim([-0.6 0.1])
% beautifyfig
% x0 = 10;
% y0 = 50;
% width = 1200;
% height = 500;
% set(gcf,'position',[x0,y0,width,height])