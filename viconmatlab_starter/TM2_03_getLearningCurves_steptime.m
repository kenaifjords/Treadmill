%TM2_03_getLearningCurves
global homepath subject F p colors asym
close all
yes_plot = 0;
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            % Calculate steplength, steptime, and steplength asymmetry
             i=1; ri = 0; li = 0;
             clear steptime1 steptime2 steplength2all steplength1all steplength1 steplength2 fastlegfirst
             i_hsL = F{subj}.hsL_idx{effcond, blk};%(2:end);
             i_hsR = F{subj}.hsR_idx{effcond, blk};%(2:end);

            fp1first = NaN;
            fp2first = NaN;
            fastlegfirst = NaN;
            
            % identify any spurious steps at the beginnning (where left and
            % right heel strikes are the same
            fir = 1;
            while F{subj}.hsR{effcond, blk}(fir) == F{subj}.hsL{effcond, blk}(fir) ||...
                F{subj}.hsR{effcond, blk}(fir) < 0.1 || F{subj}.hsL{effcond, blk}(fir) < 0.1 % ||...
%                 F{subj}.hsL{effcond, blk}(fir) - F{subj}.hsR{effcond, blk}(fir) < abs(0.05)
                fir = fir + 1;
                if fir > 3
                    disp('check heel strikes, left and right seem to be the same')
                end
            end
            % trim off the nonsense steps
            hsR = F{subj}.hsR{effcond, blk}(fir:end);
            hsL = F{subj}.hsL{effcond, blk}(fir:end);
            
            % determine which step was first
            fp1first = F{subj}.hsR{effcond, blk}(fir) < F{subj}.hsL{effcond, blk}(fir); % fp1 strikes first (right);
            fp2first = F{subj}.hsR{effcond, blk}(fir) > F{subj}.hsL{effcond, blk}(fir); % fp2 strikes first so take its second heel strike
            
            % set true flag if the first step was on the fast leg
            if subject.fastleg(subj,effcond) == 1 && fp1first
                fastlegfirst = 1;
            elseif subject.fastleg(subj,effcond) == 2 && fp2first
                fastlegfirst = 1;
            else
                fastlegfirst = 0;
            end
            
            % loop through steps to find step times
            while i < min([length(hsR) length(hsL)])                
                if fp1first % fp1 strikes first (right)
                    steptime2(i)= hsL(i) - hsR(i);
                elseif fp2first
                    steptime2(i)= hsL(i+1) - hsR(i);
                end
                
                %step time on belt 1 (right)
                if fp1first %F{subj}.hsL{effcond, blk}(fir) < F{subj}.hsR{effcond, blk}(fir)   %fp2 strikes first
                    steptime1(i)= hsR(i) - hsL(i);
                elseif fp2first % F{subj}.hsL{effcond, blk}(fir)>F{subj}.hsR{effcond, blk}(fir) %fp1 strikes first so take its second heel strike
                    steptime1(i)= hsR(i+1) - hsL(i);
                end
                i = i + 1;
            end
            
            maxsteps_time = min([length(steptime1) length(steptime2)]);
            
            % trim heel strike time vectors
            hsL_time = hsL(1:maxsteps_time) - min(hsL(1),hsR(1)); % arrange 
                % all according to the first valid step - NEED TO CHECK THE LOGIC HERE
            hsR_time = hsR(1:maxsteps_time) - min(hsL(1),hsR(1));
            
            met_length = [length(hsL_time) length(hsR_time); length(steptime2) ...
                length(steptime2)] %;length(steplength2all) length(steplength1all)]
            
            % determine if the first step was on the fast or slow leg and
            % trim accordingly
            if fastlegfirst == 1
                % no trimming required
            else
                if subject.fastleg(subj,effcond) == 1 % right fast
                    if steptime2(1) < steptime1(1) % left steps first
                        % trim slow leg for the first?
                        
                        steptime2 = steptime2(2:end);
                        steptime1 = steptime1(1:end-1);

                        hsL_time = hsL_time(2:end);
                        hsR_time = hsR_time(1:end-1);
                    else % do nothing
                    end
                    fprintf('here')
                else % left fast
                    fprintf('here1')
                    if steptime1(1)<steptime2(1) % right steps first
                        % trim slow leg for the first?
                        steptime1 = steptime1(2:end);
                        steptime2 = steptime2(1:end-1);

                        hsR_time = hsR_time(2:end);
                        hsL_time = hsL_time(1:end-1);
                    else % do nothing
                    end
                end
            end
            met_length = [length(hsL_time) length(hsR_time); length(steptime2) ...
                length(steptime1)] %length(steplength2) length(steplength1)]
            maxsteps = length(steptime1);
            if subject.fastleg(subj,effcond) == 1 % right
                steptime_asym = (steptime1 - steptime2) ./ (steptime1+steptime2);
            else
                steptime_asym = (steptime2 - steptime1) ./ (steptime1 + steptime2);
            end
            asym(subj).nsteps{effcond,blk} = maxsteps;
            asym(subj).steptime_r{effcond,blk} = steptime1;
            asym(subj).steptime_l{effcond,blk} = steptime2;
            asym(subj).steptime_asym{effcond,blk} = steptime_asym;
            asym(subj).firstvalidstep{effcond,blk} = fir;
            asym(subj).hsL{effcond,blk} = hsL_time;
            asym(subj).hsR{effcond,blk} = hsR_time;
        end
    end
end

if yes_plot
    TM2figure_plotLearningCurves_againstSteps
    TM2figure_plotTimeAsym_againstSteps
end
toc
% clearvars -except F p colors asym homepath subject