% TM2_02_identifyHeelStrikes
global homepath subject F p
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:length(subject.blockname)
            disp([subject.list{subj} '(' num2str(subj) ') ' '| effcond: ' num2str(effcond) ' | blk: ' num2str(blk)]);
            if ~isempty(F(subj).R{effcond,blk}) && ~isempty(F(subj).L{effcond,blk})
                clear stepind stepvalid
%             [F(subj).hsR{effcond,blk},F(subj).hsL{effcond,blk},F(subj).toR{effcond,blk},F(subj).toL{effcond,blk}] =...
%                 getHeelStrikeForce(F(subj).R{effcond,blk},F(subj).L{effcond,blk},F(subj).time{effcond,blk});
%             % get indices
%              [F(subj).hsR_idx{effcond,blk},F(subj).hsL_idx{effcond,blk},F(subj).toR_idx{effcond,blk},F(subj).toL_idx{effcond,blk}] =...
%                 getHeelStrikeForce_index(F(subj).R{effcond,blk},F(subj).L{effcond,blk},F(subj).time{effcond,blk});

                [p(subj).hsR{effcond,blk},p(subj).hsL{effcond,blk},p(subj).toR{effcond,blk},p(subj).toL{effcond,blk}] =...
                    getHeelStrikeMarker(p(subj).Rtoe{effcond,blk},p(subj).Ltoe{effcond,blk},...
                    p(subj).Rheel{effcond,blk},p(subj).Lheel{effcond,blk},p(subj).trajtime{effcond,blk});
                % get indices
                [p(subj).hsR_idx{effcond,blk},p(subj).hsL_idx{effcond,blk},p(subj).toR_idx{effcond,blk},p(subj).toL_idx{effcond,blk}] =...
                    getHeelStrikeMarker_index(p(subj).Rtoe{effcond,blk},p(subj).Ltoe{effcond,blk},...
                    p(subj).Rheel{effcond,blk},p(subj).Lheel{effcond,blk},p(subj).trajtime{effcond,blk});
            %     [p(subj).hsR{effcond,blk},p(subj).hsL{effcond,blk},p(subj).toR{effcond,blk},p(subj).toL{effcond,blk}] =...
            %         getHeelStrikeAnkleMarker(p(subj).Rankle{effcond,blk},p(subj).Lankle{effcond,blk},...
            %         p(subj).trajtime{effcond,blk});

            % using a force function that requires a duration of foot on or
            % foot off after a switch between to qualify as a heel strike or
            % toe off
            [hsR0, hsL0, toR0, toL0, hsR_idx0, hsL_idx0, toR_idx0, toL_idx0] =...
                getHeelStrikeForce_RMM(F(subj).R{effcond,blk},F(subj).L{effcond,blk},F(subj).time{effcond,blk});
            
            
            %% Data cleaning lyfe
            % clean heel strikes and toe offs to get valid steps
            if ~isempty(hsR0) && ~isempty(hsL0) % make unreachable for none but brute force cleaning 
                cleanHSandTO
                
                % for trimming "first" steps and toe offs that precede heel
                % strikes
                hsR = hsR1; hsL = hsL1; toL = toL1; toR = toR1;
                hsR_idx = ihsR1; hsL_idx = ihsL1; toR_idx = itoR1; toL_idx = itoL1;
                
                % save the index specifics for valid steps
                % need to sort from 1st and 2nd to right and left and also
                % to fast and slow
                F(subj).definestep{effcond,blk} = stepind; % indices in hs1 to2 hs2 to1 order
                F(subj).validstep{effcond,blk} = stepvalid;
                F(subj).rightfirst(effcond,blk) = Rfirst; % if this is 1 then hs1 is right, if this is 0, then hs1 is left
                subject.datacleaned(subj,effcond,blk) = 1;
                if sum(stepvalid) == 0 % all steps were labeled invalid
                    subject.datacleaned(subj,effcond,blk) = 0;
                end

            else
                % none but brute force cleaning
                hsR = hsR0; hsL = hsL0; toL = toL0; toR = toR0;
                hsR_idx = hsR_idx0; hsL_idx = hsL_idx0; toR_idx = toR_idx0; toL_idx = toL_idx0;
                subject.datacleaned(subj,effcond,blk) = 0;
            end
            %% assign hs and to data end data cleaning
            F(subj).hsR{effcond,blk} = hsR;
            F(subj).hsL{effcond,blk} = hsL;
            F(subj).toR{effcond,blk} = toR;
            F(subj).toL{effcond,blk} = toL;
            F(subj).hsR_idx{effcond,blk} = hsR_idx;
            F(subj).hsL_idx{effcond,blk} = hsL_idx;
            F(subj).toR_idx{effcond,blk} = toR_idx;
            F(subj).toL_idx{effcond,blk} = toL_idx;        
            
            %% brute force cleaning
            % data cleaning that the algoritm can't get
            if strcmp(subject.list(subj),'BAN')
                if effcond == 1
                    if blk== 4
                        F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
                        F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
                    end
                end
            end
            end
        end
    end
end
clearvars -except subject F p colors
toc