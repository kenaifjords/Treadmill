% TM2_04_forceandimpulseasymmetry
global F p asym colors subject
plotindividual = 1;
for subj = 1:subject.n
    subj
    for effcond = 1:2
        effcond
        for blk = 1:subject.nblk
            blk
            clear fyr fyl fzr fzl ftime sdRy sdLy sdRz sdLz asymbrk asympsh asymimp
            fyr = F{subj}.R{effcond,blk}(:,2);
            fyl = F{subj}.L{effcond,blk}(:,2);
            time = F{subj}.time{effcond,blk};
            fzr = F{subj}.R{effcond,blk}(:,3);
            fzl = F{subj}.L{effcond,blk}(:,3);
            hsR = F{subj}.hsR{effcond,blk};
            hsL = F{subj}.hsL{effcond,blk};
            %% get braking and propulsion peak force
            % get stride data for y-forces
            if ~isempty(hsR) && ~isempty(hsL)
                [ , sdLy] = getStrideDataCell(fyr,fyl,time,hsR, hsL);
                % right foot
                for s = 1:size(sdRy,1)
                    clear strd
                    strd = sdRy{s,:};
                    % get braking force (largest magnitude)
                    [rbrk,imin] = min(strd);
                    % get propulsion force peak
                    [rpsh, imax] = max(strd);
                    % get propuslion impulse
                    ify0 = find(strd(imin:imax)>0,1,'first') + imin - 1;
                    rimp = trapz(strd(ify0:end));
                end
                % left foot
                for s = 1:size(sdRy,1)
                    clear strd
                    strd = sdLy{s,:};
                    % get braking force (largest magnitude)
                    [lbrk(s),imin] = min(strd);
                    % get propulsion force peak
                    [lpsh(s), imax] = max(strd);
                    % get propuslion impulse
                    ify0(s) = find(strd(imin:imax)>0,1,'first') + imin - 1;
                    limp(s) = trapz(strd(ify0:end));
                end
                % get asymmetry
                if subject.fastleg == 1 % right leg is fast
                    asymbrk = (rbrk - lbrk)./(rbrk + lbrk);
                    asympsh = (rpsh - lpsh)./(rpsh + lpsh);
                    asymimp = (rimp - limp)./(rimp + limp);
                else
                    asymbrk = (lbrk - rbrk)./(rbrk + lbrk);
                    asympsh = (lpsh - rpsh)./(rpsh + lpsh);
                    asymimp = (limp - rimp)./(rimp + limp);
                end
                % save the metrics
                F{subj}.rbrakey{effcond,blk} = rbrk;
                F{subj}.lbrakey{effcond,blk} = lbrk;
                F{subj}.rpushoffy{effcond,blk} = rpsh;
                F{subj}.lpushoffy{effcond,blk} = lpsh;
                F{subj}.rpsuhimpulse{effcond,blk} = rimp;
                F{subj}.lpushimpulse{effcond,blk} = limp;
                asym(subj).brakeforcey{effcond,blk} = asymbrk;
                asym(subj).pushforcey{effcond,blk} = asympsh;
                asym(subj).pushimpulsey{effcond,blk} = asymimp;
                asymlength(subj,effcond,blk) = min([length(asymbrk),length(asympsh),length(asymimp)]);
            end
        
            if plotindividual
                if blk == 4 || blk == 6
                    if blk == 4
                        j = 1;
                    else
                        j = 2;
                    end
                    figure(subj); sgtitle(subject.list(subj))
                    subplot(3,2,j); hold on;
                    plot(asym(subj).brakeforcey{effcond,blk},'Color',colors.all{effcond,1});
                    xlabel('stride'); ylabel('braking force asymmetry Fy')
                    title({'blk: ', num2str(blk)})

                    subplot(3,2,j+2); hold on;
                    plot(asym(subj).pushforcey{effcond,blk},'Color',colors.all{effcond,1});
                    xlabel('stride'); ylabel('push off asymmetry Fy')
                    title({'blk: ', num2str(blk)})

                    subplot(3,2,j+4); hold on;
                    plot(asym(subj).pushimpulsey{effcond,blk},'Color',colors.all{effcond,1});
                    xlabel('stride'); ylabel('pushoff impulse Fyt asymmetry')
                    title(['blk: ', num2str(blk)])
                end
            end
        end 
    end
end
% build asymmetry matrix
for subj = 1:subject.n
    for effcond = 1:2
        for blk = subject.nblk
            trimasym = min(asymlength(:,effcond,blk));
            asym_all.brakingFy(subj,:) = asym(subj).brakeforcey{effcond,blk}(1:trimasym);
            asym_all.pushoffFy(subj,:) = asym(subj).pushforcey{effcond,blk}(1:trimasym);
            asym_all.pushimpulseFy(subj,:) = asym(subj).pushimpulsey{effcond,blk}(1:trimasym);
        end
    end
end

for effcond = 1:2
    i = 1;
    for blk = [4 6]
        figure(333); subplot(1,2,i); hold on;
        plot_with_stderr(1:size(asym_all.brakingFy,2),asym_all.brakingFy,colors.all{effcond,1});
        i = i+1;
        xlabel('stride')
        ylabel('asymmetry')
        title(['blk: ' num2str(blk)]);
        sgtitle('braking force asymmetry Fy')
    end
end

            

% [FtRint, FtLint] = getFzTimeIntegral(continuousDataR,continuousDataL,continuosDataTime, hsR, hsL)