 function getBarPlot_asymmetry_andcontrol(hf,lf,hs,ls,c,titlein,ylimvec)
%% use superbar CORRECTED first exposure asymmetry
clear colr edgcolr
global colors subject
indivoffset = 0.075;
for blk = 4:6
    if blk == 5
        ylow = -ylimvec(2); yhigh = -ylimvec(1);
    else
        ylow = ylimvec(1); yhigh = ylimvec(2);
    end
    % first exposure asym
    firstasymbar(:,1) = mean(hf{1,blk},'omitnan');
    % pert on first exposure (1,) and the two effort levels
    firstasymbar(:,2) = mean(lf{1,blk},'omitnan');
    firstasymbar(:,3) = mean(c{1,blk},'omitnan');
    for i = 1:4
        ll = max([size(hf{1,blk}(:,i),1),size(lf{1,blk}(:,i),1),size(c{1,blk}(:,i),1)]);
        inmat = nan(ll,3);
        inmat(1:size(hf{1,blk}(:,i),1),1) = hf{1,blk}(:,i);
        inmat(1:size(lf{1,blk}(:,i),1),2) = lf{1,blk}(:,i);
        inmat(1:size(c{1,blk}(:,i),1),3) = c{1,blk}(:,i);
        [p00,tbl] = anova1(inmat,{'high','low','control'},'off'); % ttest2(hf{1,blk}(:,i),lf{1,blk}(:,i));
        p0(i) = p00;
    end
    firstasymstderr(:,1) = std(hf{1,blk},[],'omitnan')./sqrt(size(hf{1,blk},1));
    firstasymstderr(:,2) = std(lf{1,blk},[],'omitnan')./sqrt(size(lf{1,blk},1));
    firstasymstderr(:,3) = std(c{1,blk},[],'omitnan')./sqrt(size(c{1,blk},1));
    
    subplot(2,3,blk-3); hold on; ylim([ylow,yhigh]);
    colr = nan(4,2,3);
    colr(1,1,:) = colors.high; colr(1,2,:) = colors.low; colr(1,3,:) = colors.control;
    colr(2,1,:) = colors.high; colr(2,2,:) = colors.low; colr(2,3,:) = colors.control;
    colr(3,1,:) = colors.high; colr(3,2,:) = colors.low; colr(3,3,:) = colors.control;
    colr(4,1,:) = colors.high; colr(4,2,:) = colors.low; colr(4,3,:) = colors.control;
    edgcolr = nan(4,2,3);
    edgcolr(1,1,:) = [colors.high]; edgcolr(1,2,:) = [colors.low]; edgcolr(1,3,:) = [colors.control];
    edgcolr(2,1,:) = [colors.high]; edgcolr(2,2,:) = [colors.low]; edgcolr(2,3,:) = [colors.control];
    edgcolr(3,1,:) = [colors.high]; edgcolr(3,2,:) = [colors.low]; edgcolr(3,3,:) = [colors.control];
    edgcolr(4,1,:) = [colors.high]; edgcolr(4,2,:) = [colors.low]; edgcolr(4,3,:) = [colors.control];

    X = superbar(1:4, firstasymbar,'E',firstasymstderr,'BarFaceColor', colr,...
        'BarEdgeColor',edgcolr,'BarRelativeGroupWidth',1,'ErrorbarStyle','|');
%     set(gca, 'XAxisLocation', 'top')
    xticks(1:4)
    xticklabels({['initial; p = ' num2str(p0(1))] ,...
        ['early; p = ' num2str(p0(2))],...
        ['late; p = ' num2str(p0(3))],...
        ['plateau; p = ' num2str(p0(4))]})
    title(['asymmetry in blk: ' num2str(blk)])
    for jj = 1: size(hf{blk},1)
        for kk = 1:4
            plot(X(kk,1)-indivoffset,hf{blk}(jj,kk),'k.')
        end
    end
    for jj = 1: size(lf{blk},1)
        for kk = 1:4
            plot(X(kk,2)-indivoffset,lf{blk}(jj,kk),'k.')
        end
    end
    for jj = 1: size(c{blk},1)
        for kk = 1:4
            plot(X(kk,3)-indivoffset,c{blk}(jj,kk),'k.')
        end
    end
    beautifyfig
    
    % second exposure
    secondasymbar(:,1) = mean(hs{1,blk},'omitnan');
    % pert on first exposure (1,) and the two effort levels
    secondasymbar(:,2) = mean(ls{1,blk},'omitnan');
    
    for i = 1:4
        [~,p00] = ttest2(hs{1,blk}(:,i),ls{1,blk}(:,i));
        p0(i) = p00;
    end

    secondasymstderr(:,1) = std(hs{1,blk},[],'omitnan')./sqrt(size(hs{1,blk},1));
    secondasymstderr(:,2) = std(ls{1,blk},[],'omitnan')./sqrt(size(ls{1,blk},1));

    subplot(2,3,blk); hold on; ylim([ylow,yhigh]);
    colr = nan(4,2,3);
    colr(1,1,:) = colors.high; colr(1,2,:) = colors.low;
    colr(2,1,:) = colors.high; colr(2,2,:) = colors.low; 
    colr(3,1,:) = colors.high; colr(3,2,:) = colors.low;
    colr(4,1,:) = colors.high; colr(4,2,:) = colors.low;
    edgcolr = nan(4,2,3);
    edgcolr(1,1,:) = [colors.low]; edgcolr(1,2,:) = [colors.high];
    edgcolr(2,1,:) = [colors.low]; edgcolr(2,2,:) = [colors.high];
    edgcolr(3,1,:) = [colors.low]; edgcolr(3,2,:) = [colors.high];
    edgcolr(4,1,:) = [colors.low]; edgcolr(4,2,:) = [colors.high];

    X = superbar(1:4, secondasymbar,'E',secondasymstderr,'BarFaceColor', colr,...
        'BarEdgeColor',edgcolr,'ErrorbarStyle','|')
%     set(gca, 'XAxisLocation', 'top')
%     ylabel('steplength asymetry');
    xticks(1:4)
%     xticklabels({'initial','early','late','plateau'})
    xticklabels({['initial; p = ' num2str(p0(1))] ,...
        ['early; p = ' num2str(p0(2))],...
        ['late; p = ' num2str(p0(3))],...
        ['plateau; p = ' num2str(p0(4))]})
        for jj = 1: size(hs{blk},1)
        for kk = 1:4
            plot(X(kk,1)-indivoffset,hs{blk}(jj,kk),'k.')
        end
    end
    for jj = 1: size(ls{blk},1)
        for kk = 1:4
            plot(X(kk,2)-indivoffset,ls{blk}(jj,kk),'k.')
        end
    end
    title(['asymmetry in blk: ' num2str(blk)])
    
    %% formatting things
    subplot(2,3,1); ylabel('VISIT 1');
%     subplot(2,3,3); legend('high', 'low', 'control')
    subplot(2,3,4); ylabel('VISIT 2');
    sgtitle(titlein);
    beautifyfig
end