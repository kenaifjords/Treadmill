%TM2_03_percentGaitIKID
global homepath subject F p colors asym IK ID
close all
yes_plot = 0;
tic
dynvars.R = {'Rhipflexion_M' 'Rhipadduction_M' 'Rhiprotation_M'...\
    'Rknee_M' 'Rknee_beta_F' 'Rankle_M'}; % 'pelvisM' 'pelvis_tF'
dynvars.L = {'Lhipflexion_M' 'Lhipadduction_M' 'Lhiprotation_M'...\
    'Lknee_M' 'Lknee_beta_F' 'Lankle_M'}; % 'pelvisM' 'pelvis_tF'
dynvars.units = {'hip flexion moment (Nm)' 'hip adduction moment (Nm)'...
    'hip rotation moment (Nm)' 'knee moment (Nm)' 'knee beta force (N)'...
    'ankle moment(Nm)'};
kinvars.R = {'Rhipflexion' 'Rhipadduction' 'Rhiprotation' 'Rkneeangle' ...
    'Rkneeangle_beta' 'Rankleangle'}; % 'pelvis' 'pelvist'
kinvars.L = {'Lhipflexion' 'Lhipadduction' 'Lhiprotation' 'Lkneeangle' ...
    'Lkneeangle_beta' 'Lankleangle'}; % 'pelvis' 'pelvist'
kinvars.units = {'hip flexion (deg)' 'hip adduction (deg)' 'hip rotation (deg)' ...
    'knee angle (deg)' 'knee angle beta (deg)' 'ankle angle (deg)'};

for subj = 3%1:subject.n
    for effcond = 2%1:length(subject.effortcondition)
        for blk = 2%1:subject.nblk
            for var = 1:length(dynvars.R)
             clear  steptime2 steplength2all steplength1all steplength1 steplength2 fastlegfirst
             hsL = F{subj}.hsL{effcond, blk};%(2:end);
             hsR = F{subj}.hsR{effcond, blk};%(2:end);
             % knee moment
             inR = dynvars.R{var};
             inL = dynvars.L{var};
             str0 = {'ID{subj}.' inR '{effcond,blk}'};
             str = join(str0);
             input1 = eval(str{1,1}); %input1 = eval({'ID{subj}.' inR '{effcond,blk}'});
             str0 = {'ID{subj}.' inL '{effcond,blk}'};
             str = join(str0);
             input2 = eval(str{1,1}); %input2 = eval({'ID{subj}.' inL '{effcond,blk}'}); % ID{subj}.Lkneeangle_M{effcond,blk};
             inputtime = ID{subj}.idtime{effcond,blk};
             disp('ID')
             [output1,output2] = resampleToPercentGait(input1,input2,inputtime,hsR,hsL);
             output_bothlegs = cat(1,output1,output2);            
             x = 1:size(output_bothlegs,2);
             
             % validation 00
             fig = figure(subj);
             fig.Name = [subject.list{subj} ' Inverse Dynamics']; 
             subplot(2,length(dynvars.units),var); hold on
             [~] = plot_with_std(x,mean(output_bothlegs,1,'omitnan'),std(output_bothlegs,[],1,'omitnan'),[0 0 0]);
             ylabel(dynvars.units(var))
             subplot(2,length(dynvars.units),length(dynvars.units) + var); hold on
             [~] = plot_with_std(x,mean(output1,1,'omitnan'),std(output1,[],1,'omitnan'),[0 1 0]);
             [~] = plot_with_std(x,mean(output2,1,'omitnan'),std(output2,[],1,'omitnan'),[1 0 0]);
             plot(x,output1,':','Color',[0 1 0 0.3],'LineWidth',0.25)
             plot(x,output2,':','Color',[1 0 0 0.3],'LineWidth',0.25)
             ylabel(dynvars.units(var))
             xlabel('percent gait cycle')
             sgtitle([subject.list{subj}  ' | effcond:' num2str(effcond) ' | blk:' num2str(blk)])
            end
            for var = 1:length(kinvars.R)
             %% kinematics
             inR = kinvars.R{var};
             inL = kinvars.L{var};
             % get input data
             str0 = {'IK{subj}.' inR '{effcond,blk}'};
             str = join(str0);
             input1 = eval(str{1,1});
             str0 = {'IK{subj}.' inL '{effcond,blk}'};
             str = join(str0);
             input2 = eval(str{1,1});
             inputtime = IK{subj}.iktime{effcond,blk};
             disp('IK')
             [output1,output2] = resampleToPercentGait(input1,input2,inputtime,hsR,hsL);
             output_bothlegs = cat(1,output1,output2);            
             x = 1:size(output_bothlegs,2);
             
             % validation 00
             fig = figure(length(subject.list) + subj);
             fig.Name = [subject.list{subj} ' Inverse Kinematics'];
             subplot(2,length(dynvars.units),var); hold on
             [~] = plot_with_std(x,mean(output_bothlegs,1,'omitnan'),std(output_bothlegs,[],1,'omitnan'),[0 0 0]);
             ylabel(kinvars.units(var))
             subplot(2,length(dynvars.units),length(dynvars.units) + var); hold on
             [~] = plot_with_std(x,mean(output1,1,'omitnan'),std(output1,[],1,'omitnan'),[0 1 0]);
             [~] = plot_with_std(x,mean(output2,1,'omitnan'),std(output2,[],1,'omitnan'),[1 0 0]);
             plot(x,output1,':','Color',[0 1 0 0.2],'LineWidth',0.25)
             plot(x,output2,':','Color',[1 0 0 0.2],'LineWidth',0.25)
             ylabel(kinvars.units(var))
             xlabel('percent gait cycle')
             sgtitle([subject.list{subj}  ' | effcond:' num2str(effcond) ' | blk:' num2str(blk)])
           
            end
%              %###### this should be a loop not a copy, but i don't want to
%              % do that today
%              input1 = F{subj}.MR{effcond,blk}(:,1);
%              input2 = F{subj}.ML{effcond,blk}(:,1);
%              inputtime = F{subj}.time{effcond,blk};
%              disp('F')
%              [output1,output2] = resampleToPercentGait(input1,input2,...
%                  inputtime,hsR,hsL);
% %              F{subj}.percentGait.Rz{effcond,blk} = output1;
% %              F{subj}.percentGait.Lz{effcond,blk} = output2;
%              output_bothlegs = cat(1,output1,output2);            
%              x = 1:size(output_bothlegs,2);
%              
%              % validation 00
%              figure(); 
%              subplot(211); hold on
%              [~] = plot_with_std(x,mean(output_bothlegs,1,'omitnan'),std(output_bothlegs,[],1,'omitnan'),[0 0 0]);
%              ylabel(dynvars.units(var))
%              subplot(212); hold on
%              [~] = plot_with_std(x,mean(output1,1,'omitnan'),std(output1,[],1,'omitnan'),[0 1 0]);
%              [~] = plot_with_std(x,mean(output2,1,'omitnan'),std(output2,[],1,'omitnan'),[1 0 0]);
%              ylabel(kinvars.units(var))
%              xlabel('percent gait cycle')
%              sgtitle(subject.list(subj))
        end
    end
end
             
             
