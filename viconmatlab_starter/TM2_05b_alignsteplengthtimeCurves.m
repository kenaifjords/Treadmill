% TM2_05b_alignstepslowtimeCurves
global asym F p colors subject asym_all
normtobase = 1; normtoheight = 0;
normblk = 3; % 3 for slow baseline; 2 for fast baseline
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
            if blk > size(F(subj).R,2)
                break
            end
            asymsl = asym(subj).steplength{effcond,blk};
            asymlength(subj,effcond,blk) = length(asymsl);
            asymst = asym(subj).steptime{effcond,blk};
            asymlengthtime(subj,effcond,blk) = length(asymst);
        end
    end
end
asymlength(asymlength == 0) = NaN;
asymlengthtime(asymlengthtime == 0) = NaN;
trimsl = min(asymlength(:,:,blk),[],'all'); 
trimst = min(asymlengthtime(:,:,blk),[],'all');
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
            if blk > size(F(subj).R,2)
                break
            end
            trimsl = min(asymlength(:,:,blk),[],'all'); 
            trimst = min(asymlength(:,:,blk),[],'all');
            asymsl = asym(subj).steplength{effcond,blk};
            asymst = asym(subj).steptime{effcond,blk};
            
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
        end
    end
end
%% sort into effort condition and visit order
[slength.hfirst,slength.lfirst,slength.hsecond,slength.lsecond,slength.control] = ...
    sortbyEffortVisitorder(asym_all.steplength);
[stime.hfirst,stime.lfirst,stime.hsecond,stime.lsecond,stime.control] = ...
    sortbyEffortVisitorder(asym_all.steptime);
%% plot
blkinclude = 4:6;

figure(555);
plotAsymmetryCurves(blkinclude,'step length symmetry',slength);
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
ylim([-0.6 0.0])
plot_with_stderr(0,slength.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lfirst{blk},colors.all{2,1})
plot_with_stderr(0,slength.control{blk},colors.all{3,1})
% xlim([0 200])

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
%% plot each block (4,5,6) for the second visit
figure(695); hold on; blk = 4;
ylabel('asymmetry'); xlabel('strides'); title('Learning (2nd visit)')
ylim([-0.4 0.1])
plot_with_stderr(0,slength.hsecond{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lsecond{blk},colors.all{2,1})
% xlim([0 200])

figure(696); hold on; blk = 5;
ylabel('asymmetry'); xlabel('strides'); title('Washout (2nd visit)')
ylim([-0.1 0.40])
plot_with_stderr(0,slength.hsecond{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lsecond{blk},colors.all{2,1})
% xlim([0 200])

figure(697); hold on; blk = 6;
ylabel('asymmetry'); xlabel('strides'); title('Relearning (2nd visit)')
ylim([-0.4 0.1])
plot_with_stderr(0,slength.hsecond{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lsecond{blk},colors.all{2,1})
% xlim([0 200])
%% plot individuals
blk = 4;
figure(); subplot(3,2,1); hold on; ylim([-0.5 0.5]);
plot(slength.hfirst{blk}','Color',colors.high)
subplot(323); hold on; ylim([-0.5 0.5]);
plot(slength.lfirst{blk}','Color',colors.low)
subplot(325); hold on; ylim([-0.5 0.5]);
plot(slength.control{blk}','Color',colors.control)
% together
subplot(122); hold on;
plot(slength.hfirst{blk}','Color',colors.high)
plot(slength.lfirst{blk}','Color',colors.low)
plot(slength.control{blk}','Color',colors.control)
%%
figure(); 
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
figure(2024); hold on; blk = 6;
ylabel('asymmetry'); xlabel('strides'); title('Learning (1st visit)')
% ylim([-0.6 0.0])
plot_with_stderr(0,slength.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lfirst{blk},colors.all{2,1})
plot_with_stderr(0,slength.control{blk},colors.all{3,1})
% xlim([0 200])
blk = 4;
plot_with_stderr_linetype(0,slength.hfirst{blk},colors.all{1,1},':') %% these need to be trimmed to shortest ###
plot_with_stderr_linetype(0,slength.lfirst{blk},colors.all{2,1},':')
plot_with_stderr_linetype(0,slength.control{blk},colors.all{3,1},':')
