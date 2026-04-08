% TM2_06_analyzefits
%% generate curves and get the average
clear curve acurve
close all
strd = 1:350;
grp = {'hfirst','lfirst','control','hsecond','lsecond'};

if exist('curvefit')~= 1
    a = load('store_curvefit_fmincon'); % load('store_curvefit');
    curvefit = a.curvefit;
end

%% state space
for blk = 1:subject.nblk
    clear c     
    for igrp = 1:length(grp)
        alpha = eval(['curvefit(1).ss.' grp{igrp} '{1,blk}']);
        beta = eval(['curvefit(2).ss.' grp{igrp} '{1,blk}']);
        offset = eval(['curvefit(3).ss.' grp{igrp} '{1,blk}']);
        initialval = eval(['curvefit(4).ss.' grp{igrp} '{1,blk}']);
        for s = 1:length(alpha)
            a = alpha(s); b = beta(s); os = offset(s); c(1) = initialval(s);
            for i = 1:length(strd)-1
                c(i+1) = a*c(i) + b*(0 - c(i));
            end
%             c = c + os;
            curve(s,blk,:,igrp) = c;
        end
    end
end 
% plot %%
% figure(1);
% for igrp = 1:length(grp); hold on;
%     c = mean(squeeze(curve(:,4,:,igrp)),'omitnan');
%     plot(c,'DisplayName',grp{igrp})
%     xlabel('strides'); ylabel('asymmetry')
%     legend
% end
% hold off; 
%%
for blk = [4]; i = 1;
    figure(31); subplot(2,2,1); %subplot(2,3,blk - 3); hold on;
    for igrp = 1:length(grp); hold on;
    %     c = mean(squeeze(curve(:,4,:,igrp)),'omitnan');
        plot_with_stderr(0,squeeze(curve(:,blk,:,igrp)),eval(['colors.',grp{igrp}]));
%         legend(grp)
        title(['state space block ' num2str(blk) ': averaged individual subject curves'])
    end
    i = i + 1;
end
plot([0 strd(end)],[0 0],'k:')
ylim([-0.6 0.1])
hold off;

for blk = [5]; i = 1;
    figure(8); subplot(2,2,1); %subplot(2,3,blk - 3); hold on;
    for igrp = 1:length(grp); hold on;
    %     c = mean(squeeze(curve(:,4,:,igrp)),'omitnan');
        plot_with_stderr(0,squeeze(curve(:,blk,:,igrp)),eval(['colors.',grp{igrp}]));
%         legend(grp)
        title(['state space block ' num2str(blk) ': averaged individual subject curves'])
    end
    i = i + 1;
end
plot([0 strd(end)],[0 0],'k:')
ylim([-0.1 0.6])
hold off;

for blk = [6]; i = 1;
    figure(33); subplot(2,2,1); %subplot(2,3,blk - 3); hold on;
    for igrp = 1:length(grp); hold on;
    %     c = mean(squeeze(curve(:,4,:,igrp)),'omitnan');
        plot_with_stderr(0,squeeze(curve(:,blk,:,igrp)),eval(['colors.',grp{igrp}]));
%         legend(grp)
        title(['state space block ' num2str(blk) ': averaged individual subject curves'])
    end
    i = i + 1;
end
plot([0 strd(end)],[0 0],'k:')
ylim([-0.6 0.1])
hold off;
%% exponential fit
for blk = [4 5 6] %1:subject.nblk
    for igrp = 1:length(grp)
        coef = eval(['curvefit(1).ex.' grp{igrp} '{1,blk}']);
        gain = eval(['curvefit(2).ex.' grp{igrp} '{1,blk}']);
        const = eval(['curvefit(3).ex.' grp{igrp} '{1,blk}']);
        for s = 1:length(coef)
            a = coef(s); b = gain(s); os = const(s);
            c = a*exp(-b*strd) + os;
            curve(s,blk,:,igrp) = c;
        end
        disp(' ');
        disp(['Exponential fit Grp: ' grp{igrp}]);
        disp([grp{igrp} ': blk:' num2str(blk)]);
        disp(['coefficient: ' num2str(mean(coef,'omitnan')) ' +/- ' num2str(std(coef,[],'omitnan')./sqrt(length(coef)))]);
        disp(['Rate: ' num2str(mean(gain,'omitnan')) ' +/- ' num2str(std(gain,[],'omitnan')./sqrt(length(gain)))]);
        disp(['Constant: ' num2str(mean(const,'omitnan')) ' +/- ' num2str(std(const,[],'omitnan')./sqrt(length(const)))]);
    end
