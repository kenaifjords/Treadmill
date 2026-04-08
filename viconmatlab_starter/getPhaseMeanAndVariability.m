function [phaseMean,phaseVar] = getPhaseMeanAndVariability(indata)
% indata must be a vector (1 x _) or (_ x 1) for teh indexing to work
% function that we put an asymmetry profile into and out comes the bar plot
% values
initialpertstep = 1:5; % 10 steps are included in the computation of intiial perturbation
earlypertstep = 6:30;
latepertstep = 31:200;
endpertstep = 20;

if ~isempty(indata) && length(indata) > max(earlypertstep)
    lengthprof = length(indata);
    lastvalid = find(~isnan(indata),1,'last');
    
    initial = mean(indata(initialpertstep),'omitnan');
    initialv = var(indata(initialpertstep),'omitnan');
    
    early = mean(indata(earlypertstep),'omitnan');
    earlyv = var(indata(earlypertstep),'omitnan');
    
    if lastvalid > max(latepertstep)
        late = mean(indata(latepertstep),'omitnan');
        latev = var(indata(latepertstep),'omitnan');
    else
        late = mean(indata(min(latepertstep):end),'omitnan');
        latev = var(indata(min(latepertstep):end),'omitnan');
    end
    if lastvalid > endpertstep
        ending = mean(indata(lastvalid-endpertstep:lastvalid),'omitnan');
        endingv = var(indata(lastvalid-endpertstep:lastvalid),'omitnan');
    else
        ending = NaN;
        endingv = NaN;
    end
    
    across = mean(indata,'omitnan');
    acrossv = var(indata,'omitnan');
else
    initial = NaN;  initialv = NaN;
    early = NaN;    earlyv = NaN;
    late = NaN;     latev = NaN;
    ending = NaN;   endingv = NaN;
    across = NaN;   acrossv = NaN;
end
phaseMean = [initial, early, late, ending, across];
phaseVar = [initialv, earlyv, latev, endingv, acrossv];

