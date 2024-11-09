% fitparameterbarplots

grp_list = {'hfirst','lfirst','control','hsecond','lsecond'};
%% Exponential fit
ex_title = {'coefficient','learning rate','constant'};

for iparam = [1 2 3]
    clear c
    sz = max([length(subject.hfirst),length(subject.lfirst),...
        length(subject.control)]);
    c = NaN(sz,5);
    for grp = 1:length(grp_list)
        cin = eval(['curvefit(iparam).ex.' grp_list{grp} '{1,blk}'])';
        mn = nanmean(cin); sd3 = 3 * nanstd(cin);
        cin(cin > mn + sd3) = NaN;
        cin(cin < mn - sd3) = NaN;
        c(1:length(cin),grp) = cin;
    end
    figure(fnum); subplot(2,6,iparam+9); hold on;
    getBarPlot_visit1(c,ex_title{iparam},ex_ylim(iparam,:))
    ylabel(ex_title{iparam});
end
subplot(2,6,11); title('Exponential fit parameters')

%% State space fit
ss_title = {'remembering factor','learning rate','initial value'};
includeparam = [1 2 4];
for iparam = includeparam
    clear c
    c = NaN(sz,5);
    for grp = 1:length(grp_list)
        cin = [eval(['curvefit(iparam).ss.' grp_list{grp} '{1,blk}'])]';
        % remove outliers
        mn = mean(cin); sd3 = 3*std(cin);
        cin(cin > mn + sd3) = NaN;
        cin(cin < mn - sd3) = NaN;
        c(1:length(cin),grp) = cin;
    end
    figure(fnum); subplot(2,6,find(includeparam == iparam) + 3); hold on;
    getBarPlot_visit1(c,ss_title{find(includeparam == iparam)},...
        [ss_ylim(find(includeparam == iparam),:)])
    ylabel(ss_title{find(includeparam == iparam)});
end
subplot(2,6,5); title('State space fit parameters')

%%
for i = [31 8 33]
    figure(i);
    x0 = 10;
    y0 = 100;
    width = 1200;
    height = 375;
    set(gcf,'position',[x0,y0,width,height])
end