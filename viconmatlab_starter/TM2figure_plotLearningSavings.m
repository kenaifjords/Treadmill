% TM2figure_learning and savings
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        % effort condition subplots are ordered according to the order
        % experienced
       figure(subj)
       subplot(1,2,subject.order(subj,effcond)); hold on;
        for blk = [4,6]
            if blk == 4
                colorcol = 1;
            else
                colorcol = 2;
            end
            plot(1:asym(subj).nsteps{effcond,blk},asym(subj).asymlength{effcond,blk},'Color',colors.all{effcond,colorcol})
            sgtitle(subject.list(subj));
            ylim([-0.5,0.5]); xlim([0,650])
            plot([0 asym(subj).nsteps{effcond,blk}],[0 0],'k:')
            ylabel('step length asym')
            xlabel('steps')
        end
        
        figure(subj + subject.n)
        subplot(1,2,subject.order(subj,effcond)); hold on;
        for blk = [4,6]
            if blk == 4
                colorcol = 1;
            else
                colorcol = 2;
            end
            plot(1:200,asym(subj).asymlength{effcond,blk}(1:200),'Color',colors.all{effcond,colorcol})
            sgtitle(subject.list(subj));
            ylim([-0.5,0.5]);xlim([0,200])
            plot([0 asym(subj).nsteps{effcond,blk}],[0 0],'k:')
            ylabel('step length asym')
            xlabel('early adaptation steps')
        end
    end
end