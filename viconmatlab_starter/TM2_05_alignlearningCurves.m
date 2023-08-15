
% align asymmetry by steps and average across subjects to get curves
% first sort by all four groups, then combine fastleg different groups (so
% that we are comparing low first to high first
split1blk = 4;
wash1blk = 5;
split2blk = 6;
clear learncurves1_cell learncurves2_cell split1_curves split2_curves wash1_curves split3_curves split4_curves wash3_curves
ninitialstep = 100;
includedsubj = subject.n;
% create binary vector to identify group high first or low first
firsteff = subject.order(1:includedsubj,1); %nonzeros(subject.order(1:includedsubj,1));
firsteff(firsteff == 0) = 3;
secondeff = subject.order(1:includedsubj,2); %nonzeros(subject.order(1:includedsubj,2));
secondeff(secondeff == 0) = NaN;
% create cell structure for each block (including all subjects)
ctrlcount = 1; effcount = 1;
for subj = 1:includedsubj
    for blk = 1:subject.nblk
        if subject.order(subj,1) ~= 0 % 1 and 2 here refer to order of visits
            learncurves1_cell{effcount,blk} = asym(subj).steplength{firsteff(subj),blk};
            learncurves2_cell{effcount,blk} = asym(subj).steplength{secondeff(subj),blk};
            learnlength1_0(effcount,blk) = length(asym(subj).steplength{firsteff(subj),blk});
            learnlength2_0(effcount,blk) = length(asym(subj).steplength{secondeff(subj),blk});
        else % control        
            learncurvesC_cell{ctrlcount,blk} = asym(subj).steplength{3,blk};
            learnlengthC_0(ctrlcount,blk) = length(asym(subj).steplength{3,blk});
        end
    end
    if subject.order(subj,1) ~= 0
        effcount = effcount + 1;
    else
        ctrlcount = ctrlcount + 1;
    end
end
ctrlcount = ctrlcount - 1;
effcount = effcount -1;

% first visit
[split1_curves,~] = alignProfiles2(learncurves1_cell(:,split1blk),ones(effcount,1));
[wash1_curves,~] = alignProfiles2(learncurves1_cell(:,wash1blk),ones(effcount,1));
[split2_curves,~] = alignProfiles2(learncurves1_cell(:,split2blk),ones(effcount,1));
% first and only visit control
[split1ctrl_curves,~] = alignProfiles2(learncurvesC_cell(:,split1blk),ones(ctrlcount,1));
[washctrl_curves,~] = alignProfiles2(learncurvesC_cell(:,wash1blk),ones(ctrlcount,1));
[split2ctrl_curves,~] = alignProfiles2(learncurvesC_cell(:,split2blk),ones(ctrlcount,1));
% second visit
[split3_curves,~] = alignProfiles2(learncurves2_cell(:,split1blk),ones(effcount,1));
[wash3_curves,~] = alignProfiles2(learncurves2_cell(:,wash1blk),ones(effcount,1));
[split4_curves,~] = alignProfiles2(learncurves2_cell(:,split2blk),ones(effcount,1));

% trim off the pad NaNs added by the align function
split1_curves = split1_curves(:,2:end-1);
wash1_curves = wash1_curves(:,2:end-1);
split2_curves = split2_curves(:,2:end-1);
split1ctrl_curves = split1ctrl_curves(:,2:end-1);
washctrl_curves = washctrl_curves(:,2:end-1);
split2ctrl_curves = split2ctrl_curves(:,2:end-1);

split3_curves = split3_curves(:,2:end-1);
wash3_curves = wash3_curves(:,2:end-1);
split3_curves = split3_curves(:,2:end-1);

% find the shortest profile from each block
learnlength1_0(learnlength1_0 == 0) = NaN;
learnlength2_0(learnlength2_0 == 0) = NaN;
learnlengthC_0(learnlengthC_0 == 0) = NaN;
learnlength1 = min(learnlength1_0,[],1);
learnlength2 = min(learnlength2_0,[],1);
learnlength3 = min(learnlengthC_0,[],1);

% multiply matrix of learning curves by binary vector and remove zeros to 
% generate matrices for each group
% sort by groups (high first and low first - ignoring fast leg for now)
highfirst = double(firsteff == 1); highfirst(highfirst == 0) = NaN;
lowfirst = double(firsteff == 2); lowfirst(lowfirst == 0) = NaN;
controlfirst = double(firsteff == 3); controlfirst(controlfirst == 0) = NaN;

% learning (visit 1 (exposure 1) and visit 2 (exposure 3))
highsplit1 = split1_curves.*highfirst;
lowsplit1 = split1_curves.*lowfirst;
highsplit3 = split3_curves.*lowfirst; 
lowsplit3 = split3_curves.*highfirst; % split 3 refers to the third exposure
% during the second visit to the lab, as such it is in the second
% collection, lowfirst implies highsecond

% washout
highwash1 = wash1_curves.*highfirst;
lowwash1 = wash1_curves.*lowfirst;
highwash3 = wash3_curves.*lowfirst; % see above
lowwash3 = wash3_curves.*highfirst;

% relearning (visit 1 (exposure 2) and visit 2 (exposure 4))
highsplit2 = split2_curves.*highfirst;
lowsplit2 = split2_curves.*lowfirst;
highsplit4 = split4_curves.*lowfirst; % see above
lowsplit4 = split4_curves.*highfirst;

%% plots for visit one
figure(11); hold on;
title('Adaptation 1 (first visit, first split)')
plot([0 size(split1_curves,2)],[0 0],'k:','HandleVisibility','off');
plot_with_stderr(0,split1ctrl_curves,colors.control)
plot_with_stderr(0,highsplit1,colors.high)
plot_with_stderr(0,lowsplit1,colors.low)
xlabel('strides count')
ylabel('steplength asymmetry')
ylim([-1 1])
xlim([0 learnlength1(split1blk)])
% plot with standard deviation and all individual learning curves
% plot each block on a separate plot and plot high and low first groups
% on the same plot for each block

figure(1); 
subplot(131); hold on; title('Adaptation 1 (first visit, first split)')
plot([0 size(split1_curves,2)],[0 0],'k:','HandleVisibility','off');
plot_with_stderr(0,split1ctrl_curves,colors.control)
plot_with_stderr(0,highsplit1,colors.high)
plot_with_stderr(0,lowsplit1,colors.low)
xlabel('strides count')
ylabel('steplength asymmetry')
ylim([-1 1])
xlim([0 learnlength1(split1blk)])   

% figure(2); 
subplot(132); hold on; title('Washout 1 (first visit,  after first split)')
plot([0 size(split1_curves,2)],[0 0],'k:','HandleVisibility','off');
plot_with_stderr(0,washctrl_curves,colors.control)
plot_with_stderr(0,highwash1,colors.high)
plot_with_stderr(0,lowwash1,colors.low)
xlabel('strides count')
ylabel('steplength asymmetry')    
ylim([-1 1])
xlim([0 learnlength1(wash1blk)])   

% figure(3); 
subplot(133); hold on; title('Adaptation 2 (first visit, second split)')
plot([0 size(split1_curves,2)],[0 0],'k:','HandleVisibility','off');
plot_with_stderr(0,split2ctrl_curves,colors.control)
plot_with_stderr(0,highsplit2,colors.high)
plot_with_stderr(0,lowsplit2,colors.low)
xlabel('strides count')
ylabel('steplength asymmetry')
ylim([-1 1])
xlim([0 learnlength1(split2blk)])   

legend('control','high effort (current effort condition so this line is high effort first)', 'low effort')

sgtitle('VISIT 1; EXPOSURES 1 and 2')
%% plot for the first ninitialstep strides of each block of interest in vist 1
% figure(2); 
% subplot(131); hold on; title('Adaptation 1 (first visit, first split)')
% plot([0 size(split1_curves,2)],[0 0],'k:','HandleVisibility','off');
% plot_with_stderr(0,highsplit1,colors.high)
% plot_with_stderr(0,lowsplit1,colors.low)
% xlabel('strides count')
% ylabel('steplength asymmetry')
% ylim([-0.4 0.4])
% xlim([0 ninitialstep])
%     
% % figure(2); 
% subplot(132); hold on; title('Washout 1 (first visit,  after first split)')
% plot([0 size(wash1_curves,2)],[0 0],'k:','HandleVisibility','off');
% plot_with_stderr(0,highwash1,colors.high)
% plot_with_stderr(0,lowwash1,colors.low)
% xlabel('strides count')
% ylabel('steplength asymmetry')    
% ylim([-0.4 0.4])
% xlim([0 ninitialstep])
% 
% % figure(3); 
% subplot(133); hold on; title('Adaptation 2 (first visit, second split)')
% plot([0 size(split2_curves,2)],[0 0],'k:','HandleVisibility','off');
% plot_with_stderr(0,highsplit2,colors.high)
% plot_with_stderr(0,lowsplit2,colors.low)
% xlabel('strides count')
% ylabel('steplength asymmetry')
% ylim([-0.4 0.4])
% xlim([0 ninitialstep])
% 
% legend('high effort (current effort condition so this line is high effort first)', 'low effort')
% 
% sgtitle([{'VISIT 1; EXPOSURES 1 and 2'}, {['first ', num2str(ninitialstep), ' strides']}])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plots for visit two
% plot with standard deviation and all individual learning curves
% plot each block on a separate plot and plot high and low first groups
% on the same plot for each block

figure(3); 
subplot(131); hold on; title('Adaptation 3 (second visit, first split)')
plot([0 size(split3_curves,2)],[0 0],'k:','HandleVisibility','off');
plot_with_stderr(0,highsplit3,colors.high)
plot_with_stderr(0,lowsplit3,colors.low)
xlabel('strides count')
ylabel('steplength asymmetry')
ylim([-1 1])
xlim([0 learnlength2(split1blk)])   

    
% figure(2); 
subplot(132); hold on; title('Washout 3 (second visit,  after first split)')
plot([0 size(wash3_curves,2)],[0 0],'k:','HandleVisibility','off');
plot_with_stderr(0,highwash3,colors.high)
plot_with_stderr(0,lowwash3,colors.low)
xlabel('strides count')
ylabel('steplength asymmetry')    
ylim([-1 1])
xlim([0 learnlength2(wash1blk)])   

% figure(3); 
subplot(133); hold on; title('Adaptation 4 (second visit, second split)')
plot([0 size(split4_curves,2)],[0 0],'k:','HandleVisibility','off');
plot_with_stderr(0,highsplit4,colors.high)
plot_with_stderr(0,lowsplit4,colors.low)
xlabel('strides count')
ylabel('steplength asymmetry')
ylim([-1 1])
xlim([0 learnlength2(split2blk)])   

legend('high effort (current effort condition so this line is low effort first)', 'low effort')

sgtitle('VISIT 2; EXPOSURES 3 and 4')

%% plot for the first 20 strides of each block of interest in vist 3
% figure(4); 
% subplot(131); hold on; title('Adaptation 3 (second visit, first split)')
% plot([0 size(split3_curves,2)],[0 0],'k:','HandleVisibility','off');
% plot_with_stderr(0,highsplit3,colors.high)
% plot_with_stderr(0,lowsplit3,colors.low)
% xlabel('strides count')
% ylabel('steplength asymmetry')
% ylim([-0.4 0.4])
% xlim([0 ninitialstep])
%     
% % figure(2); 
% subplot(132); hold on; title('Washout 3 (second visit,  after first split)')
% plot([0 size(wash3_curves,2)],[0 0],'k:','HandleVisibility','off');
% plot_with_stderr(0,highwash3,colors.high)
% plot_with_stderr(0,lowwash3,colors.low)
% xlabel('strides count')
% ylabel('steplength asymmetry')    
% ylim([-0.4 0.4])
% xlim([0 ninitialstep])
% 
% % figure(3); 
% subplot(133); hold on; title('Adaptation 4 (second visit, second split)')
% plot([0 size(split4_curves,2)],[0 0],'k:','HandleVisibility','off');
% plot_with_stderr(0,highsplit4,colors.high)
% plot_with_stderr(0,lowsplit4,colors.low)
% xlabel('strides count')
% ylabel('steplength asymmetry')
% ylim([-0.4 0.4])
% xlim([0 ninitialstep])
% 
% legend('high effort (current effort condition so this line is low effort first)', 'low effort')
% 
% sgtitle([{'VISIT 2; EXPOSURES 3 and 4'}, {['first ', num2str(ninitialstep), ' strides']}])
% 
% figure(33); hold on; title('Adaptation 4 (second visit, second split)')
% plot([0 size(split4_curves,2)],[0 0],'k:','HandleVisibility','off');
% plot_with_stderr(0,highsplit4,colors.high)
% plot_with_stderr(0,lowsplit4,colors.low)
% xlabel('strides count')
% ylabel('steplength asymmetry')
% ylim([-0.4 0.4])

%% plot for individual participants LEARNING
figure(); hold on; sgtitle('Learning')
subplot(321);
plot(1:size(highsplit1,2),highsplit1,'m');
ylim([-1 0.5])
subplot(323);
plot(1:size(lowsplit1,2),lowsplit1,'b');
ylim([-1 0.5])
subplot(325);
plot(1:size(split1ctrl_curves,2),split1ctrl_curves);
legend(subject.list{15:22})
ylim([-1 0.5])
subplot(122); hold on
plot(1:size(highsplit1,2),highsplit1,'Color',[1 0 1 0.2]);
plot(1:size(lowsplit1,2),lowsplit1,'Color',[0 0 1 0.2]);
plot(1:size(split1ctrl_curves,2),split1ctrl_curves,'Color',[0 1 1 0.2]);
plot(mean(highsplit1,1,'omitnan'),'m')
plot(mean(lowsplit1,1,'omitnan'),'b')
plot(mean(split1ctrl_curves,1,'omitnan'),'Color',[0 1 1]);
ylim([-1 0.5])
xlabel('step length asymmetry')
ylabel('stride')

%% plot for individual participants SAVINGS
figure(); hold on; sgtitle('savings')
subplot(321);
plot(1:size(highsplit2,2),highsplit2,'m');
ylim([-1 0.5])
subplot(323);
plot(1:size(lowsplit2,2),lowsplit2,'b');
ylim([-1 0.5])
subplot(325);
plot(1:size(split2ctrl_curves,2),split2ctrl_curves);
legend(subject.list{15:22})
ylim([-1 0.5])
subplot(122); hold on
plot(1:size(highsplit2,2),highsplit2,'Color',[1 0 1 0.2]);
plot(1:size(lowsplit2,2),lowsplit2,'Color',[0 0 1 0.2]);
plot(1:size(split2ctrl_curves,2),split2ctrl_curves,'Color',[0 1 1 0.2]);
plot(mean(highsplit2,1,'omitnan'),'m')
plot(mean(lowsplit2,1,'omitnan'),'b')
plot(mean(split2ctrl_curves,1,'omitnan'),'Color',[0 1 1]);
ylim([-1 0.5])
xlabel('step length asymmetry')
ylabel('stride')
% % % xlim([0 ninitialstep])
% % 
% % 
% % % ng1 = 0; ng2 = 0; ng3 = 0; ng4 = 0; nh = 0; nl = 0;
% % % for subj = 1:subject.n %1:subject.n
% % %     % determine subjects true group (Rhigh,Rlow,Lhigh,Llow)
% % %     if subject.order(subj,1) == 1% high effort first (group 1 or 3)
% % %         if subject.fastleg(subj) == 1 % right (group 1)
% % %             ngroup = 1;
% % %             ng1 = ng1 + 1;
% % %             ng = ng1;
% % %         else
% % %             ngroup = 3; % left group 3
% % %             ng3 = ng3 + 1;
% % %             ng = ng3;
% % %         end
% % %     elseif subject.order(subj,1) == 2 % low effort first (group 2 or 4)
% % %         if subject.fastleg(subj) == 1 % right (group 2)
% % %             ngroup = 2;
% % %             ng2 = ng2 + 1;
% % %             ng = ng2;
% % %         else
% % %             ngroup = 4; %left, group 4 
% % %             ng4 = ng4 + 1;
% % %             ng = ng4;
% % %         end
% % %     end
% % %     if mod(ng,2) == 1
% % %         nh = nh +1;
% % %     else
% % %         nl = nl + 1;
% % %     end
% % %     for effcond = 1:length(subject.effortcondition)
% % %         for blk = [4 5 6] % split, wash, split2
% % %             % make cell for steplengths. 
% % %             steplength_asym{ng,effcond,blk-3,ngroup} = asym(subj).asymlength{effcond,blk};
% % %             % just biuild the two order groups here
% % %             if effcond == 1
% % %                 length_high(nh,blk-3,mod(### %%% ngroup won't work here,2) + 1) = asym(subj).asymlength{effcond,blk};
% % %             else
% % %                 length_low(nl,blk-3,mod(ngroup,2) + 1) = asym(subj).asymlength{effcond,blk};
% % %             end
% % %         end
% % %     end
% % % end
% % % %% combine R/L high and R/L low
% % % % consider fast leg an unimportant factor
% % % % this means combining groups 1 and 3 and then groups 2 and 4
% % % % steplength_asymhigh = (cat(1, steplength_asym(:,:,effcond,1),...
% % % %     steplength_asym(:,:,effcond,3)));
% % % % steplength_asymlow = (cat(1, steplength_asym(:,:,:,2),...
% % % %     steplength_asym(:,:,:,4)));
% % % 
% % % % align to the firststep
% % % for blk = 1:3
% % %     length_asymhigh = alignProfiles2(steplength_asymhigh(:,:,blk),...
% % %         ones(size(steplength_asymhigh{:,:,blk},1)));
% % % end