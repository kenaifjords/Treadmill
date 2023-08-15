%TM2_Check_FootVelocityAndHeelStrikes
close all
global F p
endxlim = 25
for subj = 13 %10 % 1:subject.n
    mark = ['none' 'none'];
    for effcond = 1 %1:2 %1:length(subject.effortcondition)
        for blk =  2:subject.nblk % 1:subject.nblk
            % force profiles
            fzr = F(subj).R{effcond,blk}(:,3);
            fzl = F(subj).L{effcond,blk}(:,3);
            % heel positions
            heelR = p(subj).Rheel{effcond,blk}; % Rankle{effcond,blk}(:,3);
            heelL = p(subj).Lheel{effcond,blk}; %p(subj).
            % heel height thresholds
            heelRrange = max(heelR(:,3)) - min(heelR(:,3)); % mean(heelR); % max(heelR) - min(heelR);
            heelLrange = max(heelL(:,3)) - min(heelL(:,3)); % mean(heelL); % max(heelL) - min(heelL);
            heelRthresh = 0.3*heelRrange;
            heelLthresh = 0.3*heelLrange;
            % toe positions
            toeR = p(subj).Rtoe{effcond,blk};
            toeL = p(subj).Ltoe{effcond,blk};
            % find foot center
            footR = (heelR + toeR)./2;
            footL = (heelL + toeL)./2;
            % foot center vertical position
            footRz = footR(:,3);
            footLz = footL(:,3);
            % foot center position, velocity, acceleration (output is 
            % filtered original, first derivative, second derivative)
            Rz = diff23f5(footRz,1/100,10);
            Lz = diff23f5(footLz,1/100,10);
            % vertical velocity
            vRz = Rz(:,2);
            vLz = Lz(:,2);
                               
            % identify local maxima on a step to step time line - this is
            % characteristic of toe off
            [~,iR_toeoff] = findpeaks(vRz,'MinPeakDistance',50,'MinPeakHeight',200);
            
            % identify local minima on a shorter time interval, this
            % generates a set of potential heel strikes
            [~,setR_hs] = findpeaks(-vRz,'MinPeakDistance',10,'MinPeakHeight',200);
            
            % use a threshold on the heel height to select the proper heel
            % strike (i could also implement a force-based constraint here)
            insetR = find(heelR(setR_hs,3) < heelRthresh);
            iR_heelstrike = setR_hs(insetR);
            
%             % trying a force-based constraint (BOTH METHODS WORK)
%             iR_heelstrike = [];
%             for i = 1:length(setR_hs)
%                 if mean(fzr(setR_hs(i):setR_hs(i)+15)) > 200
%                     iR_heelstrike = [iR_heelstrike setR_hs(i)];
%                 end
%             end

            % find the force threshold heel strike using the vertical foot
            % velocity heel strike as a starting point
            forcethresh = 100; % N
            for i = 1:length(iR_heelstrike)
                % if greater than the threshold force, count backward to
                % idenify the last point where the force was less than the
                % threshold
                threshdiff = fzr(iR_heelstrike(i)) - forcethresh;
                if threshdiff > 0 && threshdiff > forcethresh; % fzr(iR_heelstrike(i)) > forcethresh
                    j = iR_heelstrike(i);
                    while fzr(j) > forcethresh
                        j = j-1;
                    end
                    rhs(i) = j;
                elseif threshdiff < 0 && abs(threshdiff) > forcethresh % fzr(iR_heelstrike(i) < forcethresh
                    k = iR_heelstrike(i);
                    while fzr(k) < forcethresh
                        k = k+1;
                    end
                    rhs(i) = k;
                else
                    rhs(i) = iR_heelstrike(i);
                end
            end
            
            
            figure(); plot(vRz); hold on;
            plot(iR_toeoff,vRz(iR_toeoff),'*')
            plot(setR_hs,vRz(setR_hs),'d')
            
            % check plot of foot velocity against force
            figure(); hold on;
            plot(fzr,'g')
%             plot(fzl,'r')
            plot(vRz/3 + 1000,'g--')
%             plot(vLz/3 + 1000,'r--')
            plot(setR_hs,vRz(setR_hs)/3 + 1000,'d')
            plot(setR_hs,fzr(setR_hs),'s')
            plot(iR_heelstrike, fzr(iR_heelstrike),'*');
            plot(rhs,fzr(rhs),'o')
            
            figure(); hold on;
            plot(heelR(:,3))
            plot(setR_hs,heelR(setR_hs,3),'o')
            plot([0 setR_hs(end)],[heelRthresh heelRthresh])
            plot(iR_heelstrike,heelR(iR_heelstrike,3),'d')
            
            
            fzr = F(subj).R{effcond,blk}(:,3);
            fzl = F(subj).L{effcond,blk}(:,3);
%             hsrval = F(subj).hsRvalid{effcond,blk};
%             hslval = F(subj).hsLvalid{effcond,blk};
            time = F(subj).time{effcond,blk};
            
            hsr = F(subj).hsR{effcond,blk};
%             hsr(hsrval == 0) = NaN;
            hsl = F(subj).hsL{effcond,blk};
%             hsl(hslval == 0) = NaN;
            phsr = p(subj).hsR{effcond,blk};
            phsl = p(subj).hsL{effcond,blk};
            
            tor = F(subj).toR{effcond,blk};
            tol = F(subj).toL{effcond,blk};
            pR = p(subj).Rheel{effcond,blk}(:,3); % Rankle{effcond,blk}(:,3);
            pL = p(subj).Lheel{effcond,blk}(:,3); % Lankle{effcond,blk}(:,3);
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
            plot(phsr,0,'gs');
            plot(phsl,0,'rs');
            plot(tor,0,'go');
            plot(tol,0,'ro');
            plot(time,pR,'b');
            plot(trajtime,pL,'m');
            plot([0, time(end)], [200, 200],'k:')
            for i = 1:length(hsr)
                text(hsr(i),-20,num2str(i))
            end
            for i = 1:length(hsl)
                text(hsl(i),-20,num2str(i),'color','r')
            end
%             xlim([0,endxlim])
            hold off;
        end
    end
end


            