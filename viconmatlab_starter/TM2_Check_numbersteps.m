%TM2_Check_numbersteps
global F p asym
close all
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            hsr = F{subj}.hsR{effcond,blk};
            hsl = F{subj}.hsL{effcond,blk};
            nstep.R(subj,effcond,blk) = size(hsr,2);
            nstep.L(subj,effcond,blk) = size(hsl,2);
            slR = asym(subj).steplength_r{effcond,blk};
            slL = asym(subj).steplength_l{effcond,blk};
            if ~isempty(slR) && ~isempty(slL)
                asymR.avgsteplength(subj,effcond,blk) = mean(slR,1,'omitnan');
                asymL.avgsteplength(subj,effcond,blk) = mean(slL,1,'omitnan');   
            end
        end
    end
end
nstep.Ravg = squeeze(mean(nstep.R,1));
nstep.Lavg = squeeze(mean(nstep.L,1));
nstep.Rstd = squeeze(std(nstep.R,1));
nstep.Lstd = squeeze(std(nstep.L,1));

for effcond = 1:2
    for blk = 1:subject.nblk
        figure(1); hold on;
        subplot(2,subject.nblk,(effcond-1)*subject.nblk + blk); hold on;
        plot(nstep.R(:,effcond,blk),'go')
        plot(nstep.L(:,effcond,blk),'ro')
        plot_with_std([1 subject.n],[nstep.Ravg(effcond,blk) nstep.Ravg(effcond,blk)],...
            [nstep.Rstd(effcond,blk) nstep.Rstd(effcond,blk)],[0 1 0])
        plot_with_std([1 subject.n],[nstep.Lavg(effcond,blk) nstep.Lavg(effcond,blk)],...
            [nstep.Lstd(effcond,blk) nstep.Lstd(effcond,blk)],[1 0 0])
        if blk == 1
            if effcond == 1
                ylabel('high effort')
            else
                ylabel('low effort')
            end
        end
        sgtitle('number of steps')   
    end
end
% relationship between number of steps and steplength
figure();
for effcond = 1:2
    for blk = 1:subject.nblk
        subplot(2, subject.nblk, (effcond-1)*subject.nblk + blk); hold on;
        plot(nstep.R(:,effcond,blk), asymR.avgsteplength(:,effcond,blk),'g.')
        plot(nstep.L(:,effcond,blk), asymL.avgsteplength(:,effcond,blk),'r.')
        for sj = 1:subject.n
            tr = text(nstep.R(sj,effcond,blk), asymR.avgsteplength(sj,effcond,blk),num2str(sj))
            tr.Color = [0 1/2 0];
            tl = text(nstep.L(sj,effcond,blk), asymL.avgsteplength(sj,effcond,blk),num2str(sj))
            tl.Color = 'r'
        end
        if blk == 1
            ylabel('average step length')
        end
        if effcond == 2
            xlabel('number of steps in a block')
        end
        title(['effcond ' num2str(effcond) 'blk ' num2str(blk)])
    end
end

