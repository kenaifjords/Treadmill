% TM2_04_forceandimpulseasymmetry
tic
global F p asym colors subject asym_all asym_all_cell
clear brake push impulse heelFz minstanceFz toeFz
plotindividualy = 0; plotindividualz = 0;
normtobodymass = 0;
normtoslowbaseline = 0;
dt = 1/100;
for subj = 1:subject.n
%     if subject.order(subj,:) == [0 0]
%         effuse = 3;
%     else
%         if size(F(subj).R,1) < 2
%             effuse = 1;
%         else
%             effuse = 1:2;
%         end
%     end
    %% braking push off and impulse
    for effcond = 1:size(F(subj).R,1)
        if normtoslowbaseline
            blk = 2;
            normyr = mean(F(subj).R{effcond,blk}(:,2),'omitnan');
            normyl = mean(F(subj).L{effcond,blk}(:,2),'omitnan');
        end
        for blk = 1:size(F(subj).R,2) %subject.nblk
            if(isempty(F(subj).R{effcond,blk}))
                break
            end
            clear fyr fyl fzr fzl ftime sdRy sdLy sdRz sdLz
            clear ify ify0 rimp limp rbrk lbrk rpsh lpsh
            clear asymbrk asympsh asymimp
            
            fyr = F(subj).R{effcond,blk}(:,2);
            fyl = F(subj).L{effcond,blk}(:,2);
            if normtobodymass
                fyr = fyr./subject.mass(subj);
                fyl = fyl./subject.mass(subj);
            end
            time = F(subj).time{effcond,blk};
            hsR = F(subj).hsR{effcond,blk};
            hsL = F(subj).hsL{effcond,blk};
            rfirst = F(subj).rfirst{effcond,blk};

            rvalid = F(subj).validstepR{effcond,blk};
            lvalid = F(subj).validstepL{effcond,blk};
            %% get braking and propulsion peak force
            %% get stride data for y-forces
            if ~isempty(hsR) && ~isempty(hsL)
                [sdRy, sdLy] = getStrideDataCell_valid(fyr,fyl,subj,effcond,blk);
                 minhs = min([size(sdRy,1) size(sdLy,1)]);
                % right foot
                for s = 1:minhs
                    clear strd
                    strd = sdRy{s,:};
                    if isempty(strd)|| length(strd) < 5
                        rbrk(s) = NaN;
                        rpsh(s) = NaN;
                        rimp(s) = NaN;
                    else
                        % get braking force (largest magnitude)
                        [rbrk(s),imin] = min(strd);
                        % get propulsion force peak
                        [rpsh(s), imax] = max(strd);
                        % get propuslion impulse
                        ify = find(strd(imin:imax)>0,1,'first') + imin - 1;
                        if ~isempty(ify)
                            ify0(s) = ify;
                            rimp(s) = trapz(strd(ify0(s):end))*dt;
                        else
                            ify0(s) = NaN;
                            rimp(s) = NaN;
                        end
                    end
                end
                % left foot
                for s = 1:minhs
                    clear strd
                    strd = sdLy{s,:};
                    if isempty(strd) || length(strd) < 5
                        lbrk(s) = NaN;
                        lpsh(s) = NaN;
                        limp(s) = NaN;
                    else
                        % get braking force (largest magnitude)
                        [lbrk(s),imin] = min(strd);
                        % get propulsion force peak
                        [lpsh(s), imax] = max(strd);
                        % get propuslion impulse
                        ify = find(strd(imin:imax)>0,1,'first') + imin - 1;
                        if ~isempty(ify)
                            ify0(s) = ify;
                            limp(s) = trapz(strd(ify0(s):end))*dt;
                        else
                            ify0(s) = NaN;
                            limp(s) = NaN;
                        end
                    end
                end
                % get asymmetry
                if subject.fastleg(subj) == 1 % right leg is fast
                    asymbrk = (rbrk - lbrk)./(rbrk + lbrk);
                    asympsh = (rpsh - lpsh)./(rpsh + lpsh);
                    asymimp = (rimp - limp)./(rimp + limp);
                else
                    asymbrk = (lbrk - rbrk)./(rbrk + lbrk);
                    asympsh = (lpsh - rpsh)./(rpsh + lpsh);
                    asymimp = (limp - rimp)./(rimp + limp);
                end
                % save the metrics
                F(subj).rbrakey{effcond,blk} = rbrk;
                F(subj).lbrakey{effcond,blk} = lbrk;
                F(subj).rpushoffy{effcond,blk} = rpsh;
                F(subj).lpushoffy{effcond,blk} = lpsh;
                F(subj).rpsuhimpulse{effcond,blk} = rimp;
                F(subj).lpushimpulse{effcond,blk} = limp;
                asym(subj).brakeforcey{effcond,blk} = asymbrk;
                asym(subj).pushforcey{effcond,blk} = asympsh;
                asym(subj).pushimpulsey{effcond,blk} = asymimp;
