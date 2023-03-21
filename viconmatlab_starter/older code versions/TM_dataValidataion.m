% TM Validate
tic
% load data
global homepath
global subject
global F
global p
% navigation
homepath = pwd;
path = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\csvData';

% data collection device parameters
devicefs = 1000; %1000 Hz for the treadmill, 100Hz for cameras
trajfs = 100; %   100Hz for cameras

% list of subjects
valsubj = {'DCD'}; % 'DAT' 'IHU' 'EDC'
nvalsubj = length(valsubj);
valblockname = {'HE1'}; % 'HE2' 'LE1' 'LE2'};
for subj = 1:nvalsubj
    for blk = 1:length(valblockname)
        subjpath = [path '\' valsubj{subj}];
        filename = [valsubj{subj} '_' valblockname{blk} '.csv'];
        [devicedata,trajdata] = readviconcsv_rmm(subjpath,filename);
        %% convert devicedata to forces
        % Forecplate1 (Left)  Z is up/down b/c COP is zero;
        % Y is in the direction of motion
        % Make forces and moments negative so they represent forces acting
        % on the subject rather than on the forceplatform
        dataraw=devicedata;
        dataraw(:,[3:5 6:8 18:20 21:23])=-dataraw(:,[3:5 6:8 18:20 21:23]);
        % Select only (16 col)
        % F1xF1yF1zM1xM1yM1zCOP1xCOP1yF2xF2yF2zM2xM2yM2zCOP2xCOP2y
        dataraw = dataraw(:,[3:10 18:25]);
        fs = devicefs; % data collection hz
        fc = 20; % low pass filter frequency cut off
        dt = 1/fs; % numerical integration time steps
        % get time
        time = [1:size(dataraw,1)]/fs;
        dataraw(isnan(dataraw))=0;
        % filter data : datafilt is original:derivative:secondderivative
        [datafilt]=diff23f5(dataraw,dt,fc);
        data=datafilt(:,1:size(dataraw,2)); %filtered data, not derivatives
        %Forecplate1 (Right)
        F1 = [data(:,1) data(:,2) data(:,3)];  %N - force
        M1 = [data(:,4) data(:,5) data(:,6)];  %Nmm - moment
        COP1 = [data(:,7) data(:,8) ]; %mm - center of pressure
        %Forecplate2 (Left)
        F2 = [data(:,9) data(:,10) data(:,11)];  %N, 
        M2 = [data(:,12) data(:,13) data(:,14)];  %Nmm
        COP2 = [data(:,15) data(:,16) ]; %mm
        % save forces since they will be resampled to identify heel strikes
        F1old=F1;
        F2old=F2;
        timeold=time;
        M1old = M1;
        M2old = M2;
        COP1old = COP1;
        COP2old = COP2;
        % resample force and force time
        time=resample(timeold,1,10);
        F1=resample(F1old,1,10);
        F2=resample(F2old,1,10);
        M1 = resample(M1old,1,10);
        M2 = resample(M2old,1,10);
        COP1 = resample(COP1old,1,10);
        COP2 = resample(COP2old,1,10);
        % save to force structure, trimming off the first 60s
        i30s = find(time > 30,1,'first');
        i60s = find(time > 60,1,'first');
        valF{subj}.R{blk} = F1(i30s:i60s,:);
        valF{subj}.L{blk} = F2(i30s:i60s,:);
        valF{subj}.time{blk} = time(i30s:i60s);
        valF{subj}.MR{blk} = M1(i30s:i60s,:);
        valF{subj}.COPR{blk} = COP1(i30s:i60s,:);
        valF{subj}.ML{blk} = M2(i30s:i60s,:);
        valF{subj}.COPL{blk} = COP2(i30s:i60s,:);
        
       %% convert trajdata to trajectories
       trajdataraw = trajdata;
       % get time and trim first 60 s
       trajtime = [1:size(trajdata,1)]/trajfs;
       ti30s = find(trajtime > 30,1,'first');
       ti60s = find(trajtime > 60,1,'first');   
       valp{subj}.trajtime{blk} = trajtime(ti30s:ti60s);
       valp{subj}.Lasis{blk} = trajdata(ti30s:ti60s,1:3);
       valp{subj}.Rasis{blk} = trajdata(ti30s:ti60s,4:6);
       valp{subj}.Lpsis{blk} = trajdata(ti30s:ti60s,7:9);
       valp{subj}.Rpsis{blk} = trajdata(ti30s:ti60s,10:12);
       valp{subj}.Lthigh{blk} = trajdata(ti30s:ti60s,13:15);
       valp{subj}.Lknee{blk} = trajdata(ti30s:ti60s,16:18);
       valp{subj}.Ltibia{blk} = trajdata(ti30s:ti60s,19:21);
       valp{subj}.Lankle{blk} = trajdata(ti30s:ti60s,22:24);
       valp{subj}.Lheel{blk} = trajdata(ti30s:ti60s,25:27);
       valp{subj}.Ltoe{blk} = trajdata(ti30s:ti60s,28:30);
       valp{subj}.Rthigh{blk} = trajdata(ti30s:ti60s,31:33);
       valp{subj}.Rknee{blk} = trajdata(ti30s:ti60s,34:36);
       valp{subj}.Rtibia{blk} =trajdata(ti30s:ti60s,37:39);
       valp{subj}.Rankle{blk} = trajdata(ti30s:ti60s,40:42);
       valp{subj}.Rheel{blk} = trajdata(ti30s:ti60s,43:45);
       valp{subj}.Rtoe{blk} = trajdata(ti30s:ti60s,46:48);

       xRfoot=[valp{subj}.Rankle{blk}(:,1) valp{subj}.Rheel{blk}(:,1) valp{subj}.Rtoe{blk}(:,1) valp{subj}.Rankle{blk}(:,1)];
       yRfoot=[valp{subj}.Rankle{blk}(:,2) valp{subj}.Rheel{blk}(:,2) valp{subj}.Rtoe{blk}(:,2) valp{subj}.Rankle{blk}(:,2)];
       zRfoot=[valp{subj}.Rankle{blk}(:,3) valp{subj}.Rheel{blk}(:,3) valp{subj}.Rtoe{blk}(:,3) valp{subj}.Rankle{blk}(:,3)]; 
       
        xRlleg=[valp{subj}.Rankle{blk}(:,1) valp{subj}.Rtibia{blk}(:,1) valp{subj}.Rknee{blk}(:,1) ];
        yRlleg=[valp{subj}.Rankle{blk}(:,2) valp{subj}.Rtibia{blk}(:,2) valp{subj}.Rknee{blk}(:,2) ];
        zRlleg=[valp{subj}.Rankle{blk}(:,3) valp{subj}.Rtibia{blk}(:,3) valp{subj}.Rknee{blk}(:,3) ];
        %line from ankle to knee
        xRuleg=[valp{subj}.Rknee{blk}(:,1) valp{subj}.Rasis{blk}(:,1) ];
        yRuleg=[valp{subj}.Rknee{blk}(:,2) valp{subj}.Rasis{blk}(:,2) ];
        zRuleg=[valp{subj}.Rknee{blk}(:,3) valp{subj}.Rasis{blk}(:,3) ];
        %line from knee to hip.
        xhh=[valp{subj}.Rasis{blk}(:,1) valp{subj}.Lasis{blk}(:,1)  valp{subj}.Lpsis{blk}(:,1) valp{subj}.Rpsis{blk}(:,1) valp{subj}.Rasis{blk}(:,1)];
        yhh=[valp{subj}.Rasis{blk}(:,2) valp{subj}.Lasis{blk}(:,2)  valp{subj}.Lpsis{blk}(:,2) valp{subj}.Rpsis{blk}(:,2) valp{subj}.Rasis{blk}(:,2)]; 
        zhh=[valp{subj}.Rasis{blk}(:,3) valp{subj}.Lasis{blk}(:,3)  valp{subj}.Lpsis{blk}(:,3) valp{subj}.Rpsis{blk}(:,3) valp{subj}.Rasis{blk}(:,3)];       %line from knee to hivalp{subj}.

        xLfoot=[valp{subj}.Ltoe{blk}(:,1) valp{subj}.Lankle{blk}(:,1) valp{subj}.Lheel{blk}(:,1) valp{subj}.Ltoe{blk}(:,1) ];
        yLfoot=[valp{subj}.Ltoe{blk}(:,2) valp{subj}.Lankle{blk}(:,2) valp{subj}.Lheel{blk}(:,2) valp{subj}.Ltoe{blk}(:,2) ];
        zLfoot=[valp{subj}.Ltoe{blk}(:,3) valp{subj}.Lankle{blk}(:,3) valp{subj}.Lheel{blk}(:,3) valp{subj}.Ltoe{blk}(:,3) ];

        xLlleg=[valp{subj}.Lankle{blk}(:,1) valp{subj}.Ltibia{blk}(:,1) valp{subj}.Lknee{blk}(:,1) ];
        yLlleg=[valp{subj}.Lankle{blk}(:,2) valp{subj}.Ltibia{blk}(:,2) valp{subj}.Lknee{blk}(:,2) ];
        zLlleg=[valp{subj}.Lankle{blk}(:,3) valp{subj}.Ltibia{blk}(:,3) valp{subj}.Lknee{blk}(:,3) ];
        %line from ankle to knee
        xLuleg=[valp{subj}.Lknee{blk}(:,1) valp{subj}.Lasis{blk}(:,1) ];
        yLuleg=[valp{subj}.Lknee{blk}(:,2) valp{subj}.Lasis{blk}(:,2) ];
        zLuleg=[valp{subj}.Lknee{blk}(:,3) valp{subj}.Lasis{blk}(:,3) ];
        %line from knee to hip


%         figure(); hold on; title(valsubj);
%         subplot(321); title('x forces')
%         xlim([min(valF{subj}.time{blk}) max(valF{subj}.time{blk})])
%         hxl = animatedline;
%         hxr = animatedline;
%         subplot(323); title('y forces')
%         xlim([min(valF{subj}.time{blk}) max(valF{subj}.time{blk})])
%         hy = animatedline;
%         subplot(325); title('z forces')
%         xlim([min(valF{subj}.time{blk}) max(valF{subj}.time{blk})])
%         hz = animatedline;
%         subplot(122); title('stick animation')
%         view(45,30) % view at a 45 degree angle and elevated
% 
%         for i = 1:length(valF{subj}.time{blk})
%             subplot(321);
%             addpoints(hxr,valF{subj}.time{blk}(i),valF{subj}.R(1,i),'r')
%             drawnow
%             subplot(321);
%             addpoints(hxl,valF{subj}.time{blk}(i),valF{subj}.L(1,i),'b')
%             drawnow
%         end

    end
    cd(homepath)
end
toc