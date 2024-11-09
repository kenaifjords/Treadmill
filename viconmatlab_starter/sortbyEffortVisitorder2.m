function [asym_sort] = sortbyEffortVisitorder(asym_allsubj)
global subject F
%% sort into effort condition and visit order
acount = 1; a2count = 1; bcount = 1; b2count = 1; ccount = 1;
for subj = 1:subject.n
    if subject.order(subj,1) == 1 % [1 2] % high effort first
        for blk = 1:subject.nblk
            if blk > size(F(subj).R,2)
                break
            end
            for effcond = 1
                hfirst{blk}(acount,:) = asym_allsubj{effcond,blk}(subj,:);
            end
            if subject.order(subj,2) == 2
                for effcond = 2
                    lsecond{blk}(a2count,:) = asym_allsubj{effcond,blk}(subj,:);    
                end
                if blk == subject.nblk
                    a2count = a2count + 1;
                end
            end
        end
        acount = acount + 1;
    elseif subject.order(subj,1) == 2 %[2 1] % low effort first
        for blk = 1:subject.nblk
            if blk > size(F(subj).R,2)
                break
            end
            if subject.order(subj,2) == 1
                for effcond = 1
                    hsecond{blk}(b2count,:) = asym_allsubj{effcond,blk}(subj,:);
                end
                if blk == subject.nblk
                    b2count = b2count + 1;
                end
            end
            for effcond = 2
                lfirst{blk}(bcount,:) = asym_allsubj{effcond,blk}(subj,:);
            end
        end
        bcount = bcount + 1;
    elseif subject.order(subj,1) == 0 % control
        for blk = 1:subject.nblk
            if blk > size(F(subj).R,2)
                break
            end
            control{blk}(ccount,:) = asym_allsubj{3,blk}(subj,:);
        end
        ccount = ccount + 1;
    end
end
asym_sort.hfirst = hfirst;
asym_sort.lfirst = lfirst;
asym_sort.control = control;
asym_sort.hsecond = hsecond;
asym_sort.lsecond = lsecond;
end