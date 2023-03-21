% combine the subject mat files into a single data structure
close all
clear all

global homepath
homepath = 'C:\Users\rache\OneDrive\Documents\GitHub\Treadmill\viconmatlab_starter';
% homepath = 'F:\Users\Rachel\viconmatlab_starter';

subjects = {'RMM'};
fastlegs = { 'R' }; % corresponds to belt 1
conditions = {'LowEffort','HighEffort'};

step_threshold = 50;

% animation of trajectories and segments parameters
animateyes = false;
start_animateidx = 100000;
end_animateidx = 102000;

% force plotting parameters
plotforceyes = true;
start_forceplotidx = 1500000;
end_forceplotidx = 1600000;

% COP plotting parameters
plotcopyes = true;
start_stepthresplotidx = 665000;
end_stepthresplotidx = 670000;

% step thresholding plotting parameters
plotstepthresyes = true;
start_copplotidx = 660000;
end_copplotidx = 680000;

% step sorting parameters
step_thres_consistency = 70;
consistency_allowance = 5;

cd('matData')
for subj = 1:length(subjects)
    name = strcat(subjects(subj), '_TM.mat');
    datain = load(name{1,1});
    TM(subj).subject = subjects(subj);
    TM(subj).fastleg = fastlegs(subj);
    for cond = 1:length(conditions)
        TM(subj).Effort(cond) = datain.subjTM.Effort(cond);
        
        %% trajectory data
        TM(subj).traj(cond).all = TM(subj).Effort(cond).trajectories(:,3:end);
        trajdataonly = TM(subj).traj(cond).all;
        trajtimeidx = TM(subj).Effort(cond).trajectories(:,1);
        % FOR LOWER BODY PLUG IN GAIT MODEL
        TM(subj).traj(cond).pLasi = trajdataonly(:,1:3);
        TM(subj).traj(cond).pRasi = trajdataonly(:,4:6);
        TM(subj).traj(cond).pLpsi = trajdataonly(:,7:9);
        TM(subj).traj(cond).pRpsi = trajdataonly(:,10:12);
        TM(subj).traj(cond).pLthigh = trajdataonly(:,13:15);
        TM(subj).traj(cond).pLknee = trajdataonly(:,16:18);
        TM(subj).traj(cond).pLtibia = trajdataonly(:,19:21);
        TM(subj).traj(cond).pLankle = trajdataonly(:,22:24);
        TM(subj).traj(cond).pLheel = trajdataonly(:,25:27);
        TM(subj).traj(cond).pLtoe = trajdataonly(:,28:30);
        TM(subj).traj(cond).pRthigh = trajdataonly(:,31:33);
        TM(subj).traj(cond).pRknee = trajdataonly(:,34:36);
        TM(subj).traj(cond).pRtibia = trajdataonly(:,37:39);
        TM(subj).traj(cond).pRankle = trajdataonly(:,40:42);
        TM(subj).traj(cond).pRheel = trajdataonly(:,43:45);
        TM(subj).traj(cond).pRtoe = trajdataonly(:,46:48);
        cd(homepath)
        
        % trim for animation
        trajdatatrim = trajdataonly(start_animateidx:end_animateidx,:);
        trajtimetrim = trajtimeidx(start_animateidx:end_animateidx);
        % call animation plot (this will only show animation for the last
        % subj / condition combination)
        if animateyes
            animation_vicon_stick(trajdatatrim, trajtimetrim, animateyes);
        end
        clear trajdataonly trajtimeidx trajdatatrim trajtimetrim
        
        %% force data
        TM(subj).force(cond).all = cat(2,TM(subj).Effort(cond).forceplate(2:end,3:11),TM(subj).Effort(cond).forceplate(2:end,18:end));
        TM(subj).force(cond).frame = TM(subj).Effort(cond).forceplate(:,1);
        % FOR STANDARD FORCE PLATE OUTPUT
        % frame subframe fx fy fz mx my mz cx cy cz pin1(10) pin2 pin3 pin4
        % pin5 pin6(15) fx fy fz mx my mz cx cy cz
        TM(subj).force(cond).fxR = TM(subj).force(cond).all(:,1);
        TM(subj).force(cond).fyR = TM(subj).force(cond).all(:,2);
        TM(subj).force(cond).fzR = TM(subj).force(cond).all(:,3);
        TM(subj).force(cond).mxR = TM(subj).force(cond).all(:,4);
        TM(subj).force(cond).myR = TM(subj).force(cond).all(:,5);
        TM(subj).force(cond).mzR = TM(subj).force(cond).all(:,6);
        TM(subj).force(cond).cxR = TM(subj).force(cond).all(:,7);
        TM(subj).force(cond).cyR = TM(subj).force(cond).all(:,8);
        TM(subj).force(cond).czR = TM(subj).force(cond).all(:,9);
        TM(subj).force(cond).fxL = TM(subj).force(cond).all(:,10);
        TM(subj).force(cond).fyL = TM(subj).force(cond).all(:,11);
        TM(subj).force(cond).fzL = TM(subj).force(cond).all(:,12);
        TM(subj).force(cond).mxL = TM(subj).force(cond).all(:,13);
        TM(subj).force(cond).myL = TM(subj).force(cond).all(:,14);
        TM(subj).force(cond).mzL = TM(subj).force(cond).all(:,15);
        TM(subj).force(cond).cxL = TM(subj).force(cond).all(:,16);
        TM(subj).force(cond).cyL = TM(subj).force(cond).all(:,17);
        TM(subj).force(cond).czL = TM(subj).force(cond).all(:,18);
        
        % trim for plotting
        forceplatetrim = TM(subj).force(cond).all(start_forceplotidx:end_forceplotidx,:);
        frametrim = TM(subj).force(cond).frame(start_forceplotidx:end_forceplotidx);
        % plot forces
        if plotforceyes
            plot_forceplate_output(forceplatetrim,frametrim)
        end
        
        %% COP
        % COP y indicates "forward / back" postion on the treadmill
        % (saggital plane)
        [TM(subj).COP(cond).yL] = diff23f5(TM(subj).force(cond).cyL,1/1000,20);
        TM(subj).COP(cond).yL(TM(subj).COP(cond).yL > 2100) = NaN;
        TM(subj).COP(cond).yL(TM(subj).COP(cond).yL < -2100) = NaN;
        
        [TM(subj).COP(cond).yR] = diff23f5(TM(subj).force(cond).cyR,1/1000,20);
        TM(subj).COP(cond).yR(TM(subj).COP(cond).yR > 2100) = NaN;
        TM(subj).COP(cond).yR(TM(subj).COP(cond).yR < -2100) = NaN;

        % y postion of the heel marker is also related to "front / back"
        % postion on the treadmill
        [TM(subj).COP(cond).traj_yL] = diff23f5(TM(subj).traj(cond).pLheel(:,2),1/100,20);
        [TM(subj).COP(cond).traj_yR] = diff23f5(TM(subj).traj(cond).pRheel(:,2),1/100,20);
        [TM(subj).COP(cond).traj_yLtoe] = diff23f5(TM(subj).traj(cond).pLtoe(:,2),1/100,20);
        [TM(subj).COP(cond).traj_yRtoe] = diff23f5(TM(subj).traj(cond).pRtoe(:,2),1/100,20);
        
        % make a COP and d(COP) plot
        if plotcopyes
            figure();
            subplot(211);hold on;
            plot(TM(subj).COP(cond).yL(start_copplotidx:end_copplotidx,1),'b') % /1000 converts from mm/s to m/s (does it - will have to check diff23f5)
            plot(TM(subj).COP(cond).yR(start_copplotidx:end_copplotidx,1),'r')
            plot((1:10:end_copplotidx-start_copplotidx+1)+10, TM(subj).COP(cond).traj_yL(start_copplotidx/10:end_copplotidx/10,1),'b--')
            plot((1:10:end_copplotidx-start_copplotidx+1)+10, TM(subj).COP(cond).traj_yR(start_copplotidx/10:end_copplotidx/10,1),'r--')
            plot((1:10:end_copplotidx-start_copplotidx+1)+10, TM(subj).COP(cond).traj_yLtoe(start_copplotidx/10:end_copplotidx/10,1),'b:')
            plot((1:10:end_copplotidx-start_copplotidx+1)+10, TM(subj).COP(cond).traj_yRtoe(start_copplotidx/10:end_copplotidx/10,1),'r:')
    %         plot(-TM(subj).force(cond).fzL(start_copplotidx:end_copplotidx),'g')
    %         plot(-TM(subj).force(cond).fzR(start_copplotidx:end_copplotidx),'m')
            legend('L from forceplate', 'R from forceplate', 'L from camera (heel)', 'R from camera (heel)', 'L from camera (toe)', 'R from camera (toe)')
            ylabel('yCOP')

            %figure();
            subplot(212);hold on;
            plot(TM(subj).COP(cond).yL(start_copplotidx:end_copplotidx,2),'b') % /1000 converts from mm/s to m/s (does it - will have to check diff23f5)
            plot(TM(subj).COP(cond).yR(start_copplotidx:end_copplotidx,2),'r')
            plot((1:10:end_copplotidx-start_copplotidx+1)+10, TM(subj).COP(cond).traj_yL(start_copplotidx/10:end_copplotidx/10,2),'b--')
            plot((1:10:end_copplotidx-start_copplotidx+1)+10, TM(subj).COP(cond).traj_yR(start_copplotidx/10:end_copplotidx/10,2),'r--')
            plot((1:10:end_copplotidx-start_copplotidx+1)+10, TM(subj).COP(cond).traj_yLtoe(start_copplotidx/10:end_copplotidx/10,2),'b:')
            plot((1:10:end_copplotidx-start_copplotidx+1)+10, TM(subj).COP(cond).traj_yRtoe(start_copplotidx/10:end_copplotidx/10,2),'r:')
    %         plot(-TM(subj).force(cond).fzL(start_copplotidx:end_copplotidx),'g')
    %         plot(-TM(subj).force(cond).fzR(start_copplotidx:end_copplotidx),'m')
            ylabel('\Delta yCOP')
        end
        
        %% step thresholding
        TM(subj).step(cond).L = (-TM(subj).force(cond).fzL > step_threshold);
        TM(subj).step(cond).R = (-TM(subj).force(cond).fzR > step_threshold);
        
        if plotstepthresyes
            figure();
            subplot(211);hold on;
            plot(-TM(subj).force(cond).fzL(start_stepthresplotidx:end_stepthresplotidx),'b')
            plot(-TM(subj).force(cond).fzR(start_stepthresplotidx:end_stepthresplotidx),'r')
            subplot(212); hold on;
            plot(TM(subj).step(cond).L(start_stepthresplotidx:end_stepthresplotidx),'b')
            plot(TM(subj).step(cond).R(start_stepthresplotidx:end_stepthresplotidx),'r')
        end
        
        % there is going to be some adjustments here to handle spurious
        % events - need to functionalize this (for now it is easier to 
        % troubleshoot this way, but basically it check the previous 
        % #step_thres_conistency# before and the subsequent 
        % #step_thres_conistency# trials to make sure that they are 0 to 1
        % meaning heelstrike or 1 and 0 indicating toe off
        % the next if statement checks for the #consistency_allowance# to
        % select only the first index that meets the above criteria
        
        % step sorting heel strike
        % left
        TM(subj).step(cond).heelstrikeL = nan(length(TM(subj).step(cond).L),1);
        for i = 1:length(TM(subj).step(cond).L)
            if i < step_thres_consistency + 1 ;
%                 TM(subj).step(cond).heelstrikeL(i) = NaN;
            elseif i > length(TM(subj).step(cond).L)- step_thres_consistency
%                 TM(subj).step(cond).heelstrikeL(i) = NaN;
            elseif sum(TM(subj).step(cond).L(i-step_thres_consistency:i-1))...
                    == 0 && sum(TM(subj).step(cond).L(i:i+step_thres_consistency))...
                    > step_thres_consistency - consistency_allowance
                if sum(TM(subj).step(cond).heelstrikeL(i- consistency_allowance:i-1),'omitnan') == 0
                    TM(subj).step(cond).heelstrikeL(i) = 1;
                end
            end
        end
        plot(TM(subj).step(cond).heelstrikeL(start_stepthresplotidx:end_stepthresplotidx),'bo')
        % right
        TM(subj).step(cond).heelstrikeR = nan(length(TM(subj).step(cond).R),1);
        for i = 1:length(TM(subj).step(cond).R)
            if i < step_thres_consistency + 1 
%                 TM(subj).step(cond).heelstrikeR(i) = NaN;
            elseif i > length(TM(subj).step(cond).R)- step_thres_consistency
%                 TM(subj).step(cond).heelstrikeR(i) = NaN;
            elseif sum(TM(subj).step(cond).R(i-step_thres_consistency:i-1))...
                    == 0 && sum(TM(subj).step(cond).R(i:i+step_thres_consistency))...
                    > step_thres_consistency - consistency_allowance
                if sum(TM(subj).step(cond).heelstrikeR(i- consistency_allowance:i-1),'omitnan') == 0
                    TM(subj).step(cond).heelstrikeR(i) = 1;
                end
            end
        end
        plot(TM(subj).step(cond).heelstrikeR(start_stepthresplotidx:end_stepthresplotidx),'ro')
        
        % step sorting toe off
        % left
        TM(subj).step(cond).toeoffL = nan(length(TM(subj).step(cond).L),1);
        for i = 1:length(TM(subj).step(cond).L)
            if i < step_thres_consistency + 1 || i > length(TM(subj).step(cond).L)- step_thres_consistency
            elseif sum(TM(subj).step(cond).L(i-step_thres_consistency:i))...
                    > step_thres_consistency - consistency_allowance && ...
                    sum(TM(subj).step(cond).L(i+1:i+step_thres_consistency)) == 0
                if sum(TM(subj).step(cond).toeoffL(i- consistency_allowance:i-1),'omitnan') == 0
                    TM(subj).step(cond).toeoffL(i) = 1;
                end
            end
        end
        plot(TM(subj).step(cond).toeoffL(start_stepthresplotidx:end_stepthresplotidx),'bd')
        % right
        TM(subj).step(cond).toeoffR = nan(length(TM(subj).step(cond).R),1);
        for i = 1:length(TM(subj).step(cond).R)
            if i < step_thres_consistency + 1 || i > length(TM(subj).step(cond).R)- step_thres_consistency-1
            elseif sum(TM(subj).step(cond).R(i-step_thres_consistency:i))...
                    > step_thres_consistency - consistency_allowance && ...
                    sum(TM(subj).step(cond).R(i+1:i+step_thres_consistency)) == 0
                if sum(TM(subj).step(cond).toeoffR(i- consistency_allowance:i-1),'omitnan') == 0
                    TM(subj).step(cond).toeoffR(i) = 1;
                end
            end
        end
        plot(TM(subj).step(cond).toeoffR(start_stepthresplotidx:end_stepthresplotidx),'rd')
        
        
        %% use COP (from camera -- heel) and force to determine split/tied
        
        
    end
end
save('TM', TM)
    