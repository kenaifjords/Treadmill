% TM2_CHECKTIME
for subj = 1:subject.n
%     if subject.order(subj,:) ~= [0 0] % this means that the subject is NOT a control subject
        if subject.order(subj,1) == 0
            effuse = 3;
        else
            effuse = [1 2];
        end
        for effcond = effuse %1:3 %2 %length(subject.effortcondition)
            for blk = 1:length(subject.blockname)
                figure(subj); 
                if effuse == 3
                    pltrow = 0;
                else
                    pltrow = effcond-1;
                end
                subplot(length(effuse),subject.nblk,blk+pltrow*subject.nblk); hold on;
                plot(F(subj).time{effcond,blk});
                plot(p(subj).trajtime{effcond,blk});
                sgtitle(subject.list(subj));
            end
        end
end