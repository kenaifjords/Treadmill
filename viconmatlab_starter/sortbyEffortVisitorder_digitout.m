function [asymsorted] = sortbyEffortVisitorder_digitout(dataallsubj)
global subject
%% sort into effort condition and visit order
acount = 1; bcount = 1; ccount = 1;
for subj = 1:subject.n
    if subject.order(subj,1) == 1 % [1 2] % high effort first
        for blk = 1:subject.nblk
            for effcond = 1
                hfirst{blk}(acount) = dataallsubj(subj,effcond,blk);
            end
            if subject.order(subj,2) == 2
                for effcond = 2
                    lsecond{blk}(acount) = dataallsubj(subj,effcond,blk);
                end
            else
                lsecond{blk}(acount) = NaN;
            end
        end
        acount = acount + 1;
    elseif subject.order(subj,1) == 2 %[2 1] % low effort first
        for blk = 1:subject.nblk
            if subject.order(subj,2) == 1
                for effcond = 1
                    hsecond{blk}(bcount,:) = dataallsubj(subj,effcond,blk);
                end
            else
                hsecond{blk}(bcount) = NaN;
            end
            for effcond = 2
                lfirst{blk}(bcount) = dataallsubj(subj,effcond,blk);
            end
        end
        bcount = bcount + 1;
    elseif subject.order(subj,1) == 0 % control
        for blk = 1:subject.nblk
            control{blk}(ccount) = dataallsubj(subj,3,blk);
        end
        ccount = ccount + 1;
    end
end
asymsorted.hfirst = hfirst; asymsorted.lfirst = lfirst;
asymsorted.hsecond = hsecond; asymsorted.lsecond = lsecond;
asymsorted.control = control;