%                 ib = find(~isnan(asymbrk),1,'last');
%                 ip = find(~isnan(asympsh),1,'last');
%                 ii = find(~isnan(asymimp),1,'last');
                asymlengthy (subj,effcond,blk) = min([length(asymbrk),...
                    length(asympsh),length(asymimp)]);% min([ib,ip,ii]); %min([length(asymbrk),length(asympsh),length(asymimp)]);
                asymlengthy(asymlengthy == 0) = NaN;
            else
                asymlengthy(subj,effcond,blk) = NaN;
            end
        
            if plotindividualy % subj == 9 % 

                    figure(subj); sgtitle(subject.list(subj))
                    subplot(2,subject.nblk,blk); hold on;
                    plot(F(subj).rbrakey{effcond,blk},'g.');
                    plot(F(subj).lbrakey{effcond,blk},'r.');
                    title({'blk: ', num2str(blk)})
                    xlabel('stride'); ylabel('braking force asymmetry Fy')
                    
                    subplot(2,subject.nblk,blk+subject.nblk); hold on;
                    plot(asym(subj).brakeforcey{effcond,blk},'Color',colors.all{effcond,1});
                    xlabel('stride'); ylabel('braking force asymmetry Fy')
                    
%                     figure(subj*100); subplot(3,2,j+2); hold on;
%                     plot(asym(subj).pushforcey{effcond,blk},'Color',colors.all{effcond,1});
%                     xlabel('stride'); ylabel('push off asymmetry Fy')
%                     title({'blk: ', num2str(blk)})
% 
%                     subplot(3,2,j+4); hold on;
%                     plot(asym(subj).pushimpulsey{effcond,blk},'Color',colors.all{effcond,1});
%                     xlabel('stride'); ylabel('pushoff impulse Fyt asymmetry')
%                     title(['blk: ', num2str(blk)])
            end
        end % blk
    end % effcond
