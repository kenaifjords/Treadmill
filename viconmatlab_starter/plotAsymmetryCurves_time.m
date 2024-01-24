function plotAsymmetryCurves_time(blkinclude,titlestring,inputstruct)
global colors
for blk = blkinclude
    subplot(length(blkinclude),1,find(blk == blkinclude)); hold on; % braking force
    sgtitle(titlestring)
    ylabel('asymmetry')
    if blk == 4 || blk == 6
        ylim([-0.1 0.5])
    else
        ylim([-0.1 0.5])
    end
    plot_with_stderr(0,inputstruct.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
    plot_with_stderr(0,inputstruct.lfirst{blk},colors.all{2,1})
    plot_with_stderr(0,inputstruct.control{blk},colors.all{3,1})
    plot_with_stderr_linetype(0,inputstruct.hsecond{blk},colors.all{1,1},':') %% these need to be trimmed to shortest ###
    plot_with_stderr_linetype(0,inputstruct.lsecond{blk},colors.all{2,1},':')
    legend('high', 'low', 'control', 'high (second visit)', 'low (second visit)')
    % note that color refers to the effort condition but the high group on
    % the second visit was the low group in the first visit
end