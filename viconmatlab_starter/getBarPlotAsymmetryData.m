function[initial,early,late,ending] = getBarPlotAsymmetryData(asymprofile)
% function that we put an asymmetry profile into and out comes the bar plot
% values
initialpertstep = 1:5; % 10 steps are included in the computation of intiial perturbation
earlypertstep = 6:30;
latepertstep = 31:200;
endpertstep = 30;

if ~isempty(asymprofile) && length(asymprofile) > max(earlypertstep)
    lengthprof = length(asymprofile);
    lastvalid = find(~isnan(asymprofile),1,'last');
    initial = mean(asymprofile(initialpertstep),'omitnan');
    early = mean(asymprofile(earlypertstep),'omitnan');
    if lastvalid > max(latepertstep)
        late = mean(asymprofile(latepertstep),'omitnan');
    else
        late = mean(asymprofile(min(latepertstep):end),'omitnan');
    end
    if lastvalid > endpertstep
        ending = mean(asymprofile(lastvalid-endpertstep:lastvalid),'omitnan');
    else
        ending = NaN;
    end
else
    initial = NaN;
    early = NaN;
    late = NaN;
    ending = NaN;
end

