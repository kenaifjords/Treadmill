%New Crossover Event code
%for i=round(1*length(time)/tport):2:round(2*length(time)/tport)
%The above code seems to be making an index that works in time and data
% it is taking the length of time dividing it my 100 to get an index i think

% First describe what a heelStrikeEvent is
timevalue = zeros(size(hsfp1)); % 00000 00000
field1 = 'time';
isCrossovervalue = zeros(size(hsfp1));
field2 = 'isCrossover';

heelStrikeEventFP1 = struct(field1,timevalue,field2,isCrossovervalue);

i=1;
for i = 1:length(hsfp1)-1
    hsfp1frame = round(1000.*hsfp1(i)); 

%this frame should correspond with the correct frame from force data

    nexthsfp1frame = round(1000.*hsfp1(i+1));

    framesbetweenhs = [hsfp1frame:nexthsfp1frame,1]; 
%column vector of frames between heelstrikes

    forcebetweenhs = data(framesbetweenhs,3);
 %column vector of the forces between the specified frames
    
    ind_Crossover = find(forcebetweenhs < 50);
 % indexes where vertical force is less than 50 newtons
 %%fuck i thought heelstrike was peak force none of this shit will work
 %%because heelstrike is defined when the force is zero and its
 %%derivative is positive. I need to find quantity that is the peak force
 %%for each step then the rest of this code will work. 
 

    if sum(ind_Crossover) == 0 %if it never zeroed must be crossover
        heelStrikeEventFP1.time(i)=hsfp1(i+1);
        heelStrikeEventFP1.isCrossover(i) = 1;
    else %No crossover
        heelStrikeEventFP1.time(i)=0;
        heelStrikeEventFP1.isCrossover(i) = 0;
    end
    i=i+1;
end

% find all points where 1st derivative is at max. I have the second
% derivative which, when set = 0 tells all max/min, but don't have third to
% seperate max from min. will have to determine max by looking at force
% data. 
% SecondDerivativeVF_F1 = VFDerivative_F1(:,3);
% %CPFirstDerivativeVF_F1 = find(-1<SecondDerivativeVF_F1<1); %what should tolerance be?
% %need a tolerance for zero becauase it never hits zero
% %because it is not a continous fxn and data is data
% %findpeaks function to find peaks of first derivative
% i=1;
% for i = 1:length(VFDerivative_F1)
%     if VFDerivative_F1(i,2)>0 && find(CPFirstDerivativeVF_F1 ==i)>0
%         ind_maxfirstDerivative=i;
%     end
%     i=i+1;
% end
% % this yeilds the index at which a max first derivative occurs, now find
% % whether that max is below a thresold


