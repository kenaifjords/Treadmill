function getBarPlot_asymmetry_andcontrol(hf,lf,hs,ls,c,titlein)
%% use superbar CORRECTED first exposure asymmetry
clear colr edgcolr
global colors
for blk = 4:6
    % first exposure asym
    firstasymbar(:,1) = mean(hf{1,blk},'omitnan');
    % pert on first exposure (1,) and the two effort levels
    firstasymbar(:,2) = mean(lf{1,blk},'omitnan');
    firstasymbar(:,3) = mean(c{1,blk},'omitnan');
    for i = 1:4
        [~,p00] = ttest2(hf{1,blk}(:,i),lf{1,blk}(:,i));
        p0(i) = p00;
    end
    firstasymstderr(:,1) = std(hf{1,blk},[],'omitnan')./size(hf{1,blk},1);
    firstasymstderr(:,2) = std(lf{1,blk},[],'omitnan')./size(lf{1,blk},1);
    firstasymstderr(:,3) = std(c{1,blk},[],'omitnan')./size(c{1,blk},1);
    
    subplot(2,3,blk-3); hold on;
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

    superbar(1:4, firstasymbar,'E',firstasymstderr,'BarFaceColor', colr,...
        'BarEdgeColor',edgcolr,'BarRelativeGroupWidth',1,'ErrorbarStyle','|')
%     set(gca, 'XAxisLocation', 'top')
    xticks(1:4)
    xticklabels({['initial; p = ' num2str(p0(1))] ,...
        ['early; p = ' num2str(p0(2))],...
        ['late; p = ' num2str(p0(3))],...
        ['plateau; p = ' num2str(p0(4))]})
    title(['asymmetry in blk: ' num2str(blk)])
    beautifyfig
    
    % second exposure
    secondasymbar(:,1) = mean(hs{1,blk},'omitnan');
    % pert on first exposure (1,) and the two effort levels
    secondasymbar(:,2) = mean(ls{1,blk},'omitnan');
    
    for i = 1:4
        [~,p00] = ttest2(hs{1,blk}(:,i),ls{1,blk}(:,i));
        p0(i) = p00;
    end

    secondasymstderr(:,1) = std(hs{1,blk},[],'omitnan')./size(hs{1,blk},1);
    secondasymstderr(:,2) = std(ls{1,blk},[],'omitnan')./size(ls{1,blk},1);

    subplot(2,3,blk); hold on;
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

    superbar(1:4, secondasymbar,'E',secondasymstderr,'BarFaceColor', colr,...
        'BarEdgeColor',edgcolr,'ErrorbarStyle','|')
%     set(gca, 'XAxisLocation', 'top')
%     ylabel('steplength asymetry');
    xticks(1:4)
%     xticklabels({'initial','early','late','plateau'})
    xticklabels({['initial; p = ' num2str(p0(1))] ,...
        ['early; p = ' num2str(p0(2))],...
        ['late; p = ' num2str(p0(3))],...
        ['plateau; p = ' num2str(p0(4))]})
    title(['asymmetry in blk: ' num2str(blk)])
    
    %% formatting things
    subplot(2,3,1); ylabel('VISIT 1');
    subplot(2,3,4); ylabel('VISIT 2');
    sgtitle(titlein);
    beautifyfig
end