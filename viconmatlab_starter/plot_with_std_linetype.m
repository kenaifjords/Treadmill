function [k] = plot_with_std(x,y,ystd,color,linetype)
% plot works withany error size that is input
upper = y + ystd; %length(upper)
lower = y - ystd; %length(lower)

transparency = 0.2;
edge = color;

% figure(); hold on;
filled=[upper,fliplr(lower)]; %size(filled)
xpts = [x,fliplr(x)];%size(xpts)
fillhandle = fill(xpts,filled,color,'HandleVisibility','off');%plot the data
% size(xpts)
% size(filled)
set(fillhandle,'EdgeColor',edge,'FaceAlpha',transparency,'EdgeAlpha',transparency,'HandleVisibility','off');
% length(x)
% length(y)
plot(x,y,'Color',color,'LineWidth',1.25,'LineStyle',linetype);%,'HandleVisibility','off'); %'HandleVisibility','off');
% plot([x(1) x(end)],[0 0],'k--')
k = 1;
end