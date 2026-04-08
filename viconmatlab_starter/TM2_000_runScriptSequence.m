 % Test Series Script
clear all
close all
%%
TM2_01_buildSubjectStructure
fprintf('built subject structure')
%%
TM2_02b_identifyHeelStrikes_streamline
% the version without _streamline also generates heel strike based on
% markers
fprintf('heel strikes found')
 %%
TM2_03b_heelStrikeValidation
fprintf('heel strikes validated')
%%
TM2_04_getvalidatedlearningcurves;
fprintf('calculated learning curves for step time and steplength')
% for stepwidth
if 1
    TM2_04_getvalidatedlearningcurves_stepwidth
    disp('and added stepwidth')
end
% for R
if 0
    TM2_04R _forRmat
end
if 0
    TM2_04R_stepcsv
end
% for propulsion and forces
if 0
    TM2_04_GRF
    disp('ground reaction force plots for baseline and learning')
end
% strides to plateau
if 0
    TM2_05_stridestoplateau
end

%%
if 0
    TM2_05c_alignstepslowtimeCurves
% TM2_05_alignlearningCurves; % TM2_05_alignsteptimeCurves; 
% TM2_05b_alignsteplengthtimeCurves;
disp('asymmetry plots :)')
%% state space and exponetial fits
if 0
    TM2_05_fitLearning_statespace_exponential
    fprintf('calculated state space and exponential curve fits for steplength')
end
%%
TM2_06_analyzefits
%%
if 0
    TM2_07_boostrap_ss_exp
end
%%
if 0                                                                                                                   
TM2_04_forceandimpulseasymmetry; %generates asym_all
end
%%
if 0
    TM2_04_GRF
end
%%
if 0
TM2_05_steplength_steptime_unilateral
%%
TM2_05c_alignstepslowtimeCurves
%%
TM2_05_aligngroundreactionforceCurves % input is asym_all, fast_all, slow_all
%%
TM2_05_asymBarPlotsSteplength;
%%
TM2_05_VariabilitySteplength;
%%
TM2_05_asymBarPlotsSteptime;
%%
TM2_05_asymBarPlotsForces;
end
%%
if 0
% TM2_06_individual_fitexponentialmodel_steplength
disp('fit individual single exponential curves and bootstrap individually fitted learning rates')
end
%%
if 0
% TM2_06_fitexponentialmodel_steplength
end
%%
if 0
% TM2_07_analyzeBootExpfits;
% need to figure out why the minimum number of steps is the same for split
% and for washout (which should have a feww more for the extra 5 min) this
% issue is for both steplength and steptime curves because they use the
% same bare bones code
% probably should make the align curves concept a function
TM2_06_percentGaitForcesMoments
end
end