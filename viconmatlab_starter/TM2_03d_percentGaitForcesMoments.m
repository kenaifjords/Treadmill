%% TM2_03d_percentGaitForcesMoments
%% identifying heelstrike and toe off force peaks
% using derivative of  force to identify peaks
global homepath subject F p colors asym
close all
clear F_all
tic
f_units = {'Fx(N)','Fy(N)','Fz(N)'};
m_units = {'Mx(Nm)','My(Nm)','Mz(Nm)'};
includebothvisits = 1;
includeblks = 1:7; %[2 3 4];
plotallaxes = 0;
plotallsubj = 0;
lntyp = {'-', '--'};

% F_all.RpGait = nan(subject.n,length(subject.effortcondition),subject.nblk,3,100);
for subj = 1:subject.n
%     % ### i don't actually think this will work... :/ 
%     % if we want to exclusively look at the first visit
    if subject.order(subj,1) == 1
        effcond0 = 1;
    else
        effcond0 = 2;
    end
    % if we want to include both visits
    if includebothvisits
        effcond0 = [1 2];
    end
    rfastsubj = 1; lfastsubj = 1;
    for effcond =  effcond0 % 1:length(subject.effortcondition)
        for blk = includeblks % 1:subject.nblk
%             subj
%             effcond
%             blk
            hsL = F{subj}.hsL{effcond, blk};%(2:end);
            hsR = F{subj}.hsR{effcond, blk};%(2:end); 
            for axis = 1:3
                % forces
                clear infR infL inmR inmL outputR outputL outputmR outputmL
                infR = F{subj}.R{effcond,blk}(:,axis);
                infL = F{subj}.L{effcond,blk}(:,axis);
                intime = F{subj}.time{effcond,blk};
                [outputR, outputL] = resampleToPercentGait(infR,infL,intime,hsR,hsL);
                
                % identify fast leg
                if subject.fastleg(subj) == 1
                    outputfast = outputR;
                    outputslow = outputL;
                else
                    outputfast = outputL;
                    outputslow = outputR;
                end
                
                x = 1:size(outputR,2);
                if plotallsubj
                    if plotallaxes
                        fig = figure(subj); fig.Name = [subject.list{subj} 'Ground Reaction Forces'];
                        hold on;
                        [~] = plot_with_std_linetype(x,mean(outputR,1,'omitnan'),std(outputR,[],1,'omitnan'),[0 1/(blk/2) 0],lntyp{effcond});
                        [~] = plot_with_std_linetype(x,mean(outputL,1,'omitnan'),std(outputL,[],1,'omitnan'),[1/(blk/2) 0 0],lntyp{effcond});
                        ylabel(f_units(axis))
                        xlabel('percent gait cycle')
                        sgtitle([subject.list{subj}  ' | effcond:' num2str(effcond) ' | blk:' num2str(blk)])
                        legend('R fast', 'L fast', 'R slow', 'L slow')
                    end

                    % z only
                    if axis == 3
                        fig = figure(subj+100); fig.Name = [subject.list{subj} 'Ground Reaction Forces'];
                        subplot(1,length(includeblks), blk - (includeblks(1)-1)); hold on;
                        [~] = plot_with_std_linetype(x,mean(outputR,1,'omitnan'),std(outputR,[],1,'omitnan'),[0 1/(blk/2) 0],lntyp{effcond});
                        [~] = plot_with_std_linetype(x,mean(outputL,1,'omitnan'),std(outputL,[],1,'omitnan'),[1/(blk/2) 0 0],lntyp{effcond});
                        ylabel(f_units(axis))
                        xlabel('percent gait cycle')
                        sgtitle([subject.list{subj}  ' | effcond:' num2str(effcond) ' | blk:' num2str(blk)])
                        legend('R fast', 'L fast', 'R slow', 'L slow')
                        ylim([0 1600])
                    end
                end
                
                %% moments
                inmR = F{subj}.MR{effcond,blk}(:,axis);
                inmL = F{subj}.ML{effcond,blk}(:,axis);
                [outputmR, outputmL] = resampleToPercentGait(inmR,inmL,intime,hsR,hsL);
                
                 % identify fast leg
                if subject.fastleg(subj) == 1
                    outputfastm = outputmR;
                    outputslowm = outputmL;
                else
                    outputfastm = outputmL;
                    outputslowm = outputmR;
                end
                
                % save the mean profiles for each subject left and right
                F_all.RpGait(subj,effcond,blk,axis,:) = mean(outputR,1,'omitnan')./subject.bodyweight(subj);
                F_all.LpGait(subj,effcond,blk,axis,:) = mean(outputL,1,'omitnan')./subject.bodyweight(subj);
                F_all.pGait(subj,effcond,blk,axis,:) = mean(cat(1,outputR,outputL),1,'omitnan')./subject.bodyweight(subj);
                F_all.mRpGait(subj,effcond,blk,axis,:) = mean(outputmR,1,'omitnan');
                F_all.mLpGait(subj,effcond,blk,axis,:) = mean(outputmL,1,'omitnan');
                % save the mean profiles for each subject fast and slow
                F_all.fastpGait(subj,effcond,blk,axis,:) = mean(outputR,1,'omitnan')./subject.bodyweight(subj);
                F_all.slowpGait(subj,effcond,blk,axis,:) = mean(outputL,1,'omitnan')./subject.bodyweight(subj);
                F_all.fastmpGait(subj,effcond,blk,axis,:) = mean(outputmR,1,'omitnan')./subject.bodyweight(subj);
                F_all.slowmpGait(subj,effcond,blk,axis,:) = mean(outputmL,1,'omitnan')./subject.bodyweight(subj);
                %% identify fast leg and save those a profiles too
            end
        end
    end
