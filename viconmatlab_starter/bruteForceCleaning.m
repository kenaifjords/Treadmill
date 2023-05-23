%% bruteForceCleaning 
%%% force threshold at 200 %%%
%
%% for MAC (1)
if strcmp(subject.list(subj),'MAC')
    if effcond == 1
        if blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
        end
    elseif effcond == 2
        if blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    end
end
%% for BAN (2)      
if strcmp(subject.list(subj),'BAN')
    if effcond == 1
        if blk == 4
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 6
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
        end
    elseif effcond == 2
        if blk == 7
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    end
end

%% for MLL (3)
if strcmp(subject.list(subj),'MLL')
    if effcond == 1
        if blk == 2
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    elseif effcond == 2
        if blk == 5
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 3
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 2
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    end
end

%% for FUM (4)
if strcmp(subject.list(subj),'FUM')
    if effcond == 1
        if blk == 7
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 6
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
        elseif blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(4:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(4:end);
        elseif blk == 3
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(3:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(3:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(3:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(3:end);
        elseif blk == 2
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    elseif effcond == 2
        if blk == 5
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 3
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 2
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    end
end

%% for QPQ (5)
if strcmp(subject.list(subj),'QPQ')
    if effcond == 1
        if blk == 7
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
        elseif blk == 6
            F(subj).hsL{effcond,blk} = cat(2,F(subj).hsL{effcond,blk}(1:2),...
                F(subj).hsL{effcond,blk}(4:end));
            F(subj).hsL_idx{effcond,blk} = cat(2,F(subj).hsL_idx{effcond,blk}(1:2),...
                F(subj).hsL_idx{effcond,blk}(4:end));
        elseif blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 4
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(3:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(3:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    elseif effcond == 2
        if blk == 6 || blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 3
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(4:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(4:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(4:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(4:end);
        end
    end
end

%% for BAB (6)
if strcmp(subject.list(subj),'BAB')
    if effcond == 1
        if blk == 7
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 3
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end); 
        end
    elseif effcond == 2
        if blk == 7
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(3:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(3:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 6
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(4:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(4:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(4:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(4:end);
        elseif blk == 3
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    end
end

%% for CFL  (7)
if strcmp(subject.list(subj),'CFL')
    if effcond == 1
        if blk == 3
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(3:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(3:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(3:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(3:end);
        end
    elseif effcond == 2
        if blk == 7 || blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
        end
    end
end

%% for COM (8)
if strcmp(subject.list(subj),'COM')
    if effcond == 2
        if blk == 5
            F(subj).hsL{effcond,blk} = cat(2,F(subj).hsL{effcond,blk}(1),...
                F(subj).hsL{effcond,blk}(3:end))
            F(subj).hsL_idx{effcond,blk} = cat(2,F(subj).hsL_idx{effcond,blk}(1),...
                F(subj).hsL_idx{effcond,blk}(3:end));
        elseif blk == 2
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(3:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(3:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    end
end

%% for KJC (9)
if strcmp(subject.list(subj),'COM')
    if effcond == 1
        if blk == 7 || blk == 6 || blk == 3
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(4:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(4:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(4:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(4:end); 
        elseif blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(3:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(3:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(3:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(3:end);
        elseif blk == 2
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    elseif effcond == 2
        if blk == 7 || blk == 6
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(3:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(3:end);
        elseif blk == 3
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
        end
    end
end

%% for LKT (10)
if strcmp(subject.list(subj),'LKT')
    if effcond == 1
        if blk == 5
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 6
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(3:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(3:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(6:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(6:end);
        end
    elseif effcond == 2
        if blk == 7
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 6 || blk == 3
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 1
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
        end
    end
end

%% for HZO (11)
if strcmp(subject.list(subj),'HZO')
    if effcond == 1
        % okay
    elseif effcond == 2
        if blk == 6 || blk == 4
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
        elseif blk == 2
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    end
end

%% for MLU (12)
if strcmp(subject.list(subj),'MLU')
    if effcond == 1
        if blk == 5
            F(subj).hsR{effcond,blk} = cat(2,F(subj).hsR{effcond,blk}(1),...
                F(subj).hsR{effcond,blk}(3:end));
            F(subj).hsR_idx{effcond,blk} = cat(2,F(subj).hsR_idx{effcond,blk}(1),...
                F(subj).hsR_idx{effcond,blk}(3:end));
        end
    elseif effcond == 2
        if blk == 5
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(3:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(3:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(3:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(3:end);
        elseif blk == 4
            F(subj).hsL{effcond,blk} = cat(2,F(subj).hsL{effcond,blk}(1),...
                F(subj).hsL{effcond,blk}(3:end));
            F(subj).hsL_idx{effcond,blk} = cat(2,F(subj).hsL_idx{effcond,blk}(1),...
                F(subj).hsL_idx{effcond,blk}(3:end));
        elseif blk == 3
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(3:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(3:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 1
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    end
end
              
%% for BEO (13)
if strcmp(subject.list(subj),'BEO')
    if effcond == 1
        if blk == 7
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(6:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(6:end);
        elseif blk == 6
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 1
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        end
    elseif effcond == 2
        if blk == 7
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(3:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(3:end); 
        elseif blk == 6 
            F(subj).hsR{effcond,blk} = F(subj).hsR{effcond,blk}(2:end);
            F(subj).hsR_idx{effcond,blk} = F(subj).hsR_idx{effcond,blk}(2:end);
            F(subj).hsL{effcond,blk} = F(subj).hsL{effcond,blk}(2:end);
            F(subj).hsL_idx{effcond,blk} = F(subj).hsL_idx{effcond,blk}(2:end);
        elseif blk == 5
            F(subj).hsL{effcond,blk} = cat(2,F(subj).hsL{effcond,blk}(1),...
                F(subj).hsL{effcond,blk}(3:end));
            F(subj).hsL_idx{effcond,blk} = cat(2,F(subj).hsL_idx{effcond,blk}(1),...
                F(subj).hsL_idx{effcond,blk}(3:end));
        end
    end
end
            
            
            