end % subj
%% peak grf
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2) % subject.nblk
            if isempty(F(subj).R{effcond,blk})  
                break
            end
            clear fzr fzl fyr fyl ftime sdRz sdLz
            clear ycross ymin  ymax rheelf lheelf rtoef ltoef rminf lminf
            clear asymheel asymtoe asymmin
            time = F(subj).time{effcond,blk};
            fzr = F(subj).R{effcond,blk}(:,3);
            fzl = F(subj).L{effcond,blk}(:,3);
            fyr = F(subj).R{effcond,blk}(:,2);
            fyl = F(subj).L{effcond,blk}(:,2);
            if normtobodymass
                fzr = fzr./subject.mass(subj);
                fzl = fzl./subject.mass(subj);
                fyr = fyr./subject.mass(subj);
                fyl = fyl./subject.mass(subj);
            end
            hsR = F(subj).hsR{effcond,blk};
            hsL = F(subj).hsL{effcond,blk};
            rfirst = F(subj).rfirst{effcond,blk};

            rvalid = F(subj).validstepR{effcond,blk};
            lvalid = F(subj).validstepL{effcond,blk};

            if ~isempty(hsR) && ~isempty(hsL)
                [sdRz, sdLz] = getStrideDataCell_valid(fzr,fzl,subj,effcond,blk);
                [sdRy, sdLy] = getStrideDataCell_valid(fyr,fyl,subj,effcond,blk);
                minhs = min([size(sdRz,1) size(sdLz,1),size(sdRy,1) size(sdLy,1)]);
                % right foot
                for s = 1:minhs
                    clear strd strdy ymin ymax ycross0
                    strd = sdRz{s,:};
                    strdy = sdRy{s,:};
                    if isempty(strd)|| length(strd) < 5
                        rheelf(s) = NaN;
                        rminf(s) = NaN;
                        rtoef(s) = NaN;
                    else
                        % determine the point where Y-forces crosses 0 -
                        % this will allow us to separate heel strike z 
                        % force from push off z force
                        [~,ymin] = min(strdy);
                        [~,ymax] = max(strdy);
                        ycross0 = find(strdy(ymin:ymax)>0,1,'first') + ymin - 1;
                        if ~isempty(ycross0) && ~isempty(ymin) && ~isempty(ymax)
                            % get braking grfz
                            [rheelf(s),~] = max(strd(1:ycross0));
                            % get toe off grfz
                            [rtoef(s),~] = max(strd(ycross0:end));
                            % get min stance grfz
                            [rminf(s),~] = min(strd(ymin:ymax));
                        else
                            rheelf(s) = NaN;
                            rtoef(s) = NaN;
                            rminf(s) = NaN;
                        end
                    end
                end
                % left foot
                for s = 1:minhs
                    clear strd strdy ymin ymax ycross0
                    strd = sdLz{s,:};
                    strdy = sdLy{s,:};
                    if isempty(strd)|| length(strd) < 5
                        lheelf(s) = NaN;
                        lminf(s) = NaN;
                        ltoef(s) = NaN;
                    else
                        % determine the point where Y-forces crosses 0 -
                        % this will allow us to separate heel strike z 
                        % force from push off z force
                        [~,ymin] = min(strdy);
                        [~,ymax] = max(strdy);
                        ycross0 = find(strdy(ymin:ymax)>0,1,'first') + ymin - 1;
                        if ~isempty(ycross0) && ~isempty(ymin) && ~isempty(ymax)
                            % get braking grfz
                            [lheelf(s),~] = max(strd(1:ycross0));
                            % get toe off grfz
                            [ltoef(s),~] = max(strd(ycross0:end));
                            % get min stance grfz
                            [lminf(s),~] = min(strd(ymin:ymax));
                        else
                            lheelf(s) = NaN;
                            ltoef(s) = NaN;
                            lminf(s) = NaN;
                        end
                    end
                end
                % get asymmetry
                if subject.fastleg(subj) == 1 % right leg is fast
                    asymheel = (rheelf - lheelf)./(rheelf + lheelf);
                    asymmin= (rminf - lminf)./(rminf + lminf);
                    asymtoe = (rtoef - ltoef)./(rtoef + ltoef);
                else
                    asymheel = (lheelf - rheelf)./(rheelf + lheelf);
                    asymmin= (lminf - rminf)./(rminf + lminf);
                    asymtoe = (ltoef - rtoef)./(rtoef + ltoef);
                end
                % save the metrics
                F(subj).rpeakhsz{effcond,blk} = rheelf;
                F(subj).lpeakhsz{effcond,blk} = lheelf;
                F(subj).rstanceminz{effcond,blk} = rminf;
                F(subj).lstanceminz{effcond,blk} = lminf;
                F(subj).rpeaktoz{effcond,blk} = rtoef;
                F(subj).lpeaktoz{effcond,blk} = ltoef;
                asym(subj).heelstrikeFz{effcond,blk} = asymheel;
                asym(subj).minstanceFz{effcond,blk} = asymmin;
                asym(subj).toeoffFz{effcond,blk} = asymtoe;
%                 ih = find(~isnan(asymheel),1,'last');
%                 im = find(~isnan(asymmin),1,'last');
%                 it = find(~isnan(asymtoe),1,'last');
                asymlengthz(subj,effcond,blk) = min([length(asymheel),length(asymmin),length(asymtoe)]);% min([ih,im,it]); %
                asymlengthz(asymlengthz == 0) = NaN;
            else
                asymlengthz(subj,effcond,blk) = NaN;
            end
        
            if plotindividualz %subj == 13 %

                    figure(subj); sgtitle(subject.list(subj))
                    subplot(2,subject.nblk,blk); hold on;
                    plot(F(subj).rpeakhsz{effcond,blk},'g.');
                    plot(F(subj).lpeakhsz{effcond,blk},'r.');
                    title({'blk: ', num2str(blk)})
                    xlabel('stride');
                    
                    subplot(2,subject.nblk,blk+subject.nblk); hold on;
                    plot(asym(subj).heelstrikeFz{effcond,blk},'Color',colors.all{effcond,1});
                    xlabel('stride'); ylabel('heelstrike peak Fz')
                    
