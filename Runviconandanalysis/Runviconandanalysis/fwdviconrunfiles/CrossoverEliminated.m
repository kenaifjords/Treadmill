%Writes all force data where crossover is to NaN
ind_Timecrossover_fp1 = find(heelStrikeEventFP1.time);
Timecrossover=heelStrikeEventFP1.time(ind_Timecrossover_fp1);
% what if any time that is crossover i just write to nan. do I want all
% forces to be nan, yes that would make the most sense, all moments, and
% cop too

%this writes forces to nan but crossover is defined  by heelstrike, thus to
%get the step times not to go wonky need to find corresponding step time.
%Idk how exactly I'd do that. Does hsfp1 correspond to time, yes it does.
%So I have the time crossover occurs(derived from force) so I need a
%condition that if between heelstrikes an instance of crossover occurs 
%then set the heelstrike to nan, but what will happen to the plot if the
%steptime is NaN. Should I write the first heelstrik ore second heelstrike
%to NaN, i guess the heelstrike values aren't invalid what i'll need to
%change is if between heelstrike 1 and 2 there is an instance of crossover 
%then the index will skip? to the next t
%this sets forces to NaN during crossover
i=1;
for i = 1:length(Timecrossover)
    F1(round(Timecrossover(i).*100),:) = NaN;
i = i+1;
end

% if between hsfp(i) and hsfp(i+1) there is a value in is crossover
%     then steptime(skips)
% else then the normal shit its doing rn

% Find a better way to see if a number is between two values
% Or make it more clear what values you are looking at

%current steptime code modified to account for crossover at in between
%consecutive heelstrikes.
i=1;
while i < min([length(hsfp1) length(hsfp2)])    
    %step time on belt 2 (left)
    if hsfp1(1)<hsfp2(1)   %fp1 strikes first
    % time crossover is when there is a instance of crossover between
    % two heelstrikes
    time_crossover=heelStrikeEventFP1.time(hsfp1(i)<heelStrikeEventFP2.time & heelStrikeEventFP2.time<hsfp2(i));
         if time_crossover > 0 
               steptime2(i)= NaN;
         else
             steptime2(i)= hsfp2(i)-hsfp1(i);
       clear time_crossover
         end   
    elseif hsfp1(1)>hsfp2(1) %fp2 strikes first so take its second heel strike
time_crossover1=heelStrikeEventFP2.time(hsfp2(i)<heelStrikeEventFP2.time & heelStrikeEventFP2.time<hsfp1(i));
%find(hsfp2(i)<heelStrikeEventFP2.time<hsfp1(i));
        if time_crossover1>0
            steptime2(i) = NaN;
        else
            steptime2(i)= hsfp2(i+1)-hsfp1(i); 
        clear time_crossover1
        end
    end
    %step time on belt 1 (right)
     if hsfp2(1)<hsfp1(1)   %fp2 strikes first
  %ind_crossover2=find(hsfp2(i)<heelStrikeEventFP1.time<hsfp1(i));
  time_crossover2 = heelStrikeEventFP1.time(hsfp2(i)<heelStrikeEventFP1.time & heelStrikeEventFP1.time<hsfp1(i));
        if time_crossover2>0
            steptime1(i) = NaN;
        else 
            steptime1(i)= hsfp1(i)-hsfp2(i);
         clear time_crossover2
        end
    elseif hsfp2(1)>hsfp1(1) %fp1 strikes first so take its second heel strike
  %ind_crossover3=find(hsfp1(i)<heelStrikeEventFP1.time<hsfp2(i));
  time_crossover3 = heelStrikeEventFP1.time(hsfp1(i)<heelStrikeEventFP1.time & heelStrikeEventFP1.time<hsfp2(i));
            if time_crossover3>0
                steptime1(i) = NaN;
            
            else
                 steptime1(i)= hsfp1(i+1)-hsfp2(i);
            end
            clear time_crossover3
     end
    i=i+1;
end

%the current issue is hsfp1 and hsfp2 are not the same size. they differ by
%7 heel strikes