% TM2_04R_forR
clear Rmat
global F asym
i = 1;
colnames = {'subj' 'effortcondition' 'stepnumber' 'slasym' 'leglength' ...
    'mass' 'addedmass' 'stasym' 'maxstepnumber' 'exposure'};
for subj = 1:subject.n
    % learning
    effcond = subject.order(subj,1); % first visit only for now
    if effcond == 0 
        effcond = 3;
    end
    for blk = 4 % LEARNING first visit
        clear slasym stasym
        slasym = asym(subj).steplength{effcond,blk};
        stasym = asym(subj).steptime{effcond,blk};
        for istep = 1:length(slasym)
            % subj
            Rmat(i,1) = subj;
            % effort condition
            Rmat(i,2) = effcond;
            % step number
            Rmat(i,3) = istep;
            % slasym
            Rmat(i,4) = slasym(istep);
            % leg length
            Rmat(i,5) = subject.leglength(subj);
            % bodyweight
            Rmat(i,6) = subject.mass(subj);
            % added mass
            if effcond == 1
                Rmat(i,7) = subject.highmass(subj);
            elseif effcond == 2
                Rmat(i,7) = subject.lowmass(subj);
            else
                Rmat(i,7) = 0;
            end
            % step time
            Rmat(i,8) = stasym(istep);
            % max stepnumber
            Rmat(i,9) = length(slasym);
            % exposure
            Rmat(i,10) = 1;
            % increment
            i = i + 1;
        end
    end
    for blk = 6 % SAVINGS first visit
        clear slasym stasym
        slasym = asym(subj).steplength{effcond,blk};
        stasym = asym(subj).steptime{effcond,blk};
        for istep = 1:length(slasym)
            % subj
            Rmat(i,1) = subj;
            % effort condition
            Rmat(i,2) = effcond;
            % step number
            Rmat(i,3) = istep;
            % slasym
            Rmat(i,4) = slasym(istep);
            % leg length
            Rmat(i,5) = subject.leglength(subj);
            % bodyweight
            Rmat(i,6) = subject.mass(subj);
            % added mass
            if effcond == 1
                Rmat(i,7) = subject.highmass(subj);
            elseif effcond == 2
                Rmat(i,7) = subject.lowmass(subj);
            else
                Rmat(i,7) = 0;
            end
            % step time
            Rmat(i,8) = stasym(istep);
            % max stepnumber
            Rmat(i,9) = length(slasym);
            % exposure
            Rmat(i,10) = 2;
            % increment
            i = i + 1;
        end
    end
    % SECOND VISIT
    effcond = subject.order(subj,2); % CONDITION second visit
    if effcond == 0 
        % do nothing
    else
        for blk = 4 % LEARNING first visit
            clear slasym stasym
            slasym = asym(subj).steplength{effcond,blk};
            stasym = asym(subj).steptime{effcond,blk};
            for istep = 1:length(slasym)
                % subj
                Rmat(i,1) = subj;
                % effort condition
                Rmat(i,2) = effcond;
                % step number
                Rmat(i,3) = istep;
                % slasym
                Rmat(i,4) = slasym(istep);
                % leg length
                Rmat(i,5) = subject.leglength(subj);
                % bodyweight
                Rmat(i,6) = subject.mass(subj);
                % added mass
                if effcond == 1
                    Rmat(i,7) = subject.highmass(subj);
                elseif effcond == 2
                    Rmat(i,7) = subject.lowmass(subj);
                else
                    Rmat(i,7) = 0;
                end
                % step time
                Rmat(i,8) = stasym(istep);
                % max stepnumber
                Rmat(i,9) = length(slasym);
                % exposure
                Rmat(i,10) = 3;
                % increment
                i = i + 1;
            end
        end
        for blk = 6 % SAVINGS second visit
            clear slasym stasym
            slasym = asym(subj).steplength{effcond,blk};
            stasym = asym(subj).steptime{effcond,blk};
            for istep = 1:length(slasym)
                % subj
                Rmat(i,1) = subj;
                % effort condition
                Rmat(i,2) = effcond;
                % step number
                Rmat(i,3) = istep;
                % slasym
                Rmat(i,4) = slasym(istep);
                % leg length
                Rmat(i,5) = subject.leglength(subj);
                % bodyweight
                Rmat(i,6) = subject.mass(subj);
                % added mass
                if effcond == 1
                    Rmat(i,7) = subject.highmass(subj);
                elseif effcond == 2
                    Rmat(i,7) = subject.lowmass(subj);
                else
                    Rmat(i,7) = 0;
                end
                % step time
                Rmat(i,8) = stasym(istep);
                % max stepnumber
                Rmat(i,9) = length(slasym);
                % exposure
                Rmat(i,10) = 4;
                % increment
                i = i + 1;
            end
        end
    end
end
labeled_Rmat = array2table(Rmat,'VariableNames', colnames);
writetable(labeled_Rmat,'Rmat_v1.csv')
fprintf('mat made')
            
    
