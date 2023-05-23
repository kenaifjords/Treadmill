%% findvalidHS
% ignore toe offs and determine whether heel strikes are both preceded and 
% followed by a heel strikes on the opposite leg
% as of 16May2023, the plan is to flag such heel strikes and move on. step
% length and step time asymmetries will only be measured if the heel strike
% is " valid" (ie preceded and followed by heel strikes on the opposite
% leg)
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
% is the first step with the right foot or the left foot? on a perhaps
% unimportant note, is the first step on the fast leg or the slow leg?
Rfirst = 0;
if hsR1(1) < hsL1(1) % first heelstrike is right
    hs1 = hsR1; hs2 = hsL1;
    to1 = toR1; to2 = toL1;
    Rfirst = 1;
elseif hsL1(1) < hsR1(1) % first heelstrike is left
    hs1 = hsL1; hs2 = hsR1;
    to1 = toL1; to2 = toR1;
end
%% identify valid heelstrikes
clear hs1valid hs2valid hsLvalid hsRvalid
% a heel strike is considered valid if it is preceded by a heel strike on
% the opposite foot and followed by a heel strike on the opposite foot
% for the leg of the first step
hs1valid = nan(length(hs1),1); hs2valid = nan(length(hs2),1);
hs1valid(1) = 1; % assume the first step is valid
minhs = min([length(hs1) length(hs2)]);
for i = 2:minhs
    % for the leg of the first step
    btw1 = find(hs1 > hs2(i - 1) & hs1 < hs2(i));
    if ~isempty(btw1) && length(btw1) == 1
        hs1valid(i) = 1;
    else
        hs1valid(btw1) = 0;
    end
end
for ii = 2:minhs
    % for the leg of the second step
    btw2 = find(hs2 > hs1(ii-1) & hs2 < hs1(ii));
    if ~isempty(btw2) && length(btw2) == 1
        hs2valid(ii) = 1;
    else
        hs2valid(btw2) = 0;
    end
end

disp(['right first? ' num2str(Rfirst)]);
disp(['first steps #: ' num2str(i) '; valid steps: ' num2str(sum(hs1valid,'omitnan'))]);
disp(['second steps #: ' num2str(ii) ': valid steps: ' num2str(sum(hs2valid,'omitnan'))]);

if Rfirst == 1
    hsRvalid = hs1valid; hsLvalid = hs2valid;
else
    hsLvalid = hs1valid; hsRvalid = hs2valid;
end