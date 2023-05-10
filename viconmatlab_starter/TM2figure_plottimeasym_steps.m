%TM2figure_plotLearningCurves
function TM2figure_plotLearningCurves
global homepath subject F p colors asym
tic
for subj = 10 % 1:subject.n Lkt(fot dragging)
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            subj
            effcond
            blk
            %% the step asymmetries
            maxsteps = asym(subj).nsteps{effcond,blk}; % = maxsteps;
            steptime1 = asym(subj).steptime_r{effcond,blk}; % = steptime1;
            steptime2 = asym(subj).steptime_l{effcond,blk}; % = steptime2;
            steptime_asym = asym(subj).steptime_asym{effcond,blk};
            %% determine plot color
            if effcond == 1
                if blk == 4 || blk == 6
                    colorasym = colors.high;
                else
                    colorasym = colors.high_light;
                end
            else % effcond == 2
                if blk== 4 || blk == 6
                    colorasym = colors.low;
                else
                    colorasym = colors.low_light;
                end
            end
            %% PLOT THAT COMPARES LEARN and SAVE and HIGH LEARN TO LOW LEARN
            figure(111*subj);
            sgtitle(subject.list(subj))
            if blk == 4 || blk == 6 % split 1 %split 2 = saving
                if blk == 4
                    subplot(221); hold on;
                    plot(1:length(steptime_asym),steptime_asym,'Color',colorasym,'LineWidth',1.5) %### x should be 1:maxsteps
                    ylabel('Asymmetry (fast - slow) Length (mm)')
                    ylim([-0.4 0.4])
                    xlim([0 615])
                    title('compare learning')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:length(steptime_asym),steptime_asym,'Color',colorasym,'LineWidth',1.5) %### x should be 1:maxsteps
                    else
                        subplot(224); hold on;
                        plot(1:length(steptime_asym),steptime_asym,'Color',colorasym,'LineWidth',1.5) %### x should be 1:maxsteps
                    end
                else
                    subplot(222); hold on;
                    plot(1:length(steptime_asym),steptime_asym,'Color',colorasym,'LineStyle',':','LineWidth',2) %### x should be 1:maxsteps
                    ylim([-0.4 0.4])
                    xlim([0 615])
                    title('compare savings')
                    if effcond == 1
                        subplot(223); hold on;
                        plot(1:length(steptime_asym),steptime_asym,'Color',colorasym,'LineStyle',':','LineWidth',2) %### x should be 1:maxsteps
                        ylabel('Asymmetry (fast - slow) Length (mm)')
                        xlabel('step number')
                        ylim([-0.4 0.4])
                        xlim([0 615])
                        title('high effort learning and savings')
                    else
                        subplot(224); hold on;
                        plot(1:maxsteps,steptime_asym,'Color',colorasym,'LineStyle',':','LineWidth',2)
                        xlabel('step number')
                        ylim([-0.4 0.4])
                        xlim([0 615])
                        title('low effort learning and savings')
                    end
                end
            end
            % PLOT THAT SHOWS EARLY COMPARES LEARN WASH SAVE
            figure(102*subj)
            sgtitle(subject.list(subj))
            if blk == 4
                subplot(131); hold on;
                plot(1:length(steptime_asym),steptime_asym,'Color',colorasym,'LineWidth',1.5) %### x should be 1:maxsteps
                ylabel('Asymmetry (fast - slow) Length (mm)')
                ylim([-0.4 0.4])
                xlim([0 200])
                title('EARLY learning')
            elseif blk == 5
                subplot(132); hold on;
                plot(1:length(steptime_asym),steptime_asym,'Color',colorasym,'LineStyle','-','LineWidth',2)%### x should be 1:maxsteps
                ylim([-0.4 0.4])
                xlim([0 200])
                title('EARLY washout')
            elseif blk == 6
                subplot(133); hold on;
                plot(1:length(steptime_asym),steptime_asym,'Color',colorasym,'LineStyle','-','LineWidth',2)%### x should be 1:maxsteps
                ylim([-0.4 0.4])
                xlim([0 200])
                title('EARLY relearning')
            end      
            beautifyfig
        end
    end
end

 