function [p] = vicon_markers(trajdataonly)
%Markers
%LASI;RASI;LPSI;RPSI;LTHI;LKNE;LTIB;LANK;LHEE;LTOE;RTHI;RKNE;RTIB;RANK;RHEE;RTOE	

% trajdataonly=trajdata(:,3:end);
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
xRfoot=[p.Rankle(:,1) p.Rheel(:,1) p.Rtoe(:,1) p.Rankle(:,1)];   
yRfoot=[p.Rankle(:,2) p.Rheel(:,2) p.Rtoe(:,2) p.Rankle(:,2)];   
zRfoot=[p.Rankle(:,3) p.Rheel(:,3) p.Rtoe(:,3) p.Rankle(:,3)]; 

xRlleg=[p.Rankle(:,1) p.Rtibia(:,1) p.Rknee(:,1) ];  
yRlleg=[p.Rankle(:,2) p.Rtibia(:,2) p.Rknee(:,2) ];  
zRlleg=[p.Rankle(:,3) p.Rtibia(:,3) p.Rknee(:,3) ]; %line from ankle to knee

xRuleg=[p.Rknee(:,1) p.Rasis(:,1) ];    
yRuleg=[p.Rknee(:,2) p.Rasis(:,2) ];    
zRuleg=[p.Rknee(:,3) p.Rasis(:,3) ];   %line from knee to hip

xhh=[p.Rasis(:,1) p.Lasis(:,1) p.Lpsis(:,1) p.Rpsis(:,1) p.Rasis(:,1)];        
yhh=[p.Rasis(:,2) p.Lasis(:,2)  p.Lpsis(:,2) p.Rpsis(:,2) p.Rasis(:,2) ];        
zhh=[p.Rasis(:,3) p.Lasis(:,3)  p.Lpsis(:,3) p.Rpsis(:,3) p.Rasis(:,3)];       %line from knee to hip

xLfoot=[p.Ltoe(:,1) p.Lankle(:,1) p.Lheel(:,1) p.Ltoe(:,1) ];   
yLfoot=[p.Ltoe(:,2) p.Lankle(:,2) p.Lheel(:,2) p.Ltoe(:,2) ];   
zLfoot=[p.Ltoe(:,3) p.Lankle(:,3) p.Lheel(:,3) p.Ltoe(:,3) ];
xLlleg=[p.Lankle(:,1) p.Ltibia(:,1) p.Lknee(:,1) ];  
yLlleg=[p.Lankle(:,2) p.Ltibia(:,2) p.Lknee(:,2) ];  
zLlleg=[p.Lankle(:,3) p.Ltibia(:,3) p.Lknee(:,3) ]; %line from ankle to knee
xLuleg=[p.Lknee(:,1) p.Lasis(:,1) ];    
yLuleg=[p.Lknee(:,2) p.Lasis(:,2) ];    
zLuleg=[p.Lknee(:,3) p.Lasis(:,3) ];   %line from knee to hip


% xsternum=[sternum(:,1) lclavicle(:,1) rclavicle(:,1) sternum(:,1)];
% ysternum=[sternum(:,2) lclavicle(:,2) rclavicle(:,2) sternum(:,2)];
% zsternum=[sternum(:,3) lclavicle(:,3) rclavicle(:,3) sternum(:,3)];
% xtrunk=[pLhip(:,1)+(pRhip(:,1)-pLhip(:,1))/2 sternum(:,1)];
% ytrunk=[pLhip(:,2)+(pRhip(:,2)-pLhip(:,2))/2 sternum(:,2)];
% ztrunk=[pLhip(:,3)+(pRhip(:,3)-pLhip(:,3))/2 sternum(:,3)];

end

