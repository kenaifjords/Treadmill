
global homepath subject F p colors asym

tic
for subj = 1
     for effcond = [1 2] 
         for blk = [2 3]            
            R = F(subj).R{effcond,blk}(:,2);
            L = F(subj).L{effcond,blk}(:,2);
            %R_BW = R/subject.weight{subj};
            %L_BW = L/subject.weight{subj};
            hsR_idx = F(subj).hsR_idx{effcond, blk}; 
            hsL_idx = F(subj).hsL_idx{effcond, blk};
              
            [F(subj).idxR{effcond,blk},F(subj).idxL{effcond,blk}] = find_interval_index(R,L,hsR_idx,hsL_idx);% row vector of indices of interest for each stride
                 
             end
         end         
end


toc