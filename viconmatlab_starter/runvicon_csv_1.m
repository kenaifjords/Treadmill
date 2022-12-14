% mfile to load .csv vicon files

close all 
clear all 

animateyes=1;
%% Read in vicon data from CSV file

readviconcsv_1

%% Sort Data
%Forecplate1 (Right?) (XYZ?) I think Z is up/down b/c COP is zero; Y maybe
%in the direction of motion
%Make forces and moments negative so they represent forces acting on the
%subject rather than on the forceplatform

dataraw=devicedata;
dataraw(:,[3:5 6:8 18:20 21:23])=-dataraw(:,[3:5 6:8 18:20 21:23]);

% F1 = [dataraw(:,3) dataraw(:,4) dataraw(:,5)];  %N, 
% M1 = [dataraw(:,6) dataraw(:,7) dataraw(:,8)];  %Nmm
% COP1 = [dataraw(:,9) dataraw(:,10) ]; %mm
% 
% %Forecplate2 (Left?)
% % F2 = [-dataraw(:,18:20)];  %?N, 
% % M2 = [-dataraw(:,21:23)];  %?Nmm
% % COP2 =[ -dataraw(:,24:26)]; %mm
% 
% F2 = [dataraw(:,18) dataraw(:,19) dataraw(:,20)];  %N, 
% M2 = [dataraw(:,21) dataraw(:,22) dataraw(:,23)];  %Nmm
% COP2 = [dataraw(:,24) dataraw(:,25) ]; %mm

% Filter
% Select only (16 col) : F1xF1yF1zM1xM1yM1zCOP1xCOP1yF2xF2yF2zM2xM2yM2zCOP2xCOP2y
dataraw = dataraw(:,[3:10 18:25]);
fs = devicefs;
fc=20;
dt=1/fs;

time=[1:size(dataraw,1)]/fs;
trajtime=[1:size(trajdata,1)]/trajfs;

dataraw(isnan(dataraw))=0;
[datafilt]=diff23f5(dataraw,dt,fc);

%Take only filtered data (not derivatives)
data=datafilt(:,1:size(dataraw,2));

%Forecplate1 (Right)
F1 = [data(:,1) data(:,2) data(:,3)];  %N, 
M1 = [data(:,4) data(:,5) data(:,6)];  %Nmm
COP1 = [data(:,7) data(:,8) ]; %mm

%Forecplate2 (Left)
F2 = [data(:,9) data(:,10) data(:,11)];  %N, 
M2 = [data(:,12) data(:,13) data(:,14)];  %Nmm
COP2 = [data(:,15) data(:,16) ]; %mm

F1old=F1;
F2old=F2;
timeold=time;


%% Animation
tport=100;
if animateyes
    
figure
subplot(121)
plot(time(1),data(1,3),'b.')
axis([time(round(length(time)/tport)) time(round(2*length(time)/tport)) 0 max(data(:,3))])
xlabel('Time (s)')
ylabel('Vertical Force (N)')
hold on

subplot(122)
plot(data(1,7),data(1,8),'b.')
%axis([ min([min(data(:,8)) min(data(:,16))]) max([max(data(:,8)) max(data(:,16))])  min([min(data(:,7)) min(data(:,15))]) max([max(data(:,7)) max(data(:,15))])])
axis([ min([min(data(:,7)) min(data(:,15))]) max([max(data(:,7)) max(data(:,15))])  min([min(data(:,8)) min(data(:,16))]) max([max(data(:,8)) max(data(:,16))])])
xlabel('Lateral COP')
ylabel('Sagittal COP')
hold on 

for i=round(1*length(time)/tport):2:round(2*length(time)/tport)
    
    subplot(121)
    plot(time(i-5:i),data(i-5:i,3),'b')
    hold on
    plot(time(i-5:i),data(i-5:i,11),'r')
    
    subplot(122)
    if (data(i-5,3)) > 400
        plot(data(i-5:i,7),data(i-5:i,8),'b')
        hold on
    end
    if (data(i-5,11)) > 400
        plot(data(i-5:i,15),data(i-5:i,16),'r')
        hold on
    end
    
    pause(0.001)
end
end
%% Plot

