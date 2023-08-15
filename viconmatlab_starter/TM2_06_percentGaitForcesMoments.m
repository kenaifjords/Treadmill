%% TM2_03d_percentGaitForcesMoments
%% identifying heelstrike and toe off force peaks
% using derivative of  force to identify peaks
global homepath subject F p colors asym
close all
clear F_all
tic
f_units = {'Fx(N)','Fy(N)','Fz(N)'};
m_units = {'Mx(Nm)','My(Nm)','Mz(Nm)'};
includeblks = [2 3 4 5 6]; %1:7
plotallaxes = 0;
plotallsubj = 0;
lntyp = {'-', '--'};

% F_all.RpGait = nan(subject.n,length(subject.effortcondition),subject.nblk,3,100);
for subj = 1:subject.n
    effcond0 = [1 2];
    rfastsubj = 1; lfastsubj = 1;
    clear visit
    for effcond =  effcond0 % 1:length(subject.effortcondition)
        if subject.order(subj,1) == 0 && effcond == 1
            effcond = 3;
            visit = 0;
        elseif subject.order(subj,1) == 0 && effcond ~= 1
            break
        end
        if subject.order(subj,:) == [1 2]
            visit = effcond;
        elseif subject.order(subj,:) == [2 1]
            if effcond == 1
                visit = 2;
            elseif effcond == 2
                visit = 1;
            end
        end
        for blk = includeblks % 1:subject.nblk
            for axis = 1:3
                % forces
                clear infR infL inmR inmL outputR outputL outputmR outputmL
                infR = F(subj).R{effcond,blk}(:,axis);
                infL = F(subj).L{effcond,blk}(:,axis);
                intime = F(subj).time{effcond,blk};
                [outputR, outputL] = resampleToPercentGait_withValid(infR,infL,subj,effcond,blk);
                
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
                        fig = figure(subj + 100*effcond + 50);
                        fig.Name = [subject.list{subj} 'Ground Reaction Forces'];
                        subplot(1,3,axis); hold on;
                        plotpercentgait(outputfast,outputslow);
                        ylabel(f_units(axis))
                        sgtitle([subject.list{subj}  ' | effcond:' num2str(effcond) ' | blk:' num2str(blk)])
                    end

                    % z only
                    if axis == 3
                        fig = figure(subj + effcond*100);
                        fig.Name = [subject.list{subj} 'Ground Reaction Fz'];
                        subplot(1,length(includeblks), find(includeblks==blk));
                        hold on;
                        plotpercentgait(outputfast,outputslow);
                        ylabel(f_units(axis))
                        title(['blk:' num2str(blk)])
                        sgtitle([subject.list{subj}  ' | effcond:' num2str(effcond) '| visit:' num2str(visit)])
                        ylim([0 1600])
                        legend('fast initial','slow initial','fast early',...
                            'slow early', 'fast late','slow late','fastss',...
                            'slowss')
                    end
                end
                %% save the percent gait data
                % forces
                F(subj).percentgait.R{effcond,blk}(:,:,axis) = outputR;
                F(subj).percentgait.L{effcond,blk}(:,:,axis) = outputL;
                
                %% moments
                inmR = F(subj).MR{effcond,blk}(:,axis);
                inmL = F(subj).ML{effcond,blk}(:,axis);
%                 [outputmR, outputmL] = resampleToPercentGait(inmR,inmL,intime,hsR,hsL);
                [outputmR, outputmL] = resampleToPercentGait_withValid(inmR,inmL,subj,effcond,blk);
                 % identify fast leg
                if subject.fastleg(subj) == 1
                    outputfastm = outputmR;
                    outputslowm = outputmL;
                else
                    outputfastm = outputmL;
                    outputslowm = outputmR;
                end
                
                %% save the percent gait data
                % moments
                F(subj).percentgait.MR{effcond,blk}(:,:,axis) = outputmR;
                F(subj).percentgait.ML{effcond,blk}(:,:,axis) = outputmL;
            end
        end
    end
end

%% Across Subjects
% for each subject, we need to identify the fast leg, take the average for
% each initial,early,late,and end indices and save it into a matrix with
% all subjects that will be averaged at the end

initial = 1:5;
early = 6:30;
% determine "late"
endp = 30;

