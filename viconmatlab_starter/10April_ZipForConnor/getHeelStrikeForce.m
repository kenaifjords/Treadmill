function [hsfp1, hsfp2, tofp1, tofp2] = getHeelStrikeForce(F1,F2,time)
F1((F1(:,3)<50),3)=0;
F2((F2(:,3)<50),3)=0;

F13post=[F1(2:end,3); F1(end,3)];
F23post=[F2(2:end,3); F2(end,3)];

F13pre=[F1(1,3); F1(1:end-1,3)];
F23pre=[F2(1,3); F2(1:end-1,3)];

% heelstrike time 1 (right)
ind_hsfp1=find(F1(:,3)==0 & F13post>0);
hsfp1=time(ind_hsfp1);
% heelstrike time 2 (left)
ind_hsfp2=find(F2(:,3)==0 & F23post>0);
hsfp2=time(ind_hsfp2);
% toe off time 1
ind_tofp1=find(F1(:,3)==0 & F13pre>0);
tofp1=time(ind_tofp1);
% toe off time 2
ind_tofp2=find(F2(:,3)==0 & F23pre>0);
tofp2=time(ind_tofp2);
end