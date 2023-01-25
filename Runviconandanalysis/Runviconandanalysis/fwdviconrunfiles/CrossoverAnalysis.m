%using crossover events to find where to eliminate data
ind_Timecrossover_fp1 = find(heelStrikeEventFP1.time);
Timecrossover=heelStrikeEventFP1.time(ind_Timecrossover_fp1);
% what if any time that is crossover i just write to nan. do I want all
% forces to be nan, yes that would make the most sense, all moments, and
% cop too
i=1;
for i = 1:length(Timecrossover)
    F1(Timecrossover(i),3) = NaN;
i = i+1;
end

%might need to do all of this processing in run vicon b/c now its too late
  
