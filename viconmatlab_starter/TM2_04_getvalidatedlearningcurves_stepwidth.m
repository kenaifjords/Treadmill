%TM2_04_getvalidatedlearningcurves_stepwidth
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
                asym(subj).stepwidth{effcond,blk} = NaN;
                break
            end
            % clear and initialize
            clear hsR hsL ihsR ihsR
            clear stepwidthR0 stepwidthL0 stepwidthR1 stepwidthL1
            clear stepwidth_asym
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
                
                %% find stepwidth %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                stepwidthR0 = []; stepwidthL0 =[]; i = 1;
                while i < minhs
%                     % right foot
%                     stepwidthR0(i) = p(subj).Rheel{effcond,blk}(ihsR(rvalid(i,1)),1) - ...
%                         p(subj).Lheel{effcond,blk}(ihsR(rvalid(i,1)),1);                  
%                     
%                     % left foot
%                     stepwidthL0(i) = p(subj).Lheel{effcond,blk}(ihsL(lvalid(i,1)),1) - ...
%                         p(subj).Rheel{effcond,blk}(ihsL(lvalid(i,1)),1);   
                   % based on Owings 2004
                   if rfirst
                       if i > 2
                       stepwidthR0(i) = p(subj).Rheel{effcond,blk}(ihsR(rvalid(i,1)),1) - ...
                          p(subj).Lheel{effcond,blk}(ihsL(rvalid(i,2)),1);
                       else
                           stepwidthR0(1) = NaN;
                       end
                       stepwidthL0(i) = p(subj).Lheel{effcond,blk}(ihsL(lvalid(i,1)),1) - ...
                          p(subj).Rheel{effcond,blk}(ihsR(lvalid(i,2)),1);
                   else
                       stepwidthR0(i) = p(subj).Rheel{effcond,blk}(ihsR(rvalid(i,1)),1) - ...
                          p(subj).Lheel{effcond,blk}(ihsL(rvalid(i,2)),1);
                       if i > 2
                          stepwidthL0(i) = p(subj).Lheel{effcond,blk}(ihsL(lvalid(i,1)),1) - ...
                            p(subj).Rheel{effcond,blk}(ihsR(lvalid(i,2)),1);
                       else
                           stepwidthL0(1) = NaN;
                       end
                   end
                   i = i + 1;
                end
                % the x coordinates are in reference to left corner, step
                % widths measured from left minus right will be negative,
                % so we take the absolute value
                stepwidthR0 = abs(stepwidthR0); %(stepwidthR0<0) = NaN;
                stepwidthL0 = abs(stepwidthL0); %(stepwidthL0<0) = NaN;
                
                %% match the lengths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
                met_length = [length(stepwidthR0) length(stepwidthL0)];
                maxsteps = min(met_length,[],'all');
                
                % trim to length of maximum 
                stepwidthR1 = stepwidthR0(1:maxsteps);
                stepwidthL1 = stepwidthL0(1:maxsteps);
              
                %% determine asymmetry measures %%%%%%%%%%%%%%%%%%%%%%%%
                % (fastleg - slowleg)/(fastleg + slowleg)
                if subject.fastleg(subj) == 1 % right is fast
                    stepwidth_asym = (stepwidthR1 - stepwidthL1)./(stepwidthR1 + stepwidthL1);
                else % left leg is fast
                    stepwidth_asym = (stepwidthL1 - stepwidthR1)./(stepwidthR1 + stepwidthL1);
                end
                %% save asymmetry and step width and step times %%%%%%%%
                % for each subject, effort condition, and block in the F
                % structure (because all values were determined from GRFz 
                % data)
                F(subj).stepwidthR{effcond,blk} = stepwidthR1;
                F(subj).stepwidthL{effcond,blk} = stepwidthL1;

                % save step width and step time asymmetries
                asym(subj).stepwidth{effcond,blk} = stepwidth_asym;
                
                if yes_plot
                    % asymmetry plots to identify spurious heelstrikes....
                    figure(subj); subplot(3,7,blk); hold on;
                    plot(F(subj).stepwidthR{effcond,blk},'g','Marker',effcondmarker(effcond),'LineStyle','none');
                    plot(F(subj).stepwidthL{effcond,blk},'r','Marker',effcondmarker(effcond),'LineStyle','none');                  
                    subplot(3,7,blk + 7); hold on;
                    plot(asym(subj).stepwidth{effcond,blk},'Color',colors.all{effcond,1});
                    if blk ==7
                        legend('high effort stepwidth', 'low effort step width')
                    end
                    sgtitle(subject.list(subj))
                end
            else
                asym(subj).stepwidth{effcond,blk} = NaN;
                stepwidthR1 = NaN; stepwidthL1 = NaN;
            end
%             linestyle_list = {'-','--','-.'};
%             figure(subj); subplot(7,1,blk); hold on;
%             plot(stepwidthR1,'LineStyle',linestyle_list{effcond},...
%                 'Color','r');
%             plot(stepwidthL1,'LineStyle',linestyle_list{effcond},...
%                 'Color','b');
        end
    end
end

clearvars -except F p colors subject asym homepath IK ID
toc
                
                
                