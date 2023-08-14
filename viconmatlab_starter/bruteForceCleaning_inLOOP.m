%% bruteForceCleaning_inLOOP
%%% force threshold at 200 %%%
%
%% for MAC (1)
if strcmp(subject.list(subj),'MAC')
    if effcond == 1
        if blk == 5
            hsR1 = hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        end
    elseif effcond == 2
        if blk == 5
            hsR1  =  hsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsR1  =  ihsR1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    end
end
%% for BAN (2)      
if strcmp(subject.list(subj),'BAN')
    if effcond == 1
        if blk == 4
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 5
            hsR1  =  hsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsR1  =  ihsR1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 6
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        end
    elseif effcond == 2
        if blk == 7
            hsR1  =  hsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsR1  =  ihsR1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    end
end

%% for MLL (3)
if strcmp(subject.list(subj),'MLL')
    if effcond == 1
        if blk == 2
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    elseif effcond == 2
        if blk == 5
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 3
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 2
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    end
end

%% for FUM (4)
if strcmp(subject.list(subj),'FUM')
    if effcond == 1
        if blk == 7
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 6
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        elseif blk == 5
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(4:end);
            ihsL1  =  ihsL1(4:end);
        elseif blk == 3
            hsR1  =  hsR1(3:end);
            ihsR1  =  ihsR1(3:end);
            hsL1  =  hsL1(3:end);
            ihsL1  =  ihsL1(3:end);
        elseif blk == 2
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    elseif effcond == 2
        if blk == 5
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 3
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 2
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    end
end

