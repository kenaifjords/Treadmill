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
tic
% leg for the first step
 for subj = 1:subject.n
     for effcond = 1:3
         for blk = 1:subject.nblk
             clear rhs lhs rfirst vi vj
             clear validr validl
             % get the heel strikes
             if effcond <= size(F(subj).R,1) && ~isempty(F(subj).hsR{effcond,blk}) && ~isempty(F(subj).hsL{effcond,blk})
                 rhs = F(subj).hsR{effcond,blk}; % size(rhs)
                 lhs = F(subj).hsL{effcond,blk}; % size(lhs)   
             
                 % determine the first step and save binary rfirst
                 if rhs(1) < lhs(1)
                     rfirst = 1;  
                     validr(1,:) = [1 NaN]; validl(1,:) = [1 1];
                 else
                     rfirst = 0;
                     validr(1,:) = [1 1]; validl(1,:) = [1 NaN];
                 end
                 vi = 2; vj = 2;
                 % RIGHT STEPS
                 for i0 = 2:length(rhs)
                     clear set2
                     set2 = find(lhs < rhs(i0) & lhs > rhs(i0 - 1));
                     if ~isempty(set2)
                         validr(vi,1) = i0;
                         validr(vi,2) = set2(end); % save the left index that makes this right step valid
                         vi = vi + 1;
                     else
                         % i0 is a nonvalid heelstrike
                     end
                 end
                 % LEFT STEPS
                 for j0 = 2:length(lhs)
                     clear set1
                     set1 = find(rhs < lhs(j0) & rhs > lhs(j0 - 1));
                     if ~isempty(set1)
                         validl(vj,1) = j0;
                         validl(vj,2) = set1(end); % save the right index that makes this left step valid
                         vj = vj + 1;
                     end
                 end
             F(subj).validstepR{effcond,blk} = validr;
             F(subj).validstepL{effcond,blk} = validl;
             F(subj).rfirst{effcond,blk} = rfirst;
             % create new corrected heelstrike vectors
%              for i = 1:length(validr)
%                  if ~isnan(validr(i))
%                      F(subj).hsRv(i) = rhs(validr(i));
%                  else
%                      F(subj).hsRv(i) = NaN;
%                  end
%              end
%              for j = 1:length(validl)
%                  if ~isnan(validl(j))
%                      F(subj).hsLv(j) = lhs(validl(i));
%                  else
%                      F(subj).hsLv(j) = NaN;
%                  end
%              end
             end             
         end
     end
 end
 clearvars -except F p subject colors IK ID
 toc