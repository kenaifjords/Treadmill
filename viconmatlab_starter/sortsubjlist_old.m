function [sorted] = sortsubjlist(list)
global subject
%% sort into effort condition and visit order
acount = 1; bcount = 1; ccount = 1;
for subj = 1:subject.n
    if subject.order(subj,:) == [1 2] % high effort first
        for blk = 1:subject.nblk
            for effcond = 1
                hfirst(acount) = list(subj);
            end
            for effcond = 2
                lsecond(acount) = list(subj);    
            end
        end
        acount = acount + 1;
    elseif subject.order(subj,:) == [2 1] % low effort first
        for blk = 1:subject.nblk
            for effcond = 1
                hsecond(bcount) = list(subj);
            end
            for effcond = 2
                lfirst(bcount) = list(subj);
            end
        end
        bcount = bcount + 1;
    elseif subject.order(subj,:) == [0 0] % control
        for blk = 1:subject.nblk
            control(ccount) = list(subj);
        end
        ccount = ccount + 1;
    end
end
sorted.hfirst = hfirst; sorted.lfirst = lfirst;
sorted.hsecond = hsecond; sorted.lsecond = lsecond;
sorted.control = control;
end