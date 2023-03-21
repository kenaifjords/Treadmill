% TM2_03_getSteptimeCurves
global subject F p colors asym
close all
yesplot = 1;
tic
for subj = 1:subject.n
    for effcond = 1:length(subject.effortcondition)
        for blk = 1:subject.nblk
            % Calculate steptime and steptime asymmetry
            i = 1;
            clear steptime1 steptime2 steptime1all steptime2all fastlegfirst...
                fp1first fp2first
            hsr0 = F{subj}.hsR{effcond,blk}(first);
            hsl0 = F{subj}.hsL{effcond,blk}(first);
            % identify any spurious steps at the beginnning (where left and
            % right heel strikes are the same or too close to constitute a
            % step
            first = 1;
            while hsr0(first) == hsl0(first) || hsr0(first) < 0.1 ||...
                    hsl0 < 0.1
                first = first + 1;
                if first > 3
                    disp('check foot strikes')
                end
            end
            hsr = hsr0(first:end);
            hsl = hsl0(first:end);
            
            % determine which step was first
            lfirst = hsl(1) < hsr(1);
            rfirst = hsl(1) > hsr(1);
            
            % was the first step on the fastleg
            if subject.fastleg(subj,effcond) == 1 && fp1first
                fastlegfirst = 1;
            elseif subject.fastleg(subj,effcond) == 2 && fp2first
                fastlegfirst = 1;
            else
                fastlegfirst = 0;
            end
            
            % loop through steps to find step times
            while i < min([length(hsr) length(hsl)])
                % steptime on left foot (belt 2)
                if rfirst
                    steptime2all = hsl(i) - hsr(i);
                elseif lfirst
                    steptime2all = hsl(i+1) - hsr(i);
                end
                % steptime on right foot (belt 1)
                if lfirst
                    steptime1all = hsr(i) - hsl(i);
                elseif rfirst
                    steptime2all = hsr(i+1) - hsl(i);
                end
                i = i+1;
            end
            maxsteps = min([length(steptime1all) length(steptime2all)]);
            steptime1 = steptime1all(1:maxsteps);
            steptime2 = steptime2all(1:maxsteps);
            
            % determine asymetry (fast - slow)
            if subject.fastleg(subj,effcond) == 1
                steptime_asym = (steptime1 - steptime2)./(steptime1 + steptime2);
            else
                steptime_asym = (steptime2 - steptime1)./(steptime1 + steptime2);
            end
            asym(subj).maxsteps_time{effcond,blk} = maxsteps;
            asym(subj).steptime_r{effcond,blk} = steptime1;
            asym(subj).steptime_l{effcond,blk} = steptime2;
            asym(subj).steptime_asym{effcond,blk} = steptime_asym;
        end
    end
end
if yesplot
    % lot function
end
toc