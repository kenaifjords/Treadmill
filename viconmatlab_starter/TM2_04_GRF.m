% TM2_04_GRF
tic
global F p asym subject
clear brake push impulse
normtobodyweight = 1;
normtoslowbaseline = 0;
dt = 1/100;
dir_list = {'x' 'y' 'z'};
grp_list = {'hfirst' 'lfirst' 'control' 'hsecond' 'lsecond'};
fs_list  = {'f' 's'};
nstrd = 20;
learn_indices = [1 5; 6 30; 31 200];
nplat = 30;
nepoch = size(learn_indices,1) + 1;
%% prepare force data 
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2)
            if ~isempty(F(subj).R{effcond,blk})
                % load other variables that we need to chop the force
                % profiles into individual steps
                time = F(subj).time{effcond,blk};
                hsR = F(subj).hsR{effcond,blk};
                hsL = F(subj).hsL{effcond,blk};
                rfirst = F(subj).rfirst{effcond,blk};
                rvalid = F(subj).validstepR{effcond,blk};
                lvalid = F(subj).validstepL{effcond,blk};
                
                for dir = 1:3 % x, y, z
                    clear fr fl sdr sdl sdr0 sdl0
                    fr = F(subj).R{effcond,blk}(:,dir);
                    fl = F(subj).L{effcond,blk}(:,dir);
                    % here is where we add normalization
                    if normtobodyweight
                        fr = fr./subject.bodyweight(subj);
                        fl = fl./subject.bodyweight(subj);
                    end
                    % get stride data
                    if ~isempty(hsR) && ~isempty(hsL)
                        if dir == 2
                            [impR,impL] = getStepImpulse(fr,fl,time,hsR,hsL);
                        end
                        % could resampleToPercentGait or toPercentStance
                        [sdr,sdl] = resampleToPercentGait(fr,fl,time,hsR,hsL);
                        % sort fastleg and slow leg
                        if subject.fastleg(subj) == 1
                            sdf = sdr; sds = sdl;
                            if dir == 2
                                impF = impR; impS = impL;
                            end
                        else
                            sds = sdr; sdf = sdl;
                            if dir == 2
                                impF = impL; impS = impR;
                            end
                        end                            
                        
                        F(subj).strideforce(dir).fast{effcond,blk} = sdf;
                        F(subj).strideforce(dir).slow{effcond,blk} = sds;
                        if dir == 2
                            F(subj).impulsefast{effcond,blk} = impF;
                            F(subj).impulseslow{effcond,blk} = impS;
                        end
                    end
                end
            end
        end
    end
