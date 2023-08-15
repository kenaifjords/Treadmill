% generate learning curve plots for ground reaction force

%% sort into effort condition and visit order
% y forces
% braking
[brake.hfirst,brake.lfirst,brake.hsecond,brake.lsecond,brake.control] = ...
    sortbyEffortVisitorder(asym_all.brakingFy);

% braking per leg
[fastlegbrake.hfirst,fastlegbrake.lfirst,fastlegbrake.hsecond,fastlegbrake.lsecond,fastlegbrake.control] = ...
    sortbyEffortVisitorder(fast_all.brakingFy);
[slowlegbrake.hfirst,slowlegbrake.lfirst,slowlegbrake.hsecond,slowlegbrake.lsecond,slowlegbrake.control] = ...
    sortbyEffortVisitorder(slow_all.brakingFy);

% propulsion
[push.hfirst,push.lfirst,push.hsecond,push.lsecond,push.control] = ...
    sortbyEffortVisitorder(asym_all.pushoffFy);

% propulsion per leg
[fastlegpush.hfirst,fastlegpush.lfirst,fastlegpush.hsecond,fastlegpush.lsecond,fastlegpush.control] = ...
    sortbyEffortVisitorder(fast_all.pushFy);
[slowlegpush.hfirst,slowlegpush.lfirst,slowlegpush.hsecond,slowlegpush.lsecond,slowlegpush.control] = ...
    sortbyEffortVisitorder(slow_all.pushFy);

[impulse.hfirst,impulse.lfirst,impulse.hsecond,impulse.lsecond,impulse.control] = ...
    sortbyEffortVisitorder(asym_all.pushimpulseFy);
% z forces
[heelFz.hfirst,heelFz.lfirst,heelFz.hsecond,heelFz.lsecond,heelFz.control] = ...
    sortbyEffortVisitorder(asym_all.heelFz);
[minstanceFz.hfirst,minstanceFz.lfirst,minstanceFz.hsecond,minstanceFz.lsecond,minstanceFz.control] = ...
    sortbyEffortVisitorder(asym_all.minstanceFz);
[toeFz.hfirst,toeFz.lfirst,toeFz.hsecond,toeFz.lsecond,toeFz.control] = ...
    sortbyEffortVisitorder(asym_all.toeFz);
%% PLOT

blkinclude = 4:6; %2:6;
% braking force
figure(1000)
plotAsymmetryCurves(blkinclude,'braking force asym',brake);

% braking forces before asym
figure(101); hold on;
plotFastSlowCompareCurves(blkinclude,...
    'braking force on first visit',...
    fastlegbrake,slowlegbrake);
figure(111); hold on;
plotFastSlowCompareCurves(4,'First exposure braking force (norm to baseline slow',...
    fastlegbrake,slowlegbrake);

% push off force
figure(1001);
plotAsymmetryCurves(blkinclude,'push off force Y (N)',push);

% push off forces before asym
figure(102); hold on;
plotFastSlowCompareCurves(blkinclude,...
    'push off force on first visit',...
    fastlegpush,slowlegpush);

% push off impulse
figure(1002);
plotAsymmetryCurves(blkinclude,'push off impulse Y (Ns)',impulse);
% heelstrike Zforce
figure(1003);
plotAsymmetryCurves(blkinclude,'heelstrike peak Fz (N)',heelFz);
% minstance fz
figure(1004);
plotAsymmetryCurves(blkinclude,'minimum stance force (N)',minstanceFz);
% toeoff Zforce
figure(1005);
plotAsymmetryCurves(blkinclude,'toe off FZ (N)',toeFz);
toc