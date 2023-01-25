function [tlaR, tlaL] = getTrailingLimbAngleHeelStrike(Rankle,Lankle,Rpsis,Lpsis)
oppR = Rpsis(:,1) - Rankle(:,1);
adjR = Rpsis(:,3) - Rankle(:,3);
oppL = Lpsis(:,1) - Lankle(:,1);
adjL = Lpsis(:,3) - Lankle(:,3);

angR = atan2(oppR,adjR);
angL = atan2(oppL,adjL);

tlaR = angR;
tlaL = angL;

% identify extrema and use index to find hs and to times
[anglemaxR, ihstlaR] = findpeaks(angR);
end
