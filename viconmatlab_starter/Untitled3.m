% TM2_02_identifyHeelStrikes_ with Filtering
global homepath subject F p
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:length(subject.blockname)
            [hsR,hsL,toR,toL] =...
                getHeelStrikeForce(F{subj}.R{effcond,blk},F{subj}.L{effcond,blk},F{subj}.time{effcond,blk});
            % get indices
             [ihsR,ihsL,itoR,itoL] =...
                getHeelStrikeForce_index(F{subj}.R{effcond,blk},F{subj}.L{effcond,blk},F{subj}.time{effcond,blk});

            [phsR, phsL, ptoR, ptoL] =...
                getHeelStrikeMarker(p{subj}.Rtoe{effcond,blk},p{subj}.Ltoe{effcond,blk},...
                p{subj}.Rheel{effcond,blk},p{subj}.Lheel{effcond,blk},p{subj}.trajtime{effcond,blk});
            % get indices
            [iphsR, iphsL, iptoR, iptoL] =...
                getHeelStrikeMarker_index(p{subj}.Rtoe{effcond,blk},p{subj}.Ltoe{effcond,blk},...
                p{subj}.Rheel{effcond,blk},p{subj}.Lheel{effcond,blk},p{subj}.trajtime{effcond,blk});
        %     [p{subj}.hsR{effcond,blk},p{subj}.hsL{effcond,blk},p{subj}.toR{effcond,blk},p{subj}.toL{effcond,blk}] =...
        %         getHeelStrikeAnkleMarker(p{subj}.Rankle{effcond,blk},p{subj}.Lankle{effcond,blk},...
        %         p{subj}.trajtime{effcond,blk});


            %% filtering
            % looks for heel strikes that appear on both plates at the same time
            % (artifact of star
            for i = 1:min(length(hsL),length(hsR))
                    if abs(hsL(i)) == abs(hsR(i))
                        hsL(i) = NaN; hsR(i) = NaN;
                        hsL = hsL(~isnan(hsL));
                        hsR = hsR(~isnan(hsR));
                    end
            end
            % find average STRIDE length on left and right - average added to keep
            % the veectors the same length
            strdTimeR0 = hsR(2:end) - hsR(1:end - 1);
            strdTimeR = [strdTimeR0 mean(strdTimeR0)];
            strdTimeL0 = hsL(2:end) - hsL(1:end - 1);
            strdTimeL = [strdTimeL0 mean(strdTimeL0)];
            % look for double strikes    
            for i = 1:length(hsR)- 1 
                aa{i,1} = a(find(hsL > hsR(i) && hsL < hsR(i+1))); % double strike on left
            end
        end
    end
end
%         if length(a) > 1 % double strike on left
%            if length(a) >= 2
%                length_a = length(a);
%                if length_a > 2
%                    fprintf(['multiple heelstrikes flagged: subj: ' ...
%                        num2str(subj) ', effcond: ' num2str(effcond)...
%                        ', blk: ' num2str(blk) 'hs times list: ' num2str(a)]);
%                end
%                a = [min(a),max(a)];
%            end
%            hsR(i) = mean(a);
%            hsR = [hsR(1:i) hsR(i+2:end)];
%         end
%     end
% %            for j = 1:2
% %                % find time from prior heel strike to first of double and
% %                % find time from later heel strike to second of double
% %                lower = a(1) - hsR(i); upper = hsR(i+1) - a(2);
% %                % set heel strike as
% %                difmeanstridelower = abs(mean(strdTimeR)/2 - lower);
% %                difmeanstrideupper = abs(mean(strdTimeR)/2 - upper);
% %                if difmeanstridelower < difmeanstrideupper
% %                    hsR  = hsR
%         
%     for i = 1:length(hsL)- 1 
%             a(find(hsR > hsL(i) && hsR < hsL(i+1))); % double strike on left
%             if length(a) > 1 % double strike on left
%                if length(a) >= 2
%                    length_a = length(a);
%                    if length_a > 2
%                        fprintf(['multiple heelstrikes flagged: subj: ' ...
%                            num2str(subj) ', effcond: ' num2str(effcond)...
%                            ', blk: ' num2str(blk) 'hs times list: ' num2str(a)]);
%                    end
%                    a = [min(a),max(a)];
%                end
%                hsL(i) = mean(a);
%                hsL = [hsL(1:i) hsL(i+2:end)];
%             end
%         end
%              
%         end
%         
%     
%     %% final definitiions
%     % save in proper structure
%     F{subj}.hsR{effcond,blk} = hsR;
%     F{subj}.hsL{effcond,blk} = hsL;
%     F{subj}.toR{effcond,blk} = toR;
%     F{subj}.toL{effcond,blk} = toL;
%     
%     F{subj}.hsR_idx{effcond,blk} = ihsR;
%     F{subj}.hsL_idx{effcond,blk} = ihsL; 
%     F{subj}.toR_idx{effcond,blk} = itoR;
%     F{subj}.toL_idx{effcond,blk} = itoL;
%     
%     p{subj}.hsR{effcond,blk} = phsR;
%     p{subj}.hsL{effcond,blk} = phsL;
%     p{subj}.toR{effcond,blk} = ptoR;
%     p{subj}.toL{effcond,blk} = ptoL;
%     
%     p{subj}.hsR_idx{effcond,blk} = iphsR;
%     p{subj}.hsL_idx{effcond,blk} = iphsL;
%     p{subj}.toR_idx{effcond,blk} = iptoR;
%     p{subj}.toL_idx{effcond,blk} = iptoL;
%         end
%     end
% end
% toc