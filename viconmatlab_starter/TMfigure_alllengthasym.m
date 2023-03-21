% TMfigure_alllengthasym
global homepath subject F p colors asym
tic
figure(); hold on
for subj = 1:subject.n
    for blk = 1:length(subject.blockname)
        %% make a plot for step length
        plotblk = subject.order(subj,blk);
        subplot(subject.nblk,subject.n,subplotNfromIdx(subject.nblk,subject.n,plotblk,subj));
        hold on;
        if blk < 3
            colorasym = colors.high;
        else
            colorasym = colors.low;
        end
        plot(F{subj}.hsR{blk}(1:asym{subj}.nsteps{blk}),asym{subj}.asymlength{blk},'Color',colorasym)
        ylabel(subject.blockname(blk))
        if plotblk == 1
            title(subject.list(subj))
        end
        xlabel('Time (s)')
        text(50,0.5,['fastleg: ' subject.leglabel(subject.fastleg(subj,blk))]);
        ylim([-1 1])
    end
end