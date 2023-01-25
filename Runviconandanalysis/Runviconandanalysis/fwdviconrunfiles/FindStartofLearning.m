% This file will determine the start of the learning period by identifying
% the index it occurs
% How do I define the fast belt?
%The fast belt is the one with cop moving 1.45 m/s backwards thus It would
%be the same as having the condition. Could I just define the fast belt
%this way and then I only need one condition within the if statement
%becuase otherwise it'd be redundant
%
%COP1 and COP2
%
%The fas
%VFDerivative_fp1 = diff23f5(F1(:,3),dt,fc); 
%Which column of COP what are the different Columns?????? X And Y so I want
%column 2 because that is y and thats the direction the treamill is
%rotating
%must determine the fast belt first using cop
%I think this is in millimeters
derivCOP1 = diff23f5(COP1(:,2),dt,fc);
velocityCOP1 = derivCOP1(:,2);

derivCOP2 = diff23f5(COP2(:,2),dt,fc);
velocityCOP2 = derivCOP2(:,2);
% 
% i =1;
% for i = 1:length(velocityCOP1)
%     if velocityCOP1(i) > 1450
%         fastbeltForce = F1;
%     else
%         fastbeltForce = F2;  
%     end
% end
%the above seems weird and hard instead just enter in the belt that was
%fast in Alaa's case it was the right belt

%this is vertical force fp1. Not using F1 because indecies are wrong. 
%data(:,3) is FP1 and data(:,11) is FP2
fastbeltForce = data(:,3);  
%thresholdforce = about body weight
i=1;

%for alaa the split should start at 244000 ish frames for LE1 10/11
%why does it not line up]
%700 was very arbitually chosen.

for i = 1:length(fastbeltForce(:))
    if fastbeltForce(i) > 550 && velocityCOP1(i) < -1450
        split(i) = 1;
    else
        split(i) = 0;
    end
end

ind_split = find(split ==1);
StartofLearning = ind_split(1);

