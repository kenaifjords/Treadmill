% TM2_02b_identifyHeelStrikes
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
                    getHeelStrikeForce_RMM0(F(subj).R{effcond,blk},F(subj).L{effcond,blk},F(subj).time{effcond,blk},100);
            
            end
        end
    end
end
clearvars -except subject F p colors
toc