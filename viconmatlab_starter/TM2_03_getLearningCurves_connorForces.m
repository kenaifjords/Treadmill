%TM2_03_getLearningCurves
global homepath subject F p colors asym
close all
yes_plot = 0;
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
%             % Calculate steplength, steptime, and steplength asymmetry
%              i=1;
%              clear steptime1 steptime2 steplength2all steplength1all steplength1 steplength2
%              i_hsL = F{subj}.hsL_idx{effcond, blk};%(2:end);
%              i_hsR = F{subj}.hsR_idx{effcond, blk};%(2:end);
% 
%             % index changed from 2 to 1 on 31Jan2023
%              steplength2all = p{subj}.Lankle{effcond, blk}(i_hsL,2) - ...
%                  p{subj}.Rankle{effcond, blk}(i_hsL,2);
%              steplength1all = p{subj}.Rankle{effcond, blk}(i_hsR,2) - ...
%                  p{subj}.Lankle{effcond, blk}(i_hsR,2);
% 
%              maxsteps=min([length(steplength1all) length(steplength2all)]);
%              steplength1=steplength1all(1:maxsteps);
%              steplength2=steplength2all(1:maxsteps);
% 
%             %%
%             
%             while i < min([length(F{subj}.hsR{effcond, blk}) length(F{subj}.hsL{effcond, blk})])
%                 rachel(i) = min([length(F{subj}.hsR{effcond, blk}) length(F{subj}.hsL{effcond, blk})]);
%                 %step time on belt 2 (left)
%                 fir = 1;
%                 while F{subj}.hsR{effcond, blk}(fir) == F{subj}.hsL{effcond, blk}(fir)
%                     fir = fir + 1;
%                     if fir > 5
%                         disp('check heel strikes, left and right seem to be the same')
%                     end
%                 end
%                 if F{subj}.hsR{effcond, blk}(fir) < F{subj}.hsL{effcond, blk}(fir) % fp1 strikes first
%                     steptime2(i)= F{subj}.hsL{effcond, blk}(i)-F{subj}.hsR{effcond, blk}(i);
%                 elseif F{subj}.hsR{effcond, blk}(fir) > F{subj}.hsL{effcond, blk}(fir) % fp2 strikes first so take its second heel strike
%                     steptime2(i)= F{subj}.hsL{effcond, blk}(i+1)-F{subj}.hsR{effcond, blk}(i); 
%                 end
%                 %step time on belt 1 (right)
%                 if F{subj}.hsL{effcond, blk}(fir) < F{subj}.hsR{effcond, blk}(fir)   %fp2 strikes first
%                     steptime1(i)= F{subj}.hsR{effcond, blk}(i)-F{subj}.hsL{effcond, blk}(i);
%                 elseif F{subj}.hsL{effcond, blk}(fir)>F{subj}.hsR{effcond, blk}(fir) %fp1 strikes first so take its second heel strike
%                     steptime1(i)= F{subj}.hsR{effcond, blk}(i+1)-F{subj}.hsL{effcond, blk}(i);
%                 end
%                 i=i+1;
%             end
%             maxsteps_time=min([length(steptime1) length(steptime2)]);
%             steptime1=steptime1(fir:maxsteps_time);
%             steptime2=steptime2(fir:maxsteps_time); 
% 
%             if subject.fastleg(subj,effcond) == 1 % right
%                 steplength_asym=(steplength1-steplength2)./(steplength1+steplength2);
%                 steptime_asym = (steptime1 - steptime2) ./ (steptime1+steptime2);
%             else
%                 steplength_asym=(steplength2-steplength1)./(steplength1+steplength2);
%                 steptime_asym = (steptime2 - steptime1) ./ (steptime1 + steptime2);
%             end
%% Force asymmetries           
            clear i
            i=1; 
            connor(effcond,blk) = min([length(F{subj}.hsR_idx{effcond,blk}) length(F{subj}.hsL_idx{effcond,blk})]);
            clear MaxVertForceR MaxVertForceL asymVertForce
            while i < min([length(F{subj}.hsR_idx{effcond,blk}) length(F{subj}.hsL_idx{effcond,blk})])
                    if F{subj}.hsR_idx{effcond,blk}(1) < F{subj}.toR_idx{effcond,blk}(1) % On the right foot hs is first
                        contactframesR = (F{subj}.hsR_idx{effcond,blk}(i):F{subj}.toR_idx{effcond,blk}(i)); %frames the foot is in contact
                        MaxVertForceR(i) = max(F{subj}.R{effcond,blk}(contactframesR,3)); % The max of the vert contact forces
                   elseif F{subj}.hsR_idx{effcond,blk}(1) > F{subj}.toR_idx{effcond,blk}(1) 
                        contactframesR = (F{subj}.hsR_idx{effcond,blk}(i):F{subj}.toR_idx{effcond,blk}(i+1));
                        MaxVertForceR(i) = max(F{subj}.R{effcond,blk}(contactframesR,3));
                  % Need this condition becuase some toe offs do happen before the
                  % heelstrike.  
                    end 
        % For the left foot
                    if F{subj}.hsL_idx{effcond,blk}(1) < F{subj}.toL_idx{effcond,blk}(1) % On the right foot hs is first
                    contactframesL = (F{subj}.hsL_idx{effcond,blk}(i):F{subj}.toL_idx{effcond,blk}(i)); %frames the foot is in contact
                    MaxVertForceL(i) = max(F{subj}.L{effcond,blk}(contactframesL,3)); % The max of the vert contact forces
                    elseif F{subj}.hsL{effcond,blk}(1) > F{subj}.toL{effcond,blk}(1) 
                    contactframesL = (F{subj}.hsL_idx{effcond,blk}(i):F{subj}.toL_idx{effcond,blk}(i+1));
                    MaxVertForceL(i) = max(F{subj}.L{effcond,blk}(contactframesL,3));
                    end
                i=i+1;
            end
            imax(effcond,blk) = i;
