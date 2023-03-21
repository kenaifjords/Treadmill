%% TM2_04_otherMetrics
% step width
% swing speed
% trailing limb angle
global homepath subject F p colors asym
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            % Calculate steplength, steptime, and steplength asymmetry
             i=1;
             clear stepwidth1 stepwidth2 stepwidth1all stepwidth2all
             i_hsL = F{subj}.hsL_idx{effcond, blk};%(2:end);
             i_hsR = F{subj}.hsR_idx{effcond, blk};%(2:end);

            % index changed from 2 to 1 to get the x position of the ankle
            % markers
             stepwidth2all = p{subj}.Lankle{effcond, blk}(i_hsL,1) - ...
                 p{subj}.Rankle{effcond, blk}(i_hsL,1);
             stepwidth1all = p{subj}.Rankle{effcond, blk}(i_hsR,1) - ...
                 p{subj}.Lankle{effcond, blk}(i_hsR,1);

            %%
            fastleg1st = NaN;
            while i < min([length(F{subj}.hsR{effcond, blk}) length(F{subj}.hsL{effcond, blk})])    
                %step time on belt 2 (left)
                fir = 1;
                while F{subj}.hsR{effcond, blk}(fir) == F{subj}.hsL{effcond, blk}(fir)
                    fir = fir + 1;
                    if fir > 3
                        fir
                        disp('check heel strikes, left and right seem to be the same')
                    end
                end
                if F{subj}.hsR{effcond, blk}(fir) < F{subj}.hsL{effcond, blk}(fir) % fp1 strikes first (right)
                    if subject.fastleg(subj,effcond) == 1
                        fastleg1st = 1;
                    end
                elseif F{subj}.hsR{effcond, blk}(fir) > F{subj}.hsL{effcond, blk}(fir) % fp2 strikes first so take its second heel strike
                    if subject.fastleg(subj,effcond) == 2
                        fastleg1st = 1;
                    end
                end
                %step time on belt 1 (right)
                if F{subj}.hsL{effcond, blk}(fir) < F{subj}.hsR{effcond, blk}(fir)   %fp2 strikes first
                    if subject.fastleg(subj,effcond) == 2
                        fastleg1st = 1;
                    end
                elseif F{subj}.hsL{effcond, blk}(fir)>F{subj}.hsR{effcond, blk}(fir) %fp1 strikes first so take its second heel strike
                    if subject.fastleg(subj,effcond) == 1
                        fastleg1st = 1;
                    end
                end
                i=i+1;
            end
            
            % define step length here in order to use the "fir" - steps
            % must be at least 5 cm long
            stepwidth1all = stepwidth1all(stepwidth1all > 30); % mm
            stepwidth2all = stepwidth2all(stepwidth2all > 30);
            maxsteps=min([length(stepwidth1all(fir:end)) length(stepwidth2all(fir:end))]);
            stepwidth1=stepwidth1all(fir:maxsteps);
            stepwidth2=stepwidth2all(fir:maxsteps);
            
            % determine if the first step was on the fast or slow leg and
            % trim accordingly
            if fastleg1st == 1
                % no trimming required
            else
                if subject.fastleg(subj,effcond) == 1
                    % trim slow leg for the first?
                    stepwidth2 = stepwidth2(2:end);
                    stepwidth1 = stepwidth1(1:end-1);
                else
                    % trim slow leg for the first?
                    stepwidth1 = stepwidth1(2:end);
                    stepwidth2 = stepwidth2(1:end-1);
                end
            end
            maxsteps = length(stepwidth1);
            if subject.fastleg(subj,effcond) == 1 % right
                steplength_asym=(stepwidth1-stepwidth2)./(stepwidth1+stepwidth2);
            else
                steplength_asym=(stepwidth2-stepwidth1)./(stepwidth1+stepwidth2);
            end
            asym(subj).stepwidth_r{effcond,blk} = stepwidth1;
            asym(subj).stepwidth_l{effcond,blk} = stepwidth2;
            asym(subj).stepwidth_asym{effcond,blk} = steplength_asym;
        end
    end
end
