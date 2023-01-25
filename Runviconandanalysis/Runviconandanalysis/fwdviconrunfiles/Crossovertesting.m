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

% in this code I want to make the index correspond to frames and use
% condition

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

%how do you integrate this into step count
i=1;

% while i < min([length(ind_hsfp1) length(ind_hsfp2)])   
% 
%     if logicallocMaxesfp1(ind_hsfp1(i)) == 1
%         ind_hsfp1(i) = nan;
%     end 
%  i=i+1;
% end

% for AAA_LE1
%plot(ind_hsfp1(1:length(steptime_asym)), steptime_asym)

%% For FP2
VFDerivative_fp2 = diff23f5(F2(:,3),dt,fc);
VFFirstDerivative_fp2 = VFDerivative_fp2(:,2);
[MaxesVFFirstDerivative_fp2,locMaxesfp2,WidthMaxesfp2,PromsMaxesfp2] = findpeaks(VFFirstDerivative_fp2);

%threshold for prominence so small prominence peaks are not recorded
absmaxPromfp2 = max(PromsMaxesfp2);
thresholdPromfp2 = .1.*absmaxPromfp2;

%threshold for the max first derivative if below threshold then could be
%crossover.
absmaxVFFD_fp2 = max(MaxesVFFirstDerivative_fp2);
maxthresholdfp2 = .5*absmaxVFFD_fp2;
minthresholdfp1 = .4*absmaxVFFD_fp2;

i=1;
locMaxesfp2_frame = zeros(size(F2,3),1);
for i = 1:length(MaxesVFFirstDerivative_fp2)
    if MaxesVFFirstDerivative_fp2(i) < maxthreshold && MaxesVFFirstDerivative_fp2(i) > minthreshold
        locMaxesfp2_frame(locMaxesfp2(i)) = nan;  
    else 
        locMaxesfp2_frame(locMaxesfp2(i)) = 1;
    end
    i=i+1;
end

logicallocMaxesfp2 = isnan(locMaxesfp2_frame);
framescrossover_fp2 = find(logicallocMaxesfp2 == 1);

%% remaking ind_hsfp1 and ind_hsfp2
for i = 1:length(ind_hsfp1)-1
    between1 = ind_hsfp1(i+1)-ind_hsfp1(i);
    for j = 1:between1
        if logicallocMaxesfp1(ind_hsfp1(i)+j) == 1
            newind_hsfp1 = ind_hsfp1(i)+j;
            remadeind_hsfp1 = [ind_hsfp1(1:i) ; newind_hsfp1 ; ind_hsfp1(i:end)];
        end
        j=j+1;
    end
    i=i+1;
end
remadehsfp1 = time(remadeind_hsfp1);

% Do the same for ind_hsfp2
clear i
clear j

for i = 1:length(ind_hsfp2)-1
    between2 = ind_hsfp2(i+1)-ind_hsfp2(i);
    for j = 1:between2
        if logicallocMaxesfp2(ind_hsfp2(i)+j) == 1
            newind_hsfp2 = ind_hsfp2(i)+j;
            remadeind_hsfp2 = [ind_hsfp2(1:i) ; newind_hsfp2 ; ind_hsfp2(i:end)];
        end
        j=j+1;
    end
    i=i+1;
end
remadehsfp2 = time(remadeind_hsfp2);

%% now if I recalculate steptime will it diverge

clear i
i=1;
clear steptime1 steptime2 

while i < min([length(remadehsfp1) length(remadehsfp2)])   

    
    %step time on belt 2 (left)
    if remadehsfp1(2)<remadehsfp2(2)   %fp1 strikes first
     remadesteptime2(i)= remadehsfp2(i)-remadehsfp1(i);
    elseif remadehsfp1(2)>remadehsfp2(2) %fp2 strikes first so take its second heel strike
     remadesteptime2(i)= remadehsfp2(i+1)-remadehsfp1(i); 
    end
 
    %step time on belt 1 (right)
     if remadehsfp2(2)<remadehsfp1(2)   %fp2 strikes first
     remadesteptime1(i)= remadehsfp1(i)-remadehsfp2(i);
    elseif hsfp2(2)>hsfp1(2) %fp1 strikes first so take its second heel strike
     remadesteptime1(i)= remadehsfp1(i+1)-remadehsfp2(i);
     end
    i=i+1;
end

% negate and shift up remadesteptime1?
remadesteptime_asym=(remadesteptime1-remadesteptime2)./(remadesteptime1+remadesteptime2);
edit_remadesteptime1 = -1*remadesteptime1+1.09;
edit_remadesteptime_asym=(edit_remadesteptime1-remadesteptime2)./(edit_remadesteptime1+remadesteptime2);
%% Graph remade one



figure
subplot(211)
plot(remadesteptime1,'b')
hold on
plot(edit_remadesteptime1,'r') % makes the plots almost line up
title('Remade Step Times')
hold on
plot(remadesteptime2,'g')
ylabel('Time (s)')
legend('Right','Edit Right','left')
 
subplot(212)
plot(remadesteptime_asym,'b')
title('Remade Asymmetry (R-L)/(R+L)')
ylabel('Time (s)')
hold on
plot(edit_remadesteptime1,'r')