end
%% PROPULSION IN BASELINE
clear fx fy fz
% get mean force profile for each subject in the baseline blocks
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2)
            for dir = 1:3
                sdf = F(subj).strideforce(dir).fast{effcond,blk};
                sds = F(subj).strideforce(dir).slow{effcond,blk};
                if ~isempty(sdf) && ~isempty(sds) 
                    % concatenate and average for tied blocks
                    sd = [sdf; sds];
                    sdmax = max(sd,[],2);
                    sdmin = min(sd,[],2);
                    push = sd; push(push < 0) = NaN;
                    impsz = min([size(F(subj).impulsefast{effcond,blk},1),...
                        size(F(subj).impulseslow{effcond,blk},1)]);
                    imp0 = [F(subj).impulsefast{effcond,blk}(1:impsz)';...
                        F(subj).impulseslow{effcond,blk}(1:impsz)'];
                    
                    % average
                    sdavg = mean(sd,1,'omitnan');
                    minf = mean(sdmin,'omitnan');
                    peakf = mean(sdmax,'omitnan');
                    
                    imp = mean(imp0,'all','omitnan');
                    % store
                    if dir == 1
                        forcestride.x{effcond,blk}(subj,:) = sdavg;
                    elseif dir == 2
                        forcestride.y{effcond,blk}(subj,:) = sdavg;
                        forcestride.ypush{effcond,blk}(subj,1) = peakf;
                        forcestride.ybrake{effcond,blk}(subj,1) = minf;
                        forcestride.yimp{effcond,blk}(subj,1) = imp;
                    else
                        forcestride.z{effcond,blk}(subj,:) = sdavg;
                        forcestride.zpeak{effcond,blk}(subj,1) = peakf;
                    end
                end
            end
        end
    end
end
%% sort by visit order
[fx] = sortbyEffortVisitorder2(forcestride.x);
[fy] = sortbyEffortVisitorder2(forcestride.y);
[fz] = sortbyEffortVisitorder2(forcestride.z);

[pkfy] = sortbyEffortVisitorder2(forcestride.ypush);
[imp] = sortbyEffortVisitorder2(forcestride.yimp);
[brk] = sortbyEffortVisitorder2(forcestride.ybrake);
[vert] = sortbyEffortVisitorder2(forcestride.zpeak);
%% compare 

%% FORCE PROFILES - plot - baseline comparison between groups
figure(30);
for dir = 1:3
    subplot(3,1,dir); hold on;
    for grp = 1:3 %length(grp_list)
        blk = 2; % fast
        f = eval(['f' dir_list{dir} '.' grp_list{grp} '{blk}']);
        plot_with_stderr(0,f,colors.all{grp,1})
        blk = 3; % slow
        f = eval(['f' dir_list{dir} '.' grp_list{grp} '{blk}']);
        plot_with_stderr_linetype(0,f,colors.all{grp,1},'--')
        ylabel([dir_list(dir) 'force (N/BW)']);
        xlabel('percent gait (dashed: slow baseline; solid: fast baseline')
    end
end
sgtitle('Baseline GRF')
beautifyfig
x0 = 10;
y0 = 50;
[width,height] = get_pxLegion(getcm(4),getcm(6));
set(gcf,'position',[x0,y0,width,height])
% compare baseline peak force in braking and push off
%% BASELINE PEAK BRAKING generate sorted matrix
pkbrk = NaN(max(subject.ncond),length(grp_list));
i = 1;
for blk = [2 3]
    for grp = 1:length(grp_list)
        pkbrk(1:subject.ncond(grp),grp) = eval(['brk.' grp_list{grp} '{blk}']);
    end
    figure(300); subplot(2,3,i); hold on;
    getBarPlot_groupsorted(pkbrk,['braking force in baseline: blk '...
        num2str(blk)],[-0.5 0]);
    % ANOVA between high, low, control
    ppush = anova1(pkbrk(:,1:3),grp_list(1,1:3),'off');
    text(0.5,-0.35,['one-way ANOVA: p = ' num2str(ppush)])
    % pairwise hihg low
    [~,pt] = ttest2(pkbrk(:,1),pkbrk(:,2));
    text(0.5,-0.3,['ttest high-low: p = ' num2str(pt)])
    % pairwise hihg control
    [~,pt] = ttest2(pkbrk(:,1),pkbrk(:,3));
    text(0.5,-0.25,['ttest high-control: p = ' num2str(pt)])
    % pairwise hihg low
    [~,pt] = ttest2(pkbrk(:,3),pkbrk(:,2));
    text(0.5,-0.2,['ttest control-low: p = ' num2str(pt)])
    i = 4;
end
ylabel('peak braking in slow base')% x0 = 10;
% y0 = 50;
% width = 450;
% height = 250;
% set(gcf,'position',[x0,y0,width,height])
%% BASELINE PEAK PUSHOFF generate sorted matrix
pkpush = NaN(max(subject.ncond),length(grp_list));
i = 2;
for blk = [2 3]
    for grp = 1:length(grp_list)
        pkpush(1:subject.ncond(grp),grp) = eval(['pkfy.' grp_list{grp} '{blk}']);
    end
    figure(300); subplot(2,3,i); hold on;
    getBarPlot_groupsorted(pkpush,['peak push off force in baseline: blk '...
        num2str(blk)],[0 0.5]);
    % ANOVA between high, low, control
    ppush = anova1(pkpush(:,1:3),grp_list(1,1:3),'off');
    text(0.5,0.25,['one-way ANOVA: p = ' num2str(ppush)])
    % pairwise hihg low
    [~,pt] = ttest2(pkpush(:,1),pkpush(:,2));
    text(0.5,0.3,['ttest high-low: p = ' num2str(pt)])
    % pairwise hihg control
    [~,pt] = ttest2(pkpush(:,1),pkpush(:,3));
    text(0.5,0.35,['ttest high-control: p = ' num2str(pt)])
    % pairwise hihg low
    [~,pt] = ttest2(pkpush(:,3),pkpush(:,2));
    text(0.5,0.4,['ttest control-low: p = ' num2str(pt)])
    i = 5;
end
ylabel('peak push off in slow base')% x0 = 10;
% y0 = 50;
% width = 450;
% height = 250;
% set(gcf,'position',[x0,y0,width,height])
%% BASELINE IMPULSE
pushimp = NaN(max(subject.ncond),length(grp_list));
 i = 3;
for blk = [2 3]
    for grp = 1:length(grp_list)
        pushimp(1:subject.ncond(grp),grp) = eval(['imp.' grp_list{grp} '{blk}']);
    end
    figure(300); subplot(2,3,i); hold on;
    getBarPlot_groupsorted(pushimp,['push impulse in baseline: blk '...
        num2str(blk)],[0 0.05]);
    % ANOVA between high, low, control
    ppush = anova1(pushimp(:,1:3),grp_list(1,1:3),'off');
    text(0.5,0.01,['one-way ANOVA: p = ' num2str(ppush)])
    % pairwise hihg low
    [~,pt] = ttest2(pushimp(:,1),pushimp(:,2));
    text(0.5,0.025,['ttest high-low: p = ' num2str(pt)])
    % pairwise hihg control
    [~,pt] = ttest2(pushimp(:,1),pushimp(:,3));
    text(0.5,0.03,['ttest high-control: p = ' num2str(pt)])
    % pairwise hihg low
    [~,pt] = ttest2(pushimp(:,3),pushimp(:,2));
    text(0.5,0.035,['ttest control-low: p = ' num2str(pt)])
    i = 6;
end
x0 = 10;
y0 = 50;
[width,height] = get_pxLegion(getcm(6),getcm(3));
set(gcf,'position',[x0,y0,width,height])
ylabel('push off impulse in slow base')
% baseline comparison within subjects that completed both conditions
%% BASELINE VERTICAL GRF
peakvert = NaN(max(subject.ncond),length(grp_list));
 i = 1;
for blk = [2 3]
    for grp = 1:length(grp_list)
        peakvert(1:subject.ncond(grp),grp) = eval(['vert.' grp_list{grp} '{blk}']);
    end
    figure(301); subplot(2,3,i); hold on;
    getBarPlot_groupsorted(peakvert,['peak zGRF in baseline: blk '...
        num2str(blk)],[0 2]);
    % ANOVA between high, low, control
    ppeakvert = anova1(peakvert(:,1:3),grp_list(1,1:3),'off');
    text(0.5,1,['one-way ANOVA: p = ' num2str(ppush)])
    % pairwise hihg low
    [~,pt] = ttest2(peakvert(:,1),peakvert(:,2));
    text(0.5,0.75,['ttest high-low: p = ' num2str(pt)])
    % pairwise hihg control
    [~,pt] = ttest2(peakvert(:,1),peakvert(:,3));
    text(0.5,0.5,['ttest high-control: p = ' num2str(pt)])
    % pairwise hihg low
    [~,pt] = ttest2(peakvert(:,3),peakvert(:,2));
    text(0.5,0.25,['ttest control-low: p = ' num2str(pt)])
    i = 4;
end
x0 = 10;
y0 = 50;
[width,height] = get_pxLegion(getcm(6),getcm(3));
set(gcf,'position',[x0,y0,width,height])
ylabel('vertical peak force in slow base')
% baseline comparison within subjects that completed both conditions

%% PROPULSION IN LEARNING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compare propulsion during learning
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2)
            if ~isempty(F(subj).R{effcond,blk})
                % load other variables that we need to chop the force
                % profiles into individual steps
                time = F(subj).time{effcond,blk};
                hsR = F(subj).hsR{effcond,blk};
                hsL = F(subj).hsL{effcond,blk};
                rfirst = F(subj).rfirst{effcond,blk};
                rvalid = F(subj).validstepR{effcond,blk};
                lvalid = F(subj).validstepL{effcond,blk};
                
                for dir = 1:3 % x, y, z
                    clear fr fl sdr sdl sdr0 sdl0
                    fr = F(subj).R{effcond,blk}(:,dir);
                    fl = F(subj).L{effcond,blk}(:,dir);
                    % here is where we add normalization
                    if normtobodyweight
                        fr = fr./subject.bodyweight(subj);
                        fl = fl./subject.bodyweight(subj);
                    end
                    % get stride data
                    if ~isempty(hsR) && ~isempty(hsL)
                        % could resampleToPercentGait or toPercentStance
                        [sdr,sdl] = resampleToPercentStance(fr,fl,time,hsR,hsL);
                        % sort fastleg and slow leg
                        if subject.fastleg(subj) == 1
                            sdf = sdr; sds = sdl;
                        else
                            sds = sdr; sdf = sdl;
                        end                            
                        
                        F(subj).strideforce(dir).stancefast{effcond,blk} = sdf;
                        F(subj).strideforce(dir).stanceslow{effcond,blk} = sds;
                    end
                end
            end
        end
    end