end

%% average across all subjects - we want a subplot for each fast and slow 
% baseline walking, then a line type for high effort or low effort, with
% standard error
fig = figure(88); fig.Name = 'Ground Reaction Forces across subjects';
axis = 3; % z ground reaction force only
for effcond = 1:2
    for blk = includeblks
        R = squeeze(F_all.RpGait(:,effcond,blk,axis,:));
        L = squeeze(F_all.LpGait(:,effcond,blk,axis,:));
        bothlegs = squeeze(F_all.pGait(:,effcond,blk,axis,:));
%         bothlegs = cat(1,R,L);
        avgR = mean(R,1); avgL = mean(L,1);
        steR = std(R)/sqrt(subject.n); steL = std(L)/sqrt(subject.n);
        avg = mean(bothlegs,1); steavg = std(bothlegs)/sqrt(subject.n);
        figure(88); subplot(1,length(includeblks), blk - (includeblks(1)-1)); hold on;
%                 plot(x,outputR,':','Color',[0 1 0 0.3],'LineWidth',0.25)
%                 plot(x,outputL,':','Color',[1 0 0 0.3],'LineWidth',0.25)
        [~] = plot_with_std_linetype(x,avgR,steR,[0 1/(blk) 0],lntyp{effcond});
        [~] = plot_with_std_linetype(x,avgL,steL,[1/(blk) 0 0],lntyp{effcond});
        ylabel(f_units(axis))
        xlabel('percent gait cycle')
        legend('R high effort', 'L high effort', 'R low effort', 'L low effort')
%         ylim([0 1600])
        figure(89);subplot(1,length(includeblks), blk - (includeblks(1)-1)); hold on;
%         plot(x,avg,'k','LineStyle',lntyp{effcond})
        [~] = plot_with_std_linetype(x,avg,steavg,[0 0 0],lntyp{effcond});
        ylabel('force (N)')
        xlabel('percent gait cycle')
        legend('high effort', 'low effort')
        title(['blk: ' num2str(blk) ' +/- standard error'])
%         ylim([0 1200])
    end
end
    sgtitle('Fz baseline')
%% fast and slow leg
includeblks = 2:7; %4;
axis = 2; % z ground reaction force only
for effcond = 1:2
    for blk = includeblks
        fst = squeeze(F_all.fastpGait(:,effcond,blk,axis,:));
        slw = squeeze(F_all.slowpGait(:,effcond,blk,axis,:));
%         bothlegs = cat(1,R,L);
        avgf = mean(fst,1); avgs = mean(slw,1);
        stef = std(fst)/sqrt(subject.n); stes = std(slw)/sqrt(subject.n);
        figure(98); subplot(1,length(includeblks), blk - (includeblks(1)-1)); hold on;
        [~] = plot_with_std_linetype(x,avgf,stef,[1/(blk/2) 0 1],lntyp{effcond});
        [~] = plot_with_std_linetype(x,avgs,stes,[1/(blk/2) 1 0],lntyp{effcond});
        ylabel(['norm ' f_units(axis)])
        xlabel('percent gait cycle')
        legend('fast high effort', 'slow high effort', 'fast low effort', 'slow low effort')
%         ylim([0 1600])
    end
end