function [p] = vicon_markers(trajdataonly)
%Markers
%LASI;RASI;LPSI;RPSI;LTHI;LKNE;LTIB;LANK;LHEE;LTOE;RTHI;RKNE;RTIB;RANK;RHEE;RTOE	

trajdataonly=trajdata(:,3:end);
p.Lasis=trajdataonly(:,1:3);
p.Rasis=trajdataonly(:,4:6);
p.Lpsis=trajdataonly(:,7:9);
p.Rpsis=trajdataonly(:,10:12);
p.Lthigh=trajdataonly(:,13:15);
p.Lknee=trajdataonly(:,16:18);
p.Ltibia=trajdataonly(:,19:21);
p.Lankle=trajdataonly(:,22:24);
p.Lheel=trajdataonly(:,25:27);
p.Ltoe=trajdataonly(:,28:30);
p.Rthigh=trajdataonly(:,31:33);
p.Rknee=trajdataonly(:,34:36);
p.Rtibia=trajdataonly(:,37:39);
p.Rankle=trajdataonly(:,40:42);
p.Rheel=trajdataonly(:,43:45);
p.Rtoe=trajdataonly(:,46:48);

%%%create segment line coordinates
xRfoot=[pRankle(:,1) pRheel(:,1) pRtoe(:,1) pRankle(:,1)];   yRfoot=[pRankle(:,2) pRheel(:,2) pRtoe(:,2) pRankle(:,2)];   zRfoot=[pRankle(:,3) pRheel(:,3) pRtoe(:,3) pRankle(:,3)]; 
xRlleg=[pRankle(:,1) pRtibia(:,1) pRknee(:,1) ];  yRlleg=[pRankle(:,2) pRtibia(:,2) pRknee(:,2) ];  zRlleg=[pRankle(:,3) pRtibia(:,3) pRknee(:,3) ]; %line from ankle to knee
xRuleg=[pRknee(:,1) pRasis(:,1) ];    yRuleg=[pRknee(:,2) pRasis(:,2) ];    zRuleg=[pRknee(:,3) pRasis(:,3) ];   %line from knee to hip

xhh=[pRasis(:,1) pLasis(:,1) pLpsis(:,1) pRpsis(:,1) pRasis(:,1)];        yhh=[pRasis(:,2) pLasis(:,2)  pLpsis(:,2) pRpsis(:,2) pRasis(:,2) ];        zhh=[pRasis(:,3) pLasis(:,3)  pLpsis(:,3) pRpsis(:,3) pRasis(:,3)];       %line from knee to hip

xLfoot=[pLtoe(:,1) pLankle(:,1) pLheel(:,1) pLtoe(:,1) ];   yLfoot=[pLtoe(:,2) pLankle(:,2) pLheel(:,2) pLtoe(:,2) ];   zLfoot=[pLtoe(:,3) pLankle(:,3) pLheel(:,3) pLtoe(:,3) ];
xLlleg=[pLankle(:,1) pLtibia(:,1) pLknee(:,1) ];  yLlleg=[pLankle(:,2) pLtibia(:,2) pLknee(:,2) ];  zLlleg=[pLankle(:,3) pLtibia(:,3) pLknee(:,3) ]; %line from ankle to knee
xLuleg=[pLknee(:,1) pLasis(:,1) ];    yLuleg=[pLknee(:,2) pLasis(:,2) ];    zLuleg=[pLknee(:,3) pLasis(:,3) ];   %line from knee to hip


% xsternum=[sternum(:,1) lclavicle(:,1) rclavicle(:,1) sternum(:,1)];
% ysternum=[sternum(:,2) lclavicle(:,2) rclavicle(:,2) sternum(:,2)];
% zsternum=[sternum(:,3) lclavicle(:,3) rclavicle(:,3) sternum(:,3)];
% xtrunk=[pLhip(:,1)+(pRhip(:,1)-pLhip(:,1))/2 sternum(:,1)];
% ytrunk=[pLhip(:,2)+(pRhip(:,2)-pLhip(:,2))/2 sternum(:,2)];
% ztrunk=[pLhip(:,3)+(pRhip(:,3)-pLhip(:,3))/2 sternum(:,3)];



