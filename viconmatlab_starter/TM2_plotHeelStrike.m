% TM2_plotHeelStrikes
global homepath subject F p
yesplot = 1;
tic
%%
for subj = 1:subject.n
    for blk = 1:length(subject.blockname)
        % get limb angle
        [p{subj}.limbangleR{blk},p{subj}.limbangleL{blk}] = getLimbAngle(p{subj}.Rankle{blk},...
            p{subj}.Lankle{blk},p{subj}.Rpsis{blk},p{subj}.Lpsis{blk});
        figure(subj);
        subplot(311)
        hold on;
        plot(F{subj}.time{blk},F{subj}.R{blk}(:,3),'r')
        plot(F{subj}.time{blk},F{subj}.L{blk}(:,3),'b')
        plot(F{subj}.hsR{blk},0,'r*');
        plot(F{subj}.hsL{blk},0,'b*');
        plot(F{subj}.toR{blk},0,'ro');
        plot(F{subj}.toL{blk},0,'bo');
        plot(p{subj}.hsR{blk},0,'m*');
        plot(p{subj}.hsL{blk},0,'g*');
        plot(p{subj}.toR{blk},0,'mo');
        plot(p{subj}.toL{blk},0,'go');
        hold off;
        subplot(312)
        hold on;
        minRankle = min(p{subj}.Rankle{blk}(:,2));
        minLankle = min(p{subj}.Lankle{blk}(:,2));
        plot(p{subj}.trajtime{blk},p{subj}.Rankle{blk}(:,2),'r')
        plot(p{subj}.trajtime{blk},p{subj}.Lankle{blk}(:,2),'b')
%         plot(p{subj}.trajtime{blk},p{subj}.Rheel{blk}(:,2),'r--')
%         plot(p{subj}.trajtime{blk},p{subj}.Lheel{blk}(:,2),'b--')
        plot(p{subj}.hsR{blk},minRankle,'m*');
        plot(p{subj}.hsL{blk},minLankle,'g*');
        plot(p{subj}.toR{blk},minRankle,'mo');
        plot(p{subj}.toL{blk},minLankle,'go');
        hold off;
        subplot(313);
        hold on;
        plot(p{subj}.trajtime{blk},p{subj}.limbangleR{blk},'r')
        plot(p{subj}.trajtime{blk},p{subj}.limbangleL{blk},'b')
    end
end
toc