%TM2figure_plotLearningCurves
function TM2figure_plotLearningCurves
global homepath subject F p colors asym
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            subj
            effcond
            blk
            %% the step asymmetries
            steplength1 = asym(subj).steplength_r{effcond,blk}; % = steplength1;
            steplength2 = asym(subj).steplength_l{effcond,blk}; % = steplength2;
%             % uncomment for step width
%             steplength1 = asym(subj).stepwidth_r{effcond,blk}; % = steplength1;
%             steplength2 = asym(subj).stepwidth_l{effcond,blk}; % = steplength2;
                % should update labels on plots so this is consistent
            maxsteps = asym(subj).nsteps{effcond,blk}; % = maxsteps;
            steplength_asym = asym(subj).asymlength{effcond,blk};% = steplength_asym;
            steptime1 = asym(subj).steptime_r{effcond,blk}; % = steptime1;
            steptime2 = asym(subj).steptime_l{effcond,blk}; % = steptime2;
            steptime_asym = asym(subj).steptime_asym{effcond,blk};
            
%             steplength1(1:10)
            %% make a plot for step length
            if effcond == 1
                if blk == 4
                    colorasym = colors.high;
                else
                    colorasym = colors.high_light;
                end
                if subject.order(subj,1) == effcond
                   %high effort first
                    plotrow = 1;
                else
                    plotrow = 3;
                end
            else % effcond == 2
                if blk== 4
                    colorasym = colors.low;
                else
                    colorasym = colors.low_light;
                end
                if subject.order(subj,1) == effcond
                    % low effort first
                    plotrow = 1;
                    
                else
                    plotrow = 3;
                end
            end
            if plotrow == 1
                plotblk = blk;
            else
                plotblk = 2*subject.nblk + blk;
            end
            % FIGURE for all step lengths and 
            figure(subj);
            sgtitle(subject.list(subj))
            subplot(4,subject.nblk,plotblk); hold on;
            plot(1:maxsteps,steplength1,'r.')
%             title('Step Lengths')
            hold on
            plot(1:maxsteps,steplength2,'g.')
            ylabel('Step length (mm)')
            if plotblk == 7 || plotblk == 21
                legend('Right','Left')
            end
            xlabel('step number')
            ylim([300,800]);
            % ASYM PLOTS
            if plotrow == 1
                plotblk = subject.nblk + blk;
            else
                plotblk = 3*subject.nblk + blk;
            end
            subplot(4,subject.nblk,plotblk)
            plot(1:maxsteps,steplength_asym,'Color',colorasym)
%             title(subject.effortlabel(effcond))
            ylabel('Asymmetry (fast - slow) Length (mm)')
            xlabel('step number')
            text(50,0.5,['fastleg: ' subject.leglabel(subject.fastleg(subj,effcond))]);
            ylim([-0.5 0.5])

            %% save the step asymmetries
            asym(subj).steplength_r{effcond,blk} = steplength1;
            asym(subj).steplength_l{effcond,blk} = steplength2;
            asym(subj).nsteps{effcond,blk} = maxsteps;
            asym(subj).asymlength{effcond,blk} = steplength_asym;
            asym(subj).steptime_r{effcond,blk} = steptime1;
            asym(subj).steptime_l{effcond,blk}= steptime2;
            
            %%% HERE WANT PLOT WITH JUST SPLITS
            figure(17*subj + effcond);
            if blk == 4 || blk == 6 % split 1 %split 2 = saving
                if blk == 4
                    splitplotloc = 1;
                else
                    splitplotloc = 2;
                end
                subplot(2,2,splitplotloc); hold on
                sgtitle(subject.list(subj))
                plot((1:maxsteps),steplength1,'r.')
                title('Step Lengths')
                hold on
                plot(1:maxsteps,steplength2,'g.')
                ylabel('Length (mm)')
                legend('Right','Left')
                xlabel('step number')
                ylim([300,800]);
                
                subplot(2,2,splitplotloc + 2); hold on;
                plot(1:maxsteps,steplength_asym,'Color',colorasym)
                title(subject.effortlabel(effcond))
                ylabel('Asymmetry (fast - slow) Length (mm)')
                xlabel('step number')
                text(50,0.5,['fastleg: ' subject.leglabel(subject.fastleg(subj,effcond))]);
                ylim([-0.5 0.5])
            end
            % PLOT THAT COMPARES LEARN and SAVE and HIGH LEARN TO LOW LEARN
            figure(111*subj);
            sgtitle(subject.list(subj))
            if blk == 4 || blk == 6 % split 1 %split 2 = saving
                if blk == 4
                    subplot(221); hold on;
                    plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineWidth',1.5)
                    ylabel('Asymmetry (fast - slow) Length (mm)')
                    ylim([-0.4 0.4])
                    xlim([0 615])
                    title('compare learning')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineWidth',1.5)
                    else
                        subplot(224); hold on;
                        plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineWidth',1.5)
                    end
                else
                    subplot(222); hold on;
                    plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                    ylim([-0.4 0.4])
                    xlim([0 615])
                    title('compare savings')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                        ylabel('Asymmetry (fast - slow) Length (mm)')
                        xlabel('step number')
                        ylim([-0.4 0.4])
                        xlim([0 615])
                        title('high effort learning and savings')
                    else
                        subplot(224); hold on;
                        plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                        xlabel('step number')
                        ylim([-0.4 0.4])
                        xlim([0 615])
                        title('low effort learning and savings')
                    end
                end
                % PLOT THAT ZOOMS COMPARES LEARN and SAVE and HIGH LEARN TO LOW LEARN
                figure(102*subj)
                sgtitle(subject.list(subj))
                if blk == 4
                    subplot(221); hold on;
                    plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineWidth',1.5)
                    ylabel('Asymmetry (fast - slow) Length (mm)')
                    ylim([-0.4 0.4])
                    xlim([0 200])
                    title('compare learning')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineWidth',1.5)
                    else
                        subplot(224); hold on;
                        plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineWidth',1.5)
                    end
                else
                    subplot(222); hold on;
                    plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                    ylim([-0.4 0.4])
                    xlim([0 200])
                    title('compare savings')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                        ylabel('Asymmetry (fast - slow) Length (mm)')
                        xlabel('step number')
                        ylim([-0.4 0.4])
                        xlim([0 200])
                        title('high effort learning and savings')
                    else
                        subplot(224); hold on;
                        plot(1:maxsteps,steplength_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                        xlabel('step number')
                        ylim([-0.4 0.4])
                        xlim([0 200])
                        title('low effort learning and savings')
                    end
                end
            end
            beautifyfig
            figure(subj)
        end
    end
end
