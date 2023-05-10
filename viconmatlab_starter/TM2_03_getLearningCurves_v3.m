%TM2_03_getLearningCurves_v2
global homepath subject F p colors asym
close all
yes_plot = 0;
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            subj
            effcond
            blk
            %% clear and initialize
            % Calculate steplength, steptime, and steplength asymmetry
             i=1;
             clear steptime1 steptime2 steplength2all steplength1all ...
                 steplength1 steplength2 hsL_time hsR_time hsL hsR
            if ~isempty(F{subj}.hsR{effcond,blk}) && ~isempty(F{subj}.hsL{effcond,blk})
                 %% identify whether the first step is spurious and whether the 
                    % first step was on the fast leg
                fastleg1st = 0;
                % sometimes there is a "first" step that has the exact same
                % step time and opposite forces - an artifact of starting the
                % treadmill - this identifies the true first step and removes
                % the spurious ones
                fir = 1;
                while F{subj}.hsR{effcond, blk}(fir) == F{subj}.hsL{effcond, blk}(fir)
                        fir = fir + 1;
                        if fir > 3
                            % sets up an error in case the code idenifies the
                            % spurious steps a large number of times (large
                            % being arbitrarily set to 3)
                            disp('check heel strikes, left and right seem to be the same')
                        end
                end
                % we trim the heelstrike vectors accordingly
                hsR_time = F{subj}.hsR{effcond, blk}(fir:end);
                hsL_time = F{subj}.hsL{effcond, blk}(fir:end);

                i_hsL = F{subj}.hsL_idx{effcond, blk}(fir:end);%(2:end);
                i_hsR = F{subj}.hsR_idx{effcond, blk}(fir:end);%(2:end);
                
                %% step length %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                steplength2all = p{subj}.Lankle{effcond, blk}(i_hsL,2) - ...
                     p{subj}.Rankle{effcond, blk}(i_hsL,2);
                 steplength1all = p{subj}.Rankle{effcond, blk}(i_hsR,2) - ...
                     p{subj}.Lankle{effcond, blk}(i_hsR,2);
                 
                % check for negative steps and trim (added 18 April 2023)
                % #############################
%                 rneg = find(steplength1all < 0);
%                 lneg = find(steplength2all < 0);
%                 neg = cat(1,rneg,lneg);
%                 steplength1all(neg) = NaN;
%                 steplength2all(neg) = NaN;
                steplength1all = steplength1all(~isnan(steplength1all));
                steplength2all = steplength2all(~isnan(steplength2all));
                
                % define step must be at least 5 cm long
                steplength1all = steplength1all(steplength1all > 50); % mm
                steplength2all = steplength2all(steplength2all > 50);
                %% step time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % then we can determine step times, we also determine if the
                % first step is on the fast leg
                while i < min([length(hsR_time) length(hsL_time)])
                    %step time on belt 2 (left)
                    if hsR_time(1) < hsL_time(1) % fp1 strikes first (right)
                        steptime2(i)= hsL_time(i) - hsR_time(i);
                        if subject.fastleg(subj) == 1 %subject.fastleg(subj,effcond) == 1
                            fastleg1st = 1;
                        end
                    elseif hsR_time(1) > hsL_time(1) %F{subj}.hsL{effcond, blk}(fir) % fp2 strikes first so take its second heel strike
                        steptime2(i)= hsL_time(i+1) - hsR_time(i);
                        if subject.fastleg(subj) == 2 %$subject.fastleg(subj,effcond) == 2
                            fastleg1st = 1;
                        end
                    end

                    %step time on belt 1 (right)
                    if hsL_time(1) < hsR_time(1) % fp2 strikes first
                        steptime1(i)= hsR_time(i) - hsL_time(i);
                        if subject.fastleg(subj) == 2 %subject.fastleg(subj,effcond) == 2
                            fastleg1st = 1;
                        end
                    elseif hsL_time(1) > hsR_time(1) % F{subj}.hsL{effcond, blk}(fir)>F{subj}.hsR{effcond, blk}(fir) %fp1 strikes first so take its second heel strike
                        steptime1(i)= hsR_time(i+1) - hsL_time(i);
                        if subject.fastleg(subj) == 1 %subject.fastleg(subj,effcond) == 1
                            fastleg1st = 1;
                        end
                    end
                    i=i+1;
                end
                %% match the lengths


    %             maxsteps_time = min([length(steptime1) length(steptime2)])
    %             steptime1=steptime1(1:maxsteps_time);
    %             steptime2=steptime2(1:maxsteps_time); 
    %             
    %             % trim heel strike time vectors
    %             hsLall = F{subj}.hsL{effcond,blk};
    %             hsL_time = hsLall(fir:maxsteps_time) - hsLall(fir); % arrange 
    %                 % all according to the first valid step - NEED TO CHECK THE LOGIC HERE
    %             hsRall = F{subj}.hsR{effcond,blk};
    %             hsR_time = hsRall(fir:maxsteps_time) - hsRall(fir);
    %             
    %             
                met_length = [length(steplength1all) length(steplength2all);...
                    length(steptime1) length(steptime2);
                    length(hsR_time) length(hsL_time)]
                maxsteps = min(met_length,[],'all')
                steplength1=steplength1all(1:maxsteps);
                steplength2=steplength2all(1:maxsteps);
                steptime1 = steptime1(1:maxsteps);
                steptime2 = steptime2(1:maxsteps);
                hsL_time = hsL_time(1:maxsteps);
                hsR_time = hsR_time(1:maxsteps);

                % determine if the first step was on the fast or slow leg and
                % trim accordingly
                if fastleg1st == 1
                    % no trimming required
                    hsL = hsL_time;
                    hsR = hsR_time;
                else
                    if subject.fastleg(subj) == 1 % subject.fastleg(subj,effcond) == 1 % right fast
                        if hsL_time(1) < hsR_time(1) % left steps first
                            % trim slow leg for the first?
                            steplength2 = steplength2(2:end);
                            steplength1 = steplength1(1:end-1); 

                            steptime2 = steptime2(2:end);
                            steptime1 = steptime1(1:end-1);

                            hsL = hsL_time(2:end);
                            hsR = hsR_time(1:end-1);

                            maxsteps = maxsteps - 1;
                        else % do nothing
                            hsL = hsL_time;
                            hsR = hsR_time;
                        end
                    else % left fast
                        if hsR_time(1) < hsL_time(1) % right steps first
                            % trim slow leg for the first?
                            steplength1 = steplength1(2:end);
                            steplength2 = steplength2(1:end-1);

                            steptime1 = steptime1(2:end);
                            steptime2 = steptime2(1:end-1);

                            hsR = hsR_time(2:end);
                            hsL = hsL_time(1:end-1);

                            maxsteps = maxsteps - 1;
                        else % do nothing
                            hsL = hsL_time;
                            hsR = hsR_time;
                        end
                    end
                end

                if subject.fastleg(subj) == 1 %subject.fastleg(subj,effcond) == 1 % right
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
end

if yes_plot
    TM2_plotLearningCurves_steps_fewerplots; % TM2figure_plotLearningCurves_againstSteps
%     TM2figure_plotTimeAsym_againstSteps
end
toc
clearvars -except F p colors asym homepath subject