%% TM2_02_identifyHeelStrikes
% This script identifies heel strikes and toe off gait events using data 
% from the force plates and includes some additional step validation 
% procedure to limit spurious heel strikes. Some data cleaning specific to 
% your data or to specific files may still be required.

global subject FP
tic
for subj = 1:subject.n
    for blk = 1:length(subject.blockname)
        disp([subject.list{subj} '(' num2str(subj) ') | blk: ' num2str(blk)]);
        if ~isempty(FP(subj).R{blk}) && ~isempty(FP(subj).L{blk})
            % finds heel strikes based on force on / force off from the
            % force plates
            [hsR0, hsL0, toR0, toL0, hsR_idx0, hsL_idx0, toR_idx0, toL_idx0] =...
                getHeelStrikeForce_SC(FP(subj).R{blk},FP(subj).L{blk},FP(subj).time{blk});

            %% Data cleaning
            % clean heel strikes and toe offs to get valid steps
            if ~isempty(hsR0) && ~isempty(hsL0) % make unreachable for none but brute force cleaning 
                % for trimming "first" steps and toe offs that precede heel
                % strikes
                findvalidHS_v2
                hsR = hsR1; hsL = hsL1; toL = toL1; toR = toR1;
                hsR_idx = ihsR1; hsL_idx = ihsL1; toR_idx = itoR1; toL_idx = itoL1;
                % identify the leg that takes the first step
                FP(subj).rightfirst(blk) = Rfirst; 
                % if this is 1 then hs1 is right, if this is 0, then hs1 is left
                subject.datacleaned(subj,blk) = 1;
            else
                % none but brute force cleaning
                hsR = hsR0; hsL = hsL0; toL = toL0; toR = toR0;
                hsR_idx = hsR_idx0; hsL_idx = hsL_idx0; toR_idx = toR_idx0; toL_idx = toL_idx0;
                subject.datacleaned(subj,blk) = 0;
            end
            
            
            %% assign hs and to data end data cleaning
            FP(subj).hsRvalid{blk} = hsRvalid;
            FP(subj).hsLvalid{blk} = hsLvalid;
            FP(subj).hsR{blk} = hsR;
            FP(subj).hsL{blk} = hsL;
            FP(subj).toR{blk} = toR;
            FP(subj).toL{blk} = toL;
            FP(subj).hsR_idx{blk} = hsR_idx;
            FP(subj).hsL_idx{blk} = hsL_idx;
            FP(subj).toR_idx{blk} = toR_idx;
            FP(subj).toL_idx{blk} = toL_idx;        
        end
    end
end
clearvars -except subject FP p colors
toc