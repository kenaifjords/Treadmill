%make profiles to be aligned, I guess I should align the hsfp because thats
%time
%the challenge is I have to make steplength asym time based. idk how to do that
%If I need 
%minsteps = min([AAA_LE2.maxsteps AAA_HE2.maxsteps]);
SLarray = {AAA_HE2.steplength_asym.'; AAA_LE2.steplength_asym.'}; 
SLframenumbers = [117,116];

%HE (1,:)} LE(2,;)
steplengthasym_array = alignProfiles2_copy(SLarray, SLframenumbers);

plot(steplengthasym_array(1,:)); 
title('Step Length Asymmetry (R-L/(R+L))')
ylabel('Length (mm)')
xlabel('Step Number')
hold on
plot(steplengthasym_array(2,:));
legend ('High Effort', 'Low Effort')




%% do the same for step time

STarray = {AAA_HE2.steptime_asym ; AAA_LE2.steptime_asym};
STframenumbers = [1,1];
steptimeasym_array = alignProfiles2_copy(STarray, STframenumbers);

figure
plot(steptimeasym_array(1,:))
title('Step Time Asymmetry (R-L)/(R+L)')
ylabel('Time (s)')
xlabel('Step Number')
hold on
plot(steptimeasym_array(2,:))
legend('High effort','Low Effort')