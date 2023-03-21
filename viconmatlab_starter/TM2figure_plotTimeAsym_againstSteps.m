 function TM2figure_plotTimeAsym_againstSteps
global homepath subject F p colors asym
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            clear steptime1 steptime2 steptime_asym maxsteps
             %% the step asymmetries
            steptime1 = asym(subj).steptime_r{effcond,blk}; % = steptime1;
            steptime2 = asym(subj).steptime_l{effcond,blk}; % = steptime       maxsteps = asym(subj).nsteps{effcond,blk}; % = maxsteps;
            steptime_asym = asym(subj).steptime_asym{effcond,blk};
            maxsteps = asym(subj).maxsteps_time{effcond,blk}; % = maxsteps;
            size(steptime1)
            %% make a plot for step time
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
            % FIGURE for all step times and 
            figure(subj);
            sgtitle(subject.list(subj))
            subplot(4,subject.nblk,plotblk); hold on;
%                 maxsteps
%                 size(steptime1)
            plot(1:maxsteps,steptime1,'r.')
%             title('Step times')
            hold on
            plot(1:maxsteps,steptime2,'g.')
            ylabel('Step time (s)')
            if plotblk == 7 || plotblk == 21
                legend('Right','Left')
            end
            xlabel('step number')
            %#ylim([300,800]);
            % ASYM PLOTS
            if plotrow == 1
                plotblk = subject.nblk + blk;
            else
                plotblk = 3*subject.nblk + blk;
            end
            subplot(4,subject.nblk,plotblk)
            plot(1:maxsteps,steptime_asym,'Color',colorasym)
%             title(subject.effortlabel(effcond))
            ylabel('Asymmetry (fast - slow) time (s)')
            xlabel('step number')
            text(50,0.5,['fastleg: ' subject.leglabel(subject.fastleg(subj,effcond))]);
            ylim([-1 1])
            
            %% % HERE WANT PLOT WITH JUST SPLITS
            figure(17*subj + effcond);
            if blk == 4 || blk == 6 % split 1 %split 2 = saving
                if blk == 4
                    splitplotloc = 1;
                else
                    splitplotloc = 2;
                end
                subplot(2,2,splitplotloc); hold on
                sgtitle(subject.list(subj))
                plot((1:maxsteps),steptime1,'r.')
                title('Step Time')
                hold on
                plot(1:maxsteps,steptime2,'g.')
                ylabel('time (s)')
                legend('Right','Left')
                xlabel('step number')
                %#ylim([300,800]);
                
                subplot(2,2,splitplotloc + 2); hold on;
                plot(1:maxsteps,steptime_asym,'Color',colorasym)
                title(subject.effortlabel(effcond))
                ylabel('Asymmetry (fast - slow) time (s)')
                xlabel('step number')
                text(50,0.5,['fastleg: ' subject.leglabel(subject.fastleg(subj,effcond))]);
                ylim([-1 1])
            end
            % PLOT THAT COMPARES LEARN and SAVE and HIGH LEARN TO LOW LEARN
            figure(111*subj);
            sgtitle(subject.list(subj))
            if blk == 4 || blk == 6 % split 1 %split 2 = saving
                if blk == 4
                    subplot(221); hold on;
                    plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineWidth',1.5)
                    ylabel('Asymmetry (fast - slow) Time (s)')
                    ylim([-1 1])
                    xlim([0 615])
                    title('compare learning')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineWidth',1.5)
                    else
                        subplot(224); hold on;
                        plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineWidth',1.5)
                    end
                else
                    subplot(222); hold on;
                    plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                    ylim([-1 1])
                    xlim([0 615])
                    title('compare savings')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                        ylabel('Asymmetry (fast - slow) Time (s)')
                        xlabel('step number')
                        ylim([-1 1])
                        xlim([0 615])
                        title('high effort learning and savings')
                    else
                        subplot(224); hold on;
                        plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                        xlabel('step number')
                        ylim([-1 1])
                        xlim([0 615])
                        title('low effort learning and savings')
                    end
                end
                % PLOT THAT ZOOMS COMPARES LEARN and SAVE and HIGH LEARN TO LOW LEARN
                figure(102*subj)
                sgtitle(subject.list(subj))
                if blk == 4
                    subplot(221); hold on;
                    plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineWidth',1.5)
                    ylabel('Asymmetry (fast - slow) Time (s)')
                    ylim([-1 1])
                    xlim([0 200])
                    title('compare learning')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineWidth',1.5)
                    else
                        subplot(224); hold on;
                        plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineWidth',1.5)
                    end
                else
                    subplot(222); hold on;
                    plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                    ylim([-1 1])
                    xlim([0 200])
                    title('compare savings')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                        ylabel('Asymmetry (fast - slow) Time (s)')
                        xlabel('step number')
                        ylim([-1 1])
                        xlim([0 200])
                        title('high effort learning and savings')
                    else
                        subplot(224); hold on;
                        plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                        xlabel('step number')
                        ylim([-1 1])
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
