 function getBarPlot_visit1(fitgrpdata,titlein,ylimvec)
 % make sure to set unincluded values to NAN
 % fitgrpdata is a 
%% use superbar CORRECTED first exposure asymmetry
clear colr edgcolr
global colors subject
indivoffset = 0.1; indivoffset2 = -0.1;


fitgrpmean = mean(fitgrpdata,1, 'omitnan');
fitgrpste = std(fitgrpdata,[],1,'omitnan')./ sqrt(sum(~isnan(fitgrpdata)));

% bars within groups in rows (pair first and second visits)
% all group hf paired with ls
barin(1,:) = [fitgrpmean(1) fitgrpmean(3) fitgrpmean(3)];
% barin(:,2) = [fitgrpmean(2) fitgrpmean(4)];
% barin(:,3) = [fitgrpmean(3) NaN];

barer(1,:) = [fitgrpste(1) fitgrpste(2) fitgrpste(3)];
% barer(:,2) = [fitgrpste(2) fitgrpste(4)];
% barer(:,3) = [fitgrpste(3) NaN];

hold on;
if ~isempty(ylimvec)
    ylow = ylimvec(1); yhigh = ylimvec(2);
    ylim([ylow,yhigh]);
end
colr = nan(1,3,3); %(3,2,3);
colr(1,1,:) = colors.high; colr(2,1,:) = colors.low; colr(3,1,:) = colors.control;
% colr(2,1,:) = colors.low; colr(2,2,:) = colors.high; %colr(2,3,:) = colors.control;
% colr(3,1,:) = colors.control; colr(3,2,:) = colors.low; %colr(3,3,:) = colors.control;
% colr(4,1,:) = colors.high; colr(4,2,:) = colors.low; colr(4,3,:) = colors.control;
edgcolr = nan(1,3,3); %3,2,3);
edgcolr(1,1,:) = [0 0 0]; edgcolr(2,1,:) = [0 0 0];  edgcolr(3,1,:) = [0 0 0];
% edgcolr(1,1,:) = [colors.high]; edgcolr(1,2,:) = [colors.high];  edgcolr(1,3,:) = [colors.control];
% edgcolr(2,1,:) = [colors.low]; edgcolr(2,2,:) = [colors.low]; % edgcolr(2,3,:) = [colors.control];
% edgcolr(3,1,:) = [colors.control]; edgcolr(3,2,:) = [colors.low]; % edgcolr(3,3,:) = [colors.control];
%edgcolr(4,1,:) = [colors.high]; edgcolr(4,2,:) = [colors.low]; edgcolr(4,3,:) = [colors.control];

X = superbar(1:3, barin','E',barer','BarFaceColor', colr,...
    'BarEdgeColor',edgcolr,'BarRelativeGroupWidth',1,'ErrorbarStyle','|');
%     set(gca, 'XAxisLocation', 'top')
    xticks(1:3)
%     xticklabels({['high first; p = ' num2str(p0(1))] ,...
%         ['low first; p = ' num2str(p0(2))],...
%         ['control; p = ' num2str(p0(3))]})
    xticklabels({'high','low','control'})

% %     title(['asymmetry in blk: ' num2str(blk)])
for j = 1:size(fitgrpdata,1)
    % hf and ls
    plot(X(1,1)-indivoffset,fitgrpdata(j,1),'k.')
%     plot(X(1,2)-indivoffset,fitgrpdata(j,5),'k.')
    % lf and hs
    plot(X(2,1)-indivoffset,fitgrpdata(j,2),'k.')
%     plot(X(2,2)-indivoffset,fitgrpdata(j,4),'k.')
    % c
    plot(X(3,1)-indivoffset,fitgrpdata(j,3),'k.')
end
%% if we want subject number labels
if 0
for j = 1:size(fitgrpdata,1)
    % hf
    if j < sum(~isnan(fitgrpdata(:,1)))
        text(X(1,1)-indivoffset2,fitgrpdata(j,1),subject.highfirstlist{j}); % num2str(subject.hfirst(j)))
    end
    % lf
    if j < sum(~isnan(fitgrpdata(:,2)))
        text(X(2,1)-indivoffset2,fitgrpdata(j,2),subject.lowfirstlist{j}); % num2str(subject.lfirst(j)))
    end
    % c
    if j < sum(~isnan(fitgrpdata(:,3)))
        text(X(3,1)-indivoffset2,fitgrpdata(j,3),subject.controllist{j}); % num2str(subject.control(j)))
    end
%     % hs and ls
%     if j < sum(~isnan(fitgrpdata(:,4)))
%         text(X(2,2)-indivoffset2,fitgrpdata(j,4),subject.highsecondlist{j}); % num2str(subject.hsecond(j)))
%     end
%     if j < sum(~isnan(fitgrpdata(:,5)))
%         text(X(1,2)-indivoffset2,fitgrpdata(j,5),subject.lowsecondlist{j}); % num2str(subject.lsecond(j)))
%     end
end
end
beautifyfig
end