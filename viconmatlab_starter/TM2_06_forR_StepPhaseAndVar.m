% TM2_04R step metrics (grf too) and variances output for R
clear Rsm fmet_phase fmet_phasevar smet_phase smet_phasevar
colnames0 = {'subj','effortcondition','exposure','visit'};

for subj = 1:subject.n
    fastleg = subject.fastleg(subj);
    if fastleg == 1
        fl_label = 'R';
        sl_label = 'L';
    else
        fl_label = 'L';
        sl_label = 'R';
    end
    order = subject.order(subj,:);
    if order(2) == 0
        order = order(1);
    end
    if order(1) == 0
        order = 3;
    end
    for effcond = order
        for blk = 1:7
            % get each metric
            sl = cat(2,eval(['F(subj).steplength' fl_label '{effcond, blk}'])',...
                eval(['F(subj).steplength' sl_label '{effcond, blk}'])');
            st = cat(2,eval(['F(subj).steptime' fl_label '{effcond, blk}'])',...
                eval(['F(subj).steptime' sl_label '{effcond, blk}'])');
            sw = cat(2,eval(['F(subj).stepwidth' fl_label '{effcond, blk}'])',...
                eval(['F(subj).stepwidth' sl_label '{effcond, blk}'])');
            
            % match sizes for each metric
            
            % store in a matrix for easy looping to get phase and var
            stepdat = cat(2,sl,st,sw);
            
            % get phase and var data for each
            for i = 1:size(stepdat,2)
                [smet0,smetvar0] = getPhaseMeanAndVariability(stepdat(:,i));
                % store
                smet_phase(subj,effcond,blk,i,:) = smet0;
                smet_phasevar(subj,effcond,blk,i,:) = smetvar0;
            end
        end
    end
end
%%
smet_names = {'length_fast','length_slow','time_fast','time_slow',...
    'width_fast', 'width_slow'};
for i = 1:length(smet_names)
    smet_varnames{i} = strcat(smet_names{i},'var');
end
%% follow up checks from RM-ANOVA
if 0
    %% step time VARIANCE has main effects of baseline block and effort
    % condition
    % effort conditions 1:3, block 2:3, time is metric 3:4, we used the
    % across phase (5) for this comparison
    st = squeeze(smet_phasevar(:,:,2:3,3:4,5)); 
    % i used average step length since there was no difference in baseline
    % between fast and slow
    st = squeeze(mean(st,3));
    % sort into groups (these are now subj x first visit effort (1) x block
    st0 = squeeze(st(subject.order(:,1) == 0,3,:));
    sth = squeeze(st(subject.order(:,1) == 1,1,:));
    stl = squeeze(st(subject.order(:,1) == 2,2,:));
    % for each group compare between baseline groups (paired)
    [~,p_fastslowbase(3)] = ttest(st0(:,1),st0(:,2));
    [~,p_fastslowbase(1)] = ttest(sth(:,1),sth(:,2));
    [~,p_fastslowbase(2)] = ttest(stl(:,1),stl(:,2))
    % for each block between effort conditions
    paov(2) = anova1([st0(:,1),sth(:,1),stl(:,1)]); % fast baseline bkl 2
    paov(3) = anova1([st0(:,2),sth(:,2),stl(:,2)]) % fast baseline bkl 2
    %% step width variability has a main effect of effort condition of learning 
    % main effects of effort and phase
    swv = squeeze(smet_phasevar(:,:,4,5:6,1:4));
    % leg was nonsignificant in the RMAnova
    swv = squeeze(mean(swv,3));
    % we want to parse out effort conditions
    swvc = squeeze(swv(:,3,:));
    swvh = squeeze(swv(:,1,:));
    swvl = squeeze(swv(:,2,:));
    % look for any thing telltale
    figure(); hold on;
    plot_with_stderr(0,swvc(subject.order(:,1) == 0,:),colors.control);
    plot_with_stderr(0,swvh(subject.order(:,1) == 1,:),colors.high);
    plot_with_stderr(0,swvl(subject.order(:,1) == 2,:),colors.low)
    xlim([0.8 4.2]); xlabel('phase'); ylabel('SW variance (with stderr)');
    beautifyfig
    % try an anova for the initial phase
    for ip = 1:4
        pa(ip) = anova1([swvc(subject.order(:,1) == 0,ip),...
            swvh(subject.order(:,1) == 1,ip),swvl(subject.order(:,1) == 2,ip)])
    end
%%
make_Rstepmet_file(smet_phase,smet_phasevar,smet_names,smet_varnames,...
    subject.order);
