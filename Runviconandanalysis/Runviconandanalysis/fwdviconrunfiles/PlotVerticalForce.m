%This script will plot the derivative of vertical force, vertical force,
%and label heel strikes/toe-offs on one plot. 

VerticalFDerivative_F1 = diff23f5(F1(:,3),dt,fc);
VerticalFDerivative_F2 = diff23f5(F2(:,3),dt,fc);

figure
plot(F1(:,3));
hold on
plot(F2(:,3));
hold on
plot(ind_hsfp1,F1(ind_hsfp1,3),'go')
plot(ind_tofp1,F1(ind_tofp1,3),'g*')
% plot(time,F2(:,3),'r');
plot(ind_hsfp2,F2(ind_hsfp2,3),'ko')
plot(ind_tofp2,F2(ind_tofp2,3),'k*')
%plot(VerticalFDerivative_F1(:,3),'--b')
%plot(time,VerticalFDerivative_F2(:,3),'--r')
%plot(heelStrikeEventFP1.time,heelStrikeEventFP1.isCrossover,'bx')
%plot(heelStrikeEventFP2.time,heelStrikeEventFP2.isCrossover,'rx')
plot(framescrossover_fp1,1,'bx')
plot(framescrossover_fp2,1,'rx')
title('Heel Strikes')
xlabel('Frames(downsized)')
ylabel('Vertical Force (N)')