function plotFastSlowCompareCurves(blkinclude,titlestring,inputstructfast,inputstructslow)
global colors
for blk = blkinclude
    subplot(length(blkinclude),1,find(blk == blkinclude)); hold on; % braking force
    sgtitle(titlestring)
    if blk == blkinclude(1)
        ylabel(['normalized ' titlestring])
    end
    title(['block: ', num2str(blk)])
    plot_with_stderr_marker(0,inputstructfast.hfirst{blk},colors.high, 'o') %% these need to be trimmed to shortest ###
    plot_with_stderr_marker(0,inputstructslow.hfirst{blk},colors.high, 'd')
    plot_with_stderr_marker(0,inputstructfast.lfirst{blk},colors.low,'o') %% these need to be trimmed to shortest ###
    plot_with_stderr_marker(0,inputstructslow.lfirst{blk},colors.low,'d')
    plot_with_stderr_marker(0,inputstructfast.control{blk},colors.control,'o') %% these need to be trimmed to shortest ###
    plot_with_stderr_marker(0,inputstructslow.control{blk},colors.control,'d')
    legend('high effort, fast leg','high effortm slow leg',...
        'low effort, fast leg', 'low effort, slow leg',...
        'control, fast leg', 'control, slow leg');
end