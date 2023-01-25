%This script will determine crossover by looking at the derivative of force
%anywehre the derivative of force is below a threshold it will lable that
%event as crossover. 
%there are two outputs heelStrikeEventFP1 and heelStrikeEventFP2 both are structs of the same form. 
%heelstrikeEventFP1.time is a double for the time crossover occurs
%heelstrikeEventFP1.isCrossover is a boolean with isCrossover = 1 when
%there is an instance of crossover
%The same form is true for force plate 2.
%At the end it output number of crossover events of each force plate.

%% Force Plate 1 Crossover 
%Finds peaks of Vertical first derivative of force, their location, width, and prominence
VFDerivative_fp1 = diff23f5(F1(:,3),dt,fc); 
VFFirstDerivative_fp1 = VFDerivative_fp1(:,2);
[MaxesVFFirstDerivative_fp1,locMaxesfp1,WidthMaxes,PromsMaxes] = findpeaks(VFFirstDerivative_fp1);


%threshold for prominence so small prominence peaks are not recorded
absmaxProm = max(PromsMaxes);
thresholdProm = .1.*absmaxProm;

%threshold for the max first derivative if below threshold then could be
%crossover.
absmaxVFFD = max(MaxesVFFirstDerivative_fp1);
maxthreshold = .7*absmaxVFFD;
minthreshold = .1*absmaxVFFD;

% in this code I want to make the index correspond to frames

i=1;
locMaxesfp1_frame = zeros(size(F1,3),1);
for i = 1:length(MaxesVFFirstDerivative_fp1)
    if MaxesVFFirstDerivative_fp1(i) < maxthreshold && MaxesVFFirstDerivative_fp1(i) > minthreshold
        locMaxesfp1_frame(locMaxesfp1(i)) = nan;  
    else 
        locMaxesfp1_frame(locMaxesfp1(i)) = 1;
    end
    i=i+1;
end


logicallocMaxesfp1 = isnan(locMaxesfp1_frame);
framescrossover_fp1 = find(logicallocMaxesfp1 == 1);

%Defines heelStrikeEvent struct
timevaluefp1 = zeros(size(MaxesVFFirstDerivative_fp1)); 
field1 = 'time';
isCrossovervaluefp1 = zeros(size(MaxesVFFirstDerivative_fp1));
field2 = 'isCrossover';
heelStrikeEventFP1 = struct(field1,timevaluefp1,field2,isCrossovervaluefp1);


%For loop with nested if determining the first derivatives who meet the conditions to be
%labeled as crossover. 
i=1;
for i = 1:length(MaxesVFFirstDerivative_fp1)
    if MaxesVFFirstDerivative_fp1(i)<maxthreshold && PromsMaxes(i)>thresholdProm
        heelStrikeEventFP1.isCrossover(i) = 1;
        heelStrikeEventFP1.time(i) = locMaxesfp1(i);
    else
        heelStrikeEventFP1.time(i)=0;
        heelStrikeEventFP1.isCrossover(i) = 0;

    end
    i=i+1;
end

%% Now repeat process for force plate 2
%Finds peaks of first derivative, their location, width, and prominence
VFDerivative_fp2 = diff23f5(F2(:,3),dt,fc);
VFFirstDerivative_fp2 = VFDerivative_fp2(:,2);
[MaxesVFFirstDerivative_fp2,locMaxesfp2,WidthMaxesfp2,PromsMaxesfp2] = findpeaks(VFFirstDerivative_fp2);

%threshold for prominence so small prominence peaks are not recorded
absmaxPromfp2 = max(PromsMaxesfp2);
thresholdPromfp2 = .1.*absmaxPromfp2;

%threshold for the max first derivative if below threshold then could be
%crossover.
absmaxVFFD_fp2 = max(MaxesVFFirstDerivative_fp2);
maxthreshold_fp2 = .7*absmaxVFFD_fp2;
minthreshold_fp2= .1*absmaxVFFD_fp2;

% in this code I want to make the index correspond to frames

i=1;
locMaxesfp2_frame = zeros(size(F1,3),1);
for i = 1:length(MaxesVFFirstDerivative_fp2)
    if MaxesVFFirstDerivative_fp2(i) < maxthreshold_fp2 && MaxesVFFirstDerivative_fp2(i) > minthreshold_fp2
        locMaxesfp2_frame(locMaxesfp2(i)) = nan;  
    else 
        locMaxesfp2_frame(locMaxesfp2(i)) = 1;
    end
    i=i+1;
end

logicallocMaxesfp2 = isnan(locMaxesfp2_frame);
framescrossover_fp2 = find(logicallocMaxesfp2 == 1);

%Defines heelStrikeEvent struct
timevaluefp1 = zeros(size(MaxesVFFirstDerivative_fp2)); 
field1 = 'time';
isCrossovervaluefp1 = zeros(size(MaxesVFFirstDerivative_fp2));
field2 = 'isCrossover';
heelStrikeEventFP2 = struct(field1,timevaluefp1,field2,isCrossovervaluefp1);

%For loop with nested if dertermining the first derivatives who meet the conditions to be
%labeled as crossover. 
i=1;
for i = 1:length(MaxesVFFirstDerivative_fp2)
    if MaxesVFFirstDerivative_fp2(i)<thresholdfp2 && PromsMaxesfp2(i)>thresholdPromfp2
        heelStrikeEventFP2.isCrossover(i) = 1;
        heelStrikeEventFP2.time(i) = locMaxesfp2(i);
    else
        heelStrikeEventFP2.time(i)=0;
        heelStrikeEventFP2.isCrossover(i) = 0;

    end
    i=i+1;
end

%% Output signficant crossover

InstancesCrossoverFP1 = length(find(heelStrikeEventFP1.isCrossover));
InstancesCrossoverFP2 = length(find(heelStrikeEventFP2.isCrossover));
    





