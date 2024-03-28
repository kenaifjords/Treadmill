% INDIVIDUAL EXPONENTIAL FITS
% TM2_06_fitexponentialmodel_steplength
tic
global F p subject colors asym asym_all
homepath = pwd;
ifplot = 1; ifboot = 0;
singleexp.param = [];
singleexp.CI = [];
singleexp.aic = [];
cd("fitExp_knkTools" );

for fitstyle = 1%:2
for fitgrp = 1:5
    subjgrp = eval(['subject.' subject.group{fitgrp}]);
    subjcond = subject.grpcond(fitgrp);
    subji = 1; i = 1;
    for subj = subjgrp
        subj
        for effcond = subjcond
            for blk = [4,6]%:6
                if fitstyle == 1
                    asymsla = asym(subj).steplength{effcond,blk};%(1:200);
                else
                    asymsla = asym(subj).steplength{effcond,blk}(1:200);
                end
                stride = 1:length(asymsla);
                if ifplot
                    figure(fitgrp)%(subj)
                    sgtitle(subject.groupname(fitgrp))
                    subplot(3,5,subji); hold on;
                    ylim([-0.5 0.1]);
                    title(strcat(subject.list(subj), '; effort condition: ', num2str(effcond), '; block: ', num2str(blk)))
                end
                %% knk tools for fitting with particle swarm initiation
