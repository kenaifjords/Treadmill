function plot_with_stderr_linetype(x,mat,color,linetype)
% mat is a matrix of profiles that will be averaged and standard errored
% across rows
% x corresponds to the direction of mat columns
% color is a 3 or 4 number RGB / 255 (division is stablished in input)
if x == 0
    x = 1:size(mat,2);
end
y = mean(mat,1,'omitnan');
% y = y(~isnan(y));
ysde = std(mat,[],1,'omitnan')/sqrt(size(mat,1));
% ysde = ysde(~isnan(y));
% x = x(~isnan(y));

% plot works withany error size that is input
upper = y + ysde; %length(upper)
lower = y - ysde; %length(lower)

upper(isnan(upper)) = 0;
lower(isnan(lower)) = 0;

transparency = 0.2;
edge = color; %[0 0 1]; %color;
matlinecolor = [color 2*transparency];
% figure(); hold on;
filled=[upper,fliplr(lower)]; %size(filled)
xpts = [x,fliplr(x)];%size(xpts)
fillhandle = fill(xpts,filled,color,'HandleVisibility','off');%plot the data
% size(xpts)
% size(filled)
set(fillhandle,'EdgeColor',edge,'FaceAlpha',transparency,'EdgeAlpha',transparency,'HandleVisibility','off');
% length(x)
% length(y)
%% uncomment if you want profiles for each subject
% plot(x,mat,'LineWidth',0.25) %,'Color',matlinecolor,'HandleVisibility','off');
%% %
plot(x,y,'Color',color,'LineWidth',1.25,'LineStyle',linetype);%,'HandleVisibility','off'); %'HandleVisibility','off');
% plot([x(1) x(end)],[0 0],'k--')
k = 1;
end 