%                     figure(subj*100); subplot(3,2,j+2); hold on;
%                     plot(asym(subj).pushforcey{effcond,blk},'Color',colors.all{effcond,1});
%                     xlabel('stride'); ylabel('push off asymmetry Fy')
%                     title({'blk: ', num2str(blk)})
% 
%                     subplot(3,2,j+4); hold on;
%                     plot(asym(subj).pushimpulsey{effcond,blk},'Color',colors.all{effcond,1});
%                     xlabel('stride'); ylabel('pushoff impulse Fyt asymmetry')
%                     title(['blk: ', num2str(blk)])
            end
        end % blk
    end % effcond
end % subj


%% build asymmetry matrix
for subj = 1:subject.n
    for effcond = 1:size(F(subj).R,1)
        for blk = 1:size(F(subj).R,2) %subject.nblk
            if isempty(F(subj).R{effcond,blk})
                break
            end
            % y force
            trimasym = min(asymlengthy(:,:,blk),[],'all');
            brk = asym(subj).brakeforcey{effcond,blk};
            psh = asym(subj).pushforcey{effcond,blk};
            imp = asym(subj).pushimpulsey{effcond,blk};
            if ~isempty(brk)
                asym_all.brakingFy{effcond,blk}(subj,:) = brk(1:trimasym);
                % asym_all_cell(effcond,blk).brakingFy{subj,1} = brk;
                if normtobodymass
                    normfyr = subject.mass(subj);
                    normfyl = normfyr;
                elseif normtoslowbaseline
                    normfyr = mean(F(subj).rbrakey{effcond,3},'omitnan');
                    normfyl = mean(F(subj).lbrakey{effcond,3},'omitnan');
                else
                    normfyr = 1; normfyl = 1;
                end
                if subject.fastleg(subj) == 1
                    fast_all.brakingFy{effcond,blk}(subj,:) = F(subj).rbrakey{effcond,blk}(1:trimasym)./normfyr;
                    slow_all.brakingFy{effcond,blk}(subj,:) = F(subj).lbrakey{effcond,blk}(1:trimasym)./normfyl;
                else
                    fast_all.brakingFy{effcond,blk}(subj,:) = F(subj).lbrakey{effcond,blk}(1:trimasym)./normfyl;
                    slow_all.brakingFy{effcond,blk}(subj,:) = F(subj).rbrakey{effcond,blk}(1:trimasym)./normfyr;
                end
            end
            if ~isempty(psh)
                asym_all.pushoffFy{effcond,blk}(subj,:) = psh(1:trimasym);
                % asym_all_cell(effcond,blk).pushoffFy{subj,1} = psh;
                if normtoslowbaseline
                    normfyr = mean(F(subj).rpushoffy{effcond,3},'omitnan');
                    normfyl = mean(F(subj).lpushoffy{effcond,3},'omitnan');
                else
                    normfyr = 1; normfyl = 1;
                end
                if subject.fastleg(subj) == 1
                    fast_all.pushFy{effcond,blk}(subj,:) = F(subj).rpushoffy{effcond,blk}(1:trimasym)./normfyr;
                    slow_all.pushFy{effcond,blk}(subj,:) = F(subj).lpushoffy{effcond,blk}(1:trimasym)./normfyl;
                else
                    fast_all.pushFy{effcond,blk}(subj,:) = F(subj).lpushoffy{effcond,blk}(1:trimasym)./normfyl;
                    slow_all.pushFy{effcond,blk}(subj,:) = F(subj).rpushoffy{effcond,blk}(1:trimasym)./normfyr;
                end
            end
            if ~ isempty(imp)
                asym_all.pushimpulseFy{effcond,blk}(subj,:) = imp(1:trimasym);
                % asym_all_cell(effcond,blk).pushimpulseFy{subj,1} = imp;
            end
            % z force
            trimasym = min(asymlengthz(:,:,blk),[],'all');
            heel = asym(subj).heelstrikeFz{effcond,blk};
            toe = asym(subj).toeoffFz{effcond,blk};
            minf = asym(subj).minstanceFz{effcond,blk};
            if ~isempty(heel)
                asym_all.heelFz{effcond,blk}(subj,:) = heel(1:trimasym);
                % asym_all_cell(effcond,blk).heelFz{subj,1} = heel;
            end
            if ~isempty(minf)
                asym_all.minstanceFz{effcond,blk}(subj,:) = minf(1:trimasym);
                % asym_all_cell(effcond,blk).minstanceFz{subj,1} = minf;
            end
            if ~ isempty(toe)
                asym_all.toeFz{effcond,blk}(subj,:) = toe(1:trimasym);
                % asym_all_cell(effcond,blk).toeFz{subj,1} = toe;
            end
        end
    end
