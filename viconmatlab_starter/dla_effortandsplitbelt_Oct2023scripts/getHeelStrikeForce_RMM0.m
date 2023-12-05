function [hs1, hs2, to1, to2, ihs1, ihs2, ito1, ito2] = getHeelStrikeForce_RMM0(F1,F2,time,threshold)
eventnum = 20;
% get z forces
f1 = F1(:,3);
f2 = F2(:,3);
% get binary foot on or off based on 50N threshold
fb1 = f1>threshold;
fb2 = f2>threshold;
% identify changes from foot off to foot on with a requirement for several
% samples following the first change (removes spurious true/false related
% to slight changes in force at or near the threshold)
hs_pattern = [0 ones(1, eventnum)];
to_pattern = [1 zeros(1,eventnum)];

ihs1 = strfind(fb1', hs_pattern);
ito1 = strfind(fb1', to_pattern);
ihs2 = strfind(fb2', hs_pattern);
ito2 = strfind(fb2', to_pattern);

hs1 = time(ihs1);
to1 = time(ito1);
hs2 = time(ihs2);
to2 = time(ito2);
end