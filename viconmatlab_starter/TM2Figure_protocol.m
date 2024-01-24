% TM2Figure_protocol
% bar(0,[1,2,2,2,10,15,10,2],'stacked','Color');
load fisheriris
t = table(species,meas(:,1),meas(:,2),meas(:,3),meas(:,4),...
VariableNames=["species","meas1","meas2","meas3","meas4"]);
Meas = table([1 2 3 4]',VariableNames="Measurements");