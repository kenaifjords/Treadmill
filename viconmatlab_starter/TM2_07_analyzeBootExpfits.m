% TM2_07_accessexpfits
for i = 4 %1:3
    sef = load(['singleexponentialfit_nboot1000_0' num2str(i) '.mat']);
    def = load(['doubleexponentialfit_nboot1000_0' num2str(i) '.mat']);
    singleexp(:,(1000*(i-1)+1):1000*i,:) = squeeze(sef.singleexpfit);
    doubleexp(:,(1000*(i-1)+1):1000*i,:) = squeeze(def.doubleexpfit);
end
effcondlabel = {'high' 'low' 'control'};
nbin = 20
% the files have the bootstrap fits indexed as effort condition, block
% index (index 1 = blk 4), bootloop, parameter index
% right now, we are only looking at blk 4, so lets squeeze to 3d
singleexp = squeeze(sef.singleexpfit);
doubleexp = squeeze(def.doubleexpfit);
% for the single fit
sparamlabel = {'coef','exponent','offset'};
% for the double fit
dparamlabel = {'coef1', 'exp1', 'coef2', 'exp2', 'offset'};


for effcond = 1:3  %effcond
    figure(43); subplot(3,1,effcond); hold on;
    ylabel(effcondlabel{effcond})
    xlim([-0.6 0])
    for parami = 1:length(sparamlabel)
        histogram(singleexp(effcond,:,parami),nbin);
        plot([median(singleexp(effcond,:,parami)) median(singleexp(effcond,:,parami))],...
            [0 250],'k--','HandleVisibility','off')
    end
end
legend(sparamlabel)

for effcond = 1:3  %effcond
    figure(34); subplot(3,1,effcond); hold on;
    for parami = 1:length(dparamlabel)
        histogram(doubleexp(effcond,:,parami),nbin);
        plot([median(doubleexp(effcond,:,parami)) median(doubleexp(effcond,:,parami))],...
            [0 250],'k--','HandleVisibility','off')
    end
end
legend(dparamlabel)

%% stats
% single exponential
% anova across coefficient fit parameter
[p,tab,astat] = anova1(singleexp(:,:,1)');
p_scoef = p
% anova across expoential fit parameter
[p,tab,astat] = anova1(singleexp(:,:,2)');
p_sexp = p
% anova across constant offset fit parameter
[p,tab,astat] = anova1(singleexp(:,:,3)');
p_sconst = p