end
% get mean force profile for each subject in the baseline blocks
for i = 1:nepoch % 1:floor(sdsz/nstrd)
    epoch = i;
    for subj = 1:subject.n
        for effcond = 1:size(F(subj).R,1)
            for blk = 1:size(F(subj).R,2)
                for dir = 1:3
                    j = 1;
                    sdf = F(subj).strideforce(dir).stancefast{effcond,blk};
                    sds = F(subj).strideforce(dir).stanceslow{effcond,blk};
                    if dir == 1 % absolute value of mediolateral forces
                        sdf = abs(sdf);
                        sds = abs(sds);
                    end
                    if ~isempty(sdf) && ~isempty(sds) 
                        % generate an average curve for every nstrd strides
                        sdsz = min(size(sdf,1),size(sds,1));

                        if i < nepoch && learn_indices(i,2) < sdsz
                            idx = learn_indices(i,1):learn_indices(i,2);
                        elseif i < nepoch && learn_indices(i,2) > sdsz
                            idx = NaN;
                        else
                            %get plateau -last
                            if sdsz <= nplat
                                idx = 1:sdsz;
                            else
                                idx = sdsz-nplat:sdsz;
                            end
                        end
                        clear sdfavg sdsavg
                        if ~isnan(idx)
                            sdfavg = mean(sdf(idx,:),1,'omitnan');
                            sdsavg = mean(sds(idx,:),1,'omitnan');

                            if dir == 1
                                forcestride.xf{effcond,blk}(subj,:) = sdfavg;
                                forcestride.xs{effcond,blk}(subj,:) = sdsavg;
                            elseif dir == 2
                                forcestride.yf{effcond,blk}(subj,:) = sdfavg;
                                forcestride.ys{effcond,blk}(subj,:) = sdsavg;
                               forcestride.ypushf{effcond,blk}{subj,1} = peakf;
        %                         forcestride.ypushs{effcond,blk}{subj,1} = peaks;
                            else
                                forcestride.zf{effcond,blk}(subj,:) = sdfavg;
                                forcestride.zs{effcond,blk}(subj,:) = sdsavg;
                            end
                        end
                    end
    %                     peakf = max(sdf,[],2);
    %                     peaks = max(sds,[],2);                    
                end
            end
        end
    end
    [fx(1,epoch)] = sortbyEffortVisitorder2(forcestride.xf);
    [fx(2,epoch)] = sortbyEffortVisitorder2(forcestride.xs);
    [fy(1,epoch)] = sortbyEffortVisitorder2(forcestride.yf);
    [fy(2,epoch)] = sortbyEffortVisitorder2(forcestride.ys);
    [fz(1,epoch)] = sortbyEffortVisitorder2(forcestride.zf);
    [fz(2,epoch)] = sortbyEffortVisitorder2(forcestride.zs);    
