function [pout] = get1wayANOVA(abar_in)
global subject
y = []; b = []; ef = []; ix = [];
for idx = 1:4
    for blk = 4:6
        clear t stat y ef
        y = []; ef = [];
        for subj = 1:subject.n
            for effcond = subject.order(subj,1)
                if effcond == 0
                    effcond = 3;
                end
                y = cat(1,y,abar_in{effcond,blk}(subj,idx));
%                 b = cat(1,b,blk);
                ef = cat(1,ef,effcond);
%                 ix = cat(1,idx,ix);
            end
        end
        size(y)
        [p(blk,idx),t,stat] = anova1(y,ef)
    end
end
pout = p;
end

% for subj = 1:subject.n
%     for exposure = 1:2
%         if exposure == 1
%             blk = 4;
%         else
%             blk = 6;
%         end
%         effcond = subject.order(subj,1);
%         amati(1,:) = cat(2,exposure,effcond,abar{effcond,blk}(subj,1));
%     end
%     for exposure = 3:4
%         if exposure == 3
%             blk = 4;
%         else
%             blk = 6;
%         end
%         effcond = subject.order(subj,2);
%         amati(1,:) = cat(2,exposure,effcond,abar{effcond,blk}(subj,1));
%     end
% end
