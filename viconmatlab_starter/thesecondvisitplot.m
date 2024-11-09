%% plot each block (4,5,6) for the second visit
% figure(695); hold on; 
blk = 4;
figure(695); subplot(3,1,1); hold on;
% ylabel('asymmetry'); xlabel('strides'); title('Learning (2nd visit)')
ylim([-0.4 0.1])
plot_with_stderr(0,slength.hsecond{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lsecond{blk},colors.all{2,1})


                
%%
% xlim([0 200])

% figure(696); hold on; 
blk = 5;
figure(695); subplot(3,1,2); hold on;
% ylabel('asymmetry'); xlabel('strides'); title('Washout (2nd visit)')
ylim([-0.1 0.40])
plot_with_stderr(0,slength.hsecond{blk}(:,1:400),colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lsecond{blk}(:,1:400),colors.all{2,1})
% xlim([0 200])

% figure(697); hold on; 
blk = 6;
figure(695); subplot(3,1,3); hold on;
% ylabel('asymmetry'); xlabel('strides'); title('Relearning (2nd visit)')
ylim([-0.4 0.1])
plot_with_stderr(0,slength.hsecond{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lsecond{blk},colors.all{2,1})
% xlim([0 200])
if exist('firstplat','var')
    for i = 1:2
        fp = eval(['firstplat.' grplist{i+3} '{1,6}']);
%         plot(fp,-0.2-i/20*ones(length(fp),1),'.','Color',colors.all{i,1},'MarkerSize',5);
        plot(mean(fp,'omitnan'),-0.1-i/20,'s','Color',colors.all{i,1},'MarkerSize',10);
        m = mean(fp,'omitnan');
        range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
        plot(range, -0.1-i/20*ones(2,1),'Color',colors.all{i,1});
    end
end
%%
for i = 695 %[695 696 697]
    figure(i); beautifyfig
    x0 = 10;
    y0 = 50;
    width = 1200;
    height = 800;
    set(gcf,'position',[x0,y0,width,height])
    for subi = 1:3
        if mod(subi,2) == 1
            subplot(3,1,subi); ylim([-0.3 0.1])
            plot([0 400],[0 0],'k:');
        else
            subplot(3,1,subi); ylim([-0.1 0.3])
            plot([0 400],[0 0],'k:');
        end
    end
end