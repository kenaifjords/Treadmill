%% findvalidHS_v2
% ignore toe offs and determine whether heel strikes are both preceded and 
% followed by a heel strikes on the opposite leg
% as of 16May2023, the plan is to flag such heel strikes and move on. step
% length and step time asymmetries will only be measured if the heel strike
% is " valid" (ie preceded and followed by heel strikes on the opposite
% leg)
% as of 17 May, we also want to check that there are not multiple
% heelstrikes from one foot that both satisfy the previous requirements. To
% do this, we need to identify that the heel strikes are alternating in
% time.
% Modus Operandi: 
% 2) check that a given heel strike on the first step side (side 1) falls
% befort the index matched

% %% identify first heelstrike
% % is the first step with the right foot or the left foot? on a perhaps
% % unimportant note, is the first step on the fast leg or the slow leg?
% Rfirst = 0;
% if hsR1(1) < hsL1(1) % first heelstrike is right
%     hs1 = hsR1; hs2 = hsL1;
%     to1 = toR1; to2 = toL1;
%     Rfirst = 1;
% elseif hsL1(1) < hsR1(1) % first heelstrike is left
%     hs1 = hsL1; hs2 = hsR1;
%     to1 = toL1; to2 = toR1;
% end
%% identify valid heelstrikes
clear hs1valid hs2valid hsLvalid hsRvalid
% a heel strike is considered valid if it is preceded by a heel strike on
% the opposite foot and followed by a heel strike on the opposite foot
% for the leg of the first step
hs1valid = zeros(length(hs1),1); hs2valid = zeros(length(hs2),1);
hs1valid(1) = 1; % assume the first step is valid
minhs = min([length(hs1) length(hs2)]);
for i = 2:minhs
    % for the leg of the first step
    btw1 = find(hs1 > hs2(i - 1) & hs1 < hs2(i));
    if ~isempty(btw1) && length(btw1) == 1
        hs1valid(i) = 1;
        if btw1 ~= i
            disp(['index in hs1 matching requirements for hs2(i-1:i) is not i: i = '...
                num2str(i) '; btw1 = ' num2str(btw1) '; hs1 time = ' num2str(hs1(btw1))])
        end
    else
        hs1valid(btw1) = 0;
    end
end
for ii = 2:minhs
    % for the leg of the second step
    btw2 = find(hs2 > hs1(ii-1) & hs2 < hs1(ii));
    if ~isempty(btw2) && length(btw2) == 1
        hs2valid(ii) = 1;
        if btw2 ~= ii-1
            disp(['index in hs2 matching requirements for hs1(i-1:i) is not i: ii = '...
                num2str(ii) '; btw2 = ' num2str(btw2) '; hs1 time = ' num2str(hs2(btw2))])
        end
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