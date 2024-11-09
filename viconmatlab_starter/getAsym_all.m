function [asym_all] = getAsym_all
global subject F asym 
%% determine the shortest profile so that we can trim to shortest
for subj = 1:subject.n
    if subject.order(subj,1) == 0
        effuse = 3;
    else
        if size(F(subj).R,1) < 2
            effuse = 1;
        else
            effuse = 1:2;
        end
    end
    for effcond = effuse
        for blk = 1:subject.nblk
            if blk > size(F(subj).R,2)
                break
            end
            asymsl = asym(subj).steplength{effcond,blk};
            asymlength(subj,effcond,blk) = length(asymsl);
            asymst = asym(subj).steptime{effcond,blk};
            asymlengthtime(subj,effcond,blk) = length(asymst);
        end
    end
end
asymlength(asymlength == 0) = NaN;
asymlengthtime(asymlengthtime == 0) = NaN;
trimsl = min(asymlength(:,:,blk),[],'all'); 
trimst = min(asymlengthtime(:,:,blk),[],'all');

%% build matrix
    for subj = 1:subject.n
        if subject.order(subj,1) == 0
            effuse = 3;
        else
            if size(F(subj).R,1) < 2
                effuse = 1;
            else
                effuse = 1:2;
            end
        end
        for effcond = effuse
            for blk = 1:subject.nblk
                if blk > size(F(subj).R,2)
                    break
                end
                trimsl = min(asymlength(:,:,blk),[],'all'); 
                trimst = min(asymlength(:,:,blk),[],'all');
                asymsl = asym(subj).steplength{effcond,blk};
                asymst = asym(subj).steptime{effcond,blk};

                if ~isempty(asymsl)
                    asym_all.steplength{effcond,blk}(subj,:) = asymsl(1:trimsl);
                else
                    asym_all.steplength{effcond,blk}(subj,:) = NaN;
                end
                if ~isempty(asymst)
                    asym_all.steptime{effcond,blk}(subj,:) = asymst(1:trimst);
                else
                    asym_all.steptime{effcond,blk}(subj,:) = NaN;
                end
            end
        end
    end
end