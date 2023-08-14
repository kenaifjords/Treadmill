%TM2_03_getLearningCurves_v2
global subject F p colors asym
close all
yes_plot = 0;
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            %% clear and initialize
            % Calculate steplength, steptime, and steplength asymmetry
             i=1;
             clear steptimeR1 steptimeR0 steptimeL1 steptimeL0...
                 steplengthR1 steplengthR0 steplengthL1 steplengthL0...
                 hsL hsR ihsL ihsR hsRvalid hsLvalid minhs...
                 steplength_asym steptime_asym
            if ~isempty(F(subj).hsR{effcond,blk}) && ~isempty(F(subj).hsL{effcond,blk})
                clear hsR hsL ihsL ihsR
                % assign the heelstrikes to accessible variables
                hsR = F(subj).hsR{effcond, blk};
                hsL = F(subj).hsL{effcond, blk};

                ihsL = F(subj).hsL_idx{effcond, blk};
                ihsR = F(subj).hsR_idx{effcond, blk};
                
                % only take the steplength or step time measurement if the 
                % heel strike is valid (preceded and followed by a 
                % heelstrike on the opposite leg)
                minhs = min([length(hsR) length(hsL)])-1;
                %% steplength %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for i = 1:minhs
                    steplengthR0(i) = p(subj).Rankle{effcond,blk}(ihsR(i),2) - ...
                        p(subj).Lankle{effcond,blk}(ihsR(i),2);

                    % for a case of subject when the ankle marker fell off
                    if strcmp('MLL', subject.list(subj))
                        if effcond == 2
                            if blk == 5
                                steplengthR0(i) = p(subj).Rheel{effcond, blk}(ihsR(i),2) - ...
                                   p(subj).Lheel{effcond, blk}(ihsR(i),2);
                            end
                        end
                    end

                    steplengthL0(i) = p(subj).Lankle{effcond,blk}(ihsL(i),2) - ...
                        p(subj).Rankle{effcond,blk}(ihsL(i),2);
                    
                    % for a case of subject when the ankle marker fell off
                    if strcmp('MLL', subject.list(subj))
                        if effcond == 2
                            if blk == 5
                                steplengthL0(i) = p(subj).Lheel{effcond, blk}(ihsL(i),2) - ...
                                   p(subj).Rheel{effcond, blk}(ihsL(i),2);
                            end
                        end
                    end
                    %

                end

                %% steptime WITHOUT hsRvalid and hsLvalid %%%%%%%%%%%%
                i = 1; clear steptimeR0 steptimeL0
                while i < minhs
                    % step time on the right leg
                    if hsL(1) < hsR(1)
                        steptimeR0(i) = hsR(i) - hsL(i);
                    elseif hsL(1) > hsR(1)
                        steptimeR0(i) = hsR(i+1) - hsL(i);
                    end
                    % steptime on the left leg
                    if hsR(1) < hsL(1)
                        steptimeL0(i) = hsL(i) - hsR(i);
                    elseif hsR(1) > hsL(1)
                        steptimeL0(i) = hsL(i+1) - hsR(i);
                    end
                    i = i + 1;
                end
                %% match the lengths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
                met_length = [length(steplengthR0) length(steplengthL0);...
                    length(steptimeR0) length(steptimeL0)];
                maxsteps = min(met_length,[],'all');
                % trim to length of maximum 
                steplengthR1 = steplengthR0(1:maxsteps);
                steplengthL1 = steplengthL0(1:maxsteps);
                steptimeR1 = steptimeR0(1:maxsteps);
                steptimeL1 = steptimeL0(1:maxsteps);
                
                %% determine asymmetry measures
                % (fastleg - slowleg)/(fastleg + slowleg)

                if subject.fastleg(subj) == 1 % right is fast
                    steplength_asym = (steplengthR1 - steplengthL1)./(steplengthR1 + steplengthL1);
                    steptime_asym = (steptimeR1 - steptimeL1)./(steptimeR1 + steptimeL1);
                else % left leg is fast
                    steplength_asym = (steplengthL1 - steplengthR1)./(steplengthR1 + steplengthL1);
                    steptime_asym = (steptimeL1 - steptimeR1)./(steptimeR1 + steptimeL1);
                end
                % save step length and step times for each subject, effort
                % condition, and block in the F structure (because all
                % values were determined from GRFz data)
                F(subj).steplengthR{effcond,blk} = steplengthR1;
                F(subj).steplengthL{effcond,blk} = steplengthL1;
                F(subj).steptimeR{effcond,blk} = steptimeR1;
                F(subj).steptimeL{effcond,blk} = steptimeL1;
                F(subj).nsteps{effcond,blk} = maxsteps;
                % save step length and step time asymmetries
                asym(subj).steplength{effcond,blk} = steplength_asym;
                asym(subj).steptime{effcond,blk} = steptime_asym;
                
                % asymmetry plots to identify spurious heelstrikes....
                figure(subj); subplot(2,7,blk); hold on;
                plot(asym(subj).steplength{effcond,blk},'Color',colors.all{effcond,1});
                if blk ==7
                    legend('high effort steplength', 'low effort step length')
                end
                subplot(2,7,blk + 7); hold on
                plot(asym(subj).steptime{effcond,blk},'Color',colors.all{effcond,3});
                if blk == 7
                    legend('high effort step time','low effort step time');
                end
                sgtitle(subject.list(subj))
            end
        end
    end
end

if yes_plot
    TM2figure_plotLearningCurves_steps_fewerplots; % TM2figure_plotLearningCurves_againstSteps
%     TM2figure_plotTimeAsym_againstSteps
end
toc
clearvars -except F p colors asym homepath subject