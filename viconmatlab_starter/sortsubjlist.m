function [sorted] = sortsubjlist(list)
global subject
%% sort into effort condition and visit order
acount = 1; bcount = 1; ccount = 1;
aacount = 1; bbcount = 1;
hfirst = []; lfirst = []; hsecond = []; lsecond = []; control = [];
for subj = 1:subject.n
    if subject.order(subj,1) == 1 % high effort first
        hfirst{acount} = list{subj};
        if subject.order(subj,2) == 2
            lsecond{aacount} = list{subj}; 
            aacount = aacount + 1;
        end
        acount = acount + 1;
    elseif subject.order(subj,1) == 2% low effort first
        lfirst{bcount} = list{subj};
        bcount = bcount + 1;
        if subject.order(subj,2) == 1
            hsecond{bbcount} = list{subj};
            bbcount = bbcount + 1;
        end
    elseif subject.order(subj,1) == 0 % control
        for blk = 1:subject.nblk
            control{ccount} = list{subj};
        end
        ccount = ccount + 1;
    end
end
sorted.hfirst = hfirst; sorted.lfirst = lfirst;
sorted.hsecond = hsecond; sorted.lsecond = lsecond;
sorted.control = control;
end