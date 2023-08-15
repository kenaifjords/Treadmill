function plotAsymmetryCurves(blkinclude,titlestring,inputstruct)
global colors
for blk = blkinclude
    subplot(length(blkinclude),1,find(blk == blkinclude)); hold on; % braking force
    sgtitle(titlestring)
    ylabel('asymmetry')
    ylim([-0.5 0.5])
    plot_with_stderr(0,inputstruct.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
    plot_with_stderr(0,inputstruct.lfirst{blk},colors.all{2,1})
    plot_with_stderr(0,inputstruct.control{blk},colors.all{3,1})
    plot_with_stderr_linetype(0,inputstruct.hsecond{blk},colors.all{1,1},':') %% these need to be trimmed to shortest ###
    plot_with_stderr_linetype(0,inputstruct.lsecond{blk},colors.all{2,1},':')
end