end 
% plot %%
figure(4);
blk = 4;
for igrp = 1:length(grp); hold on;
    c = mean(squeeze(curve(:,blk,:,igrp)),'omitnan');
    plot(c,'DisplayName',grp{igrp})
%     legend
end
hold off; 
%%
i = 1;
for blk = [4]
    figure(31); subplot(2,2,3); %subplot(2,3,blk)
    for igrp = 1:length(grp); hold on;
    %     c = mean(squeeze(curve(:,4,:,igrp)),'omitnan');
        plot_with_stderr(0,squeeze(curve(:,blk,:,igrp)),eval(['colors.',grp{igrp}]));
%         legend(grp)
        title(['exponential fits block ' num2str(blk) ': averaged individual subject curves'])
    end
    i = i + 1;
end
plot([0 strd(end)],[0 0],'k:')
ylim([-0.6 0.1])
hold off;

i = 1;
for blk = [5]
    figure(8); subplot(2,2,3); %subplot(2,3,blk)
    for igrp = 1:length(grp); hold on;
    %     c = mean(squeeze(curve(:,4,:,igrp)),'omitnan');
        plot_with_stderr(0,squeeze(curve(:,blk,:,igrp)),eval(['colors.',grp{igrp}]));
%         legend(grp)
        title(['exponential fits block ' num2str(blk) ': averaged individual subject curves'])
    end
    i = i + 1;
end
plot([0 strd(end)],[0 0],'k:')
ylim([-0.1 0.6])
hold off;

i = 1;
for blk = [6]
    figure(33); subplot(2,2,3); %subplot(2,3,blk)
    for igrp = 1:length(grp); hold on;
    %     c = mean(squeeze(curve(:,4,:,igrp)),'omitnan');
        plot_with_stderr(0,squeeze(curve(:,blk,:,igrp)),eval(['colors.',grp{igrp}]));
%         legend(grp)
        title(['exponential fits block ' num2str(blk) ': averaged individual subject curves'])
    end
    i = i + 1;
end
plot([0 strd(end)],[0 0],'k:')
ylim([-0.6 0.1])
hold off;
%% find average parameters and generate curves
for blk = [4 5 6] %1:subject.nblk
    disp(['BLOCK: ' num2str(blk)]);
    for igrp = 1:length(grp)
        alpha = eval(['curvefit(1).ss.' grp{igrp} '{1,blk}']);
        beta = eval(['curvefit(2).ss.' grp{igrp} '{1,blk}']);
        offset = eval(['curvefit(3).ss.' grp{igrp} '{1,blk}']);
        initialval = eval(['curvefit(4).ss.' grp{igrp} '{1,blk}']);
        a = mean(alpha,'omitnan'); b = mean(beta,'omitnan'); 
        os = mean(offset,'omitnan');
        c(1) = mean(initialval,'omitnan');
        for i = 1:length(strd)-1
            c(i+1) = a*c(i) + b*(0 - c(i));
        end
%         c = c + os;
        disp(' ')
        disp(['State space Grp: ' grp{igrp}]);
        disp([grp{igrp} ': blk:' num2str(blk)]);
        disp(['Alpha: ' num2str(a) ' +/- ' num2str(std(alpha,[],'omitnan')./sqrt(length(alpha)))]);
        disp(['Beta: ' num2str(b) ' +/- ' num2str(std(beta,[],'omitnan')./sqrt(length(beta)))]);
        disp(['initial val: ' num2str(c(1)) ' +/- ' num2str(std(initialval,[],'omitnan')./sqrt(length(initialval)))]);
        acurve(blk,:,igrp) = c;      
    end
end

%%
figure(3);
for igrp = 1:length(grp); hold on;
    c = acurve(4,:,igrp);
    plot(c,'DisplayName',grp{igrp})
