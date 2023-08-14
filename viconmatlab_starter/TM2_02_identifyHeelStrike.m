% TM2_02_identifyHeelStrikes
global homepath subject F p
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:length(subject.blockname)
            disp([subject.list{subj} '(' num2str(subj) ') ' '| effcond: ' num2str(effcond) ' | blk: ' num2str(blk)]);
            if ~isempty(F(subj).R{effcond,blk}) && ~isempty(F(subj).L{effcond,blk})
                clear stepind stepvalid
                [p(subj).hsR{effcond,blk},p(subj).hsL{effcond,blk},p(subj).toR{effcond,blk},p(subj).toL{effcond,blk}] =...
                    getHeelStrikeMarker(p(subj).Rtoe{effcond,blk},p(subj).Ltoe{effcond,blk},...
                    p(subj).Rheel{effcond,blk},p(subj).Lheel{effcond,blk},p(subj).trajtime{effcond,blk});
                % get indices
                [p(subj).hsR_idx{effcond,blk},p(subj).hsL_idx{effcond,blk},p(subj).toR_idx{effcond,blk},p(subj).toL_idx{effcond,blk}] =...
                    getHeelStrikeMarker_index(p(subj).Rtoe{effcond,blk},p(subj).Ltoe{effcond,blk},...
                    p(subj).Rheel{effcond,blk},p(subj).Lheel{effcond,blk},p(subj).trajtime{effcond,blk});
                % using a force function that requires a duration of foot on or
                % foot off after a switch between to qualify as a heel strike or
                % toe off
                [hsR0, hsL0, toR0, toL0, hsR_idx0, hsL_idx0, toR_idx0, toL_idx0] =...
                    getHeelStrikeForce_RMM(F(subj).R{effcond,blk},F(subj).L{effcond,blk},F(subj).time{effcond,blk});
                
                % WITH HEEL MARKER CHECK
                [hsR0, hsL0, toR0, toL0, hsR_idx0, hsL_idx0, toR_idx0, toL_idx0] =...
                    getHeelStrikeForce_checkheel(F(subj).R{effcond,blk},F(subj).L{effcond,blk},...
                    F(subj).time{effcond,blk},p(subj).Rheel{effcond,blk},p(subj).Lheel{effcond,blk});
            
                %% Data cleaning lyfe
                % clean heel strikes and toe offs to get valid steps
                if ~isempty(hsR0) && ~isempty(hsL0) % make unreachable for none but brute force cleaning 
%                     cleanHSandTO
                    trimFirstSpurious % produces hsR1 hsL1 ihsR1 ihsL1 ...
                        % toR1 toL1 itoR1 itoL1
                        if 0
                            % for trimming "first" steps and toe offs that precede heel
                            % strikes only
                            hsR = hsR1; hsL = hsL1; toL = toL1; toR = toR1;
                            hsR_idx = ihsR1; hsL_idx = ihsL1; toR_idx = itoR1; toL_idx = itoL1;
                        end
                    bruteForceCleaning_inLOOP % trims hsR1 hsL1 ihsR1 ...
                        % ihsR1 (no changes to toe off data)
                    
                    %% identify first heelstrike
                    % is the first step with the right foot or the left foot? on a perhaps
                    % unimportant note, is the first step on the fast leg or the slow leg?
                    Rfirst = 0;
                    if hsR1(1) < hsL1(1) % first heelstrike is right
                        hs1 = hsR1; hs2 = hsL1;
                        to1 = toR1; to2 = toL1;
                        Rfirst = 1;
                    elseif hsL1(1) < hsR1(1) % first heelstrike is left
                        hs1 = hsL1; hs2 = hsR1;
                        to1 = toL1; to2 = toR1;
                    end
                    
                    findvalidHS_v3 % this finds valid heel strikes after 
                    % cleaning. script makes no changes to the heelstrike 
                    % vectors, just saves the specific indices of valid ones
                        
                    % assign function output to save values
                    hsR = hsR1; hsL = hsL1;
                    hsR_idx = ihsR1; hsL_idx = ihsL1;
                    toL = toL1; toR = toR1;
                    toL_idx = itoL1; toR_idx = itoR1;
                    
                    % save the index specifics for valid steps
                    % need to sort from 1st and 2nd to right and left and also
                    % to fast and slow
                    F(subj).rightfirst(effcond,blk) = Rfirst; % if this is 1 then hs1 is right, if this is 0, then hs1 is left

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
                
                F(subj).hsRvalid{effcond,blk} = hsRvalid;
                F(subj).hsLvalid{effcond,blk} = hsLvalid;
            end
        end
    end
end
clearvars -except subject F p colors
toc



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                 if Rfirst
% %                     stepvalidR = stepvalid1;
% %                     stepeventR = stepind1;
% %                     stepvalidL = stepvalid2;
% %                     stepeventL = stepind2;
% %                     if subject.fastleg == 1
% %                         stepvalidFast = stepvalidR;
% %                         stepeventFast = stepeventR;
% %                         stepvalidSlow = stepvalidL;
% %                         stepeventSlow = stepeventL;
% %                     else
% %                         
% %                 else
% %                     stepvalidL = stepvalid1;
% %                     stepeventL = stepind1;
% %                     stepvalidR = stepvalid2;
% %                     stepeventR = stepind2;
% %                 end
%                     
%                     
%                     
%                     
%                     
%                     if subject.fastleg == 1 % step with fast foot first
%                         fastfirst = 1;
%                     else % step with right foot first, but left is fast
%                         remove1st_r(subj,effcond,blk) = 1;
%                     end
%                 else % step with left foot first
%                     if subject.fastleg == 2 % step with fast foot first
%                     else % step with left foot first and right is fast
%                         remove1st_l(subj,effcond,blk) = 1;
%                     end
%                 end
%               
%                 F(subj).definestep{effcond,blk} = stepind; % indices in hs1 to2 hs2 to1 order
%                 F(subj).validstep{effcond,blk} = stepvalid;
%                 subject.datacleaned(subj,effcond,blk) = 1;
%                 if sum(stepvalid) == 0 % all steps were labeled invalid
%                     subject.datacleaned(subj,effcond,blk) = 0;
%                 end