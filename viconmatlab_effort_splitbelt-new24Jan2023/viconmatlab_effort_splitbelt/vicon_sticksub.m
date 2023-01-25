hold on
grid on
xlabel('X axis')
ylabel('Y axis')
zlabel('Z axis')

axis manual

rfootline=line(xRfoot(i,:)',yRfoot(i,:)',zRfoot(i,:)','color','r');
rllegline=line(xRlleg(i,:)',yRlleg(i,:)',zRlleg(i,:)','color','r');
rulegline=line(xRuleg(i,:)',yRuleg(i,:)',zRuleg(i,:)','color','r');
hhline=line(xhh(i,:)',yhh(i,:)',zhh(i,:)','color','b');
lfootline=line(xLfoot(i,:)',yLfoot(i,:)', zLfoot(i,:)','color','g');
lllegline=line(xLlleg(i,:)',yLlleg(i,:)', zLlleg(i,:)','color','g');
lulegline=line(xLuleg(i,:)',yLuleg(i,:)', zLuleg(i,:)','color','g');
%sternumline=line(xsternum(i,:)',ysternum(i,:)', zsternum(i,:)','color','c');
%trunkline=line(xtrunk(i,:)',ytrunk(i,:)',ztrunk(i,:)','color','k');   %changed to white for black background
% itrunkcsline=line(xitrunkcs(i,:)',yitrunkcs(i,:)',zitrunkcs(i,:)','color','r');
% jtrunkcsline=line(xjtrunkcs(i,:)',yjtrunkcs(i,:)',zjtrunkcs(i,:)','color','g');
% ktrunkcsline=line(xktrunkcs(i,:)',yktrunkcs(i,:)',zktrunkcs(i,:)','color','b');

% plot3(CG_lb(i,1), CG_lb(i,2),CG_lb(i,3),'b:o')                             %CG wholebody
% plot3(CG_ub(i,1), CG_ub(i,2),CG_ub(i,3),'g:o')                             %CG wholebody
% plot3(CG_wb(i,1), CG_wb(i,2),CG_wb(i,3),'k:o')                             %CG wholebody
plot3(0,0,0,'r:o')                                                        %origin

set(rfootline,'LineWidth',[3]);
set(rllegline,'LineWidth',[3]);
set(rulegline,'LineWidth',[3]);
set(hhline,'LineWidth',[3]);
set(lfootline,'LineWidth',[3]);
set(lllegline,'LineWidth',[3]);
set(lulegline,'LineWidth',[3]);
% set(sternumline,'LineWidth',[3]);
% set(trunkline,'LineWidth',[3]);
