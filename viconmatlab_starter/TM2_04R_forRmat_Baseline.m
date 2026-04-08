% TM2_04R_forR
clear Rmat
global F asym
i = 1;
colnames = {'subj' 'effortcondition' 'stepnumber' 'slasym' 'leglength' ...
    'mass' 'addedmass' 'stasym' 'maxstepnumber' 'exposure' 'height'...
    'fastleg', 'exposeinday','last30stride', 'steplengthR','steplengthL'...
    'block','visit'};
for subj = [1:42 44:subject.n]
    % learning
    effcond = subject.order(subj,1); % first visit only for now
    if effcond == 0 
        effcond = 3;
    end
    for blk = 1:7 %[4,6] % LEARNING first visit
        clear slasym stasym slR slL
        slasym = asym(subj).steplength{effcond,blk};
        stasym = asym(subj).steptime{effcond,blk};
        SLR = F(subj).steplengthR{effcond,blk};
        SLL = F(subj).steplengthL{effcond,blk};
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
            if blk == 4
                Rmat(i,10) = 1;
            elseif blk == 6
                Rmat(i,10) = 2;
            else
                Rmat(i,10) = 0;
            end
            % height
            Rmat(i,11) = subject.height(subj);
            % fastleg
            Rmat(i,12) = subject.fastleg(subj);
            % exposure number in a day
            if blk == 4
                Rmat(i,13) = 1;
            elseif blk == 6
                Rmat(i,13) = 2;
            else
                Rmat(i,13) = 0;
            end
            % last 30 strides
            if istep > length(slasym) - 30
                Rmat(i,14) = 1;
            else
                Rmat(i,14) = 0;
            end
            % steplengthR
            if isempty(SLR) || isempty(SLL)
                Rmat(i,15) = NaN;
                Rmat(i,16) = NaN;
            else
                Rmat(i,15) = SLR(istep);
                % steplengthL
                Rmat(i,16) = SLL(istep);
            end
            % block
            Rmat(i,17) = blk;
            % visit
            Rmat(i,18) = 1;
            % increment
            i = i + 1;
        end
    end
    % SECOND VISIT
    effcond = subject.order(subj,2); % CONDITION second visit
    if effcond == 0 
        % do nothing
    else
        for blk = [4,6] % LEARNING first visit
            clear slasym stasym
            slasym = asym(subj).steplength{effcond,blk};
            stasym = asym(subj).steptime{effcond,blk};
            SLR = F(subj).steplengthR{effcond,blk};
            SLL = F(subj).steplengthL{effcond,blk};
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
                if blk == 4
                    Rmat(i,10) = 3;
                elseif blk == 6
                    Rmat(i,10) = 2;
                else
                    Rmat(i,10) = 0;
                end
                % height
                Rmat(i,11) = subject.height(subj);
                % fastleg
                Rmat(i,12) = subject.fastleg(subj);
                % exposure number in a day
                if blk == 4
                    Rmat(i,13) = 1;
                elseif blk == 6
                    Rmat(i,13) = 2;
                else
                    Rmat(i,13) = 0;
                end
                % last 30 strides
                if istep > length(slasym) - 30
                    Rmat(i,14) = 1;
                else
                    Rmat(i,14) = 0;
                end
                % steplength
                if isempty(SLR) || isempty(SLL)
                    Rmat(i,15) = NaN;
                    Rmat(i,16) = NaN;
                else
                    Rmat(i,15) = SLR(istep);
                    % steplengthL
                    Rmat(i,16) = SLL(istep);
                end
                % block
                Rmat(i,17) = blk;
                % visit
                Rmat(1,18) = 2;
                % increment
                i = i + 1;
            end
        end
    end
end
labeled_Rmat = array2table(Rmat,'VariableNames', colnames);
writetable(labeled_Rmat,'Rmat_allblk.csv')
fprintf('mat made')
            
    
