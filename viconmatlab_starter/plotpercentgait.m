function plotpercentgait(fastLeg, slowLeg)
initial = 1:5;
early = 6:30;
% determine "late"
endp = 30;
lateend = min(size(fastLeg,1)-endp,200);
if lateend < 31
    lateend = size(fastLeg,1);
    disp('Late and end refer to overlapping step indices')
end
late = 31:lateend-1;

lntyp = {'-','--','-.',':'};

fastColor = [245,39,110] / 255; %[0 1/(blk/2) 0];
slowColor = [107,104,254] / 255; %1/(blk/2) 0 0];
% initial
plot_with_stderr_linetype(0,fastLeg(initial,:),fastColor,lntyp{1});
plot_with_stderr_linetype(0,slowLeg(initial,:),slowColor,lntyp{1});
% early
plot_with_stderr_linetype(0,fastLeg(early,:),fastColor,lntyp{2});
plot_with_stderr_linetype(0,slowLeg(early,:),slowColor,lntyp{2});
% late
plot_with_stderr_linetype(0,fastLeg(late,:),fastColor,lntyp{3});
plot_with_stderr_linetype(0,slowLeg(late,:),slowColor,lntyp{3});
% end
plot_with_stderr_linetype(0,fastLeg(end - endp:end,:),fastColor,lntyp{4});
plot_with_stderr_linetype(0,slowLeg(end - endp:end,:),slowColor,lntyp{4});
% other stuff
xlabel('percent gait cycle')
end