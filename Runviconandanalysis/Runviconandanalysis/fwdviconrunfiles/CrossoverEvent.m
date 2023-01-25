% This will identify crossover events by seeking two heelstrikes in a row
% on the left forceplate fp2 without the vertical force dipping below a
% force threshold. The threshold will be 50 newtons
%there will be zero inputs and the output will be a vairable deemed
%crossover that identifies has the indices at which the force occurs 

%threshold= 50; %the force threshold Newtons
%crossover=zeros(size(hsfp1));

% Determine which Heel strike is first

if hsfp1(1)<hsfp2(1);  %fp1 strikes first
     firstBelt = hsfp1;
     secondBelt = hsfp2;
elseif hsfp1(1)>hsfp2(1); 
     firstBelt = hsfp2;
     secondBelt = hsfp1;
end
% Determine min number of heel strike events
if length(firstBelt)<length(secondBelt);
    MinHeelStrikes = firstBelt;
elseif length(firstBelt)>length(secondBelt); 
    MinHeelStrikes = secondBelt;
end
% First describe what a heelStrikeEvent is
timevalue = zeros(size(MinHeelStrikes)); % 00000 00000
field1 = 'time';
isCrossovervalue = zeros(size(MinHeelStrikes));
field2 = 'isCrossover';

heelStrikeEvent = struct(field1,timevalue,field2,isCrossovervalue);

% How to set structs:
%
% Declaring new instance of crossover !!pretty sure wrong
%heelStrikeEvent(i).time = ;
% heelStrikeEvent(i).isCrossover = 1;
% numHeelStrikes = numHeelStrikes + 1;
%think below is right
%heelStrikeEvent.time(i) = hsfp1(or2)(i) (this is whatever belt we are on)
%heelStrikeEvent.isCrossover(i)=

i = 1;
while i < length(MinHeelStrikes)-1
    nextStep = firstBelt(i+1);
    if (firstBelt(i) < secondBelt(i)) && (secondBelt(i)< nextStep) % No Crossover
        heelStrikeEvent.time(i) = firstBelt(i);
        heelStrikeEvent.isCrossover(i) = 0; 
    else %there is crossover
            heelStrikeEvent.time(i) = firstBelt(i);
            heelStrikeEvent.isCrossover(i) = 1;
%Once crossover I need to reset variables because rn once there is crossover
%then the code fails because the steps are not longer on the same index
    end
    i = i+1;
end

ind_Crossover = find(heelStrikeEvent.isCrossover == 1);


     


   
