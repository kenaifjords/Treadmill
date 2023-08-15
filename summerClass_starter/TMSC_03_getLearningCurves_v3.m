%% TM2_03_getLearningCurves_v2
% this script uses valid heelstrikes to determine step lengths and step
% times over the course of strides in the experiment. These values are used
% to determine asymmetry measures and the script includes a testing plot

global homepath subject F p colors asym
close all
tic
for subj = 1:subject.n
    for blk = 1:subject.nblk
        %% clear and initialize
        % Calculate steplength, steptime, and steplength asymmetry
         i=1;
         clear steptimeR1 steptimeR0 steptimeL1 steptimeL0...
             steplengthR1 steplengthR0 steplengthL1 steplengthL0...
             hsL hsR ihsL ihsR hsRvalid hsLvalid minhs...
             steplength_asym steptime_asym
        if ~isempty(F(subj).hsR{blk}) && ~isempty(F(subj).hsL{blk})
            clear hsR hsL ihsL ihsR
            % assign the heelstrikes to accessible variables
            hsR = F(subj).hsR{blk};
            hsL = F(subj).hsL{blk};

            ihsL = F(subj).hsL_idx{blk};
            ihsR = F(subj).hsR_idx{blk};

            hsRvalid = F(subj).hsRvalid{blk};
            hsLvalid = F(subj).hsLvalid{blk};

            % only take the steplength or step time measurement if the 
            % heel strike is valid (preceded and followed by a 
            % heelstrike on the opposite leg) as determined in the
            % validHS_v2 function in the identifyHeelStrike Script
            
            minhs = min([length(hsR) length(hsL)])-1;
            %% steplength %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for i = 1:minhs
                if hsRvalid(i) == 1
                    steplengthR0(i) = p(subj).Rankle{blk}(ihsR(i),2) - ...
                        p(subj).Lankle{blk}(ihsR(i),2);
                else
                    steplengthR0(i) = NaN;
                end
                if hsLvalid(i) == 1
                    steplengthL0(i) = p(subj).Lankle{blk}(ihsL(i),2) - ...
                        p(subj).Rankle{blk}(ihsL(i),2);
                else
                    steplengthL0(i) = NaN;
                end
            end
            %% steptime %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            i = 1;
            while i < minhs
                % step time on the right leg
                if hsL(1) < hsR(1) & hsRvalid(i) == 1
                    steptimeR0(i) = hsR(i) - hsL(i);
                elseif hsL(1) > hsR(1) & hsRvalid(i) == 1
                    steptimeR0(i) = hsR(i+1) - hsL(i);
                elseif hsRvalid(i) == 0
                    steptimeR0(i) = NaN;
                end
                % steptime on the left leg
                if hsR(1) < hsL(1) & hsLvalid(i) == 1
                    steptimeL0(i) = hsL(i) - hsR(i);
                elseif hsR(1) > hsL(1) & hsLvalid(i) == 1
                    steptimeL0(i) = hsL(i+1) - hsR(i);
                elseif hsLvalid(i) == 0
                    steptimeL0(i) = NaN;
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
            F(subj).steplengthR{blk} = steplengthR1;
            F(subj).steplengthL{blk} = steplengthL1;
            F(subj).steptimeR{blk} = steptimeR1;
            F(subj).steptimeL{blk} = steptimeL1;
            F(subj).nsteps{blk} = maxsteps;
            % save step length and step time asymmetries
            asym(subj).steplength{blk} = steplength_asym;
            asym(subj).steptime{blk} = steptime_asym;

            %% TESTING PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % asymmetry plots to identify spurious heelstrikes....
            figure(10*subj + blk); hold on;
            plot(asym(subj).steplength{blk},'Color',[1 0 1]);
            plot(asym(subj).steptime{blk},'Color',[0 1 1]);
            sgtitle([subject.list(subj), subject.blockname(blk)])
            legend('step length', 'step time');
            ylabel('ASYMMETRY')
            ylim([-1 1])
        end
    end
end
toc
clearvars -except F p colors asym homepath subject