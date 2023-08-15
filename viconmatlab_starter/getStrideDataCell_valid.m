function [strideR, strideL] = getStrideDataCell_valid...
    (rdata, ldata, subj, effcond, blk)
% resampleToPercentGaitCycle
% 1) we input data that reflects the time profile of the data (position,
% forces, dynamics, kinematics etc.)
% 2) using heel strikes we trim the continuos profile into a cell structure
% that includes the time profile of each stride (one stride per row)
% 3) identify the force time integral, peak heel strike and toe off forces

% break down into each stride hsR and hsL are in time, we want to find the
% time in continuosDataTime that is closest to the hs time, then we want to
% save these indices
global F
nSamp = 100;
validr = F(subj).validstepR{effcond,blk};
validl = F(subj).validstepL{effcond,blk};
time = F(subj).time{effcond, blk};
% dtime = diff(time);
% a = find(dtime < 0,1,'first');
% if ~isempty(a)
%     time(a:end) = nan(length(time)-a+1,1);
% end
%% RIGHT FOOT
hsR = F(subj).hsR{effcond,blk}(validr(:,1));
for i = 1:length(hsR)
    % save the indices in time (the continuous data)
    ix = find(time<hsR(i),1,'last');
    if isempty(ix)
        hsidx(i) = NaN;
    else
        hsidx(i) = ix;
    end
end
% cut the continuous data into strides
for strd = 1:length(hsidx)-1
    if ~isnan(hsidx(strd)) && ~isnan(hsidx(strd + 1))
        sdR = rdata(hsidx(strd):hsidx(strd+1));
        sdtime = time(hsidx(strd):hsidx(strd + 1));
    else
        sdR = [];
        sdtime = [];
    end
    strideR{strd,1} = sdR;
    stridetime{strd,1} = sdtime;
end

%% LEFT FOOT
clear sdtime stridetime
hsL = F(subj).hsL{effcond,blk}(validl(:,1));
for i = 1:length(hsL)
    % save the indices in time (the continuous data)
    ix = find(time<hsL(i),1,'last');
    if isempty(ix)
        hsidx(i) = NaN;
    else
        hsidx(i) = ix;
    end
end
% cut the continuous data into strides
for strd = 1:length(hsidx)-1
    if ~isnan(hsidx(strd)) && ~isnan(hsidx(strd + 1))
        sdL = ldata(hsidx(strd):hsidx(strd+1));
        sdtime = time(hsidx(strd):hsidx(strd + 1));
    else
        sdL = [];
        sdtime = [];
    end
    strideL{strd,1} = sdL;
    stridetime{strd,1} = sdtime;
end
end
            