end
asym_all.asymlengthy = asymlengthy;
asym_all.asymlengthz = asymlengthz;

acount = 1; bcount = 1; ccount = 1;
% %% sort into effort condition and visit order
% % y forces
% % braking
% [brake.hfirst,brake.lfirst,brake.hsecond,brake.lsecond,brake.control] = ...
%     sortbyEffortVisitorder(asym_all.brakingFy);
% 
% % braking per leg
% [fastlegbrake.hfirst,fastlegbrake.lfirst,fastlegbrake.hsecond,fastlegbrake.lsecond,fastlegbrake.control] = ...
%     sortbyEffortVisitorder(fast_all.brakingFy);
% [slowlegbrake.hfirst,slowlegbrake.lfirst,slowlegbrake.hsecond,slowlegbrake.lsecond,slowlegbrake.control] = ...
%     sortbyEffortVisitorder(slow_all.brakingFy);
% 
% % propulsion
% [push.hfirst,push.lfirst,push.hsecond,push.lsecond,push.control] = ...
%     sortbyEffortVisitorder(asym_all.pushoffFy);
% 
% % propulsion per leg
% [fastlegpush.hfirst,fastlegpush.lfirst,fastlegpush.hsecond,fastlegpush.lsecond,fastlegpush.control] = ...
%     sortbyEffortVisitorder(fast_all.pushFy);
% [slowlegpush.hfirst,slowlegpush.lfirst,slowlegpush.hsecond,slowlegpush.lsecond,slowlegpush.control] = ...
%     sortbyEffortVisitorder(slow_all.pushFy);
% 
% [impulse.hfirst,impulse.lfirst,impulse.hsecond,impulse.lsecond,impulse.control] = ...
%     sortbyEffortVisitorder(asym_all.pushimpulseFy);
% % z forces
% [heelFz.hfirst,heelFz.lfirst,heelFz.hsecond,heelFz.lsecond,heelFz.control] = ...
%     sortbyEffortVisitorder(asym_all.heelFz);
% [minstanceFz.hfirst,minstanceFz.lfirst,minstanceFz.hsecond,minstanceFz.lsecond,minstanceFz.control] = ...
%     sortbyEffortVisitorder(asym_all.minstanceFz);
% [toeFz.hfirst,toeFz.lfirst,toeFz.hsecond,toeFz.lsecond,toeFz.control] = ...
%     sortbyEffortVisitorder(asym_all.toeFz);
% %% PLOT
% 
% blkinclude = 4:6; %2:6;
% % braking force
% figure(1000)
% plotAsymmetryCurves(blkinclude,'braking force asym',brake);
% 
% % braking forces before asym
% figure(101); hold on;
% plotFastSlowCompareCurves(blkinclude,...
%     'braking force on first visit',...
%     fastlegbrake,slowlegbrake);
% figure(111); hold on;
% plotFastSlowCompareCurves(4,'First exposure braking force (norm to baseline slow',...
%     fastlegbrake,slowlegbrake);
% 
% % push off force
% figure(1001);
% plotAsymmetryCurves(blkinclude,'push off force Y (N)',push);
% 
% % push off forces before asym
% figure(102); hold on;
% plotFastSlowCompareCurves(blkinclude,...
%     'push off force on first visit',...
%     fastlegpush,slowlegpush);
% 
% % push off impulse
% figure(1002);
% plotAsymmetryCurves(blkinclude,'push off impulse Y (Ns)',impulse);
% % heelstrike Zforce
% figure(1003);
% plotAsymmetryCurves(blkinclude,'heelstrike peak Fz (N)',heelFz);
% % minstance fz
% figure(1004);
% plotAsymmetryCurves(blkinclude,'minimum stance force (N)',minstanceFz);
% % toeoff Zforce
% figure(1005);
% plotAsymmetryCurves(blkinclude,'toe off FZ (N)',toeFz);

clearvars -except asym asym_all colors F p ID IK subject
toc