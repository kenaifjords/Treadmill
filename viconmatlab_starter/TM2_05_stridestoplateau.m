% TM2_05_stridestoplateau
% based on Malone and Bastian 2010
close all
fplat = NaN(subject.n,3,subject.nblk);
for subj = 1:subject.n
    for effcond = 1:3
        if effcond > size(F(subj).R,1)
            fplat(subj,effcond,blk) = NaN;
            break
        end
        for blk = 1:subject.nblk
            clear platrng frng
            if blk > size(F(subj).R,2)
                break
            end
            if ismember(blk,[1 2 3 7])
                fplat(subj,effcond,blk) = NaN;
            else
                clear asymm smoothasym
                asymm = asym(subj).steplength{effcond,blk};
                if ~isempty(asymm)
%                     smasym = smooth(asymm);
                    smasym = smoothdata(asymm,'movmean',3,'omitnan');
                    platrng(:) = nanmean(smasym(end-30:end)) +...
                        [-nanstd(smasym(end-30:end)) nanstd(smasym(end-30:end))];
                    binaryplatL = (smasym > platrng(1));
                    binaryplatU = (smasym < platrng(2));
                    binaryplat = binaryplatL .* binaryplatU;
                    % check for the first 5 trials in the range
                    for i = 1:length(binaryplat)-25
                        inrng(i) = nanmean(binaryplat(i):binaryplat(i+5));
                    end
                    frng = find(inrng == 1,1,'first'); 
                    if isempty(frng)
                        disp(['No plateau identified for subject '...
                            num2str(subj) '; effcond ' num2str(effcond) ...
                            '; blk ' num2str(blk) ';'])
                        fplat(subj,effcond,blk) = NaN;
                    else
                        fplat(subj,effcond,blk) = frng;
                    end
                    
%                     figure(subj); subplot(3,1,effcond); hold on;
%                     plot(asymm,'k:','HandleVisibility','off');
%                     plot(smasym,'DisplayName',['e:' num2str(effcond) ' blk: ' num2str(blk)]);
%                     plot(frng,smasym(frng),'ro','HandleVisibility','off')
%                     legend
                else
                    fplat(subj,effcond,blk) = NaN;
                end
                
            end  
        end
    end
end
%% sort
fplat(fplat > 300) = NaN;
firstplat = sortbyEffortVisitorder_digitout(fplat);
%% analyze and plot
grp = {'hfirst','lfirst','control','hsecond','lsecond'};

% compare parameters in the first visit
disp('FIRST VISIT (one-way anova: high, low, control)')
list_blk = [4 5 ]; 

for blk = [4 5 6] %list_blk
     disp(['BLOCK ' num2str(blk)])
    datin = [firstplat.hfirst{1,blk}' firstplat.lfirst{1,blk}'...
        firstplat.control{1,blk}']; 
    p0 = anova1(datin,[],'off');
    for i = 1:3
        disp(['first stride to plateau: ' grp{i} ' '...
            num2str(nanmean(datin(:,i))) ' +/-' ...
            num2str(nanstd(datin(:,i))./sqrt(length(datin(:,i))))]);
    end
    disp(['between groups, p = ' num2str(p0)])
    
    datin = [firstplat.hfirst{1,blk}' firstplat.lfirst{1,blk}'];
    p0 = anova1(datin,[],'off');
    [~,p0] = ttest2(datin(:,1),datin(:,2));
    disp(['compare low and high, p = ' num2str(p0)]);
    
    % high v control
    datin = [firstplat.hfirst{1,blk}' firstplat.control{1,blk}'];
    p0 = anova1(datin,[],'off');
    [~,p0] = ttest2(datin(:,1),datin(:,2));
    disp(['compare high and control, p = ' num2str(p0)]);
    % low v control
    datin = [firstplat.lfirst{1,blk}' firstplat.control{1,blk}'];
    p0 = anova1(datin,[],'off');
    [~,p0] = ttest2(datin(:,1),datin(:,2));
    disp(['compare low and control, p = ' num2str(p0)]);
end
%% visit 2
disp('VISIT 2; Learning')
for blk = [4 5 6] %list_blk
    disp(['BLOCK ' num2str(blk)])
    datin = [firstplat.hsecond{1,blk}' [firstplat.lsecond{1,blk}'; NaN]]; 
    p0 = anova1(datin,[],'off');
    for i = 1:2
        disp(['first stride to plateau: ' grp{i+3} ' '...
            num2str(mean(datin(:,i),'omitnan')) ' +/-' ...
            num2str(std(datin(:,i),[],'omitnan')./sqrt(length(datin(:,i))))]);
    end
    disp(['between high and low groups on second visit, p = ' num2str(p0)])
end
%% BARPLOT
fp = NaN(max(subject.ncond),5);
for blk = [4 5 6]
    for i = 1:length(grp)
        infp = eval(['firstplat.' grp{i} '{1,' num2str(blk) '}']);
        fp(1:length(infp),i) = infp;
    end
    figure(200 + blk); hold on;
    titlein = ['First stride to plateau, block:' num2str(blk)];
    getBarPlot_groupsorted(fp,titlein,[0 200]); title(titlein)
    if blk == 4
        fp0 = fp;
    else
        fprl = fp;
    end
end
%% compare learn and relearn
fp = NaN(max(subject.ncond),5);
for i = 1:length(grp)
    infp = eval(['firstplat.' grp{i} '{1,6} - firstplat.' grp{i} '{1,4}']);
    fp(1:length(infp),i) = infp;
end
figure(97 + blk); hold on;
titlein = ['difference number of strides to plateau, relearning - learning'];
getBarPlot_groupsorted(fp,titlein,[-200 200]); title(titlein)
%% compare learn between visits
fp = NaN(max(subject.ncond),5);
for i = 1:2
    infp = fp0(:,i) - fp0(:,i+3);
    fp(1:length(infp),i+3) = infp;
end
figure(190 + blk); subplot(211); hold on;
titlein = ['First stride to plateau visit 1 - visit 2, block: 4'];
getBarPlot_groupsorted(fp,titlein,[0 200]); title(titlein)

fp = NaN(max(subject.ncond),5);
for i = 1:2
    infp = fprl(:,i) - fprl(:,i+3);
    fp(1:length(infp),i+3) = infp;
end
figure(190 + blk);subplot(212); hold on;
titlein = ['First stride to plateau visit 1 - visit 2, block: 6'];
getBarPlot_groupsorted(fp,titlein,[0 200]); title(titlein)