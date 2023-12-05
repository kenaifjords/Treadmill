function [asymsorted] = sortbyEffortVisitorder_02(asym_allsubj)
global subject
%% sort into effort condition and visit order
acount = 1; bcount = 1; ccount = 1;
for subj = 1:subject.n
    if subject.order(subj,1) == 1 % [1 2] % high effort first
        for blk = 1:subject.nblk
            effcond = 1
            hfirst{blk}(acount,:) = asym_allsubj{effcond,blk}(subj,:);
            if subject.order(subj,2) == 2
                effcond = 2
                lsecond{blk}(acount,:) = asym_allsubj{effcond,blk}(subj,:);
            else
                lsecond{blk}(acount,:) = NaN;
            end
        end
        acount = acount + 1;
    elseif subject.order(subj,1) == 2 %[2 1] % low effort first
        for blk = 1:subject.nblk
            effcond = 2
            lfirst{blk}(bcount,:) = asym_allsubj{effcond,blk}(subj,:);
            if subject.order(subj,2) == 1
                effcond = 1
                hsecond{blk}(bcount,:) = asym_allsubj{effcond,blk}(subj,:);
            else
                hsecond{blk}(bcount,:) = NaN;
            end
        end
        bcount = bcount + 1;
    elseif subject.order(subj,1) == 0 % control
        for blk = 1:subject.nblk
            if subj <= size(asym_allsubj{3,blk},1)
                control{blk}(ccount,:) = asym_allsubj{3,blk}(subj,:);
            end
        end
        ccount = ccount + 1;
    end
end
asymsorted.hfirst = hfirst; asymsorted.lfirst = lfirst;
asymsorted.hsecond = hsecond; asymsorted.lsecond = lsecond;
asymsorted.control = control;