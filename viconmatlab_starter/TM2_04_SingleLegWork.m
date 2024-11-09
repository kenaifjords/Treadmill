% TM2_04_SingleLegWork
tic
global F p asym subject
normtobodyweight = 1;
normtoslowbaseline = 0;

dt = 1/100;
dir_list = {'x' 'y' 'z'};
grp_list = {'hfirst' 'lfirst' 'control' 'hsecond' 'lsecond'};
fs_list  = {'f' 's'};
nstrd = 20;
learn_indices = [1 5; 6 30; 31 200];

%% prepare force data 
for subj = 1:subject.n
    smass = subject.mass(subj);
    g = 9.81; % m/s^2
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2)
            clear powR_body powL_body powF_body powS_body powF_tm powS_tm
            if ~isempty(F(subj).R{effcond,blk})
                % load other variables that we need to chop the force
                % profiles into individual steps
                time = F(subj).time{effcond,blk};
                ihsR = F(subj).hsR_idx{effcond,blk};
                ihsL = F(subj).hsL_idx{effcond,blk};
                rfirst = F(subj).rfirst{effcond,blk};
                rvalid = F(subj).validstepR{effcond,blk};
                lvalid = F(subj).validstepL{effcond,blk};
                fR = F(subj).R{effcond,blk};
                fL = F(subj).L{effcond,blk};
                fRz = fR(:,3); fLz = fL(:,3);
                % subtract force from body weight from the z direction
                % forces (see Tesio 2010)
                fRz(fRz < g * smass) = 0;
                fRz(fRz > 0) = fRz(fRz > 0) - (g * smass);
                fLz(fLz < g * smass) = 0;
                fLz(fLz > 0) = fLz(fLz > 0) - (g * smass);
                % replace measured z forces
                fR(:,3) = fRz; fL(:,3) = fLz;
                % z forces are measured as negative on the treadmill
%                 fR(:,3) = - fR(:,3); 
%                 fL(:,3) = - fL(:,3);
                
                % find single leg work (mechanical power of leg on body
                % + mechanical power of leg on treadmill)
                if ~isempty(ihsR) && ~isempty(ihsL)
                    % determine the minimum number of heel strikes
                    minhs = min([size(rvalid,1) size(lvalid,1)]);
                    % instaneous power (leg on body)
                    for i = 1:minhs-1 % each stride
                        % get grf for the individual stride
                        sfr = fR(ihsR(i):ihsR(i+1),:);
                        sfl = fL(ihsR(i):ihsR(i+1),:);
                        aCOMr = (sfr + sfl)/smass;
                        clear sfr sfl
                        sfr = fR(ihsL(i):ihsL(i+1),:);
                        sfl = fL(ihsL(i):ihsL(i+1),:);
                        aCOMl = (sfr + sfl)/smass;
                        clear sfr sfl
                        % find the center of mass velocity (summed ground
                        % reaction forces = COM acceleration -> integrate)
                        for dir = 1:3
                            vCOMr(dir) = trapz(aCOMr(:,dir));
                            vCOMl(dir) = trapz(aCOMl(:,dir));
                        end
                        clear aCOMr aCOMl
                        % instantaneous power (leg -> body)
                        powR_body = fR(ihsR(i):ihsR(i+1),:) * vCOMr';
                        powL_body = fL(ihsL(i):ihsL(i+1),:) * vCOMl';
                    
                        if subject.fastleg == 1
                            powF_body = powR_body; powS_body = powL_body;
                        else
                            powF_body = powL_body; powS_body = powR_body;
                        end
                    % instantaneous power (leg -> treadmill)

                        % sort fast and slow leg
                        if subject.fastleg == 1
                            fF = fR(ihsR(i):ihsR(i+1),:);
                            fS = fL(ihsL(i):ihsL(i+1),:);
                        else
                            fS = fR(ihsR(i):ihsR(i+1),:);
                            fF = fL(ihsL(i):ihsL(i+1),:);
                        end
                        powF_tm = -fF * [0 -1.5 0]';
                        powS_tm = -fS * [0 -0.5 0]';
                   
                        % total instantaneous power
                        powF = powF_body + powF_tm;
                        powS = powS_body + powS_tm;
                        
                        % get total positive work by integrating power over
                        % the duration of positive anterior posterior force
                        w_pos = trapz(powF .* (fF(:,2) > 0)) * dt;
                        % get total negative work by integrating power over
                        % the duration of negative anterior posterior force
                        w_neg = trapz(powS .* (fS(:,2) < 0)) * dt;
                        
                    end
                end
            end
        end
    end
end


