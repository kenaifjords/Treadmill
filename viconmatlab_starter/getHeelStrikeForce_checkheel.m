function [hs1, hs2, to1, to2, ihs1, ihs2, ito1, ito2] = getHeelStrikeForce_checkheel(F1,F2,time,pheel1,pheel2)
eventnum = 30;
% get z forces
f1 = F1(:,3);
f2 = F2(:,3);
% get z coordinate of heel position
heelz1 = pheel1(:,3);
heelz2 = pheel2(:,3);
% get binary foot on or off based on 50N threshold
fb1 = f1>200;
fb2 = f2>200;
% identify changes from foot off to foot on with a requirement for several
% samples following the first change (removes spurious true/false related
% to slight changes in force at or near the threshold)
hs_pattern = [0 ones(1, eventnum)];
to_pattern = [1 zeros(1,eventnum)];

ihs1 = strfind(fb1', hs_pattern);
ito1 = strfind(fb1', to_pattern);
ihs2 = strfind(fb2', hs_pattern);
ito2 = strfind(fb2', to_pattern);

% check that the heel marker is below 75mm when heel strikes are recordedd
length(heelz1)
max(ihs1)
initialheelmarkerheight = mean(heelz1(1:10));
for i = 1:length(ihs1)-1
    if heelz1(ihs1(i)) > initialheelmarkerheight + 40
        ihs1(i) = NaN;
    end
end
ihs1 = ihs1(~isnan(ihs1));

initialheelmarkerheight = mean(heelz2(1:10));
for i = 1:length(ihs2)-1
    if heelz2(ihs2(i)) > initialheelmarkerheight + 40
        ihs2(i) = NaN;
    end
end
ihs2 = ihs2(~isnan(ihs2));

hs1 = time(ihs1);
to1 = time(ito1);
hs2 = time(ihs2);
to2 = time(ito2);
end