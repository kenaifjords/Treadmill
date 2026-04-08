function make_Rfmet_file(phase,phasevar,names,varnames,subject_order)
% phase and phasevar is 5 dimensional: subj, effcond, blk, metric, phase)
%% get col names
phasenames = {'initial' 'early' 'late' 'plateau' 'across'};
colnames = {'subj' 'effortcondition' 'block' 'visit'};
for i = 1:length(names)
    for j = 1:size(phase,5)
        colnames1(j) = strcat(names{i},'_', phasenames{j});
    end
    for j = 1:size(phase,5)
        colnames2(j) = strcat(varnames{i},'_', phasenames{j});
    end
    colnames = [colnames, colnames1, colnames2];
end

% size(phase)
%% make R
i = 1;
for subj = 1:size(phase,1)
    order = subject_order(subj,:);
    if order(1) == 0
        order = 3;
    elseif order(2) == 0
        order = order(1);
    end
    for effcond = order %size(phase,2)
        for blk = 1:size(phase,3)
            j = 5;
            R(i,:) = NaN(1,214);
            for met = 1:size(phase,4) % this is what is stored in names
                R(i,1) = subj;
                R(i,2) = effcond;
                R(i,3) = blk;
                if order(1) == effcond % visit 1
                    R(i,4) = 1;
                elseif length(order) == 2 && order(2) == effcond
                    R(i,4) = 2;
                end
                for iph = 1:size(phase,5)
                    R(i,j) = phase(subj,effcond,blk,met,1);
                    R(i,j+1) = phase(subj,effcond,blk,met,2);
                    R(i,j+2) = phase(subj,effcond,blk,met,3);
                    R(i,j+3) = phase(subj,effcond,blk,met,4);
                    R(i,j+4) = phase(subj,effcond,blk,met,5);
                    R(i,j+5) = phasevar(subj,effcond,blk,met,1);
                    R(i,j+6) = phasevar(subj,effcond,blk,met,2);
                    R(i,j+7) = phasevar(subj,effcond,blk,met,3);
                    R(i,j+8) = phasevar(subj,effcond,blk,met,4);
                    R(i,j+9) = phasevar(subj,effcond,blk,met,5);
                end
                j = j + 10;
            end
            i = i + 1;
        end
    end
end
%%
labeled_Rmat = array2table(R,'VariableNames', colnames);
writetable(labeled_Rmat,'Rforcephase_var.csv')
fprintf('mat made')

%% R#light
% no variability and removing unused force metrics % no longer indexed
% correctly
% R_lite = labeled_Rmat(:,[1:4 10:19 25:34 40:44 55:59 65:74]);
% writetable(R_lite,'Rforcephase_lite.csv')
% fprintf('R#lite mat made')