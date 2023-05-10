%% code to compare moments
% bertec acquire data (with axes at the back outer corners ands with
% left-directed x axis and a downward facing z axis) is compared to the csv
% ascii export from Vicon Nexux (the data observed in nexus may be
% translated at export)

% AT THIS TIME, WITH THIS SETUP
% nexus origin for moments are centered on each force plate with y directed
% to the front of treadmill, x directed to the right of the treadmill, and
% an upward x. this is NOT translated during export
%% load moment measurement files and plot
for i = 1:5
    num = ['0' num2str(i)];
    % load the ascii nexus forceplate export
    ndata0 = readmatrix(['testMoments' num '.csv']);
    ndata{i,1} = ndata0(6:end,:);
    n.FR{i,1} = ndata{i,1}(:,3:5);
    n.FL{i,1}= ndata{i,1}(:,18:20);
    
    n.MR{i,1} = ndata{i,1}(:,6:8)./10^3; % mm to m
    n.ML{i,1} = ndata{i,1}(:,21:23)./10^3; % mm to m
    
    n.COPR{i,1} = ndata{i,1}(:,9:10);
    n.COPL{i,1} = ndata{i,1}(:,24:25);
    
    % load the bertecAcquire forceplace file
    adata{i,1} = readmatrix(['testMoments' num '_acquire.csv']);
    a.FL{i,1} = adata{i,1}(:,5:7);
    a.FR{i,1}= adata{i,1}(:,16:18);
    
    a.ML{i,1} = adata{i,1}(:,8:10);
    a.MR{i,1} = adata{i,1}(:,19:21);
    
    a.COPL{i,1} = adata{i,1}(:,11:12);
    a.COPR{i,1} = adata{i,1}(:,22:23);
end

vars = {'FL' 'FR' 'ML' 'MR'}; pos = {'COPR' 'COPL'};
i = 5;
%% compare Z forces (verification
clear nin ain
figure('Name','Compare Z forces');

nin1 = n.FR{i,1}; ain1 = a.FR{i,1};
subplot(222); hold on % right
plot(nin1(:,3),'b');
plot(ain1(:,3),'r');
title('right')

clear ain nin
nin2 = n.FL{i,1}; ain2 = a.FL{i,1};
subplot(221); hold on % left
plot(nin2(:,3),'b');
plot(ain2(:,3),'r');
title('left')
legend({'nexux' 'acquire'})

subplot(223); hold on % right
plot(nin1(:,3),'g');
plot(nin2(:,3),'r');
title('nexux')

clear ain nin
nin = n.FL{i,1}; ain = a.FL{i,1};
subplot(224); hold on % left
plot(ain1(:,3),'g');
plot(ain2(:,3),'r');
title('aqcuire')
%% compare moments X
figure('Name','Compare X moments'); subplot(122); hold on % right
nin = n.MR{i,1}; ain = a.MR{i,1};
plot(nin(:,1),'g');
plot(ain(:,1),'g--');
title('right')

subplot(121); hold on % left
nin = n.ML{i,1}; ain = a.ML{i,1};
plot(nin(:,1),'r');
plot(ain(:,1),'r--');
title('left')
legend({'nexux' 'acquire'})


figure('Name','Compare X moments'); subplot(122); hold on % right
nin1 = n.MR{i,1}; nin2 = n.ML{i,1};
plot(nin1(:,1),'g');
plot(nin2(:,1),'r');
title('nexux')

subplot(121); hold on % left
ain1 = a.MR{i,1}; ain2 = a.ML{i,1};
plot(ain1(:,1),'g');
plot(ain2(:,1),'r');
title('acquire')

%% compare moments Y
figure('Name','Compare Y moments'); subplot(122); hold on % right
nin = n.MR{i,1}; ain = a.MR{i,1};
plot(nin(:,2),'g');
plot(ain(:,2),'g--');
title('right')

subplot(121); hold on % left
nin = n.ML{i,1}; ain = a.ML{i,1};
plot(nin(:,2),'r');
plot(ain(:,2),'r--');
title('left')
legend({'nexux' 'acquire'})


figure('Name','Compare y moments'); subplot(122); hold on % right
nin1 = n.MR{i,1}; nin2 = n.ML{i,1};
plot(nin1(:,2),'g');
plot(nin2(:,2),'r');
title('nexux')

subplot(121); hold on % left
ain1 = a.MR{i,1}; ain2 = a.ML{i,1};
plot(ain1(:,2),'g');
plot(ain2(:,2),'r');
title('acquire')

%% compare moments Z
figure('Name','Compare Z moments'); subplot(212); hold on % right
nin = n.MR{i,1}; ain = a.MR{i,1};
plot(nin(:,3),'g');
plot(ain(:,3),'g--');
title('right')

subplot(211); hold on % left
nin = n.ML{i,1}; ain = a.ML{i,1};
plot(nin(:,3),'r');
plot(ain(:,3),'r--');
title('left')
legend({'nexux' 'acquire'})


figure('Name','Compare z moments'); subplot(212); hold on % right
nin1 = n.MR{i,1}; nin2 = n.ML{i,1};
plot(nin1(:,3),'g');
plot(nin2(:,3),'r');
title('nexux')

subplot(211); hold on % left
ain1 = a.MR{i,1}; ain2 = a.ML{i,1};
plot(ain1(:,3),'g');
plot(ain2(:,3),'r');
title('acquire')
