% TM2_06_fitexponentialmodel_steplength
% fit average group curves and bootstrap learning curves
tic
global F p subject colors asym asym_all
homepath = pwd;
ifplot = 1; ifprint = 0;
hfirst = []; lowfirst =[]; control = [];
ih = 0; il = 0; ic = 0;
individualfit = 1; 

% generate sorted lists for visit number / effort condition
[slength] = sortbyEffortVisitorder_02(asym_all.steplength);

for fitstyle = 1:2
   % get average learning curves
for fitgrp = 1:5
    figure(300); subplot(5,1,fitgrp); title(subject.groupname(fitgrp)); hold on;
    grp = eval(['slength.' subject.group{fitgrp}]);
    for blk = 4
        grpblk = grp{blk};
        if fitstyle == 1
            asymsla = mean(grpblk,'omitnan');
        else
            asymsla = mean(grpblk(:,1:200),'omitnan');
        end
    end
    stride = 1:length(asymsla);
    %% using nlinfit
    nlmodel = @(b,stride)b(1) * exp(-b(2)*stride) + b(3);
    b0 = [0.4, 0.025, -0.025];
    try
        [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
    catch
        try
            b0 = [0.4, 0.01, -0.025];
            [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
        catch
            try
                b0 = [0.4 0.07, -0.025];
                [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
            catch
                param = [];
            end
            disp(subject.list(subj))
        end
    end

    if ~isempty(param)
        groupsingleexp.param(fitgrp,:) = param;
        groupsingleexp.mse(fitgrp) = mse;
%                     singleexp.CI(i,fitgrp,:,:) = CI;
%                     singleexp.aic(i,fitgrp) = aic;
        if ifplot
            plot(stride,asymsla); hold on;
            plot(stride,param(1) * exp(-param(2)*stride) + param(3));
        end
    elseif ifplot
        plot(stride,asymsla,'g');
    end
end
end




%% Bootstrap learning curves
ifboot = 1; nboot = 10000; modnumber = ceil(nboot/5); %10; %10000;
ifplotbootsample = 0;
for fitstyle = 1:2
    clear bootcurve
     if fitstyle == 1
        savename = 'singleexp_bootcurve_wholeprofile_v0';
    else
        savename = 'singleexp_bootcurve_200strides_v0';
    end
for nb = 1:nboot
for fitgrp = 1:5
    grp = eval(['slength.' subject.group{fitgrp}]);
    for blk = 4
        grpblk = grp{blk};
        clear samp
        n = size(grpblk,1);
        for i = 1:size(grpblk,1)
            randsubj = randi(n,1,1);
            samp(i,:) = grpblk(randsubj,:);
        end
        if fitstyle == 1
            asymsla = mean(samp,'omitnan');
        else
            asymsla = mean(samp(:,1:200),'omitnan');
        end
    end
    stride = 1:length(asymsla);
    %% using nlinfit
    b0 = [0.4, 0.025, -0.025];
    try
        [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
    catch
        try
            b0 = [0.4, 0.01, -0.025];
            [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
        catch
            try
                b0 = [0.4 0.07, -0.025];
                [param,R,J,cobB,mse,errmod] = nlinfit(stride,asymsla,nlmodel,b0);
            catch
                param = [];
            end
        end
    end
    bootcurve.learning(nb,fitgrp,:) = asymsla;
    bootcurve.param(nb,fitgrp,:) = param;
    bootcurve.mse(nb,fitgrp) = mse;
    
    %%
    if ifplotbootsample && fitgrp < 4
        figure(400 + fitstyle);hold on;
        if(mod(nb,modnumber) == 0)
            plot(stride,asymsla,'Color',colors.all{fitgrp,1})
            plot(stride, param(1) * exp(-param(2)*stride) + param(3));
        end
    end
end
end
figure(500);subplot(2,1,fitstyle); hold on; xlim([0 0.1]);
title('bootstrap average learning curves to fit rate')
for grp = 1:3 % to focus on first visit
    histogram(bootcurve.param(:,grp,2))
end
legend(subject.groupname)
% save(savename,'bootcurve');
end

%% ANOVA for bootstrap learning rate
[p_curveboot_anova,tbl,curveboot_stat] = anova1(bootcurve.param(:,1:3,2))
% multiple comparison tests
figure(); [comp] = multcompare(curveboot_stat)
% ttests
[~,p_curveboot_HvL] = ttest2(bootcurve.param(:,1,2),bootcurve.param(:,2,2))
[~,p_curveboot_HvC] = ttest2(bootcurve.param(:,1,2),bootcurve.param(:,3,2))
[~,p_curveboot_LvC] = ttest2(bootcurve.param(:,2,2),bootcurve.param(:,3,2))

%%
% 
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
% toc
% 
% 
% 
% %% fit average curves
% % ifplot = 1;
% % for blk = includeblk
% %     % get average curves
% %     hfavg = mean(slength.hfirst{blk},1,'omitnan');
% %     lfavg = mean(slength.lfirst{blk},1,'omitnan');
% %     ctavg = mean(slength.control{blk},1,'omitnan');
% %     % fit average curves
% %     [asym_all.hf.singleExp{effcond,blk}.params,...
% %             asym_all.hf.singleExp{effcond,blk}.CI,...
% %             asym_all.hf.singleExp{effcond,blk}.aic,...
% %             asym_all.hf.doubleExp{effcond,blk}.params,...
% %             asym_all.hf.doubleExp{effcond,blk}.CI,...
% %             asym_all.hf.doubleExp{effcond,blk}.aic]...
% %             = fitExpModels_RMM(hfavg,ifplot,ifprint);
% %     [asym_all.lf.singleExp{effcond,blk}.params,...
% %             asym_all.lf.singleExp{effcond,blk}.CI,...
% %             asym_all.lf.singleExp{effcond,blk}.aic,...
% %             asym_all.lf.doubleExp{effcond,blk}.params,...
% %             asym_all.lf.doubleExp{effcond,blk}.CI,...
% %             asym_all.lf.doubleExp{effcond,blk}.aic]...
% %             = fitExpModels_RMM(lfavg,ifplot,ifprint);
% %     [asym_all.ct.singleExp{effcond,blk}.params,...
% %             asym_all.ct.singleExp{effcond,blk}.CI,...
% %             asym_all.ct.singleExp{effcond,blk}.aic,...
% %             asym_all.ct.doubleExp{effcond,blk}.params,...
% %             asym_all.ct.doubleExp{effcond,blk}.CI,...
% %             asym_all.ct.doubleExp{effcond,blk}.aic]...
% %             = fitExpModels_RMM(ctavg,ifplot,ifprint);
% % end