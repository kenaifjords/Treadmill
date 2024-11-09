%% TM2_07_bootstrap the fits
% check if you have already loaded or generated the boostrap data
nboot = 10000;
reboot = 0;

if reboot
    clear boot_curve
    clear boot_param
else
    % load
    a = load('bootstrapped_param_29-Apr-2024.mat');
    b = load('bootstrapped_curve_fit_29-Apr-2024.mat');
    boot_param = a.boot_param;
    boot_curve = b.boot_curve;
    clear a b
end

grp_list = {'hfirst','lfirst','control','hsecond','lsecond'};

if ~exist('asym_all','var')
    [asym_all] = getAsym_all;
end
if ~exist('asym_sort','var')
    [asym_sort] = sortbyEffortVisitorder2(asym_all.steplength);
end

%% protocol 1: sample asym profiles
% protocol 1: select asymmetry profiles with replacement, average, fit
blkinclude = [4 6];
if ~exist('boot_curve','var')
    % generate bootstrapped data
    for b = 1:nboot
        for grp = 1:length(grp_list)
            for blk = blkinclude
                iblk = find(blkinclude == blk,1,'first');
                clear bc bcmat asymgrp
                asymgrp = eval(['asym_sort.' grp_list{grp} '{1,' num2str(blk) '}']);
                for i = 1:size(asymgrp,1)
                    % select a random index
                    irand = randi(size(asymgrp,1),1);
                    % save corresponding curve into a matrix
                    bcmat(i,:) = asymgrp(irand,:);   
                end
                % get mean curve for grp
                bc = mean(bcmat,1,'omitnan');
                
%                 % store the curves
%                 boot_avgasym.(grp_list{grp}){1,blk}(b,:) = bc;

                % fit the curve with a state space model
                x0 = [1, 0.01];
                [ss_fit_param, ~] = fitLearning0(bc,x0, zeros(1,length(bc)));
                ss_fit = [ss_fit_param mean(bc(1:5),'omitnan')];
                % store the ss fit parameters
                boot_curve.ss.(grp_list{grp}){1,iblk}(b,:) = ss_fit;
                
                % fit the curve with exponential model
                ex0 = [-0.4, 0.02, -0.05];
                [ex_fit, ~] = fitExpLearning0(bc,ex0);
                % store the exp fit parameters
                boot_curve.exp.(grp_list{grp}){1,iblk}(b,:) = ex_fit;
            
            end
        end
    end
end

%% protocol 2: sample curve fit parameters
% protocol 2: select fitted parameters with replacement, average
if ~exist('boot_param','var')
    for b = 1:nboot
        for grp = 1:length(grp_list)
            for blk = blkinclude
                iblk = find(blk == blkinclude,1,'first');
                clear ss_mat ex_mat

                % % state space
                alpha = eval(['curvefit(1).ss.' grp_list{grp} '{1,blk}']);
                beta = eval(['curvefit(2).ss.' grp_list{grp} '{1,blk}']);
                offset = eval(['curvefit(3).ss.' grp_list{grp} '{1,blk}']);
                initialval = eval(['curvefit(4).ss.' grp_list{grp} '{1,blk}']);
                for i = 1:size(asymgrp,1)
                    % select a random index
                    irand = randi(size(asymgrp,1),1);
                    % save corresponding curve fit parameters
                    ss_mat(i,:) = [alpha(irand) beta(irand) initialval(irand)];
                end
                % store state space
                boot_param.ss.(grp_list{grp}){1,iblk}(b,:) = mean(ss_mat,1,'omitnan');

                % % exponential
                coef = eval(['curvefit(1).ex.' grp_list{grp} '{1,blk}']);
                gain = eval(['curvefit(2).ex.' grp_list{grp} '{1,blk}']);
                const = eval(['curvefit(3).ex.' grp_list{grp} '{1,blk}']);
                for i = 1:size(asymgrp,1)
                    % select a random index
                    irand = randi(size(asymgrp,1),1);
                    % save corresponding curve fit parameters
                    exp_mat(i,:) = [coef(irand) gain(irand) const(irand)];
                end
                % store exponential
                boot_param.exp.(grp_list{grp}){1,iblk}(b,:) = mean(exp_mat,1,'omitnan');
            end
        end
    end
end

%% save
if reboot
    save(['bootstrapped_curve_fit_' date],'boot_curve')
    save(['bootstrapped_param_' date],'boot_param')
end

%% histograms
close all

boot_list = {'boot_curve','boot_param'};
fit_list = {'ss','exp'};
fit_title = {'alpha','beta','initialval'; 'coef','rate','const'};

for i = 1:length(boot_list)
    for j = 1:length(fit_list)
        for grp = 1:3 % to inlcude all groups with second visit, use 1:length(grp_list)
            for blk = 4 % blkinclude
                iblk = find(blk == blkinclude);
                dat = eval([boot_list{i} '.' fit_list{j} '.' grp_list{grp} '{1,' num2str(iblk) '}']);
                for k = 1:size(dat,2)
                    figure(i + (j - 1)*100); sgtitle([boot_list{i} ' ' fit_list{j}]);
                    subplot(2,3,k); hold on;
                    h = histogram(dat(:,k),'DisplayName',grp_list{grp});
                    h.FaceColor = colors.all{grp,1};
                    h.NumBins = 45;
                    title(fit_title{j,k})
                    legend
                    beautifyfig
                    % calculate confidence intervals (estimate standard
                    % error of the mean)
                    sdm = std(dat(:,k)); % standard error
                    ts = tinv([0.025 0.975],nboot - 1); % T-score
                    CI = mean(dat(:,k),'omitnan') + ts*sdm;
                    disp([boot_list{i} ' ' fit_list{j} ' ' fit_title{j,k} ...
                        ' ' grp_list{grp}, ' 95%CL: = [' ...
                        num2str(CI) ']']);
                    % plot confidence intervals
                    figure(i + (j - 1)*100);
                    sgtitle([boot_list{i} ' ' fit_list{j}]);
                    subplot(2,3,3+k); hold on;
                    plot(CI,[grp grp],'Color', colors.all{grp,1},...
                        'LineWidth',3,'DisplayName',grp_list{grp});
                    title(fit_title{j,k})
                    ylim([0 4])
                    legend
                    x0 = 10;
                    y0 = 100;
                    width = 1300;
                    height = 350;
                    set(gcf,'position',[x0,y0,width,height])
                    beautifyfig
                end
            end
        end
    end
end

