% TM2_06_analyzeBaseline
% dependent on TM@_05b
for blk = 2:3 % fast and slow baseline
    disp(['block: ' num2str(blk)])
    % compare mean asym for each group to 0
    slah = mean(slength.hfirst{1,blk},2,'omitnan');
    [~,p,ci] = ttest(slah);
    disp(['high: p = ', num2str(p), ' ci: [', num2str(ci'), ']'])
    slal = mean(slength.lfirst{1,blk},2,'omitnan');
    [~,p,ci] = ttest(slal);
    disp(['low: p = ', num2str(p), ' ci: [', num2str(ci'), ']'])
    slac = mean(slength.control{1,blk},2,'omitnan');
    [~,p,ci] = ttest(slac);
    disp(['control: p = ', num2str(p), ' ci: [', num2str(ci'), ']'])
    % compare groups to one another
    ain = cat(2,slah,slal,slac);
    [p,~,stat] = anova1(ain);
    disp(['anova for differences between groups: ' num2str(p)])
end