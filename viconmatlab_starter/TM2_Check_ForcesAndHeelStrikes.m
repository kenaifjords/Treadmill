%TM2_Check_ForcesAndHeelStrikes
close all
global F p
endxlim = 25
for subj = 13 %10 % 1:subject.n
    mark = ['none' 'none'];
    for effcond = 2 %1:2 %1:length(subject.effortcondition)
        for blk =  2:subject.nblk % 1:subject.nblk
            fzr = F(subj).R{effcond,blk}(:,3);
            fzl = F(subj).L{effcond,blk}(:,3);
            hsrval = F(subj).hsRvalid{effcond,blk};
            hslval = F(subj).hsLvalid{effcond,blk};
            time = F(subj).time{effcond,blk};
            
            hsr = F(subj).hsR{effcond,blk};
%             hsr(hsrval == 0) = NaN;
            hsl = F(subj).hsL{effcond,blk};
%             hsl(hslval == 0) = NaN;
            
            tor = F(subj).toR{effcond,blk};
            tol = F(subj).toL{effcond,blk};
            pR = p(subj).Rankle{effcond,blk}(:,2);
            pL = p(subj).Lankle{effcond,blk}(:,2);
            trajtime = p(subj).trajtime{effcond,blk};
            
            timeidxlength = [length(fzr) length(fzl); length(pR) length(pL);...
                length(time) length(trajtime)]
            maxidx = min(timeidxlength);
            
            fzr = fzr(1:maxidx); % F(subj).R{effcond,blk}(:,3);
            fzl = fzl(1:maxidx); % F(subj).L{effcond,blk}(:,3);
            time = time(1:maxidx); % F(subj).time{effcond,blk};
            pR = pR(1:maxidx); % p(subj).Rankle{effcond,blk}(:,2);
            pL = pL(1:maxidx); % p(subj).Lankle{effcond,blk}(:,2);
            trajtime = trajtime(1:maxidx); % p(subj).trajtime{effcond,blk};
            
            fig = figure(blk);hold on; % fig.Name = 'Forces and Heel Strikes'
            plot(time,fzr,'Color',[0 1 0]); %,'Marker',mark(effcond));
            plot(time,fzl,'Color',[1 0 0]); %,'Marker',mark(effcond));
            if ~isempty(hsr) & ~isempty(hsl)
            plot(hsr,0,'gx');
            plot(hsl,0,'rx');
            end
            plot(tor,0,'go');
            plot(tol,0,'ro');
            plot(time,pR,'b');
            plot(trajtime,pL,'m');
            plot([0, time(end)], [100, 100],'k:')
            for i = 1:length(hsr)
                text(hsr(i),-20,num2str(i))
            end
            for i = 1:length(hsl)
                text(hsl(i),-20,num2str(i),'color','r')
            end
            xlim([0,endxlim])
            hold off;
        end
    end
end


            