%% calculate COM velocity, power, and work
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2)
            clear COM vCOM wF_pos wS-pos wF_neg wS_neg powr powf pows powl
            if ~isempty(F(subj).R{effcond,blk}) &&...
                    ~isempty(F(subj).hsR{effcond,blk})
                % load other variables that we need to chop the force
                % profiles into individual steps
                time = F(subj).time{effcond,blk};
                hsR = F(subj).hsR{effcond,blk};
                hsL = F(subj).hsL{effcond,blk};
                rfirst = F(subj).rfirst{effcond,blk};
                rvalid = F(subj).validstepR{effcond,blk};
                lvalid = F(subj).validstepL{effcond,blk};
                
                % estimate COM as point in between L and R anterior
                % superior iliac spine so vector is the average of the
                % two positions
                Lasis = p(subj).Lasis{effcond,blk};
                Rasis = p(subj).Rasis{effcond,blk};
                COM0 = Lasis + Rasis ./ 2;
                % get velocity
                for dir = 1:3
                    com0 = COM0(:,dir);
                    com0(isnan(com0)) = 0;
                    comva = diff23f5(com0,dt,10);
                    comva(comva == 0) = NaN;
                    COM(:,dir) = comva(:,1);
                    vCOM(:,dir) = comva(:,2);
                end
                % calculate power (F * vCOM)
                fr = F(subj).R{effcond,blk};
                fl = F(subj).L{effcond,blk};
                % here is where we add normalization
                if normtobodyweight
                    fr = fr./subject.bodyweight(subj);
                    fl = fl./subject.bodyweight(subj);
                end
                % compare sizes
                datlength = min(size(fl,1),size(vCOM,1));
                % trim
                fl = fl(1:datlength,:); fr = fr(1:datlength,:);
                vCOM = vCOM(1:datlength,:);
                % calculate power (force * velocity)
                powL0 = fl .* vCOM;
                powR0 = fr .* vCOM;
                powL = sum(powL0,2);
                powR = sum(powR0,2);
                % divide into strides
                [powr,powl] = resampleToPercentGait(powR,powL,time,hsR,hsL);
                % sort into fast and slow              
                if subject.fastleg(subj) == 1
                    powf = powr; pows = powl;
                else
                    pows = powr; powf = powl;
                end
                % compute work (integration of power) with positive work
                % taking only positive parts of the integrand and the
                % opposite for negative work
                wF_pos = sum(powf(powf > 0),2)*dt;
                wS_pos = sum(pows(pows > 0),2)*dt;
                wF_neg = sum(powf(powf < 0),2)*dt;
                wS_neg = sum(pows(pows < 0),2)*dt;
                datlength = min([size(wF_pos,1),size(wS_pos,1),...
                    size(wF_neg,1),size(wS_neg,1)]);
                PW(subj).work{effcond,blk} = cat(2,wF_pos(1:datlength),...
                    wS_pos(1:datlength),wF_neg(1:datlength),...
                    wS_neg(1:datlength));
                PW(subj).powerFast{effcond,blk} = powf;
                PW(subj).powerSlow{effcond,blk} = pows;
            end
        end
    end
end

%% Single Leg Power in BASELINE
% get mean force profile for each subject in the baseline blocks
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2)
            sdf = PW(subj).powerFast{effcond,blk};
            sds = PW(subj).powerSlow{effcond,blk};
            if ~isempty(sdf) && ~isempty(sds)
                % get first leading leg
                hsR = F(subj).hsR{effcond,blk};
                hsL = F(subj).hsL{effcond,blk};
                hslength = min(length(hsR),length(hsL))-1;
                if hsR(1) > hsL(1)
                    ll = 1; % first step is right foot
                else
                    ll = 2; % first step is left foot
                end
                % determine steps on which each leg is the leading leg
                if ll == 1 % right leg is first
                    llR = 1:2:hslength;
                    llL = 2:2:hslength;
                else
                    llR = 2:2:hslength;
                    llL = 1:2:hslength;
                end
                % get strides when the fast leg is leadiing
                 if subject.fastleg == 1
                     fastlead = sdf(llR,:);
                     slowtrail = sds(llL,:);
                     fasttrail = sdf(llL,:);
                     slowlead = sds(llR,:);
                 else
                     fastlead = sdf(llL,:);
                     slowtrail = sds(llR,:);
                     fasttrail = sdf(llR,:);
                     slowlead = sds(llL,:);
                 end
                % concatenate and average for tied blocks
                sdlead = [fastlead; slowlead];
%                 sdmax = max(sdlead,[],2);
%                 sdmin = min(sdlead,[],2);
                sdtrail = [fasttrail; slowtrail];
%                 sdmax = max(sdtrail,[],2);
%                 sdmin = min(sdtrail,[],2);
                % average
                powlead = mean(sdlead,1,'omitnan');
                powtrail = mean(sdtrail,1,'omitnan');
                % store
