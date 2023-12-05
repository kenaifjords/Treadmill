%% TM2_07_barplots_steplengthandsteptime
global F p asym asym_all
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2)
            if ~isempty(asym(subj) .steplength{effcond,blk})
               sla.initial(subj,effcond,blk) = mean(asym(subj) .steplength{effcond,blk}(1:5));
               sla.early(subj,effcond,blk) = mean(asym(subj).steplength{effcond,blk}(6:30));
               sla.late(subj,effcond,blk) = mean(asym(subj).steplength{effcond,blk}(end-30:end));
            end
        end
    end
end
sla.initial(sla.initial == 0) = NaN;
sla.early(sla.initial == 0) = NaN;
sla.late(sla.initial == 0) = NaN;

% sort
[a] = sortbyEffortVisitorder_digitout(sla.initial)
[b] = sortbyEffortVisitorder_digitout(sla.early)
[c] = sortbyEffortVisitorder_digitout(sla.late)

[a] = sortbyEffortVisitorder_02(asym_all.steplength);
getBarPlot_asymmetry_andcontrol(a.hfirst, a.lfirst, a.hsecond, a.lsecond,...
    a.control, 'SLA')
