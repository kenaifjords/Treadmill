% TM03_3_plotlearningcurve_stepsonX
% TM3_getLearningCurves
global homepath subject F p colors asym
yesplot = 1;
tic
%%
for subj = 1:subject.n
    for blk = 1:length(subject.blockname)
        % Calculate steplength, steptime, and steplength asymmetry
         i=1;
         clear steptime1 steptime2 steplength2all steplength1all steplength1 steplength2

         i_hsL = F{subj}.hsL_idx{blk};%(2:end);
         i_hsR = F{subj}.hsR_idx{blk};%(2:end);

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
        steplength_asym=(steplength1-steplength2)./(steplength1+steplength2); 
     
        %% make a plot for step length
        plotblk = subject.order(subj,blk);
        figure(subj);
        sgtitle(subject.list(subj))
        subplot(2,4,plotblk); hold on;
        plot(steplength1,'r.')
        title('Step Lengths')
        hold on
        plot(steplength2,'g.')
        ylabel('Length (mm)')
        legend('Right','Left')

        xlabel('steps')
        subplot(2,4,4+plotblk)
        if blk < 3
            colorasym = colors.high;
        else
            colorasym = colors.low;
        end
        plot(steplength_asym,'Color',colorasym)
        title(subject.effortlabel(blk))
        ylabel('Asymmetry (R-L) Length (mm)')
        xlabel('steps')
        text(50,0.5,['fastleg: ' subject.leglabel(subject.fastleg(subj,blk))]);
        ylim([-1 1])
    end
end