figure
% subplot(311)
% plot(F1(:,1),'g')
% hold on
% plot(F2(:,1),'r')
% title('X forces')
% 
% subplot(312)
% plot(F1(:,2))
% hold on
% plot(F2(:,2),'r')
% title('Y forces')

subplot(313)
plot(F1(:,3))
hold on
plot(F2(:,3),'r')
title('Z forces')



%% Marker data
vicon_stick

%%
figure
plot(trajtime,pRankle(:,2))
hold on
plot(trajtime,pLankle(:,2),'g')
title('Ankle Marker')
xlabel('Position (Y) (mm)')
ylabel('Time (s)')

%% Identify heelstrike
time=resample(timeold,1,10);
F1=resample(F1old,1,10);
F2=resample(F2old,1,10);

F1((F1(:,3)<50),3)=0;
F2((F2(:,3)<50),3)=0;

F13post=[F1(2:end,3); F1(end,3)];
F23post=[F2(2:end,3); F2(end,3)];

F13pre=[F1(1,3); F1(1:end-1,3)];
F23pre=[F2(1,3); F2(1:end-1,3)];

ind_hsfp1=find(F1(:,3)==0 & F13post>0);
hsfp1=time(ind_hsfp1);

ind_hsfp2=find(F2(:,3)==0 & F23post>0);
hsfp2=time(ind_hsfp2);


ind_tofp1=find(F1(:,3)==0 & F13pre>0);
tofp1=time(ind_tofp1);

ind_tofp2=find(F2(:,3)==0 & F23pre>0);
tofp2=time(ind_tofp2);

figure
plot(time,F1(:,3));
hold on
plot(hsfp1,F1(ind_hsfp1,3),'go')
plot(tofp1,F1(ind_tofp1,3),'g*')
plot(time,F2(:,3),'r');
plot(hsfp2,F2(ind_hsfp2,3),'ko')
plot(tofp2,F2(ind_tofp2,3),'k*')
title('Heel Strikes')
xlabel('Time (s)')
ylabel('Heel Marker Height (mm)')

disp([length(hsfp1) length(hsfp2)])
disp([length(tofp1) length(tofp2)])
%% Calculate steplength, steptime, and steplength asymmetry
% 

i=1;
clear steptime1 steptime2

steplength2all=pLankle(ind_hsfp2,2)-pRankle(ind_hsfp2,2);
steplength1all=pRankle(ind_hsfp1,2)-pLankle(ind_hsfp1,2);

maxsteps=min([length(steplength1all) length(steplength2all)]);
steplength1=steplength1all(1:maxsteps);
steplength2=steplength2all(1:maxsteps); 
    
while i < min([length(hsfp1) length(hsfp2)])    
    %step time on belt 2 (left)
    if hsfp1(1)<hsfp2(1)   %fp1 strikes first
     steptime2(i)= hsfp2(i)-hsfp1(i);
    elseif hsfp1(1)>hsfp2(1) %fp2 strikes first so take its second heel strike
     steptime2(i)= hsfp2(i+1)-hsfp1(i); 
    end
 
    %step time on belt 1 (right)
     if hsfp2(1)<hsfp1(1)   %fp2 strikes first
     steptime1(i)= hsfp1(i)-hsfp2(i);
    elseif hsfp2(1)>hsfp1(1) %fp1 strikes first so take its second heel strike
     steptime1(i)= hsfp1(i+1)-hsfp2(i);
     end
    
    i=i+1;
end

%steptime_asym=steptime1-steptime2;
steplength_asym=(steplength1-steplength2)./(steplength1+steplength2); 

figure
subplot(211)
plot(hsfp2(1:maxsteps),steplength1,'bo')
title('Step Lengths')
hold on
plot(hsfp1(1:maxsteps),steplength2,'go')
ylabel('Length (mm)')
legend('Right','Left')
xlabel('Time (s)')


subplot(212)
plot(hsfp1(1:maxsteps),steplength_asym)
title('Asymmetry (R-L)')
ylabel('Length (mm)')
xlabel('Time (s)')

%figure
%subplot(211)
%plot(steptime1)
%title('Step Times')
%hold on
%plot(steptime2,'g')
%ylabel('Time (s)')
%legend('Right','Left')
 
%subplot(212)
%plot(steptime_asym)
%title('Asymmetry (R-L)')
%ylabel('Time (s)')