% TM2_04_steplengthduringadaptation
includeblk = [4 5 6];
normbyheight = 0;
for subj = 1:subject.n
    for effcond = 1:2
        for blk = includeblk
            spi = find(blk == includeblk) + length(includeblk)*(effcond - 1);
            figure(subj); subplot(2,3,spi); hold on;
            if normbyheight == 0
                plot(F(subj).steplengthR{effcond,blk},'g-')
                plot(F(subj).steplengthL{effcond,blk},'r-')
            else
                plot(F(subj).steplengthR{effcond,blk}./subject.height(subj),'g-')
                plot(F(subj).steplengthL{effcond,blk}./subject.height(subj),'r-')
            end
            fl = subject.fastleg(subj);
            if fl == 1
                legend('fast','slow')
            else
                legend('slow', 'fast')
            end
            title(subject.list(subj))
            ylabel('steplength (mm)')
            ss = mean(cat(1,F(subj).steplengthR{effcond,blk}(end-40:end),F(subj).steplengthL{effcond,blk}(end-40:end)),'all');
            plot([0 600],[ss ss],'k:')
            xlabel('strides');
        end
    end
end