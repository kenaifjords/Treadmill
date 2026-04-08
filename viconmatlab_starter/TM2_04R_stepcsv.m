% make csv step length, time, width

% column names
colnames = {'subj', 'effortcondition','block','stepnumber',...
    'steplength_fast','steplength_slow','steptime_fast','steptime_slow',...
    'stepwidth_fast', 'stepwidth_slow'};
i = 1;
% consider  VISiT 1 only
for subj = 1:subject.n
    % get effort condition for first visit
    effcond = subject.order(subj,1);
    % get index for control
    if effcond == 0
        effcond = 3;
    end
    % get fast leg (1 for right; 2 for left)
    fastleg = subject.fastleg(subj);
    for blk = 1:7 %4:6 % learning, washout, relearning
        clear sl_f sl_s st_f st_s sw_f sw_s
        if fastleg == 1
            sl_f = F(subj).steplengthR{effcond,blk};
            sl_s = F(subj).steplengthL{effcond,blk};
            st_f = F(subj).steptimeR{effcond,blk};
            st_s = F(subj).steptimeL{effcond,blk};
            sw_f = F(subj).stepwidthR{effcond,blk};
            sw_s = F(subj).stepwidthL{effcond,blk};
        else
            sl_s = F(subj).steplengthR{effcond,blk};
            sl_f = F(subj).steplengthL{effcond,blk};
            st_s = F(subj).steptimeR{effcond,blk};
            st_f = F(subj).steptimeL{effcond,blk};
            sw_s = F(subj).stepwidthR{effcond,blk};
            sw_f = F(subj).stepwidthL{effcond,blk};
        end
        mxs = max([length(sl_f),length(sl_s), length(st_f),length(st_s),...
            length(sw_f),length(sw_s)]);
        for si = 1:mxs % loop through each step
            % subject
            mat(i,1) = subj;
            % effort condition
            mat(i,2) = effcond;
            % block
            mat(i,3) = blk;
            % stepnumber
            mat(i,4) = si;
            
            % steplength fast
            if si <= length(sl_f)
                mat(i,5) = sl_f(si);
            else
                mat(i,5) = NaN;
            end
            % steplength slow
            if si <= length(sl_s)
                mat(i,6) = sl_s(si);
            else
                mat(i,6) = NaN;
            end
        
            % steptime fast
            if si <= length(st_f)
                mat(i,7) = st_f(si);
            else
                mat(i,7) = NaN;
            end
            % steptime slow
            if si <= length(st_s)
                mat(i,8) = st_s(si);
            else
                mat(i,8) = NaN;
            end
            
            % stepwidth fast
            if si <= length(sw_f)
                mat(i,9) = sw_f(si);
            else
                mat(i,9) = NaN;
            end
            % stepwidth slow
            if si <= length(sw_s)
                mat(i,10) = sw_s(si);
            else
                mat(i,10) = NaN;
            end
            i = i + 1;
        end % step
    end % block
end % subject

labeled_mat = array2table(mat,'VariableNames', colnames);
writetable(labeled_mat,'step_mat.csv')
fprintf('step mat made')