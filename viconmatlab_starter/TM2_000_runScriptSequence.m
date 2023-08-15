% Test Series Script
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

%%
TM2_04_forceandimpulseasymmetry; %generates asym_all
% TM2_04_
% this is where new metrics should be introduced
% peak heelstrike force, push off impulse, peak push off force, braking 
% braking force, trailing limb angle
%%
% TM2_05_alignlearningCurves;
% TM2_05_alignsteptimeCurves;
TM2_05b_alignsteplengthtimeCurves;
%%
TM2_05_steplength_steptime_unilateral
%%
TM2_05_aligngroundreactionforceCurves % input is asym_all
%%
TM2_05_asymBarPlotsSteplength;
%%
TM2_05_asymBarPlotsSteptime;
%%
TM2_06_fitexponentialmodel_steplength

% need to figure out why the minimum number of steps is the same for split
% and for washout (which should have a feww more for the extra 5 min) this
% issue is for both steplength and steptime curves because they use the
% same bare bones code
% probably should make the align curves concept a function
TM2_06_percentGaitForcesMoments