%                 powerf0{effcond,blk}(subj,:) = mean(sdf);
%                 powers0{effcond,blk}(subj,:) = mean(sds);
                powerlead0{effcond,blk}(subj,:) = powlead;
                powertrail0{effcond,blk}(subj,:) = powtrail;
            end
        end
    end
end
% % sort by visit order
% [powerf] = sortbyEffortVisitorder2(powerf0);
% [powers] = sortbyEffortVisitorder2(powers0);
[powerlead] = sortbyEffortVisitorder2(powerlead0);
[powertrail] = sortbyEffortVisitorder2(powertrail0);
% power plot - baseline comparison between groups
%%
figure(80); hold on;
for grp = 1:3 %length(grp_list)
    blk = 2; % fast
    f = eval(['powerlead.' grp_list{grp} '{blk}']);
    plot_with_stderr(0,f,colors.all{grp,1})
    f = eval(['powertrail.' grp_list{grp} '{blk}']);
    plot_with_stderr_linetype(0,f,colors.all{grp,2},'--')
    blk = 3; % slow
    f = eval(['powerlead.' grp_list{grp} '{blk}']);
    plot_with_stderr_linetype(0,f,colors.all{grp,1},'-.')
    f = eval(['powertrail.' grp_list{grp} '{blk}']);
    plot_with_stderr_linetype(0,f,colors.all{grp,2},':')
    ylabel(['Power (Ns/BW)']);
    xlabel('percent gait (dashed: slow baseline; solid: fast baseline')
end
sgtitle('Baseline power')
beautifyfig
x0 = 10;
y0 = 50;
width = 850;
height = 700;
set(gcf,'position',[x0,y0,width,height])
% compare baseline peak force in braking and push off
%% WORK IN BASELINE
figure(81);
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
sgtitle('peak braking')
% x0 = 10;
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
sgtitle('peak push off force')
% x0 = 10;
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
sgtitle('push off impulse')
x0 = 10;
y0 = 50;
width = 850;
height = 350;
set(gcf,'position',[x0,y0,width,height])
% baseline comparison within subjects that completed both conditions

%% PROPULSION IN LEARNING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compare propulsion during learning
% get mean force profile for each subject in the baseline blocks
for i = 1:size(learn_indices,1) + 1 % 1:floor(sdsz/nstrd)
    epoch = i;
    for subj = 1:subject.n
        for effcond = 1:size(F(subj).R,1)
            for blk = 1:size(F(subj).R,2)
                for dir = 1:3
                    j = 1;
                    sdf = F(subj).strideforce(dir).fast{effcond,blk};
                    sds = F(subj).strideforce(dir).slow{effcond,blk};
                    if ~isempty(sdf) && ~isempty(sds) 
                        % generate an average curve for every nstrd strides
                        sdsz = min(size(sdf,1),size(sds,1));
%                         if j + nstrd < sdsz
%                             idx = j:j+nstrd;
%                         else
%                             idx = j:sdsz;
%                         end
%                         j = j + nstrd;
                        if i <4 && learn_indices(i,2) < sdsz
                            idx = learn_indices(i,1):learn_indices(i,2);
                        elseif i <4 && learn_indices(i,2) > sdsz
                            idx = NaN;
                        else                            
                            idx = sdsz-30:sdsz;
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
%% sort
% sort by visit order
% [fx(1,epoch)] = sortbyEffortVisitorder2(forcestride.xf);
% [fx(2)] = sortbyEffortVisitorder2(forcestride.xs);
% [fy(1)] = sortbyEffortVisitorder2(forcestride.yf);
% [fy(2)] = sortbyEffortVisitorder2(forcestride.ys);
% [fz(1)] = sortbyEffortVisitorder2(forcestride.zf);
% [fz(2)] = sortbyEffortVisitorder2(forcestride.zs);
%% plot for learning blocks
line_list = {'-','-.','--',':'};
for dir = 2:3
    for grp = 1:3 %length(grp_list)
        ei = 1;
        for epoch = [1 size(learn_indices,1) + 1] % initial and final only
            figure(34); subplot(2,1,dir-1); hold on;
            blk = 4;
            % fast
            ff = eval(['f' dir_list{dir} '(1,' num2str(epoch) ').' grp_list{grp} '{blk}']);
            plot_with_stderr_linetype(0,ff,colors.all{grp,1},line_list{ei})
            % slow
            ei = ei + 1;
            fs = eval(['f' dir_list{dir} '(2,' num2str(epoch) ').' grp_list{grp} '{blk}']);
            plot_with_stderr_linetype(0,fs,colors.all{grp,1},line_list{ei})
            ylabel([dir_list(dir) 'force (N/kg BW)']);
            xlabel('percent gait (dashed: slow leg; solid: fast leg')
            ei = ei + 1;
        end
    end
end
beautifyfig
x0 = 10;
y0 = 50;
width = 850;
height = 700;
set(gcf,'position',[x0,y0,width,height])
%%
toc