%     legend
    title(['block ' num2str(blk) ' curves from parameters averaged across subjects'])
end
hold off; 
%% compare parameters (ANOVA)
%% VISIT 1
clear p
ip_list ={'alpha','beta','offset','initial'};
eip_list = {'coef','rate','constant','initial'};
% compare parameters in the first visit
disp('FIRST VISIT (one-way anova: high, low, control)')
list_blk = [4 5 6];
for ip = 1:length(ip_list)
    for blk = list_blk
        disp(['BLOCK: ' num2str(blk)]); disp(' '); disp('STATE SPACE');
        % STATE SPACE
        datin = [curvefit(ip).ss.hfirst{1,blk}' curvefit(ip).ss.lfirst{1,blk}'...
            curvefit(ip).ss.control{1,blk}'];        p0 = anova1(datin,[],'off');
        disp(['state space ' ip_list{ip} ' p = ' num2str(p0)]);
        if p0 < 0.05
            disp(['significant difference between groups;'...
                'first visit; ss _param: ', num2str(ip),': p = ',...
                num2str(p0)])
        end
        p.ss1stvisit(ip,blk) = p0;
        % get pairwise comparisons
        % compare only low and high effort
        datin = [curvefit(ip).ss.hfirst{1,blk}' curvefit(ip).ss.lfirst{1,blk}'];
        p0 = anova1(datin,[],'off');
        [~,p0] = ttest2(datin(:,1),datin(:,2));
        disp(['state space compare low and high' ip_list{ip} ' p = ' num2str(p0)]);
        if p0 < 0.05
            disp(['significant difference low and high groups;'...
                'first visit; ss _param: ', num2str(ip),': p = ',...
                num2str(p0)])
        end
        p.ss1stvisit_lowVhigh(ip,blk) = p0;
        
        % high v control
        datin = [curvefit(ip).ss.hfirst{1,blk}' curvefit(ip).ss.control{1,blk}'];
        p0 = anova1(datin,[],'off');
        [~,p0] = ttest2(datin(:,1),datin(:,2));
        disp(['state space compare high and control' ip_list{ip} ' p = ' num2str(p0)]);
        p.ss1stvisit_highVcontrol(ip,blk) = p0;
       
        % low v control
        datin = [curvefit(ip).ss.lfirst{1,blk}' curvefit(ip).ss.control{1,blk}'];
        p0 = anova1(datin,[],'off');
        [~,p0] = ttest2(datin(:,1),datin(:,2));
        disp(['state space compare low and control' ip_list{ip} ' p = ' num2str(p0)]);
        p.ss1stvisit_lowVcontrol(ip,blk) = p0;
        
        disp(' '); disp('EXPONENTIAL')
        % EXPONENTIAL
        datin = [curvefit(ip).ex.hfirst{1,blk}' curvefit(ip).ex.lfirst{1,blk}'...
            curvefit(ip).ex.control{1,blk}'];
        p0 = anova1(datin,[],'off');
        disp(['exponential ' eip_list{ip} ' p = ' num2str(p0)]);
        if p0 < 0.05
            disp(['significant difference between groups;'...
                'first visit; ex _param: ', num2str(ip),': p = ',...
                num2str(p0)])
        end
        p.ex1stvisit(ip,blk) = p0;
        % get pairwise comparisons
        % compare only low and high effort
        datin = [curvefit(ip).ex.hfirst{1,blk}' curvefit(ip).ex.lfirst{1,blk}'];
        p0 = anova1(datin,[],'off');
        [~,p0] = ttest2(datin(:,1),datin(:,2));
        disp(['exp compare low and high' eip_list{ip} ' p = ' num2str(p0)]);
        if p0 < 0.05
            disp(['significant difference low and high groups;'...
                'first visit; ex _param: ', num2str(ip),': p = ',...
                num2str(p0)])
        end
        p.ex1stvisit_lowVhigh(ip,blk) = p0;
        % high v control
        datin = [curvefit(ip).ex.hfirst{1,blk}' curvefit(ip).ex.control{1,blk}'];
        p0 = anova1(datin,[],'off');
        [~,p0] = ttest2(datin(:,1),datin(:,2));
        disp(['exp compare high and control' eip_list{ip} ' p = ' num2str(p0)]);
        p.ex1stvisit_highVcontrol(ip,blk) = p0;
        % low v control
        datin = [curvefit(ip).ex.lfirst{1,blk}' curvefit(ip).ex.control{1,blk}'];
        p0 = anova1(datin,[],'off');
        [~,p0] = ttest2(datin(:,1),datin(:,2));
        disp(['exp compare low and control' eip_list{ip} ' p = ' num2str(p0)]);
        p.ex1stvisit_lowVcontrol(ip,blk) = p0;
        disp(' ')
    end
end

% compare low and high during first visit

%% VISIT 2
% compare parameters in the second visit
disp('SECOND VISIT (high v low)')
list_blk = [4 5 6];
for ip = 1:length(ip_list)
    for blk = list_blk
        disp(' '); disp(['BLOCK ' num2str(blk)]);
        % ss
        datin = [curvefit(ip).ss.hsecond{1,blk}' [curvefit(ip).ss.lsecond{1,blk} NaN(1,1)]'];
        p0 = anova1(datin,[],'off');
        disp(['state space ' ip_list{ip} ' p = ' num2str(p0)]);
        if p0 < 0.05
            disp(['significant difference between groups;'...
                'second visit; ss _param: ', num2str(ip),': p = ',...
                num2str(p0)])
        end
        p.ss2ndvisit(ip,blk) = p0;
        % ex
        datin = [curvefit(ip).ex.hsecond{1,blk}' [curvefit(ip).ex.lsecond{1,blk} NaN(1,1)]'];
        p0 = anova1(datin,[],'off');
        disp(['exponential ' eip_list{ip} ' p = ' num2str(p0)]);
        if p0 < 0.05
            disp(['significant difference between groups;'...
                'second visit; ex _param: ', num2str(ip),': p = ',...
                num2str(p0)])
        end
        p.ex2ndvisit(ip,blk) = p0;        
    end
end
%% Compare learning and relearning
% ratio of learning rates in initial learning block and relearning block

%% PLOT
blk = 4; fnum = 31;
ex_ylim = [-1 0; 0 0.22; -0.35 0.1];
ss_ylim = [0.95 1; 0 0.035; -0.8 0];
getBarplot_ModelFit

blk = 6; fnum = 33;
ex_ylim = [-1 0; 0 1; -0.3 0.1];
ss_ylim = [0.95 1; 0 0.06; -0.6 0];
getBarplot_ModelFit

blk = 5; fnum = 8; 
ex_ylim = [0 1.25; 0 0.3; -0.2 0.2];
ss_ylim = [0.95 1; 0 0.05; 0 1];
getBarplot_ModelFit
% shift plot sizes

% %%
% % for ip = 1:4for i = [2]
%     figure(31);
%     x0 = 10;
%     y0 = 100;
%     width = 400;
%     height = 400;
%     set(gcf,'position',[x0,y0,width,height])
%     legend('Location','southeast')
%     beautifyfig
% 
%     figure(8);
%     x0 = 10;
%     y0 = 100;
%     width = 400;
%     height = 400;
%     set(gcf,'position',[x0,y0,width,height])
%     legend('Location','southeast')
%     beautifyfig
% %     for blk = 4
% %         iin = 1;
% %         for  igrp = 1:length(grp)
%             plist = eval(['curvefit(',num2str(ip),').ss.', grp{igrp},'{1,', num2str(blk),'}']);
%             for i = 1:length(plist)
%                 paramlist(ip,iin) = plist(i);
%                 paramgrp{iin} = grp{igrp};
%                 iin = iin + 1;
%             end
%         end
%     end
% end
% %%
% ic = find(strcmp('control',paramgrp),1,'first');
% % select only data from the high and low effort groups in the first visit
% pg = paramlist(:,1:ic-1);
% for i = 1:4
%     [p,tab] = anova1(pg(i,:),paramgrp(1:ic-1))
% end
% isv = find(strcmp('lsecond',paramgrp),1,'first');
