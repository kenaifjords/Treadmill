% TM2_02b_identifyHeelStrikes
global homepath subject F p
tic
for subj = 1:subject.n
%     if subject.order(subj,:) ~= [0 0] % this means that the subject is NOT a control subject
        if subject.order(subj,1) == 0
            effuse = 3;
        else
            effuse = [1 2];
        end
        for effcond = effuse %1:3 %2 %length(subject.effortcondition)
            for blk = 1:length(subject.blockname)

                disp([subject.list{subj} '(' num2str(subj) ') ' '| effcond: ' num2str(effcond) ' | blk: ' num2str(blk)]);
                if size(F(subj).R,1) >= effcond && size(F(subj).R,2) >= blk && ~isempty(F(subj).R{effcond,blk}) && ~isempty(F(subj).L{effcond,blk})
                    clear stepind stepvalid
                    
                    [hsR0, hsL0, toR0, toL0, hsR_idx0, hsL_idx0, toR_idx0, toL_idx0] =...
                        getHeelStrikeForce_RMM0(F(subj).R{effcond,blk},...
                        F(subj).L{effcond,blk},F(subj).time{effcond,blk},100);

                    trimFirstSpurious % produces hsR1 hsL1 ihsR1 ihsL1 ...
                            % toR1 toL1 itoR1 itoL1

                    hsR = hsR1; hsL = hsL1; toL = toL1; toR = toR1;
                    hsR_idx = ihsR1; hsL_idx = ihsL1; toR_idx = itoR1; toL_idx = itoL1;

                    F(subj).hsR{effcond,blk} = hsR;
                    F(subj).hsL{effcond,blk} = hsL;
                    F(subj).toR{effcond,blk} = toR;
                    F(subj).toL{effcond,blk} = toL;
                    F(subj).hsR_idx{effcond,blk} = hsR_idx;
                    F(subj).hsL_idx{effcond,blk} = hsL_idx;
                    F(subj).toR_idx{effcond,blk} = toR_idx;
                    F(subj).toL_idx{effcond,blk} = toL_idx;

                end
            end
        end
end
clearvars -except subject F p colors IK ID
toc