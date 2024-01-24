% TM2_02b_identifyHeelStrikes
global homepath subject F p
tic
for subj = 1:subject.n
%     if subject.order(subj,:) ~= [0 0] % this means that the subject is NOT a control subject
        if subject.order(subj,1) == 0
            effuse = 3;
        else
            effuse = [1 2];
        end
        for effcond = effuse %1:3 %2 %length(subject.effortcondition)
            for blk = 1:length(subject.blockname)
%                 % clean up the time vectors (some odd oscillations at the
%                 % end)
%                 time0 = F(subj).time{effcond,blk};
%                 dtime = diff(time0);
%                 a = find(dtime < 0,1,'first');
%                 if ~isempty(a)
%                     time0(a:end) = nan(length(time0)-a+1,1);
%                 end
%                 time = time0;
%                 F(subj).time{effcond,blk} = time;
%                 % end clean up time
                disp([subject.list{subj} '(' num2str(subj) ') ' '| effcond: ' num2str(effcond) ' | blk: ' num2str(blk)]);
                if size(F(subj).R,1) >= effcond && size(F(subj).R,2) >= blk && ~isempty(F(subj).R{effcond,blk}) && ~isempty(F(subj).L{effcond,blk})
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
                        getHeelStrikeForce_RMM0(F(subj).R{effcond,blk},...
                        F(subj).L{effcond,blk},F(subj).time{effcond,blk},100);

                    trimFirstSpurious % produces hsR1 hsL1 ihsR1 ihsL1 ...
                            % toR1 toL1 itoR1 itoL1

    %                 hsR = hsR0; hsL = hsL0; toL = toL0; toR = toR0;
    %                 hsR_idx = hsR_idx0; hsL_idx = hsL_idx0; toR_idx = toR_idx0; toL_idx = toL_idx0;
                    hsR = hsR1; hsL = hsL1; toL = toL1; toR = toR1;
                    hsR_idx = ihsR1; hsL_idx = ihsL1; toR_idx = itoR1; toL_idx = itoL1;

                    F(subj).hsR{effcond,blk} = hsR;
                    F(subj).hsL{effcond,blk} = hsL;
                    F(subj).toR{effcond,blk} = toR;
                    F(subj).toL{effcond,blk} = toL;
                    F(subj).hsR_idx{effcond,blk} = hsR_idx;
                    F(subj).hsL_idx{effcond,blk} = hsL_idx;
                    F(subj).toR_idx{effcond,blk} = toR_idx;
                    F(subj).toL_idx{effcond,blk} = toL_idx;

                end
            end
        end
%     else % the subject is a control
%         effcond = 3;
%         for blk = 1:length(subject.blockname)
%             disp([subject.list{subj} '(' num2str(subj) ') ' '| effcond: ' num2str(effcond) ' | blk: ' num2str(blk)]);
%             if ~isempty(F(subj).R{effcond,blk}) && ~isempty(F(subj).L{effcond,blk})
%                 clear stepind stepvalid
%                 % using a force function that requires a duration of foot on or
%                 % foot off after a switch between to qualify as a heel strike or
%                 % toe off
%                 [hsR0, hsL0, toR0, toL0, hsR_idx0, hsL_idx0, toR_idx0, toL_idx0] =...
%                     getHeelStrikeForce_RMM0(F(subj).R{effcond,blk},...
%                     F(subj).L{effcond,blk},F(subj).time{effcond,blk},100);
% 
%                 trimFirstSpurious % produces hsR1 hsL1 ihsR1 ihsL1 ...
%                         % toR1 toL1 itoR1 itoL1
% 
% %                 hsR = hsR0; hsL = hsL0; toL = toL0; toR = toR0;
% %                 hsR_idx = hsR_idx0; hsL_idx = hsL_idx0; toR_idx = toR_idx0; toL_idx = toL_idx0;
%                 hsR = hsR1; hsL = hsL1; toL = toL1; toR = toR1;
%                 hsR_idx = ihsR1; hsL_idx = ihsL1; toR_idx = itoR1; toL_idx = itoL1;
% 
%                 F(subj).hsR{effcond,blk} = hsR;
%                 F(subj).hsL{effcond,blk} = hsL;
%                 F(subj).toR{effcond,blk} = toR;
%                 F(subj).toL{effcond,blk} = toL;
%                 F(subj).hsR_idx{effcond,blk} = hsR_idx;
%                 F(subj).hsL_idx{effcond,blk} = hsL_idx;
%                 F(subj).toR_idx{effcond,blk} = toR_idx;
%                 F(subj).toL_idx{effcond,blk} = toL_idx;
%             end
%         end
%     end
end
clearvars -except subject F p colors IK ID
toc