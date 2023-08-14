% TM2_check_HS-step-stride-count
global subject F p colors asym
yes_plot = 0;
effcondmarker = ['x','o','.'];
tic
for subj = 1:subject.n
    if subject.order(subj,1) == 0
        effuse = 3;
    else
        effuse = [1 2];
    end
    for effcond = effuse
        for blk = 1:subject.nblk
            hsR = F(subj).hsR{effcond, blk}; % size(hsR)
            hsL = F(subj).hsL{effcond, blk}; % size(hsL)

            ihsL = F(subj).hsL_idx{effcond, blk};
            ihsR = F(subj).hsR_idx{effcond, blk};
          
            rvalid = F(subj).validstepR{effcond,blk};
            lvalid = F(subj).validstepL{effcond,blk};
            
            sizehsR(subj,effcond,blk) = length(hsR);
            sizehsL(subj,effcond,blk) = length(hsL);
            sizevalR(subj,effcond,blk) = length(rvalid);
            sizevalL(subj,effcond,blk) = length(lvalid);
        end
    end
end

sizehsR(sizehsR == 0) = NaN;
sizehsL(sizehsL == 0) = NaN;
sizevalR(sizevalR == 0) = NaN;
sizevalL(sizevalL == 0) = NaN;




figure(); hold on;
for effcond = 1:3
    for blk = 1:subject.nblk
        subplot(2,subject.nblk,blk); hold on;
        ps = sizevalL(:,:,blk); lowb = min(ps(ps>0));
        plot([lowb max(sizehsL(:,:,blk),[],'all')],[lowb max(sizehsL(:,:,blk),[],'all')],'k:')
        ylabel('left foot # valid'); xlabel('# heel strikes')
        plot(sizehsL(:,effcond,blk),sizevalL(:,effcond,blk),'Color',colors.all{effcond,1},'LineStyle','none','Marker','.')
        plot(mean(sizehsL(:,effcond,blk),'all','omitnan'),mean(sizevalL(:,effcond,blk),'all','omitnan'),'Color',colors.all{effcond,1},'Marker','+','MarkerSize',20)
        ylim([lowb - 2,max(sizehsL(:,:,blk),[],'all')]);
        xlim([lowb - 2,max(sizehsL(:,:,blk),[],'all')]);
        title({'fewest valid steps: ', num2str(lowb)})
        axis square
        
        subplot(2,subject.nblk,blk+subject.nblk); hold on;
        ps = sizehsR(:,:,blk); lowb = min(ps(ps>0));
        plot([lowb max(sizehsR(:,effcond,blk),[],'all')],[lowb max(sizehsR(:,effcond,blk),[],'all')],'k:')
        ylabel('right foot # valid'); xlabel('# heel strikes')
        plot(sizehsR(:,effcond,blk),sizevalR(:,effcond,blk),'Color',colors.all{effcond,1},'LineStyle','none','Marker','.')
        plot(mean(sizehsR(:,effcond,blk),'all','omitnan'),mean(sizevalR(:,effcond,blk),'all','omitnan'),'Color',colors.all{effcond,1},'Marker','+','MarkerSize',20)
        ylim([lowb - 2,max(sizehsL(:,:,blk),[],'all')]);
        xlim([lowb - 2,max(sizehsL(:,:,blk),[],'all')]);
        title({'fewest valid steps: ', num2str(lowb)})
        axis square
    end
end