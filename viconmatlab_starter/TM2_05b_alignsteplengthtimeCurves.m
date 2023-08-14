% TM2_05b_alignstepslowtimeCurves
global asym F p colors subject asym_all
normtobase = 1; normtoheight = 0;
normblk = 3; % 3 for slow baseline; 2 for fast baseline
for subj = 1:subject.n
    if subject.order(subj,1) == 0
        effuse = 3;
    else
        effuse = [1:2];
    end
    for effcond = effuse
        for blk = 1:subject.nblk
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
% build asymmetry matrix
for subj = 1:subject.n
    if subject.order(subj,1) == 0
        effuse = 3;
    else
        effuse = [1:2];
    end
    for effcond = effuse
        for blk = 1:subject.nblk
            trimsl = min(asymlength(:,:,blk),[],'all'); 
            trimst = min(asymlength(:,:,blk),[],'all');
            asymsl = asym(subj).steplength{effcond,blk};
            asymst = asym(subj).steptime{effcond,blk};
            
            if ~isempty(asymsl)
                asym_all.steplength{effcond,blk}(subj,:) = asymsl(1:trimsl);
            end
            if ~isempty(asymst)
                asym_all.steptime{effcond,blk}(subj,:) = asymst(1:trimst);
            end
        end
    end
end
%% sort into effort condition and visit order
[slength.hfirst,slength.lfirst,slength.hsecond,slength.lsecond,slength.control] = ...
    sortbyEffortVisitorder(asym_all.steplength);
[stime.hfirst,stime.lfirst,stime.hsecond,stime.lsecond,stime.control] = ...
    sortbyEffortVisitorder(asym_all.steptime);

%% plot
blkinclude = 4:6;

figure(555);
plotAsymmetryCurves(blkinclude,'step length symmetry',slength);
figure(556);
plotAsymmetryCurves(blkinclude,'step time symmetry',stime);