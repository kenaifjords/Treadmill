% TM2_07_accessexpfits
homepath = pwd;
cd('bootstrap_data');
for i = 1:4 %4 %1:3
    sef = load(['singleexponentialfit_nboot1000_0' num2str(i) '.mat']);
%     def = load(['doubleexponentialfit_nboot1000_0' num2str(i) '.mat']);
    sexp0(:,(1000*(i-1)+1):1000*i,:) = squeeze(sef.singleexpfit(:,:,:,1:3));
%     dexp0(:,(1000*(i-1)+1):1000*i,:) = squeeze(def.doubleexpfit(:,:,:,1:5));
end
effcondlabel = {'high' 'low' 'control'};
nbin = 20;
% the files have the bootstrap fits indexed as effort condition, block
% index (index 1 = blk 4), bootloop, parameter index
% right now, we are only looking at blk 4, so lets squeeze to 3d
% sexp = squeeze(sexp0(:,1,:,:)); %sef.singleexpfit);
% this squeeze is already covered in the load
sexp = sexp0;
% dexp = squeeze(def.doubleexpfit);
% for the single fit
sparamlabel = {'coef','exponent','offset'};
% % for the double fit
% dparamlabel = {'coef1', 'exp1', 'coef2', 'exp2', 'offset'};


for effcond = 1:3  %effcond
    figure(43); subplot(3,1,effcond); hold on;
    ylabel(effcondlabel{effcond})
    xlim([-0.6 0])
    for parami = 1:length(sparamlabel)
        histogram(sexp(effcond,:,parami),nbin);
        plot([median(sexp(effcond,:,parami)) median(sexp(effcond,:,parami))],...
            [0 250],'k--','HandleVisibility','off')
    end
end
legend(sparamlabel)

%% estimate standard error of the mean
for effcond = 1:3  %effcond
   for parami = 1:length(sparamlabel)
       disp([effcondlabel{effcond},' ', sparamlabel{parami}, ': '])
       disp([num2str(mean(sexp(effcond,:,parami))),' +/- ' num2str(std(sexp(effcond,:,parami))), '(SE)'])
       % get confidence intervals
       ts = tinv([0.025  0.975],size(sexp,2)-1);      % T-Score
       CI =   mean(sexp(effcond,:,parami)) + ts*std(sexp(effcond,:,parami));
       disp(['[ ' num2str(CI) ' ]'])
       
       figure(67); subplot(3,1,parami);hold on;
       title(sparamlabel(parami));
       plot(CI,[effcond effcond],'Color',colors.all{effcond,1});
       ylim([0.5 3.5])
   end
end
beautifyfig
% for effcond = 1:3  %effcond
%     figure(34); subplot(3,1,effcond); hold on;
%     for parami = 1:length(dparamlabel)
%         histogram(dexp(effcond,:,parami),nbin);
%         plot([median(dexp(effcond,:,parami)) median(dexp(effcond,:,parami))],...
%             [0 250],'k--','HandleVisibility','off')
%     end
% end
% legend(dparamlabel)
cd(homepath)
%% stats
% single exponential
% % anova across coefficient fit parameter
% [p,tab,astat] = anova1(singleexp(:,:,1)');
% p_scoef = p
% % anova across expoential fit parameter
% [p,tab,astat] = anova1(singleexp(:,:,2)');
% p_sexp = p
% % anova across constant offset fit parameter
% [p,tab,astat] = anova1(singleexp(:,:,3)');
% p_sconst = p
