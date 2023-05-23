% cleanHSandTO
% a proper stride requires a chronological order of hs1 to2 hs2 to1
clear hs1 hs2 hsR1 hsL1 ihsL1 ihsR1 validstep stepvalid1 stepvalid2...
    stepind1 stepind2 minstep
% remove "first" steps

%% identify whether the first step is spurious 
% sometimes there is a "first" step that has the exact same
% step time and opposite forces - an artifact of starting the
% treadmi1l? - this identifies the true first step and removes
% the spurious ones
fir = 1;
while hsR0(fir) == hsL0(fir)
        fir = fir + 1;
        if fir > 3
            % sets up an error in case the code idenifies the
            % spurious steps a large number of times (large
            % being arbitrarily set to 3)
            disp('check heel strikes, left and right seem to be the same')
        end 
end
% we trim the heelstrike vectors accordingly, removing spurious steps
hsR1 = hsR0(fir:end);
hsL1 = hsL0(fir:end);

% remove toe offs prior to the first heel strike
toR1 = toR0(toR0 > hsR1(1));
toL1 = toL0(toL0 > hsL1(1));

% match the indice vectors
ihsL1 = hsL_idx0(fir:end);
ihsR1 = hsR_idx0(fir:end);
itoR1 = toR_idx0(toR0 > hsR1(1));
itoL1 = toL_idx0(toL0 > hsL1(1));

%% identify first heelstrike
Rfirst = 0;
if hsR1(1) < hsL1(1) % first heelstrike is right
    hs1 = hsR1; hs2 = hsL1;
    to1 = toR1; to2 = toL1;
    Rfirst = 1;
elseif hsL1(1) < hsR1(1) % first heelstrike is left
    hs1 = hsL1; hs2 = hsR1;
    to1 = toL1; to2 = toR1;
end

%% define cleaned strides (for leg of first step)
% a proper stride requires a chronological order of hs1 to2 hs2 to1
% that is hs1 to2 (swing 2) hs2 to1 - stance 1 for the whole time
maxindex1 = min([length(hs1) length(to1)]);
j = 1;
for i1 = 1:maxindex1
    clear to2i hs2i to1i hs1i
    yesto = 0; yeshs = 0; % match the hs and to indices
    % check if there is a to2 between hs1 and to1
    to2i = find(to2 > hs1(i1) & to2 < to1(i1));
    % check if there is a  hs2 between hs1 and to1
    hs2i = find(hs2 > hs1(i1) & hs2 < to1(i1));
    % if there is both a to2 and a hs2 and there is only on of each,
    % the step is valid
    if length(to2i) == 1 && length(hs2i) == 1 && to2i < hs2i
        stepvalid1(i1,1) = 1; stepvalid1(i1,2) = hs1(i1);
        stepind1(i1,:) = [i1,to2i,hs2i,i1];
    % could check if there is an issue with the primary toe off and
    % adjust with i1t index
    else
        stepvalid1(i1,1) = 0; stepvalid1(i1,2) = hs1(i1);
        stepind1(i1,:) = NaN(1,4);
    end
end
%% define cleaned strides (for leg of second step)
% a proper stride requires a chronological order of hs2 to1 hs1 to2
% that is hs2 to1 (swing 1) hs1 to2 - stance 2 for the whole time
maxindex2 = min([length(hs2) length(to2)]);
for i2 = 1:maxindex2
    clear to2i hs2i to1i hs1i
    yesto = 0; yeshs = 0; % match the hs and to indices
    % check if there is a to2 between hs2 and to2
    to1i = find(to1 > hs2(i2) & to1 < to2(i2));
    % check if there is a  hs2 between hs1 and to1
    hs1i = find(hs1 > hs2(i2) & hs1 < to2(i2));
    % if there is both a to2 and a hs2 and there is only on of each,
    % the step is valid
    if length(to1i) == 1 && length(hs1i) == 1 && to1i < hs1i
        stepvalid2(i2,1) = 1; stepvalid2(i2,2) = hs2(i2);
        stepind2(i2,:) = [i2,to1i,hs1i,i2];
    % could check if there is an issue with the primary toe off and
    % adjust with i1t index
    else
        stepvalid2(i2,1) = 0; stepvalid2(i2,2) = hs2(i2);
        stepind2(i2,:) = NaN(1,4);
    end
end
% now find a way to remove any invalid steps from both steps 1 and steps 2
% - can we assume the indices are aligned in any way? how do we use the
% times to identify if they are not aligned? - try it now without
% verification
% do we have close to the same number of steps?
disp(['right first? ' num2str(Rfirst) '; first steps #: ' num2str(i1) '; second steps #: ' num2str(i2)]);

minstep = min([i1 i2]);
validstep = stepvalid1(1:minstep,1) + stepvalid2(1:minstep,1) - 1;
disp(['total valid steps ' num2str(sum(validstep))])
%%
    % if there are no hs2s or to2s -> then there is a missed step on
    % the secondary side (2)

    % if there are more than hs2s and to2s -> then there is a missed
    % step on the primary side (1)

    % if there is only a to2
    % if there is only a hs2

%% define cleaned strides (for leg of second step)
% a proper stride requires a chronological order of hs2 to1 hs1 to2
% that is hs2 to1 (swing 1) hs1 to2 - stance 2 for the whole time

%     
%     if Rfirst
%         stepvalid = cat(2,stepvalid2',stepvalid1');
%     else
%         stepvalid = cat(2,stepvalid1',stepvalid2');
%     end


    % if there are no hs2s or to2s -> then there is a missed step on
    % the secondary side (2)

    % if there are more than hs2s and to2s -> then there is a missed
    % step on the primary side (1)

    % if there is only a to2
    % if there is only a hs2
            
        
    