%                 [param,CI,aic] = fitSingleExp_RM(asymsla,ifplot);
%                 if ~isempty(param)
%                     singleexp.param(i,fitgrp,:) = param;
%                     singleexp.CI(i,fitgrp,:,:) = CI;
%                     singleexp.aic(i,fitgrp) = aic;
%                 end
                %% using nlinfit
                clear param
                nlmodel = @(b,stride)b(1) * exp(-b(2)*stride) + b(3);
                b0 = [-0.4, 0.025, -0.025];
                try
                    [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
                catch
                    try
                        b0 = [-0.4, 0.01, -0.025];
                        [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
                    catch
                        try
                            b0 = [-0.4 0.05, -0.025];
                            [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
                        catch
                            param = [];
                        end
                        disp(subject.list(subj))
                    end
                end
                    
                if ~isempty(param)
                    singleexp.param(i,fitgrp,blk,:) = param;
                    singleexp.mse(i,fitgrp,blk) = mse;
%                     singleexp.CI(i,fitgrp,:,:) = CI;
%                     singleexp.aic(i,fitgrp) = aic;
                    if ifplot
                        plot(stride,asymsla); hold on;
                        plot(stride,param(1) * exp(-param(2)*stride) + param(3));
                        if blk == 4
                            text(100,-0.2,num2str(param(2)))
                        elseif blk == 6
                            text(100,-0.3,num2str(param(2)),'Color','r')
                        end
                    end
                elseif ifplot
                    plot(stride,asymsla,'g');
                end
                
                
                %%
                
            end
            i = i + 1;
        end
        subji = subji + 1;
    end
end
cd(homepath)
%% learning rate bar plot from single exponential fit
blk = 4;
figure(100+fitstyle + blk); hold on;
learnrate = singleexp.param(:,:,blk,2);
learnrate(learnrate == 0) = NaN;
getBarPlot_groupsorted(learnrate,'single exp fit: learning rate',[0 0.5])
title(['learning rate; blk: ' num2str(blk)])
%%
figure(120+fitstyle); hold on;
blk = 4;
coef = singleexp.param(:,:,blk,1);
learnrate = singleexp.param(:,:,blk,2);
const = singleexp.param(:,:,blk,3);

learnrate(learnrate == 0) = NaN; learnrate(:,4:5)= NaN;
coef(coef == 0) = NaN; coef(:,4:5) = NaN;
const(const == 0) = NaN; const(:,4:5) = NaN;
% learning rate
subplot(311); hold on;
getBarPlot_groupsorted(learnrate,'single exp fit: learning rate',[0 0.15])
[plr,tbl] = anova1(learnrate(:,1:3),{'high','low','control'},'off');
[~,p_hl]= ttest2(learnrate(:,1),learnrate(:,2));
ylabel('learning rate')
% coefficient
subplot(312);hold on
getBarPlot_groupsorted(coef,'single exp fit: learning rate',[-1 0])
[pcf,tbl] = anova1(coef(:,1:3),{'high','low','control'},'off');
[~,p_hl1]= ttest2(coef(:,1),coef(:,2));
ylabel('exp coefficient(delta)')
% constant
subplot(313); hold on;
getBarPlot_groupsorted(const,'single exp fit: learning rate',[-0.2 0.2])
[pco,tbl] = anova1(const(:,1:3),{'high','low','control'},'off');
[~,p_hl3]= ttest2(const(:,1),const(:,2));
ylabel('exp constant (ss)')
%% Examine Learning Rate Distribution
figure(150+fitstyle); hold on;
for grp = 1:3 % for first visit groups only 5
%     histogram(singleexp.param(:,grp,2));
% end
plot(singleexp.param(:,grp,3),singleexp.param(:,grp,2),'o','Color',colors.all{grp,1})
end
legend(subject.groupname)
xlabel('constant, exp fit proxy for final asym')
ylabel('exponential fit learning rate')
title('exponential learning rate')

%% Bootstrap learning rates
if ifboot
expLR = singleexp.param; expLR(expLR == 0) = NaN;
tic
nboot = 10000;
for nb = 1:nboot
    clear sampLR
    for grp = 1:3 % to focus on first visit % 5
        n = sum(~isnan(expLR(:,grp,1)));
        for i = 1:n
            randsubj = randi(n,1,1); % select a random subject
            sampLR(i,grp) = expLR(randsubj,grp,2); % 2 indicates learning rate
        end
    end
    bootLR(nb,:) = mean(sampLR,'omitnan');
end

figure(200);subplot(2,1,fitstyle); hold on; xlim([0 0.1]);
title('bootstrap individually-fitted exp learning rate')
for grp = 1:3 % to focus on first visit
    histogram(bootLR(:,grp))
end
legend(subject.groupname)
%% ANOVA
[p_lrboot_anova,tbl,lrboot_stat] = anova1(bootLR(:,1:3))
figure(); [comp] = multcompare(lrboot_stat)
% ttest
[~,p_bootlr_HvL] = ttest2(bootLR(:,1),bootLR(:,2))
[~,p_bootlr_HvC] = ttest2(bootLR(:,1),bootLR(:,3))
[~,p_bootlr_LvC] = ttest2(bootLR(:,2),bootLR(:,3))

meanLR = mean(bootLR);
stdLR = std(bootLR);
ciLR = [meanLR'-1.96*stdLR' meanLR'+1.96*stdLR'];
end
toc
end

%% compare fits rates within groups between learning and savings
if 1
if 0 % blk == 4
    se4 = singleexp;
    lr4 = se4.param(:,:,blk,2);
elseif blk == 6
    se6 = singleexp
    lr6 = se6.param(:,:,blk,2);
end

for effcond = 1:3
    for parami = 1:3
        [~,plr] = ttest(singleexp.param(:,effcond,4,parami),singleexp.param(:,effcond,6,parami));
        disp(['effort condition: ' num2str(effcond)])
        disp(['parameter: ' num2str(parami)])
        disp(['ttest between learn and save: p = ' num2str(plr)]);
    end
end
end

%% compare groups for learning on second visit
for blk = 4:6
    for parami = 1:3
        [~,phl] =  ttest2(singleexp.param(:,4,blk,parami),...
            singleexp.param(:,5,blk,parami));
        disp(['blk ' num2str(blk) 'parameter: ' num2str(parami)])
        disp(['ttest between low and high second visit: p = ' num2str(phl)]);
    end
end
%%
    % generate a selection of learning rate values sampled with replacement
    % for each group        
    % high first
% % %     nhf = size(slength.hfirst{blk},1);
%             for i = 1:nhf
%                 randsubj = randi(nhf,1,1);
%                 hfcurve(i,:) = slength.hfirst{blk}(randsubj,:);
%             end
%             % low first
%             nlf = size(slength.lfirst{blk},1);
%             for i = 1:nlf
%                 randsubj = randi(nlf,1,1);
%                 lfcurve(i,:) = slength.lfirst{blk}(randsubj,:);
%             end
%             % control
%             nc = size(slength.control{blk},1);
%             for i = 1:nc
%                 randsubj = randi(nc,1,1);
%                 ccurve(i,:) = slength.control{blk}(randsubj,:);
%             end


%% Across subjects with boot strap
% ifboot = 1; nboot = 10; modnumber = ceil(nboot/10); %10; %10000;
% rng(2023)
% includeblk = 4;
% 
% % generate sorted lists for visit number / effort condition
% [slength] = sortbyEffortVisitorder_02(asym_all.steplength);
% 
% %%   
% cd("fitExp_knkTools" );   
% ifplotbootsample = 1;
% if ifboot
%     for nb = 1:nboot
%         % generate a selection of curves for each group        
%         for blk = includeblk
%             clear hfcurve lfcurve ccurve hfavg lfavg ctavg
%             % high first
%             nhf = size(slength.hfirst{blk},1);
%             for i = 1:nhf
%                 randsubj = randi(nhf,1,1);
%                 hfcurve(i,:) = slength.hfirst{blk}(randsubj,:);
%             end
%             % low first
%             nlf = size(slength.lfirst{blk},1);
%             for i = 1:nlf
%                 randsubj = randi(nlf,1,1);
%                 lfcurve(i,:) = slength.lfirst{blk}(randsubj,:);
%             end
%             % control
%             nc = size(slength.control{blk},1);
%             for i = 1:nc
%                 randsubj = randi(nc,1,1);
%                 ccurve(i,:) = slength.control{blk}(randsubj,:);
%             end
%             % average curves and fits
% %             hfavg = mean(hfcurve,1,'omitnan');
% %             [hfsingleparams,~,aicShf,hfdoubleparams,~,aicDhf]...
% %                 = fitExpModels_RMM_streamlined(hfavg);
% %             lfavg = mean(lfcurve,1,'omitnan');
% %             [lfsingleparams,~,aicSlf,lfdoubleparams,~,aicDlf]...
% %                 = fitExpModels_RMM_streamlined(lfavg);
% %             ctavg = mean(ccurve,1,'omitnan');
% %             [ctsingleparams,~,aicSc,ctdoubleparams,~,aicDc]...
% %                 = fitExpModels_RMM_streamlined(ctavg);
%            %% only single exp fits
%            hfavg = mean(hfcurve,1,'omitnan');
%             [hfsingleparams,~,aicShf,hfdoubleparams,~,aicDhf]...
%                 = fitSingleExpPSO_RMM(hfavg);
%             lfavg = mean(lfcurve,1,'omitnan');
%             [lfsingleparams,~,aicSlf,lfdoubleparams,~,aicDlf]...
%                 = fitSingleExpPSO_RMM(lfavg);
%             ctavg = mean(ccurve,1,'omitnan');
%             [ctsingleparams,~,aicSc,ctdoubleparams,~,aicDc]...
%                 = fitSingleExpPSO_RMM(ctavg);
%         end
%         iblk = find(blk == includeblk,1,'first');
%         % high first
%         singleexpfit(1,iblk,nb,:) = cat(2,hfsingleparams,aicShf); % hf
%         doubleexpfit(1,iblk,nb,:) = cat(2,hfdoubleparams,aicDhf);
%         % low first
%         singleexpfit(2,iblk,nb,:) = cat(2,lfsingleparams,aicSlf); % lf
%         doubleexpfit(2,iblk,nb,:) = cat(2,lfdoubleparams,aicDlf);
%         % control
%         singleexpfit(3,iblk,nb,:) = cat(2,ctsingleparams,aicSc); % ct
%         doubleexpfit(3,iblk,nb,:) = cat(2,ctdoubleparams,aicDc);
%         % test plot
%         if ifplotbootsample
%             figure(111);hold on;
%             if(mod(nb,modnumber) == 0)
%                 xin = 1:length(hfavg);
%                 plot(xin,hfavg,'Color',colors.all{1,1})
%                 plot(xin,lfavg,'Color',colors.all{2,1})
%                 plot(xin,ctavg,'Color',colors.all{3,1})
%                 for effcond = 1:3
%                     expout = singleexpfit(effcond,iblk,nb,1) * ...
%                         exp(singleexpfit(effcond,iblk,nb,2)*xin) + ...
%                         singleexpfit(effcond,iblk,nb,3);
%                     plot(xin,expout,'Color',colors.all{effcond,1}) 
%                 end
%             end
%         end
%     end
% end
% cd(homepath)
% %% Plot the boot strap median curves
% size(singleexpfit) % effortcondition %blk index % bootloop %param index
% for effcond = 1:3
%     for iblk = 1 % corresponds to blk 4
%         for parami = 1:3
%             singleparams(effcond,iblk,parami) = median(singleexpfit(effcond,iblk,parami));
%         end
%         for parami = 1:5
%             doubleparams(effcond,iblk,parami) = median(doubleexpfit(effcond,iblk,parami));
%         end
%     end
% end
% for effcond = 1:3
%     for iblk = 1 % corresponds to blk 4        figure(665);hold on;
%         xin = 1:200;
%         figure(12); hold on;
%         expout = singleparams(effcond,iblk,1) * ...
%             exp(singleparams(effcond,iblk,2)*xin) + ...
%             singleparams(effcond,iblk,3);
%         plot(xin,expout,'Color',colors.all{effcond,1}) 
%         dexpout = doubleparams(effcond,iblk,1) * ...
%             exp(doubleparams(effcond,iblk,2)*xin) + ...
%             doubleparams(effcond,iblk,3) * ...
%             exp(doubleparams(effcond,iblk,4)*xin) + ...
%             doubleparams(effcond,iblk,5);
%         plot(xin,dexpout,'Color',colors.all{effcond,1},'Linestyle','--') 
%     end
% end
% 
% %% output print
% for effcond = 1:3
%     for iblk = 1
%         
%         Sbetter = sum(squeeze(singleexpfit(effcond,iblk,:,4)> doubleexpfit(effcond,iblk,:,6)+2));
%         Dbetter = sum(squeeze(singleexpfit(effcond,iblk,:,4)+2 < doubleexpfit(effcond,iblk,:,6)));
%         SDcomp = nboot - Sbetter - Dbetter;
%         disp(['Effort condition ' num2str(effcond) ', blk: ' num2str(blk) ': Of '...
%             num2str(nboot) ' fits, ' num2str(Sbetter)...
%             ' are better fit with a single expontnetial.'])
%         disp([num2str(Dbetter) ' are better fit wtih a double exponential. And fits are comparable for '...
%             num2str(SDcomp) ' fits.'])
%     end
% end
toc



%% fit average curves
% ifplot = 1;
% for blk = includeblk
%     % get average curves
%     hfavg = mean(slength.hfirst{blk},1,'omitnan');
%     lfavg = mean(slength.lfirst{blk},1,'omitnan');
%     ctavg = mean(slength.control{blk},1,'omitnan');
%     % fit average curves
%     [asym_all.hf.singleExp{effcond,blk}.params,...
%             asym_all.hf.singleExp{effcond,blk}.CI,...
%             asym_all.hf.singleExp{effcond,blk}.aic,...
%             asym_all.hf.doubleExp{effcond,blk}.params,...
%             asym_all.hf.doubleExp{effcond,blk}.CI,...
%             asym_all.hf.doubleExp{effcond,blk}.aic]...
%             = fitExpModels_RMM(hfavg,ifplot,ifprint);
%     [asym_all.lf.singleExp{effcond,blk}.params,...
%             asym_all.lf.singleExp{effcond,blk}.CI,...
%             asym_all.lf.singleExp{effcond,blk}.aic,...
%             asym_all.lf.doubleExp{effcond,blk}.params,...
%             asym_all.lf.doubleExp{effcond,blk}.CI,...
%             asym_all.lf.doubleExp{effcond,blk}.aic]...
%             = fitExpModels_RMM(lfavg,ifplot,ifprint);
%     [asym_all.ct.singleExp{effcond,blk}.params,...
%             asym_all.ct.singleExp{effcond,blk}.CI,...
%             asym_all.ct.singleExp{effcond,blk}.aic,...
%             asym_all.ct.doubleExp{effcond,blk}.params,...
%             asym_all.ct.doubleExp{effcond,blk}.CI,...
%             asym_all.ct.doubleExp{effcond,blk}.aic]...
%             = fitExpModels_RMM(ctavg,ifplot,ifprint);
% end