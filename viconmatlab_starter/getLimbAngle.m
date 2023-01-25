function [tlaR, tlaL] = getLimbAngle(Rankle,Lankle,Rpsis,Lpsis)
oppR = Rpsis(:,1) - Rankle(:,1);
adjR = Rpsis(:,3) - Rankle(:,3);
oppL = Lpsis(:,1) - Lankle(:,1);
adjL = Lpsis(:,3) - Lankle(:,3);

leginfrontR = (oppR < 0);
leginfrontL = (oppL < 0);

% angR = atan(oppR./adjR);
% angL = atan(oppL./adjL);

angR = atan2(abs(oppR),adjR);
angL = atan2(abs(oppL),adjL);

angR = angR .* ~leginfrontR + angR .* -1.*leginfrontR;
angL = angL .* ~leginfrontL + angL .* -1.*leginfrontL;

% for i = 2:size(angR,1)
%     if (angR(i) - angR(i-1)) >= 2*pi
%         angR(i) = angR(i) + 2*pi;
%     end
% end
% 
% for i = 2:size(angL,1)
%     if (angL(i) - angL(i-1)) >= 2*pi
%         angL(i) = angL(i) + 2*pi;
%     end
% end
        
tlaR = angR;
tlaL = angL;
end