end
%% plot for learning blocks
line_list = {'-','-.','--',':'};
for dir = 1:3
    for grp = 1:3 %length(grp_list)
        ei = 1;
        for epoch = [1 size(learn_indices,1) + 1] % initial and final only
            figure(34); subplot(3,1,dir); hold on;
            blk = 4;
            % fast
            ff = eval(['f' dir_list{dir} '(1,' num2str(epoch) ').' grp_list{grp} '{blk}']);
            plot_with_stderr_linetype(0,ff,colors.all{grp,1},line_list{ei})
            % slow
            ei = ei + 1;
            fs = eval(['f' dir_list{dir} '(2,' num2str(epoch) ').' grp_list{grp} '{blk}']);
            plot_with_stderr_linetype(0,fs,colors.all{grp,1},line_list{ei})
            ylabel([dir_list(dir) 'force (N/kg BW)']);
            xlabel('percent stance')
            ei = ei + 1;
        end
    end
end
beautifyfig
x0 = 10;
y0 = 50;
[width,height] = get_pxLegion(getcm(4),getcm(6));
set(gcf,'position',[x0,y0,width,height])
%% plot for learning blocks  compare groups
line_list = {'-','-.','--',':'};
for dir = 1:3
    for grp = 1:3 %length(grp_list)
        ei = 1;
        for epoch = 1:4% [1 size(learn_indices,1) + 1] % initial and final only
            figure(dir); subplot(1,4,ei); hold on;
            blk = 4;
            % fast
            ff = eval(['f' dir_list{dir} '(1,' num2str(epoch) ').' grp_list{grp} '{blk}']);
            plot_with_stderr_linetype(0,ff,colors.all{grp,1},'-')
            xlabel('percent stance')
            ylabel(['grf (N/BW) bin ' num2str(epoch)])
            ei = ei + 1;
            if dir == 2
                ylim([-0.25,0.25]);
            elseif dir == 3
                ylim([0 1.6]);
            else
                ylim([0 0.15])
            end
        end
        ei = 1;
        for epoch = 1:4
            % slow
            subplot(1,4,ei); hold on;
            fs = eval(['f' dir_list{dir} '(2,' num2str(epoch) ').' grp_list{grp} '{blk}']);
            plot_with_stderr_linetype(0,fs,colors.all{grp,1},'--')
            ylabel([dir_list(dir) 'force (N/kg BW)']);
            xlabel('percent stance')
            ylabel(['grf (N/BW) bin ' num2str(epoch)])
            ei = ei + 1;
            if dir == 2
                ylim([-0.25,0.25]);
            elseif dir == 3
                ylim([0 1.6]); 
            else
                ylim([0 0.15]);
            end
        end
    end
    beautifyfig
    x0 = 10;
    y0 = 50;
    [width,height] = get_pxLegion(getcm(12),getcm(6));
    set(gcf,'position',[x0,y0,width,height])
end

%%

toc