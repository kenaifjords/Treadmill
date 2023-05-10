function [strideDataR, strideDataL] = getStrideDataCell(continuousDataR,...
continuousDataL,continuosDataTime, hsR, hsL)
global F
nSamp = 100;
dt = 1/100;
% resampleToPercentGaitCycle
% 1) we input data that reflects the time profile of the data (position,
% forces, dynamics, kinematics etc.)
% 2) using heel strikes we trim the continuos profile into a cell structure
% that includes the time profile of each stride (one stride per row)

% break down into each stride hsR and hsL are in time, we want to find the
% time in continuosDataTime that is closest to the hs time, then we want to
% save these indices
for i = 1:length(hsR)
    ix = find(continuosDataTime < hsR(i),1,'last');
    if isempty(ix)
        continuosDataHsIdx(i) = NaN;
    else
        continuosDataHsIdx(i) = ix;
    end
end
cdhsi = continuosDataHsIdx;
for strd = 1:length(cdhsi)-1
    if ~isnan(cdhsi(strd)) && ~isnan(cdhsi(strd+1))
        sdR = continuousDataR(cdhsi(strd):cdhsi(strd+1));
        sdTime = continuosDataTime(cdhsi(strd):cdhsi(strd+1));
    else
        sdR = [];
        sdTime = [];
    end % nan strides will be empty
    strideDataR{strd,1} = sdR; %(~cellfun('isempty',sdR)); %remove empty cells
    strideDataTimeR{strd,1} = sdTime; %(~cellfun('isempty',sdR)); %remove empty cells
end

% LEFT
for i = 1:length(hsL)
    ix = find(continuosDataTime < hsL(i),1,'last');
    if isempty(ix)
        continuosDataHsIdx(i) = NaN;
    else
        continuosDataHsIdx(i) = ix;
    end
end
cdhsi = continuosDataHsIdx;
for strd = 1:length(cdhsi)-1
    if ~isnan(cdhsi(strd)) && ~isnan(cdhsi(strd+1))
        sdL = continuousDataL(cdhsi(strd):cdhsi(strd+1));
        sdTime = continuosDataTime(cdhsi(strd):cdhsi(strd+1));
    else
        sdL = [];
        sdTime = [];
    end % nan strides will be empty
    strideDataL{strd,1} = sdL; %(~cellfun('isempty',sdL)); %remove empty cells
    strideDataTimeL{strd,1} = sdTime; %(~cellfun('isempty',sdL)); %remove empty cells
end         
end