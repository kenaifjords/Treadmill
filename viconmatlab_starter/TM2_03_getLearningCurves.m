%TM2_03_getLearningCurves
global homepath subject F p colors asym
close all
yes_plot = 0;
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            % Calculate steplength, steptime, and steplength asymmetry
             i=1;
             clear steptime1 steptime2 steplength2all steplength1all steplength1 steplength2
             i_hsL = F{subj}.hsL_idx{effcond, blk};%(2:end);
             i_hsR = F{subj}.hsR_idx{effcond, blk};%(2:end);

            % index changed from 2 to 1 on 31Jan2023
             steplength2all = p{subj}.Lankle{effcond, blk}(i_hsL,2) - ...
                 p{subj}.Rankle{effcond, blk}(i_hsL,2);
             steplength1all = p{subj}.Rankle{effcond, blk}(i_hsR,2) - ...
                 p{subj}.Lankle{effcond, blk}(i_hsR,2);

%              maxsteps=min([length(steplength1all) length(steplength2all)]);
%              steplength1=steplength1all(1:maxsteps);
%              steplength2=steplength2all(1:maxsteps);

            %%
            fastleg1st = NaN;
            while i < min([length(F{subj}.hsR{effcond, blk}) length(F{subj}.hsL{effcond, blk})])    
                %step time on belt 2 (left)
                fir = 1;
                while F{subj}.hsR{effcond, blk}(fir) == F{subj}.hsL{effcond, blk}(fir)
                    fir = fir + 1;
                    if fir > 3
                        disp('check heel strikes, left and right seem to be the same')
                    end
                end
                
                if F{subj}.hsR{effcond, blk}(fir) < F{subj}.hsL{effcond, blk}(fir) % fp1 strikes first (right)
                    steptime2(i)= F{subj}.hsL{effcond, blk}(i)-F{subj}.hsR{effcond, blk}(i);
                    if subject.fastleg(subj,effcond) == 1
                        fastleg1st = 1;
                    end
                elseif F{subj}.hsR{effcond, blk}(fir) > F{subj}.hsL{effcond, blk}(fir) % fp2 strikes first so take its second heel strike
                    steptime2(i)= F{subj}.hsL{effcond, blk}(i+1)-F{subj}.hsR{effcond, blk}(i);
                    if subject.fastleg(subj,effcond) == 2
                        fastleg1st = 1;
                    end
                end
                
                %step time on belt 1 (right)
                if F{subj}.hsL{effcond, blk}(fir) < F{subj}.hsR{effcond, blk}(fir)   %fp2 strikes first
                    steptime1(i)= F{subj}.hsR{effcond, blk}(i)-F{subj}.hsL{effcond, blk}(i);
                    if subject.fastleg(subj,effcond) == 2
                        fastleg1st = 1;
                    end
                elseif F{subj}.hsL{effcond, blk}(fir)>F{subj}.hsR{effcond, blk}(fir) %fp1 strikes first so take its second heel strike
                    steptime1(i)= F{subj}.hsR{effcond, blk}(i+1)-F{subj}.hsL{effcond, blk}(i);
                    if subject.fastleg(subj,effcond) == 1
                        fastleg1st = 1;
                    end
                end
                i=i+1;
            end
            
            maxsteps_time = min([length(steptime1(fir:end)) length(steptime2(fir:end))])
            steptime1=steptime1(fir:maxsteps_time);
            steptime2=steptime2(fir:maxsteps_time);
            steplength1all = steplength1all(fir:maxsteps_time);
            steplength2all = steplength2all(fir:maxsteps_time);
            
            % trim heel strike time vectors
            hsLall = F{subj}.hsL{effcond,blk};
            hsRall = F{subj}.hsR{effcond,blk};
            hsL_time = hsLall(fir:maxsteps_time) - min(hsLall(fir),hsRall(fir)); % arrange 
                % all according to the first valid step - NEED TO CHECK THE LOGIC HERE
            hsR_time = hsRall(fir:maxsteps_time) - min(hsLall(fir),hsRall(fir));
            
            met_length = [length(hsL_time) length(hsR_time); length(steptime2) ...
                length(steptime2);length(steplength2all) length(steplength1all)]
            
            % define step length here in order to use the "fir" - steps
            % must be at least 5 cm long
            steplength1all(find(steplength1all < 50)) = NaN; % mm
%             size(steplength2all)
            steplength2all(find(steplength2all < 50)) = NaN;
%             size(steplength2all)
            steplength1=steplength1all;
            steplength2=steplength2all;
%             size(steplength2)
            
            % determine if the first step was on the fast or slow leg and
            % trim accordingly
            if fastleg1st == 1
                % no trimming required
            else
                if subject.fastleg(subj,effcond) == 1 % right fast
                    if steptime2(1) < steptime1(1) % left steps first
                        % trim slow leg for the first?
                        
                        steplength2 = steplength2(2:end);
                        steplength1 = steplength1(1:end-1); 
                        
                        steptime2 = steptime2(2:end);
                        steptime1 = steptime1(1:end-1);

                        hsL = hsL_time(2:end);
                        hsR = hsR_time(1:end-1);
                    else % do nothing
                        hsL = hsL_time;
                        hsR = hsR_time;
                    end
                    fprintf('here')
                else % left fast
                    fprintf('here1')
                    if steptime1(1)<steptime2(1) % right steps first
                        % trim slow leg for the first?
                        steplength1 = steplength1(2:end);
                        steplength2 = steplength2(1:end-1);

                        steptime1 = steptime1(2:end);
                        steptime2 = steptime2(1:end-1);

                        hsR = hsR_time(2:end);
                        hsL = hsL_time(1:end-1);
                    else % do nothing
                        hsL = hsL_time;
                        hsR = hsR_time;
                    end
                end
            end
            met_length = [length(hsL) length(hsR); length(steptime2) ...
                length(steptime2);length(steplength2) length(steplength1)]
            maxsteps = length(steplength1);
            if subject.fastleg(subj,effcond) == 1 % right
                steplength_asym=(steplength1-steplength2)./(steplength1+steplength2);
                steptime_asym = (steptime1 - steptime2) ./ (steptime1+steptime2);
            else
                steplength_asym=(steplength2-steplength1)./(steplength1+steplength2);
                steptime_asym = (steptime2 - steptime1) ./ (steptime1 + steptime2);
            end
            asym(subj).steplength_r{effcond,blk} = steplength1;
            asym(subj).steplength_l{effcond,blk} = steplength2;
            asym(subj).nsteps{effcond,blk} = maxsteps;
            asym(subj).asymlength{effcond,blk} = steplength_asym;
            asym(subj).steptime_r{effcond,blk} = steptime1;
            asym(subj).steptime_l{effcond,blk} = steptime2;
            asym(subj).steptime_asym{effcond,blk} = steptime_asym;
            asym(subj).firstvalidstep{effcond,blk} = fir;
            asym(subj).hsL{effcond,blk} = hsL;
            asym(subj).hsR{effcond,blk} = hsR;
        end
    end
end

if yes_plot
    TM2figure_plotLearningCurves_againstSteps
    TM2figure_plotTimeAsym_againstSteps
end
toc
% clearvars -except F p colors asym homepath subject