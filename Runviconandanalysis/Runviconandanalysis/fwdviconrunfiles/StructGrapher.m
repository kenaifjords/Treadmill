%This file will need to take the code defined structs and graph them.
%Essentially copy code from runvicon and make it plot new.


% Need to account for frame difference of when learning starts
% I guess that means I need to be plotting each with respect to frames, but
% how do I know which frame. I could plot them both with heels strikes
% which corresponds to time which then corresponds to frames
%% Define frames and shit i think
% framesfile1 = 1000.*AAA_HE2.hsfp1;
% framesfile2 = 1000.*AAA_LE2.hsfp1;
%if I plot with respect to frames it should work


%% Steplengths
% %File one first
% figure(1)
% subplot(211)
% %plot(AAA_HE2.hsfp2(1:AAA_HE2.maxsteps),AAA_HE2.steplength1,'bo')
% plot(AAA_HE2.steplength1,'bo')
% title('Step Lengths')
% hold on
% %plot(AAA_HE2.hsfp1(1:AAA_HE2.maxsteps),AAA_HE2.steplength2,'go')
% plot(AAA_HE2.steplength2,'go')
% ylabel('Length (mm)')
% legend('Right','Left')
% %xlabel('Time (s)')


figure
%plot(framesfile1(1:AAA_HE2.maxsteps),AAA_HE2.steplength_asym)
%plot(AAA_HE2.steplength_asym)
%plot(steplength_asymArray(1,:))
plot(steplengthasym_array(1,:)); %ok this works jesus crhist that took too long
title('Asymmetry (R-L/(R+L))')
ylabel('Length (mm)')
xlabel('Time (s)')

% %data for file two
% hold on
% subplot(211)
% %plot(AAA_LE2.hsfp2(1:AAA_LE2.maxsteps),AAA_LE2.steplength1,'bo')
% plot(AAA_LE2.steplength1,'bo')
% title('Step Lengths')
% hold on
% %plot(AAA_LE2.hsfp1(1:AAA_LE2.maxsteps),AAA_LE2.steplength2,'go')
% ylabel('Length (mm)')
% legend('Right','Left')
% xlabel('Time (s)')


hold on
%plot(framesfile2(1:AAA_LE2.maxsteps),AAA_LE2.steplength_asym)
%plot(AAA_LE2.steplength_asym)
%plot(steplength_asymArray(2,:))
plot(steplengthasym_array(2,:));
title('Asymmetry (R-L/(R+L))')
ylabel('Length (mm)')
xlabel('Time (s)')
legend ('High Effort', 'Low Effort')

%% Step times
% %file one
% figure
% subplot(211)
% plot(AAA_HE2.steptime1)
% title('Step Times')
% hold on
% plot(AAA_HE2.steptime2,'g')
% ylabel('Time (s)')
% legend('Right','Left')
%  
figure
plot(AAA_HE2.steptime_asym)
title('Asymmetry (R-L)/(R+L)')
ylabel('Time (s)')

% %File two
% hold on
% 
% subplot(211)
% plot(AAA_LE2.steptime1)
% title('Step Times')
% hold on
% plot(AAA_LE2.steptime2,'g')
% ylabel('Time (s)')
% legend('Right','Left')
hold on
plot(AAA_LE2.steptime_asym)
title('Asymmetry (R-L)/(R+L)')
ylabel('Time (s)')
legend('High effort','Low Effort')