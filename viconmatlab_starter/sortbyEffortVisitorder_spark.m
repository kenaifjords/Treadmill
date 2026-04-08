function [spark,spark_color] = sortbyEffortVisitorder_spark(asym_allsubj)
global subject
count = 1;
for grp = [4 1 5 2 3] %1:5
    for subj = 1:subject.n
        if subject.twovisitgroup(subj) == grp
            subord = subject.order(subj,1);
            if subord == 0
                subord = 3;
            end
            % learning
            spark{count,1} = asym_allsubj{subord,4}(subj,:);
            spark_color(count,1) = subord;
            % relearning
            spark{count,2} = asym_allsubj{subord,6}(subj,:);
            spark_color(count,2) = subord;
            if subject.twovisit(subj) == 1
                % visit 2 relearning
                spark{count,3} = asym_allsubj{subject.order(subj,2),4}(subj,:);
                spark_color(count,3) = subject.order(subj,2);
                % visit 2 relearning
                spark{count,4} = asym_allsubj{subject.order(subj,2),6}(subj,:);
                spark_color(count,4) = subject.order(subj,2);
            else
                spark_color(count,3:4) = [NaN NaN];
            end
            count = count + 1;
        end 
    end
end

% %% sort into effort condition and visit order
% acount = 1; a2count = 1; bcount = 1; b2count = 1; ccount = 1;
% for subj = 1:subject.n
%     if subject.order(subj,1) == 1 % [1 2] % high effort first
%         for blk = 1:subject.nblk
%             if blk > size(F(subj).R,2)
%                 break
%             end
%             for effcond = 1
%                 hfirst{blk}(acount,:) = asym_allsubj{effcond,blk}(subj,:);
%             end
%             if subject.order(subj,2) == 2
%                 for effcond = 2
%                     lsecond{blk}(acount,:) = asym_allsubj{effcond,blk}(subj,:);    
%                 end
%             else
%                 lsecond{blk}(acount,:) = NaN;
%             end
%         end
%         acount = acount + 1;
%     elseif subject.order(subj,1) == 2 %[2 1] % low effort first
%         for blk = 1:subject.nblk
%             if blk > size(F(subj).R,2)
%                 break
%             end
%             if subject.order(subj,2) == 1
%                 for effcond = 1
%                     hsecond{blk}(bcount,:) = asym_allsubj{effcond,blk}(subj,:);
%                 end
%             else
%                 hsecond{blk}(bcount,:) = NaN;
%             end
%             for effcond = 2
%                 lfirst{blk}(bcount,:) = asym_allsubj{effcond,blk}(subj,:);
%             end
%         end
%         bcount = bcount + 1;
%     elseif subject.order(subj,1) == 0 % control
%         for blk = 1:subject.nblk
%             if blk > size(F(subj).R,2)
%                 break
%             end
%             control{blk}(ccount,:) = asym_allsubj{3,blk}(subj,:);
%         end
%         ccount = ccount + 1;
%     end
% end
% asym_sort.hfirst = hfirst;
% asym_sort.lfirst = lfirst;
% asym_sort.control = control;
% asym_sort.hsecond = hsecond;
% asym_sort.lsecond = lsecond;
end