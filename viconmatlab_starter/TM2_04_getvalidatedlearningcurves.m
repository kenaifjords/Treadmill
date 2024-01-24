%TM2_04_getvalidatedlearningcurves
global subject F p colors asym
yes_plot = 0;
effcondmarker = ['x','o','.'];
tic
for subj = 1:subject.n
    for effcond = 1:3
        if effcond > size(F(subj).R,1)
            break
        end
        for blk = 1:subject.nblk
            if blk > size(F(subj).R,2)
                break
            end
            % clear and initialize
            clear hsR hsL ihsR ihsR
            clear steptimeR0 steptimeL0 steptimeR1 steptimeL0 steptimeL1
            clear steplengthR0 steplengthL0 steplengthR1 steplengthL1
            clear steplength_asym steptime_asym
            clear rvalid lvalid
            
            hsR = F(subj).hsR{effcond, blk}; % size(hsR)
            hsL = F(subj).hsL{effcond, blk}; % size(hsL)

            ihsL = F(subj).hsL_idx{effcond, blk};
            ihsR = F(subj).hsR_idx{effcond, blk};
            
            rfirst = F(subj).rfirst{effcond,blk};

            rvalid = F(subj).validstepR{effcond,blk};
            lvalid = F(subj).validstepL{effcond,blk};
             
            if ~isempty(hsR) && ~isempty(hsL)
                % determine the minimum number of heel strikes
                minhs = min([size(rvalid,1) size(lvalid,1)]);
                
                %% find steplength %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for i = 1:minhs
                    % right foot
                    steplengthR0(i) = p(subj).Rankle{effcond,blk}(ihsR(rvalid(i,1)),2) - ...
                        p(subj).Lankle{effcond,blk}(ihsR(rvalid(i,1)),2);

                    % for a case of subject when the ankle marker fell off
                    if strcmp('MLL', subject.list(subj))
                        if effcond == 2
                            if blk == 5
                                steplengthR0(i) = p(subj).Rheel{effcond, blk}(ihsR(rvalid(i,1)),2) - ...
                                   p(subj).Lheel{effcond, blk}(ihsR(rvalid(i,1)),2);
                            end
                        end
                    end
                    
                    % left foot
                    steplengthL0(i) = p(subj).Lankle{effcond,blk}(ihsL(lvalid(i,1)),2) - ...
                        p(subj).Rankle{effcond,blk}(ihsL(lvalid(i,1)),2);
                    
                    % for a case of subject when the ankle marker fell off
                    if strcmp('MLL', subject.list(subj))
                        if effcond == 2
                            if blk == 5
                                steplengthL0(i) = p(subj).Lheel{effcond, blk}(ihsL(lvalid(i,1)),2) - ...
                                   p(subj).Rheel{effcond, blk}(ihsL(lvalid(i,1)),2);
                            end
                        end
                    end
                end
                steplengthR0(steplengthR0<0) = NaN;
                steplengthL0(steplengthL0<0) = NaN;
                %% find steptime %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                i = 1;
                while i < minhs
                    if sum(isnan(rvalid(i,:))) == 0
                    % steptime on the right leg
                        steptimeR0(i) = hsR(rvalid(i,1)) - hsL(rvalid(i,2));
                    end
                    if sum(isnan(lvalid(i,:))) == 0
                        steptimeL0(i) = hsL(lvalid(i,1)) - hsR(lvalid(i,2));
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
                %% determine asymmetry measures %%%%%%%%%%%%%%%%%%%%%%%%
                % (fastleg - slowleg)/(fastleg + slowleg)
                if subject.fastleg(subj) == 1 % right is fast
                    steplength_asym = (steplengthR1 - steplengthL1)./(steplengthR1 + steplengthL1);
                    steptime_asym = (steptimeR1 - steptimeL1)./(steptimeR1 + steptimeL1);
                else % left leg is fast
                    steplength_asym = (steplengthL1 - steplengthR1)./(steplengthR1 + steplengthL1);
                    steptime_asym = (steptimeL1 - steptimeR1)./(steptimeR1 + steptimeL1);
                end
                %% save asymmetry and step length and step times %%%%%%%%
                % for each subject, effort condition, and block in the F
                % structure (because all values were determined from GRFz 
                % data)
                F(subj).steplengthR{effcond,blk} = steplengthR1;
                F(subj).steplengthL{effcond,blk} = steplengthL1;
                F(subj).steptimeR{effcond,blk} = steptimeR1;
                F(subj).steptimeL{effcond,blk} = steptimeL1;
                F(subj).nsteps{effcond,blk} = maxsteps;
                % save step length and step time asymmetries
                asym(subj).steplength{effcond,blk} = steplength_asym;
                asym(subj).steptime{effcond,blk} = steptime_asym;
                
                if yes_plot
                    % asymmetry plots to identify spurious heelstrikes....
                    figure(subj);subplot(3,7,blk); hold on;
                    plot(F(subj).steplengthR{effcond,blk},'g','Marker',effcondmarker(effcond),'LineStyle','none');
                    plot(F(subj).steplengthL{effcond,blk},'r','Marker',effcondmarker(effcond),'LineStyle','none');                  
                    subplot(3,7,blk + 7); hold on;
                    plot(asym(subj).steplength{effcond,blk},'Color',colors.all{effcond,1});
                    if blk ==7
                        legend('high effort steplength', 'low effort step length')
                    end
                    subplot(3,7,blk + 14); hold on
                    plot(asym(subj).steptime{effcond,blk},'Color',colors.all{effcond,3});
                    if blk == 7
                        legend('high effort step time','low effort step time');
                    end
                    sgtitle(subject.list(subj))
                end
            end
        end
    end
end
clearvars -except F p colors subject asym homepath IK ID
toc
                
                
                