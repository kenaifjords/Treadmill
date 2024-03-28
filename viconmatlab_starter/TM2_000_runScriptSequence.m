 % Test Series Script
clear all
close all
%%
TM2_01_buildSubjectStructure
fprintf('built subject structure')
%%
TM2_02b_identifyHeelStrikes
fprintf('heel strikes found')
%%
TM2_03b_heelStrikeValidation
fprintf('heel strikes validated')
%%
TM2_04_getvalidatedlearningcurves;
fprintf('calculated learning curves for step time and steplength')

% for R
if 0
    TM2_04R_forRmat
end
%%
if 0                                                                                                                   
TM2_04_forceandimpulseasymmetry; %generates asym_all
% TM2_04_
% this is where new metrics should be introduced
% peak heelstrike force, push off impulse, peak push off force, braking 
% braking force, trailing limb angle
end
%%
if 0
% TM2_05_alignlearningCurves;
% TM2_05_alignsteptimeCurves;
TM2_05b_alignsteplengthtimeCurves;
fprintf('aligned step length and step time curves')
end
%%
if 0
TM2_05_steplength_steptime_unilateral
%%
TM2_05_aligngroundreactionforceCurves % input is asym_all
%%
TM2_05_asymBarPlotsSteplength;
%%
TM2_05_asymBarPlotsSteptime;
%%
TM2_05_asymBarPlotsForces;
end
%%
if 0
TM2_06_individual_fitexponentialmodel_steplength
disp('fit individual single exponential curves and bootstrap individually fitted learning rates')
end
%%
if 0
TM2_06_fitexponentialmodel_steplength
end
%%
if 0
TM2_07_analyzeBootExpfits;
% need to figure out why the minimum number of steps is the same for split
% and for washout (which should have a feww more for the extra 5 min) this
% issue is for both steplength and steptime curves because they use the
% same bare bones code
% probably should make the align curves concept a function
TM2_06_percentGaitForcesMoments
end