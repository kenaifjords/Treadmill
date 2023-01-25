function [hsR,hsL,toR,toL] = getHeelStrikeAnkleMarker(pRankle,pLankle,trajtime)
% using the y position of the heel markers, we define heel strike as the
% maximum position and ankle off as the minimum position

% find heel strike with ankle
[yRanklemag,ihsRankle] = findpeaks(pRankle(:,2),'MinPeakDistance',90);
[yLanklemag,ihsLankle] = findpeaks(pLankle(:,2),'MinPeakDistance',90);
hsR = trajtime(ihsRankle);
hsL = trajtime(ihsLankle);

% find ankle off with ankle
[yRanklemin,itoRankle] = findpeaks(-pRankle(:,2),'MinPeakDistance',90);
[yLanklemin,itoLankle] = findpeaks(-pLankle(:,2),'MinPeakDistance',90);
% yRanklemin = -yRanklemin;
% yLanklemin = -yLanklemin;
toR = trajtime(itoRankle);
toL = trajtime(itoLankle);
end