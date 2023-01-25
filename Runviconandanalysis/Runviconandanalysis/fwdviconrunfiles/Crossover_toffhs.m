% % Looking At toe offs and heelstrikes to find crosssover
% 
% if hsfp1(1)<hsfp2(1)
%     firstHS = hspf1;
%     firstTO = tofp1;
%     secondHS = hsfp2;
%     secondTO = tofp2;
% elseif hsfp1(1)>hsfp2(1)
%     firstHS = hsfp2;
%     firstTO = tofp2;
%     secondHS = hsfp1;
%     secondTO = tofp1;
% elseif hsfp1(1)=hsfp2(1)
%     if hsfp1(2)<hsfp2(2)
%         firstHS = hsfp1;
%         firstTO = tofp1;
%         secondHS = hsfp2;
%         secondTO = tofp2;
%     elseif hsfp1(2)>hsfp2(2)
%         firstHS = hsfp2;
%         firstTO = tofp2;
%         secondHS = hsfp1;
%         secondTO = tofp1;
%     end
% end
% 
% %Now to determine in first hs if the corresponding toe off is less then hs
% if firstHS(1)<firstTO(1)
%     startpattern1 = firstHS;
%     endpattern1 = firstTO;
% elseif firstHS(1)>firstTO(1)
%     startpattern1 = firstTO;
%     endpattern1 = firstHS;
% end
% 
% if secondHS(1)<secondTO(1)
%     startpattern2 = secondHS;
%     endpattern2 = secondTO;
% elseif secondHS(1)>secondTO(1)
%     startpattern2 = secondTO;
%     endpattern2 = secondHS;
% end
% 
% %Need for loop  to cycle through. If endpa
% i=1;
% for i = 1: min(length([hspf1 hsfp2]))
%     if 
% 


