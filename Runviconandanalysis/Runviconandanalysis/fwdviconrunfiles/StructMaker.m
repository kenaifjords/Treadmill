%Code to create sructs. Will have to come up with a way for each
%participants data to be called into a struct so that low and high effort
%graphs can be compared. Sounds hard.

%What data will I need from each participant to make struct that has
%enough code to graph. 

%how do i load data into struct at 

%I guess I'll runvicon on a certain data set, take important the data rn write it into
%a struct. Then I'll have to label that struct according to data set run.

% The data I'll Load rn is
% hsfp1,hsfp2,maxsteps,steplength1,steplength2,steplength_asym,steptime1,steptime2,steptime_asym

%Define the struct, change name

CBL_LE2 = struct('hsfp1',hsfp1, 'hsfp2', hsfp2,'maxsteps',maxsteps, ...
    'steplength1',steplength1,'steplength2',steplength2,'steplength_asym', ...
    steplength_asym,'steptime1',steptime1,'steptime2',steptime2,'steptime_asym',steptime_asym,...
    'COP1',COP1,'COP2',COP2);

               
             