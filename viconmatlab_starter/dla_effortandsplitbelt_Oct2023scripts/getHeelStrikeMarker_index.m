function [ihsRheel,ihsLheel,itoRheel,itoLheel] = getHeelStrikeMarker_index(pRtoe,pLtoe,pRheel,pLheel,trajtime)
% using the y position of the heel markers, we define heel strike as the
% maximum position and toe off as the minimum position

% % find heel strike with toe
% [yRtoemag,ihsRtoe] = findpeaks(pRtoe(:,2),'MinPeakDistance',90);
% [yLtoemag,ihsLtoe] = findpeaks(pLtoe(:,2),'MinPeakDistance',90);
% hsR = trajtime(ihsRtoe);
% hsL = trajtime(ihsLtoe);

% changed column index from 2 to 1 on 31Jan2023 and back to 1Feb2023

% find heel strike with heel
[yRheelmag,ihsRheel] = findpeaks(pRheel(:,2),'MinPeakDistance',90);
[yLheelmag,ihsLheel] = findpeaks(pLheel(:,2),'MinPeakDistance',90);
hsR = trajtime(ihsRheel);
hsL = trajtime(ihsLheel);

% find toe off with heel
[yRheelmin,itoRheel] = findpeaks(-pRheel(:,2),'MinPeakDistance',90);
[yLheelmin,itoLheel] = findpeaks(-pLheel(:,2),'MinPeakDistance',90);
% yRheelmin = -yRheelmin;
% yLheelmin = -yLheelmin;
toR = trajtime(itoRheel);
toL = trajtime(itoLheel);
end