%% for QPQ (5)
if strcmp(subject.list(subj),'QPQ')
    if effcond == 1
        if blk == 7
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        elseif blk == 6
            hsL1  =  cat(2,hsL1(1:2),hsL1(4:end)); %F(subj).hsL{effcond,blk}(1:2),F(subj).hsL{effcond,blk}(4:end));
            ihsL1  =  cat(2,ihsL1(1:2),ihsL1(4:end));
        elseif blk == 5
            hsR1  =  hsL1(2:end);
            ihsR1  =  ihsL1(2:end);
        elseif blk == 4
            hsR1  =  hsR1(3:end);
            ihsR1  =  ihsR1(3:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    elseif effcond == 2
        if blk == 6 || blk == 5
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 3
            hsR1  =  hsR1(4:end);
            ihsR1  =  ihsR1(4:end);
            hsL1  =  hsL1(4:end);
            ihsL1  =  ihsL1(4:end);
        end
    end
end

%% for BAB (6)
if strcmp(subject.list(subj),'BAB')
    if effcond == 1
        if blk == 7
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 3
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end); 
        end
    elseif effcond == 2
        if blk == 7
            hsR1  =  hsR1(3:end);
            ihsR1  =  ihsR1(3:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 6
            hsR1  =  hsR1(4:end);
            ihsR1  =  ihsR1(4:end);
            hsL1  =  hsL1(4:end);
            ihsL1  =  ihsL1(4:end);
        elseif blk == 3
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    end
end

%% for CFL  (7)
if strcmp(subject.list(subj),'CFL')
    if effcond == 1
        if blk == 3
            hsR1  =  hsR1(3:end);
            ihsR1  =  ihsR1(3:end);
            hsL1  =  hsL1(3:end);
            ihsL1  =  ihsL1(3:end);
        end
    elseif effcond == 2
        if blk == 7 || blk == 5
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        end
    end
end

%% for COM (8)
if strcmp(subject.list(subj),'COM')
    if effcond == 2
        if blk == 5
            hsL1  =  cat(2,hsL1(1),hsL1(3:end));
            ihsL1  =  cat(2,ihsL1(1),ihsL1(3:end));
        elseif blk == 2
            hsR1  =  hsR1(3:end);
            ihsR1  =  ihsR1(3:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    end
end

%% for KJC (9)
if strcmp(subject.list(subj),'COM')
    if effcond == 1
        if blk == 7 || blk == 6 || blk == 3
            hsR1  =  hsR1(4:end);
            ihsR1  =  ihsR1(4:end);
            hsL1  =  hsL1(4:end);
            ihsL1  =  ihsL1(4:end); 
        elseif blk == 5
            hsR1  =  hsR1(3:end);
            ihsR1  =  ihsR1(3:end);
            hsL1  =  hsL1(3:end);
            ihsL1  =  ihsL1(3:end);
        elseif blk == 2
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    elseif effcond == 2
        if blk == 7 || blk == 6
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(3:end);
            ihsL1  =  ihsL1(3:end);
        elseif blk == 3
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        end
    end
end

%% for LKT (10)
if strcmp(subject.list(subj),'LKT')
    if effcond == 1
        if blk == 5
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 6
            hsR1  =  hsR1(3:end);
            ihsR1  =  ihsR1(3:end);
            hsL1  =  hsL1(6:end);
            ihsL1  =  ihsL1(6:end);
        end
    elseif effcond == 2
        if blk == 7
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 6 || blk == 3
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 1
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        end
    end
end

%% for HZO (11)
if strcmp(subject.list(subj),'HZO')
    if effcond == 1
        % okay
    elseif effcond == 2
        if blk == 6 || blk == 4
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 5
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        elseif blk == 2
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    end
end

%% for MLU (12)
if strcmp(subject.list(subj),'MLU')
    if effcond == 1
        if blk == 5
            hsR1  =  cat(2,hsR1(1),hsR1(3:end));
            ihsR1  =  cat(2,ihsR1(1),ihsR1(3:end));
        end
    elseif effcond == 2
        if blk == 5
            hsR1  =  hsR1(3:end);
            ihsR1  =  ihsR1(3:end);
            hsL1  =  hsL1(3:end);
            ihsL1  =  ihsL1(3:end);
        elseif blk == 4
            hsL1  =  cat(2,hsL1(1),hsL1(3:end));
            ihsL1  =  cat(2,ihsL1(1),ihsL1(3:end));
        elseif blk == 3
            hsR1  =  hsR1(3:end);
            ihsR1  =  ihsR1(3:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 1
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    end
end
              
%% for BEO (13)
if strcmp(subject.list(subj),'BEO')
    if effcond == 1
        if blk == 7
            hsR1  =  hsR1(4:end);
            ihsR1  =  ihsR1(4:end);
        elseif blk == 6
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 1
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        end
    elseif effcond == 2
        if blk == 7
            hsL1  =  hsL1(3:end);
            ihsL1  =  ihsL1(3:end); 
        elseif blk == 6 
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 5
            hsL1  =  cat(2,hsL1(1),hsL1(3:end));
            ihsL1  =  cat(2,ihsL1(1),ihsL1(3:end));
        end
    end
end

%% for BAX
if strcmp(subject.list(subj),'BAX')
    if effcond == 1
        if blk == 7
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        elseif blk == 5
            hsL1  =  hsL1(4:end);
            ihsL1  =  ihsL1(4:end); 
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
        elseif blk == 4 || blk == 3
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end);
        elseif blk == 2
%             hsL1  =  hsL1(2:end);
%             ihsL1  =  ihsL1(2:end); 
%             hsR1  =  hsR1(2:end);
%             ihsR1  =  ihsR1(2:end);
        end
    elseif effcond == 2
        if blk == 3
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end); 
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end); 
        end
    end
end
%% for DCU
if strcmp(subject.list(subj),'DCU')
    if effcond == 1
        if blk == 3
            hsR1  =  hsR1(2:end);
            ihsR1  =  ihsR1(2:end);
            hsL1  =  hsL1(4:end);
            ihsL1  =  ihsL1(4:end);
        end
    elseif effcond == 2
        if blk == 2
            hsL1  =  hsL1(2:end);
            ihsL1  =  ihsL1(2:end); 
        end
    end
end
            