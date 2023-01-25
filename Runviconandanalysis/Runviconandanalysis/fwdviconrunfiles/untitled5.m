%This script will plot the derivative of vertical force, vertical force,
%and label heel strikes/toe-offs on one plot. 

VerticalFDerivative_F1 = diff23f5(F1(:,3),dt,fc);
VerticalFDerivative_F2 = diff23f5(F2(:,3),dt,fc);

figure
plot(time,F1(:,3));
hold on
plot(hsfp1,F1(ind_hsfp1,3),'go')
plot(tofp1,F1(ind_tofp1,3),'g*')
plot(time,F2(:,3),'r');
plot(hsfp2,F2(ind_hsfp2,3),'ko')
plot(tofp2,F2(ind_tofp2,3),'k*')
plot(time,VerticalFDerivative_F1(:,2),'--b')
%plot(time,VerticalFDerivative_F2(:,2),'--r')
title('Heel Strikes')
xlabel('Time (s)')
ylabel('Vertical Force (N)')