% TM3_getLearningCurves
global homepath subject F p colors asym
yesplot = 0;
tic
%%
for subj = 1:subject.n
    for blk = 1:length(subject.blockname)
        % Calculate steplength, steptime, and steplength asymmetry
         i=1;
         clear steptime1 steptime2 steplength2all steplength1all steplength1 steplength2
         
         % crossover and matching the number of heel strike has to be
         % handled here
%          pankle_hsL = p{subj}.Lankle{blk}(F{subj}.hsL_idx{blk});
%          pankle_hsR = p{subj}.Rankle{blk}(F{subj}.hsR_idx{blk});
%          if length(pankle_hsL) > length(pankle_hsR)
%             dif = length(pankle_hsL) - length(pankle_hsR);
%             pankle_hsL = pankle_hsL(dif+1:end);
%             disp('here')
%          elseif length(pankle_hsL) < length(pankle_hsR)
%             dif = length(pankle_hsR) - length(pankle_hsL);
%             pankle_hsR = pankle_hsR(dif+1:end);        
%             disp('here2')
%          end
         i_hsL = F{subj}.hsL_idx{blk};%(2:end);
         i_hsR = F{subj}.hsR_idx{blk};%(2:end);
%          if length(i_hsL) > length(i_hsR)
%             dif = length(i_hsL) - length(i_hsR);
%             i_hsL = i_hsL(1:end-dif); %(dif+1:end);
%             disp('here')
%          elseif length(i_hsL) < length(i_hsR)
%             dif = length(i_hsR) - length(i_hsL);
%             i_hsR = i_hsR(1:end-dif); %(dif+1:end);        
%             disp('here2')
%          end
        
        % index changed from 2 to 1 on 31Jan2023
         steplength2all = p{subj}.Lankle{blk}(i_hsL,2) - ...
             p{subj}.Rankle{blk}(i_hsL,2);
         steplength1all = p{subj}.Rankle{blk}(i_hsR,2) - ...
             p{subj}.Lankle{blk}(i_hsR,2);
        
         maxsteps=min([length(steplength1all) length(steplength2all)]);
         steplength1=steplength1all(1:maxsteps);
         steplength2=steplength2all(1:maxsteps);
         
        %%
        while i < min([length(F{subj}.hsR{blk}) length(F{subj}.hsL{blk})])    
            %step time on belt 2 (left)
            if F{subj}.hsR{blk}(1) < F{subj}.hsL{blk}(1) % fp1 strikes first
                steptime2(i)= F{subj}.hsR{blk}(i)-F{subj}.hsL{blk}(i);
            elseif F{subj}.hsR{blk}(1) > F{subj}.hsL{blk}(1) % fp2 strikes first so take its second heel strike
                steptime2(i)= F{subj}.hsL{blk}(i+1)-F{subj}.hsR{blk}(i); 
            end
            %step time on belt 1 (right)
            if F{subj}.hsL{blk}(1)<F{subj}.hsR{blk}(1)   %fp2 strikes first
                steptime1(i)= F{subj}.hsR{blk}(i)-F{subj}.hsL{blk}(i);
            elseif F{subj}.hsL{blk}(1)>F{subj}.hsR{blk}(1) %fp1 strikes first so take its second heel strike
                steptime1(i)= F{subj}.hsR{blk}(i+1)-F{subj}.hsL{blk}(i);
            end
            i=i+1;
        end
        maxsteps_time=min([length(steptime1) length(steptime2)]);
        steptime1=steptime1(1:maxsteps_time);
        steptime2=steptime2(1:maxsteps_time); 
        steptime_asym=steptime1-steptime2;
        
        if subject.fastleg(subj,blk) == 1 % right
            steplength_asym=(steplength1-steplength2)./(steplength1+steplength2); 
        else
            steplength_asym=(steplength2-steplength1)./(steplength1+steplength2); 
        end
        % make sure this is happening for step time too
        
        %% make a plot for step length
        plotblk = subject.order(subj,blk);
        figure(subj);
        sgtitle(subject.list(subj))
        subplot(2,4,plotblk); hold on;
        plot(F{subj}.hsL{blk}(1:maxsteps),steplength1,'r.')
        title('Step Lengths')
        hold on
        plot(F{subj}.hsR{blk}(1:maxsteps),steplength2,'g.')
        ylabel('Length (mm)')
        legend('Right','Left')

        xlabel('Time (s)')
        subplot(2,4,4+plotblk)
        if blk < 3
            colorasym = colors.high;
        else
            colorasym = colors.low;
        end
        plot(F{subj}.hsR{blk}(1:maxsteps),steplength_asym,'Color',colorasym)
        title(subject.effortlabel(blk))
        ylabel('Asymmetry (fast - slow) Length (mm)')
        xlabel('Time (s)')
        text(50,0.5,['fastleg: ' subject.leglabel(subject.fastleg(subj,blk))]);
        ylim([-1 1])
        
        %% make a plot for step time
%         plotblk = subject.order(subj,blk);
%         figure(100 + subj);
%         sgtitle(subject.list(subj))
%         subplot(2,4,plotblk); hold on;
%         plot(F{subj}.hsL{blk}(1:maxsteps_time),steptime1,'r*')
%         title('Step Lengths')
%         hold on
%         plot(F{subj}.hsR{blk}(1:maxsteps_time),steptime2,'g*')
%         ylabel('Time (s)')
%         legend('Right','Left')
% 
%         xlabel('Time (s)')
%         subplot(2,4,4+plotblk)
%         if blk < 3
%             colorasym = colors.high;
%         else
%             colorasym = colors.low;
%         end
%         plot(F{subj}.hsR{blk}(1:maxsteps_time),steptime_asym,'Color',colorasym)
%         title(subject.effortlabel(blk))
%         ylabel('Asymmetry (R-L) Time (s)')
%         xlabel('Time (s)')
%         text(50,0.5,['fastleg: ' subject.leglabel(subject.fastleg(subj,blk))]);
%         ylim([-1 1])
        %% save the step asymmetries
        asym{subj}.length{blk,1} = steplength1;
        asym{subj}.length{blk,2} = steplength2;
        asym{subj}.nsteps{blk} = maxsteps;
        asym{subj}.asymlength{blk} = steplength_asym;
        asym{subj}.time{blk,1} = steptime1;
        asym{subj}.time{blk,2} = steptime2;
    end
end
clearvars -except F p colors asym homepath subject