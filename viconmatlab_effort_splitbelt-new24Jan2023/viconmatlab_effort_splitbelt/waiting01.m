%%
close all 
clear all 

%% Read in vicon data from CSV file

readviconcsv

%%

dataraw=devicedata;
dataraw(:,[3:5 6:8 18:20 21:23])=-dataraw(:,[3:5 6:8 18:20 21:23]);


% Select only (16 col) : F1xF1yF1zM1xM1yM1zCOP1xCOP1yF2xF2yF2zM2xM2yM2zCOP2xCOP2y
dataraw = dataraw(:,[1 20]);
time = dataraw(:,1);
zforce = dataraw(:,2);

%%

%test
figure
plot(time, zforce, 'b')
axis ([12000 12500 0 1000])
xlabel('Time (s e-2)')
ylabel('Vertical Force (N)')
hold on

%%

% %identifying peaks
% 
%     if (zforce(i) < 10) & (zforce((i - 1) < 10) & (zforce((i - 2) < 10)
%         strike = i;
%     end
%     

