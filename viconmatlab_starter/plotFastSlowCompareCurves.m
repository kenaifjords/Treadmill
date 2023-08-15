function plotFastSlowCompareCurves(blkinclude,titlestring,inputstructfast,inputstructslow)
global colors
for blk = blkinclude
    subplot(1,length(blkinclude),find(blk == blkinclude)); hold on; % braking force
    sgtitle(titlestring)
    ylabel('first visit')
    plot_with_stderr(0,inputstructfast.hfirst{blk},colors.fastleg) %% these need to be trimmed to shortest ###
    plot_with_stderr(0,inputstructslow.hfirst{blk},colors.slowleg)
    plot_with_stderr_linetype(0,inputstructfast.lfirst{blk},colors.fastleg,'--') %% these need to be trimmed to shortest ###
    plot_with_stderr_linetype(0,inputstructslow.lfirst{blk},colors.slowleg,'--')
    plot_with_stderr_linetype(0,inputstructfast.control{blk},colors.fastleg,':') %% these need to be trimmed to shortest ###
    plot_with_stderr_linetype(0,inputstructslow.control{blk},colors.slowleg,':')
    legend('high effort, fast leg','high effortm slow leg',...
        'low effort, fast leg', 'low effort, slow leg',...
        'control, fast leg', 'control, slow leg');
end