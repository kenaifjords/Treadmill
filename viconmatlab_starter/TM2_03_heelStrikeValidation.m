% TM2_03_heelStrikeValidation
global F p subject colors
% a heel strike is valid if preceded by an opposite heel strike

% work through the right foot heel strikes using index i, for each index i,
% find the set of left foot heel strikes between right side i-1 and i. If
% that set is non-empty then right side heelstrike i is valid and we save
% the heelstrike index in at valid_i row in column 1. In column 2, we save
% the index of the last member of the left foot heelstrikes set. This way
% we have valid right foot heel strikes *and* their corresponding left foot
% step pairs

% leg for the first step
 for subj = 1:subject.n
     for effcond = 1:2
         for blk = 1:subject.nblk
             clear rhs lhs rfirst firsths secondhs
             clear validfirst validsecond
             % get the heel strikes
             rhs = F(subj).hsL{effcond,blk};
             lhs = F(subj).hsR{effcond,blk};
             % determine the first step and save binary rfirst, then assign
             % the right and left to first step or second step sides
             if ~isempty(rhs) && ~isempty(lhs)
                 if rhs(1) > lhs(1)
                     rfirst = 0;
                     firsths = lhs;
                     secondhs = rhs;
                 else
                     rfirst = 1;
                     firsths = rhs;
                     secondhs = lhs;
                 end
                 % FIRST STEP SIDE
                 vi = 1; % assume that the first step is valid
                 for i0 = 2:length(firsths)
                     clear set2
                     set2 = find(secondhs < firsths(i0) & secondhs > firsths(i0 - 1));
                     if ~isempty(set2)
                         validfirst(vi,1) = i0-1;
                         validfirst(vi,2) = set2(end);
                         vi = vi + 1;
                     else
                         % i0 is a nonvalid heelstrike
                     end
                 end
                 % SECOND STEP SIDE % i'm not entirely sure i need this...
                 vj = 1;
                 for j0 = 2:length(secondhs)
                     clear set1
                     set1 = find(firsths < secondhs(j0) & firsths > secondhs(j0 - 1));
                     if ~isempty(set1)
                         validsecond(vj,1) = j0-1;
                         validsecond(vj,2) = set1(end);
                         vj = vj + 1;
                     end
                 end
             F(subj).validstep1{effcond,blk} = validfirst;
             F(subj).validstep2{effcond,blk} = validsecond;
             F(subj).rightfirst{effcond,blk} = rfirst;
             end             
         end
     end
 end