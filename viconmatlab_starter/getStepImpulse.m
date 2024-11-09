function [impulseR,impulseL] = getStepImpulse(continuousDataR,...
continuousDataL,continuosDataTime, hsR, hsL)
global F
% get impulse of POSTIVE force for each step, based on continuous force
% data
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
    strideDataTime{strd,1} = sdTime; %(~cellfun('isempty',sdR)); %remove empty cells
end
% get impulse 
impR = NaN(size(strideDataR,1),1);
for ci = 1:size(strideDataR,1)
    a = strideDataR{ci,1}.*(strideDataR{ci,1} > 0);
    x = strideDataTime{ci,1};
    if ~isempty(x) && length(x) > 1
        imp0r = trapz(x,a);
        impR(ci,:) = imp0r;
    end
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
    strideDataTime{strd,1} = sdTime; %(~cellfun('isempty',sdL)); %remove empty cells
end
% resample each cell and writing to matrix
impL = NaN(size(strideDataL,1),1);
for ci = 1:size(strideDataL,1)
    a = strideDataL{ci,1}.*(strideDataL{ci,1} > 0);
    x = strideDataTime{ci,1};
    if ~isempty(x) && length(x) > 1
        imp0l = trapz(x,a);
        impL(ci,:) = imp0l;
    end
end
impulseR = impR;
impulseL = impL;
end