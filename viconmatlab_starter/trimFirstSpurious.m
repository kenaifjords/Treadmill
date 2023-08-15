%% identify whether the first step is spurious 
% sometimes there is a "first" step that has the exact same
% step time and opposite forces - an artifact of starting the
% treadmi1l? - this identifies the true first step and removes
% the spurious ones
fir = 1;
while hsR0(fir) == hsL0(fir) && fir < length(hsR0) && fir < length(hsL0)
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

if length(hsR0) < 2 || length(hsL0) < 2
    hsR1 = []; hsL1 = []; ihsL1 = []; ihsR1 = [];
end