% now i need to plot the asymmetry and then look at the code rachel sent.
            if subject.fastleg(subj,effcond) == 1 % right
                asymVertForce =(MaxVertForceR-MaxVertForceL)./(MaxVertForceR+MaxVertForceL); 
            else
                asymVertForce=(MaxVertForceL-MaxVertForceR)./(MaxVertForceR+MaxVertForceL); 
            end
            fprintf('asymvert')
            size(asymVertForce)
%% Asymmetries
% should these all be the same length? I guess MaxVertForce is only when
% foot is in contact. Whereas, steplength and step time are from heelstrike
% to opposise heelstrike. So they shouldn't be the same length. Because
% MaxVertForce wouldnt necessarily align? I'm unsure. Or should they be the
% same length because they each happen each step.
            fprintf('size max vert')
            size(MaxVertForceR)
            asym(subj).MaxVertForceR{effcond,blk} = MaxVertForceR;%Right foot is first column 
            fprintf('asym')
            size(asym(subj).MaxVertForceR{effcond,blk})
            asym(subj).MaxVertForceL{effcond,blk} = MaxVertForceL;
            asym(subj).asymVertForce{effcond,blk} = asymVertForce;
%             asym(subj).steplength_r{effcond,blk} = steplength1;
%             asym(subj).steplength_l{effcond,blk} = steplength2;
%             asym(subj).nsteps{effcond,blk} = maxsteps;
%             asym(subj).asymlength{effcond,blk} = steplength_asym;
%             asym(subj).steptime_r{effcond,blk} = steptime1;
%             asym(subj).steptime_l{effcond,blk} = steptime2;
%             asym(subj).steptime_asym{effcond,blk} = steptime_asym;
        end
    end
end

if yes_plot
    TM2figure_plotLearningCurves
end
toc
% clearvars -except F p colors asym homepath subject