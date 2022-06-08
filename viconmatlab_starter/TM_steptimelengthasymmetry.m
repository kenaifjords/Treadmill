% get step time, length, and asymmetry
devicefs = 1000; % bertec frames per second
trajfs = 100; % vicon camera frames per second

homepath = 'F:\Users\Rachel\viconmatlab_starter';
% homepath = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter';
path = 'F:\Users\Rachel\viconmatlab_starter\csvData\';
% path = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter\csvData\';

subjects = {'RMM'}; % RMM
conditions = {'LowEffort','HighEffort'};

cd('matData')
for subj = 1:length(subjects)
    name = strcat(subjects(subj), '_TM.mat');
    T = load(name{1,1});
    
    cd(homepath)
    for cond = 1:length(conditions)
        forceplate = T.subjTM.Effort(cond).forceplate;
        trajectories = T.subjTM.Effort(cond).trajectories;
        trajall = T.subjTM.Effort(cond).trajectories(:,3:end);

    % FORCE DATA
        force_dataraw = forceplate;
        force_dataraw(:,[3:5 6:8 18:20 21:23])=-force_dataraw(:,[3:5 6:8 18:20 21:23]);

        % Filter
        % Select only (16 col) : F1xF1yF1zM1xM1yM1zCOP1xCOP1yF2xF2yF2zM2xM2yM2zCOP2xCOP2y
        force_dataraw = force_dataraw(:,[3:10 18:25]);
        fs = devicefs;
        fc=20;
        dt=1/fs;

        force_time = [1:size(force_dataraw,1)]/fs;
        traj_time=[1:size(trajectories,1)]/trajfs;

        force_dataraw(isnan(force_dataraw))=0;
        [datafilt]=diff23f5(force_dataraw,dt,fc);

        %Take only filtered data (not derivatives)
        force_data=datafilt(:,1:size(force_dataraw,2));
        %Forecplate1 (Right)
        F1 = [force_data(:,1) force_data(:,2) force_data(:,3)];  %N, 
        M1 = [force_data(:,4) force_data(:,5) force_data(:,6)];  %Nmm
        COP1 = [force_data(:,7) force_data(:,8) ]; %mm

        %Forecplate2 (Left)
        F2 = [force_data(:,9) force_data(:,10) force_data(:,11)];  %N, 
        M2 = [force_data(:,12) force_data(:,13) force_data(:,14)];  %Nmm
        COP2 = [force_data(:,15) force_data(:,16) ]; %mm

        F1old=F1;
        F2old=F2;
        timeold=force_time;

        % TRAJECTORIES DATA
        trajdataonly = trajall;
        p = vicon_markers(trajdataonly);

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

        %% Calculate steplength, steptime, and steplength asymmetry
        % 

        i=1; ii = 1; % added ii to get around equal indices on the first trial
        clear steptime1 steptime2

        steplength2all=p.Lankle(ind_hsfp2,2)-p.Rankle(ind_hsfp2,2);
        steplength1all=p.Rankle(ind_hsfp1,2)-p.Lankle(ind_hsfp1,2);

        maxsteps=min([length(steplength1all) length(steplength2all)]);
        steplength1=steplength1all(1:maxsteps);
        steplength2=steplength2all(1:maxsteps); 
        steptime1 = nan(min([length(hsfp1) length(hsfp2)]),1);
        steptime2 = nan(min([length(hsfp1) length(hsfp2)]),1);
        while i < min([length(hsfp1) length(hsfp2)])    
            %step time on belt 2 (left)
            if hsfp1(ii)<hsfp2(ii)   %fp1 strikes first
             steptime2(i)= hsfp2(i)-hsfp1(i);
            elseif hsfp1(ii)>hsfp2(ii) %fp2 strikes first so take its second heel strike
             steptime2(i)= hsfp2(i+1)-hsfp1(i); 
            end
               disp(num2str(i))
            %step time on belt 1 (right)
             if hsfp2(ii)<hsfp1(ii)   %fp2 strikes first
             steptime1(i)= hsfp1(i)-hsfp2(i);
            elseif hsfp2(ii)>hsfp1(ii) %fp1 strikes first so take its second heel strike
             steptime1(i)= hsfp1(i+1)-hsfp2(i);
             end
            disp(num2str(steptime1(i)))
            i=i+1;
            if hsfp1(ii) == hsfp2(ii)
                ii = ii+1;
            end
        end

        %steptime_asym=steptime1-steptime2;
        steplength_asym=(steplength1-steplength2)./(steplength1+steplength2);
        steptime_asym = (steptime1-steptime2)./(steptime1+steptime2);
        
        % save the step asymm
        T.subjTM.Effort(cond).steplength_asym = steplength_asym;
        T.subjTM.Effort(cond).steptime_asym = steptime_asym;
    end
    figure(); hold on;
    plot(steplength_asym)
    plot(steptime_asym)
end

    