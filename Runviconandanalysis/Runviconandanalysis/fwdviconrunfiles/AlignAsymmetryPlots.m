% Run this to plot structure data. Will plot HE1w/LE1(can change names for HE2)
% and Savings HE1w/HE2 LE1w/LE2
% Load in structure before use and determine frame numbers to align
%% Lines of code I have to change for each subject
%Comparison of High and Low Effort
SLarray = {CBL_HE2.steplength_asym.'; CBL_LE2.steplength_asym.'}; %Input data here
SLframenumbers = [109,108]; %Input data here High effort, low effort frames
steplengthasym_array = alignProfiles2_copy(SLarray, SLframenumbers);
STarray = {CBL_HE2.steptime_asym ; CBL_LE2.steptime_asym}; %Input data here
STframenumbers = [109,108]; %Input data here
steptimeasym_array = alignProfiles2_copy(STarray, STframenumbers); 
% Savings - Steplength
Savings_SLArray = {CBL_HE1.steplength_asym.'; CBL_HE2.steplength_asym.';CBL_LE1.steplength_asym.';CBL_LE2.steplength_asym.'};
HESavings_SLframenumbers = [215,108]; %this can come from a plot 
LESavings_SLframenumbers = [215,108]; %Input data here
%Savings - Steptime
Savings_STarray = {CBL_HE1.steptime_asym ; CBL_HE2.steptime_asym ; CBL_LE1.steptime_asym ; CBL_LE2.steptime_asym};
HESavings_STframenumbers = [215,108];
LESavings_STframenumbers = [215,108];


%% Plot StepLength and Steptime HE1 and LE1(or HE2 and LE2)
figure 
subplot(2,1,1)
plot(steplengthasym_array(1,:)); 
title('High and Low Effort (second learning) - Step Length Asymmetry')
ylabel('Length (mm)')
xlabel('Step Number')
hold on
plot(steplengthasym_array(2,:));
legend ('High Effort', 'Low Effort')
% do the same for steptime

subplot(2,1,2)
plot(steptimeasym_array(1,:))
title('High and Low Effort (second learning) - Step Time Asymmetry')
ylabel('Time (s)')
xlabel('Step Number')
hold on
plot(steptimeasym_array(2,:))
legend('High effort','Low Effort')
%% Figures for Saving HE1w/HE2 and LE1w/LE2
% Savings Steplength primer
HESavings_steplengthasym_array = alignProfiles2_copy(Savings_SLArray(1:2,:), HESavings_SLframenumbers);
LESavings_steplengthasym_array = alignProfiles2_copy(Savings_SLArray(3:4,:), LESavings_SLframenumbers);
%Savings Step time primer
HESavings_steptimeasym_array = alignProfiles2_copy(Savings_STarray(1:2,:), HESavings_STframenumbers); 
LESavings_steptimeasym_array = alignProfiles2_copy(Savings_STarray(3:4,:), LESavings_STframenumbers); 

%% Steplength Savings
figure 
subplot(2,1,1)
plot(HESavings_steplengthasym_array(1,:)); 
title('Savings High Effort - Step Length Asymmetry')
ylabel('Length (mm)')
xlabel('Step Number')
hold on
plot(HESavings_steplengthasym_array(2,:));
legend ('High Effort First Learning', 'High Effort Second Learning')

% do the same for low effort

subplot(2,1,2)
plot(LESavings_steplengthasym_array(1,:)); 
title('Savings Low Effort - Step Length Asymmetry')
ylabel('Length (mm)')
xlabel('Step Number')
hold on
plot(LESavings_steplengthasym_array(2,:));
legend ('Low Effort First Learning', 'Low Effort Second Learning')

%% Steptime Savings
figure 
subplot(2,1,1)
plot(HESavings_steptimeasym_array(1,:)); 
title('Savings High Effort - Step Time Asymmetry')
ylabel('Time (s)')
xlabel('Step Number')
hold on
plot(HESavings_steptimeasym_array(2,:));
legend ('High Effort First Learning', 'High Effort Second Learning')
% do the same for low effort
subplot(2,1,2)
plot(LESavings_steptimeasym_array(1,:)); 
title('Savings Low Effort - Step Time Asymmetry')
ylabel('Time (s)')
xlabel('Step Number')
hold on
plot(LESavings_steptimeasym_array(2,:));
legend ('Low Effort First Learning', 'Low Effort Second Learning')