for effcond = 1:2
    for blk = 1:subject.nblk
        for subj = 1:subject.n
            if subject.order(subj,1) == 0
                break
            end
            clear fmat
            rforce = F(subj).percentgait.R{effcond,blk};
            lforce = F(subj).percentgait.L{effcond,blk};
            if subject.fastleg == 1
                fastLeg = rforce;
                slowLeg = lforce;
            else
                fastLeg = lforce;
                slowLeg = rforce;
            end
            lateend = min(size(fastLeg,1)-endp,200);
            if lateend < 31
                lateend = size(fastLeg,1);
            end
            late = 31:lateend;

            for axis = 1:3
                % initial
                fmatinitial_fast(subj,:,axis) = mean(fastLeg(initial,:,axis),1,'omitnan');
                fmatinitial_slow(subj,:,axis) = mean(slowLeg(initial,:,axis),1,'omitnan');
                % early
                fmatearly_fast(subj,:,axis) = mean(fastLeg(early,:,axis),1,'omitnan');
                fmatearly_slow(subj,:,axis) = mean(slowLeg(early,:,axis),1,'omitnan');
                % late
                fmatlate_fast(subj,:,axis) = mean(fastLeg(late,:,axis),1,'omitnan');
                fmatlate_slow(subj,:,axis) = mean(slowLeg(late,:,axis),1,'omitnan');
                % end
                fmatsteady_fast(subj,:,axis) = mean(fastLeg(end-endp:end,:,axis),1,'omitnan');
                fmatsteady_slow(subj,:,axis) = mean(slowLeg(end-endp:end,:,axis),1,'omitnan');
            end
        end
        
    end
end
            
% %% average across all subjects - we want a subplot for each fast and slow 
% % baseline walking, then a line type for high effort or low effort, with
% % standard error
% fig = figure(88); fig.Name = 'Ground Reaction Forces across subjects';
% axis = 3; % z ground reaction force only
% for effcond = 1:2
%     for blk = includeblks
%         R = squeeze(F_all.RpGait(:,effcond,blk,axis,:));
%         L = squeeze(F_all.LpGait(:,effcond,blk,axis,:));
%         bothlegs = squeeze(F_all.pGait(:,effcond,blk,axis,:));
% %         bothlegs = cat(1,R,L);
%         avgR = mean(R,1); avgL = mean(L,1);
%         steR = std(R)/sqrt(subject.n); steL = std(L)/sqrt(subject.n);
%         avg = mean(bothlegs,1); steavg = std(bothlegs)/sqrt(subject.n);
%         figure(88); subplot(1,length(includeblks), blk - (includeblks(1)-1)); hold on;
% %                 plot(x,outputR,':','Color',[0 1 0 0.3],'LineWidth',0.25)
% %                 plot(x,outputL,':','Color',[1 0 0 0.3],'LineWidth',0.25)
%         [~] = plot_with_std_linetype(x,avgR,steR,[0 1/(blk) 0],lntyp{effcond});
%         [~] = plot_with_std_linetype(x,avgL,steL,[1/(blk) 0 0],lntyp{effcond});
%         ylabel(f_units(axis))
%         xlabel('percent gait cycle')
%         legend('R high effort', 'L high effort', 'R low effort', 'L low effort')
% %         ylim([0 1600])
%         figure(89);subplot(1,length(includeblks), blk - (includeblks(1)-1)); hold on;
% %         plot(x,avg,'k','LineStyle',lntyp{effcond})
%         [~] = plot_with_std_linetype(x,avg,steavg,[0 0 0],lntyp{effcond});
%         ylabel('force (N)')
%         xlabel('percent gait cycle')
%         legend('high effort', 'low effort')
%         title(['blk: ' num2str(blk) ' +/- standard error'])
% %         ylim([0 1200])
%     end
% end
%     sgtitle('Fz baseline')
% %% fast and slow leg
% includeblks = 2:7; %4;
% axis = 2; % z ground reaction force only
% for effcond = 1:2
%     for blk = includeblks
%         fst = squeeze(F_all.fastpGait(:,effcond,blk,axis,:));
%         slw = squeeze(F_all.slowpGait(:,effcond,blk,axis,:));
% %         bothlegs = cat(1,R,L);
%         avgf = mean(fst,1); avgs = mean(slw,1);
%         stef = std(fst)/sqrt(subject.n); stes = std(slw)/sqrt(subject.n);
%         figure(98); subplot(1,length(includeblks), blk - (includeblks(1)-1)); hold on;
%         [~] = plot_with_std_linetype(x,avgf,stef,[1/(blk/2) 0 1],lntyp{effcond});
%         [~] = plot_with_std_linetype(x,avgs,stes,[1/(blk/2) 1 0],lntyp{effcond});
%         ylabel(['norm ' f_units(axis)])
%         xlabel('percent gait cycle')
%         legend('fast high effort', 'slow high effort', 'fast low effort', 'slow low effort')
% %         ylim([0 1600])
%     end
% end