% TM2_04R_forR
clear Rmat
global F asym
i = 1;
colnames = {'subj' 'effortcondition' 'stridenumber' 'slasym' 'normaddedmass'...
    'arctanhsla'}; %'stasym' 'maxstepnumber' 'exposure' 'height'...
%     'fastleg', 'exposeinday','twovisitsubject'};
for subj = 1:subject.n
    % learning
    effcond = subject.order(subj,1); % first visit only for now
    if effcond == 0 
        effcond = 3;
    end
    if subject.order(subj,2) ~= 0 
        twovisitsubj = 1;
    else
        twovisitsubj = 0;
    end
    for blk = [4] % LEARNING first visit
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
%             % leg length
%             Rmat(i,5) = subject.leglength(subj);
%             % bodyweight
%             Rmat(i,6) = subject.mass(subj);
            % added mass
            if effcond == 1
                Rmat(i,5) = subject.highmass(subj)/subject.mass(subj);
            elseif effcond == 2
                Rmat(i,5) = subject.lowmass(subj)/subject.mass(subj);
            else
                Rmat(i,5) = 0;
            end
            % arctanhsla
            Rmat(i,6) = 1/2 * (1 + slasym(istep))/(1 - slasym(istep));
%             % step time
%             Rmat(i,8) = stasym(istep);
%             % max stepnumber
%             Rmat(i,9) = length(slasym);
%             % exposure
%             if blk == 4
%                 Rmat(i,10) = 1;
%             else
%                 Rmat(i,10) = 2;
%             end
%             % height
%             Rmat(i,11) = subject.height(subj);
%             % fastleg
%             Rmat(i,12) = subject.fastleg(subj);
%             % exposure number in a day
%             if blk == 4
%                 Rmat(i,13) = 1;
%             else
%                 Rmat(i,13) = 2;
%             end
%             % does the subject visit twice
%             Rmat(i,14) = twovisitsubj;
            % increment
            i = i + 1;
        end
    end
    % SECOND VISIT
end
labeled_Rmat = array2table(Rmat,'VariableNames', colnames);
writetable(labeled_Rmat,'Pymat_v0.csv')
fprintf('mat made')
            
    
