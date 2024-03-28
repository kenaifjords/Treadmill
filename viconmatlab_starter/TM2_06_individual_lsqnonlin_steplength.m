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
            for blk = 4%[4,6]%:6
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
                nlmodel = @(b)b(1) * exp(-b(2)*stride) + b(3) - asymsla;
                b0 = [-0.4, 0.025, -0.025]; lb = [-1,0,-0.4]; ub = [-0.1,0.3,0.25];
                clear param
                try
                    [param] = lsqnonlin(nlmodel,b0,lb,ub);
                catch
                    try
                        b0 = [-0.4, 0.005, -0.025];
                        [param] = lsqnonlin(nlmodel,b0,lb,ub);
%                         [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
                    catch
                        try
                            b0 = [-0.4 0.05, -0.025];
                            [param] = lsqnonlin(nlmodel,b0,lb,ub);
%                             [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
                        catch
                            param = [];
                        end
%                         disp(subject.list(subj))
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