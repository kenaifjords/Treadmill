 function getBarPlot_groupsorted_separatelegs(fitgrpdata,titlein,ylimvec)
 % make sure to set unincluded values to NAN
 
 % fitgrpdata is a matrix with a column for each group, a row for each
 % subject within a group and a third dimension which is for the separate
 % legs
 % subj in grp X grp X leg
 % fitgrpdata is a 
%% use superbar CORRECTED first exposure asymmetry
clear colr edgcolr
global colors subject
indivoffset = 0.075; indivoffset2 = -0.075;


fitgrpmean(1,:) = (mean(fitgrpdata(:,:,1),1, 'omitnan'));
fitgrpmean(2,:) = (mean(fitgrpdata(:,:,2),1, 'omitnan'));
fitgrpste(1,:) = std(fitgrpdata(:,:,1),[],1,'omitnan')./ sqrt(sum(~isnan(fitgrpdata(:,:,1))));
fitgrpste(2,:) = std(fitgrpdata(:,:,2),[],1,'omitnan')./ sqrt(sum(~isnan(fitgrpdata(:,:,2))));

% bars within groups in rows (pair first and second visits)
% all group hf paired with ls
barin(:,1) = [fitgrpmean(:,1)' fitgrpmean(:,5)'];
barin(:,2) = [fitgrpmean(:,2)' fitgrpmean(:,4)'];
barin(:,3) = [fitgrpmean(:,3)' NaN(1,2)];

barer(:,1) = [fitgrpste(:,1)' fitgrpste(:,5)'];
barer(:,2) = [fitgrpste(:,2)' fitgrpste(:,4)'];
barer(:,3) = [fitgrpste(:,3)' NaN(1,2)];

hold on;
if ~isempty(ylimvec)
    ylow = ylimvec(1); yhigh = ylimvec(2);
    ylim([ylow,yhigh]);
end
colr = nan(3,4,3);
%
colr(1,1,:) = colors.high; colr(1,2,:) = colors.high_light;
colr(1,3,:) = colors.low; colr(1,4,:) = colors.low_light; %colr(1,3,:) = colors.control;
%
colr(2,1,:) = colors.low; colr(2,2,:) = colors.low_light;
colr(2,3,:) = colors.high; colr(2,4,:) = colors.high_light; %colr(2,3,:) = colors.control;
%
colr(3,1,:) = colors.control; colr(3,2,:) = colors.control_light;
colr(3,3,:) = colors.low; colr(3,4,:) = colors.low_light;
%colr(3,3,:) = colors.control;
% colr(4,1,:) = colors.high; colr(4,2,:) = colors.low; colr(4,3,:) = colors.control;
edgcolr = nan(3,4,3);
%
edgcolr(1,1,:) = [colors.high]; edgcolr(1,2,:) = [colors.high_light];
edgcolr(1,3,:) = [colors.high]; edgcolr(1,4,:) = [colors.high_light];% edgcolr(1,3,:) = [colors.control];
%
edgcolr(2,1,:) = [colors.low]; edgcolr(2,2,:) = [colors.low_light]; % edgcolr(2,3,:) = [colors.control];
edgcolr(2,3,:) = [colors.low]; edgcolr(2,4,:) = [colors.low_light];
%
edgcolr(3,1,:) = [colors.control]; edgcolr(3,2,:) = [colors.control_light]; % edgcolr(3,3,:) = [colors.control];
edgcolr(3,3,:) = [colors.control]; edgcolr(3,4,:) = [colors.low];
%edgcolr(4,1,:) = [colors.high]; edgcolr(4,2,:) = [colors.low]; edgcolr(4,3,:) = [colors.control];

X = superbar(1:3, barin','E',barer','BarFaceColor', colr,...
    'BarEdgeColor',edgcolr,'BarRelativeGroupWidth',1,'ErrorbarStyle','|');
%     set(gca, 'XAxisLocation', 'top')
    xticks(1:3)
%     xticklabels({['high first; p = ' num2str(p0(1))] ,...
%         ['low first; p = ' num2str(p0(2))],...
%         ['control; p = ' num2str(p0(3))]})
    xticklabels({'high first','low first','control'})

% %     title(['asymmetry in blk: ' num2str(blk)])
for j = 1:size(fitgrpdata,1)
    % hf and ls
    plot(X(1,1)-indivoffset,fitgrpdata(j,1,1),'k.')
    plot(X(1,2)-indivoffset,fitgrpdata(j,1,2),'k.')
    plot(X(1,3)-indivoffset,fitgrpdata(j,4,1),'k.')
    plot(X(1,4)-indivoffset,fitgrpdata(j,4,2),'k.')
    % lf and hs
    plot(X(2,1)-indivoffset,fitgrpdata(j,2,1),'k.')
    plot(X(2,2)-indivoffset,fitgrpdata(j,2,2),'k.')
    plot(X(2,3)-indivoffset,fitgrpdata(j,5,1),'k.')
    plot(X(2,4)-indivoffset,fitgrpdata(j,5,2),'k.')
    % c
    plot(X(3,1)-indivoffset,fitgrpdata(j,3,1),'k.')
    plot(X(3,2)-indivoffset,fitgrpdata(j,3,2),'k.')
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
    % hs and ls
    if j < sum(~isnan(fitgrpdata(:,4)))
        text(X(2,2)-indivoffset2,fitgrpdata(j,4),subject.highsecondlist{j}); % num2str(subject.hsecond(j)))
    end
    if j < sum(~isnan(fitgrpdata(:,5)))
        text(X(1,2)-indivoffset2,fitgrpdata(j,5),subject.lowsecondlist{j}); % num2str(subject.lsecond(j)))
    end
end
end
beautifyfig
end