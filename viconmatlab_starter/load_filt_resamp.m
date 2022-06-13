function [data] = load_filt_resamp(filename)
% function that loads in all data from csv
% filters the data
% resamples data from the forceplates
forceplatefs = 1000;
camerafs = 100;
homepath = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter';

hsthresh = 50; % N for heelstrike detection threshold

cd('matData')
Told = load(filename);
cd(homepath)

for cond = 1:2
    
    forceall_raw = Told.subjTM.Effort(cond).forceplate;
    trajall_raw = Told.subjTM.Effort(cond).trajectories;
    traj_raw = trajall_raw(:,3:end);
    % make z forces positive
    forceall_raw(:,[3:5 6:8 18:20 21:23])=-forceall_raw(:,[3:5 6:8 18:20 21:23]);
    % Select only (16 col) : F1xF1yF1zM1xM1yM1zCOP1xCOP1yF2xF2yF2zM2xM2yM2zCOP2xCOP2y
    force_raw = forceall_raw(:,[3:10 18:25]);

    % processing and differentiation of force data
    dt = 1/forceplatefs;
    fc = 20;
    % remove NAN for differentiation
    force_raw(isnan(force_raw)) = 0;
    [dataforce] = diff23f5(force_raw,dt,fc);
    % take filtered data
    force_datalong = dataforce(:,1:size(force_raw,2));
    force_data = resample(force_datalong, 1, 10);

    force_timelong = [1:size(force_raw,1)]/forceplatefs;
    traj_time = [1:size(traj_raw,1)]/camerafs;

    force_time = resample(force_timelong,1,10);

    % retrieve trajectories data
    p = vicon_markers(traj_raw);

    % identify heelstrike and toe off from force plate
    Fz1 = force_data(:,3);
    Fz2 = force_data(:,11);

    Fz1(Fz1<hsthresh) = 0;
    Fz2(Fz2<hsthresh) = 0;

    Fz1pre = [Fz1(1); Fz1(1:end-1)];
    Fz2pre = [Fz2(1); Fz2(1:end-1)];
    Fz1post = [Fz1(2:end); Fz1(end)];
    Fz2post = [Fz2(2:end); Fz2(end)];

    hs1_idx = find(Fz1 == 0 & Fz1post>0);
    hs1 = force_time(hs1_idx);

    hs2_idx = find(Fz2 == 0 & Fz2post>0);
    hs2 = force_time(hs2_idx);

    tof1_idx = find(Fz1 == 0 & Fz1pre>0);
    tof1 = traj_time(tof1_idx);

    tof2_idx = find(Fz2 == 0 & Fz1pre > 0);
    tof2 = traj_time(tof2_idx);

    % Calculate steplength, steptime, and steplength asymmetry
    steplength2all = p.Lankle(hs1_idx,2) - p.Rankle(hs1_idx,2);
    steplength1all = p.Rankle(hs2_idx,2) - p.Rankle(hs2_idx,2);
    
    stepnum = min(length(steplength1all), length(steplength2all));
    steplength1 = steplength1all(1:stepnum);
    steplength2 = steplength2all(1:stepnum);
    steptime1 = nan(stepnum,1);
    steptime2 = nan(stepnum,1);
    
    i = 1; ii = 1;
    while i < min([length(hs1) length(hs2)])    
        %step time on belt 2 (left)
        if hs1(ii)<hs2(ii)   %fp1 strikes first
         steptime2(i)= hs2(i)-hs1(i);
        elseif hs1(ii)>hs2(ii) %fp2 strikes first so take its second heel strike
         steptime2(i)= hs2(i+1)-hs1(i); 
        end
        %step time on belt 1 (right)
         if hs2(ii)<hs1(ii)   %fp2 strikes first
         steptime1(i)= hs1(i)-hs2(i);
        elseif hs2(ii)>hs1(ii) %fp1 strikes first so take its second heel strike
         steptime1(i)= hs1(i+1)-hs2(i);
         end
        i=i+1;
        if hs1(ii) == hs2(ii)
            ii = ii+1;
        end
    end
    
    steplength_asym=(steplength1-steplength2)./(steplength1+steplength2);
    steptime_asym = (steptime1-steptime2)./(steptime1+steptime2);

    T(cond).forcedata = force_data;
    T(cond).trajectories = p;
    T(cond).steplengthR = steplength1;
    T(cond).steplengthL = steplength2;
    T(cond).steptimeR = steptime1;
    T(cond).steptimeL = steptime2;
    T(cond).asym.time = steptime_asym;
    T(cond).asym.length = steplength_asym;
    
    data = T;
    
end
