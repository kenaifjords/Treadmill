% TM2_06_forR_learningparam
clear Rmat
global F asym
if 1 
    TM2_05_fitLearning_statespace_exponential
    TM2_05_asymBarPlotsSteplength
end
i = 1;
colnames = {'subj' 'effortcondition' 'ss_remember' 'ss_learnrate' ... (4)
    'ss_initial' 'mass' 'added_mass' 'exp_coef' 'exp_learnrate' 'exp_const'... (10)
    'exposure' 'fastleg' 'exposeinday' 'iswashout' 'sla_initial' ... (15)
    'sla_early' 'sla_late' 'sla_plateau' 'sta_initial' 'sta_early'... (20)
    'sta_late' 'sta_plateau' 'swa_initial' 'swa_early' 'swa_late'... (25)
    'swa_plateau' 'visit' 'block' 'twovisit','twovisit_group' ... (30)
    'firsteff'}; % (31)
for subj = 1:subject.n
    for vis = 1:2
        % are they two visit participants?
        ord = subject.order(subj,:);
        if ord(2) ~= 0
            tvp = 1;
            if ord(1) == 1
                tvg = 4;
            else
                tvg = 5;
            end
        else
            tvp = 0;
            tvg = ord(1);
        end
        % learning
        effcond = subject.order(subj,vis); % first visit only for now
        if effcond == 0 && vis == 1 
            effcond = 3;
        elseif effcond == 0 && vis == 2
            % disp('break for control subjects')
            break
        end
        ss = ss_fit(subj,effcond,blk,:); % remember, learn,[], initial
        ex = exp_fit(subj,effcond,blk,:); % coef, learn, const, initial
        slabin = abar.sla{effcond,blk}(subj,:);
        stabin = abar.sta{effcond,blk}(subj,:);
        swabin = abar.swa{effcond,blk}(subj,:);
        eff1 = subject.order(subj,1);
        for blk = [4, 5 ,6] % LEARNING first visit
            ss = ss_fit(subj,effcond,blk,:); % remember, learn,[], initial
            ex = exp_fit(subj,effcond,blk,:); % coef, learn, const, initial
            slabin = abar.sla{effcond,blk}(subj,:);
            stabin = abar.sta{effcond,blk}(subj,:);
            swabin = abar.swa{effcond,blk}(subj,:);
            eff1 = subject.order(subj,1);
            s2plat = 
            % subj
            Rmat(i,1) = subj;
            % effort condition
            Rmat(i,2) = effcond;
            % ss remember
            Rmat(i,3) = ss(1);
            % ss_learnrate
            Rmat(i,4) = ss(2);
            % ss_initial
            Rmat(i,5) = ss(4);
            % mass
            Rmat(i,6) = subject.mass(subj);
            % added mass
            if effcond == 1
                Rmat(i,7) = subject.highmass(subj);
            elseif effcond == 2
                Rmat(i,7) = subject.lowmass(subj);
            else
                Rmat(i,7) = 0;
            end
            % exponetial coefficient
            Rmat(i,8) = ex(1);
            % exponential learning rate
            Rmat(i,9) = ex(2);
            % exponential constant
            Rmat(i,10) = ex(3);
            % exposure
            if blk == 4
                if vis == 1
                    Rmat(i,11) = 1;
                elseif vis == 2
                    Rmat(i,11) = 3;
                end
            end
            if blk == 6
                if vis == 1
                    Rmat(i,11) = 2;
                elseif vis == 2
                    Rmat(i,11) = 4;
                end
            end
            if blk == 5
                Rmat(i,11) = 0;
            end
            % fastleg
            Rmat(i,12) = subject.fastleg(subj);
            % exposure number in a day
            if blk == 4
                Rmat(i,13) = 1;
            elseif blk == 6
                Rmat(i,13) = 2;
            else
                Rmat(i,13) = 0;
            end
            % is washout
            if blk == 5
                Rmat(i,14) = 1;
            else
                Rmat(i,14) = 0;
            end
            % bin error initial  sla
            Rmat(i,15) = slabin(1);
            % bin error early sla
            Rmat(i,16) = slabin(2);
            % bin error late sla
            Rmat(i,17) = slabin(3);
            % bin error plateau sla
            Rmat(i,18) = slabin(4);

            % bin error initial  sta
            Rmat(i,19) = stabin(1);
            % bin error early sta
            Rmat(i,20) = stabin(2);
            % bin error late sta
            Rmat(i,21) = stabin(3);
            % bin error plateau sta
            Rmat(i,22) = stabin(4);

            % bin error initial  swa
            Rmat(i,23) = swabin(1);
            % bin error early swa
            Rmat(i,24) = swabin(2);
            % bin error late swa
            Rmat(i,25) = swabin(3);
            % bin error plateau swa
            Rmat(i,26) = swabin(4);

            % visit
            Rmat(i,27) = vis;
            % block
            Rmat(i,28) = blk;
            
            % high-low or low-high;
            Rmat(i,29) = tvp;
            
            % group in the 5 group listing
            Rmat(i,30) = tvg;
            % first exposure effort condition
            Rmat(i,31) = eff1;
            
            % strides to plateau
            Rmat(i,32) = s2plat;
            % increment
            i = i + 1;
        end
%         % SECOND VISIT
%         effcond = subject.order(subj,2); % CONDITION second visit
%         if effcond == 0 
%             % do nothing
%         else
%         end
%     end
    end
end
labeled_Rmat = array2table(Rmat,'VariableNames', colnames);
writetable(labeled_Rmat,'Rmat_param_new2.csv')
fprintf('param mat made')
            
    
