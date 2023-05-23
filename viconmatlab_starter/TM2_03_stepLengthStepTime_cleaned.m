% get learning curves from cleaned data
%% TM2_03_stepLengthStepTime_cleaned
global F p subject colors asym
for subj = 1:subject.n
    for effcond = 1:2
        for blk = 1:subject.nblk
            if subject.datacleaned(subj,effcond,blk) == 0
                disp([subject.list(subj) ' (' num2str(subj) ') | effcond: ' num2str(effcond) ' | blk: ' num2str(blk) ' NOT CLEANED'])
            else
               