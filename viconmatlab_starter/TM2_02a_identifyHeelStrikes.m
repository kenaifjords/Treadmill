%TM2_02a_identifyHeelStrikes
global subject F p
tic
for subj = 1:3 % subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            
            disp([subject.list{subj} '(' num2str(subj) ') ' '| effcond: '...
                num2str(effcond) ' | blk: ' num2str(blk)]);
            
            % retrieve needed force and marker position data
            fR = F(subj).R{effcond,blk};
            fL = F(subj).L{effcond,blk};
            ftime = F(subj).time{effcond,blk};
            heelR = p(subj).Rheel{effcond,blk};
            heelL = p(subj).Lheel{effcond,blk};
            toeR = p(subj).Rtoe{effcond,blk};
            toeL = p(subj).Ltoe{effcond,blk};
            ankleR = p(subj).Rankle{effcond,blk};
            ankleL = p(subj).Lankle{effcond,blk};
            
            % uncomment if needed for a subject where there is a missing toe or heel marker    
            if strcmp(subject.list(subj),'MLL') && (blk == 2 || blk == 4) % ~isempty(fR) && ~isempty(fL) && ~isempty(ankleR) && ~isempty(ankleL)
                % use ankle markers because heel marker fell off
                [ihsR0,ihsL0,itoR0,itoL0] =...
                    getHeelStrike_AnkleVelocityAndForce(fR,fL,ankleR,ankleL);
                % get heel strike times
                hsR0 = ftime(ihsR0);
                hsL0 = ftime(ihsL0);
                toR0 = ftime(itoR0);
                toL0 = ftime(itoL0);
            elseif strcmp(subject.list(subj),'FUM') && blk == 1
                % use ankle markers because heel marker fell off
                [ihsR0,ihsL0,itoR0,itoL0] =...
                    getHeelStrike_AnkleVelocityAndForce(fR,fL,ankleR,ankleL);
                % get heel strike times
                hsR0 = ftime(ihsR0);
                hsL0 = ftime(ihsL0);
                toR0 = ftime(itoR0);
                toL0 = ftime(itoL0);
                
            elseif ~isempty(fR) && ~isempty(fL) && ~isempty(heelR) &&...
                    ~isempty(heelL) && ~isempty(toeR) && ~isempty(toeL)
                % uses velocity of the foot center to identify toe off and
                % heel strike, heel strikes are adjusted according to a 100N
                % force threshold AFTER identification using the foot
                % velocity peaks and troughs
                [ihsR0,ihsL0,itoR0,itoL0] =...
                    getHeelStrike_FootVelocityAndForce(fR,fL,heelR,heelL,toeR,toeL);
                % get heel strike times
                hsR0 = ftime(ihsR0);
                hsL0 = ftime(ihsL0);
                toR0 = ftime(itoR0);
                toL0 = ftime(itoL0);
            end
            
            % save the outputs into the data structure
            F(subj).hsR{effcond,blk} = hsR0;
            F(subj).hsL{effcond,blk} = hsL0;
            F(subj).toR{effcond,blk} = toR0;
            F(subj).toL{effcond,blk} = toL0;
            F(subj).hsR_idx{effcond,blk} = ihsR0;
            F(subj).hsL_idx{effcond,blk} = ihsL0;
            F(subj).toR_idx{effcond,blk} = itoR0;
            F(subj).toL_idx{effcond,blk} = itoL0;
            
        end %blk
    end %effcond
end %subj
clearvars -except subject F p colors
toc
