%%% THE SLA PLOT
figure(2024); hold on; blk = 6;
ylabel('asymmetry'); xlabel('strides'); title('Learning (1st visit)')
% ylim([-0.6 0.0])
plot_with_stderr(0,slength.hfirst{blk},colors.all{1,1}) %% these need to be trimmed to shortest ###
plot_with_stderr(0,slength.lfirst{blk},colors.all{2,1})
plot_with_stderr(0,slength.control{blk},colors.all{3,1})
% xlim([0 200])
blk = 4;
plot_with_stderr_linetype(0,slength.hfirst{blk},colors.all{1,1},':') %% these need to be trimmed to shortest ###
plot_with_stderr_linetype(0,slength.lfirst{blk},colors.all{2,1},':')
plot_with_stderr_linetype(0,slength.control{blk},colors.all{3,1},':')

j = 1; markerlist = {'s','d'};
for blk = [4 6]
    if exist('firstplat','var')
        for i = 1:3
            fp = eval(['firstplat.' grplist{i} '{1,' num2str(blk) '}']);
    %         plot(fp,-0.2-i/20*ones(length(fp),1),'.','Color',colors.all{i,1},'MarkerSize',5);
            plot(mean(fp,'omitnan'),-0.3-i/20,markerlist{j},'Color',colors.all{i,1},'MarkerSize',10);
            m = mean(fp,'omitnan');
            range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
            plot(range, -0.3-i/20*ones(2,1),'Color',colors.all{i,1}); 
        end
    end
    j = j + 1;
end

plot([0 400],[0 0],'k:')

if exist('firstplat','var')
    for blk = [4 6]
        for i = 1:5
            k = mod(i,3);
            if k ==0
                k = 3;
            end
            fp = eval(['firstplat.' grplist{i} '{1,' num2str(blk) '}']);
    %         plot(fp,-0.2-i/20*ones(length(fp),1),'.','Color',colors.all{i,1},'MarkerSize',5);
            if blk == 4 || blk == 6
                plot(mean(fp,'omitnan'),0.1+i/20,'s','Color',colors.all{k,1},'MarkerSize',10,'HandleVisibility','off');
                m = mean(fp,'omitnan');
                range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
                plot(range, +0.1+i/20*ones(2,1),'Color',colors.all{k,1},'HandleVisibility','off');
            else
                plot(mean(fp,'omitnan'),-0.1-i/20,'s','Color',colors.all{k,1},'MarkerSize',10,'HandleVisibility','off');
                m = mean(fp,'omitnan');
                range = m + [-std(fp,[],'omitnan') std(fp,[],'omitnan')]./sqrt(length(fp));
                plot(range, -0.1-i/20*ones(2,1),'Color',colors.all{k,1},'HandleVisibility','off');
            end
        end
    end
end


ylim([-0.6 0.1])
beautifyfig
x0 = 10;
y0 = 50;
width = 1200;
height = 500;
set(gcf,'position',[x0,y0,width,height])