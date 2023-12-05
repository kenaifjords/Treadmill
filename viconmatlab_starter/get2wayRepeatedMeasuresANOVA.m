function [pout] = get2wayRepeatedMeasuresANOVA(abar_in)
global subject
y = []; ef = {}; phase = {}; subjL = [];
efname = {'high' 'low' 'control'};
clear p t stat term
for subj = 1:subject.n
    for effcond = subject.order(subj,1)
        if effcond == 0
            effcond = 3;
        end
        for blk = 3:6
            if blk == 3 % baseline
                idx = 3; % late baseline
                y = cat(1,y,abar_in{effcond,blk}(subj,idx));
                if isnan(y)
                    break
                end
                ef = cat(1,ef,efname{effcond});
                subjL = cat(1,subjL,subj);
                phase = cat(1,phase,'base');
            else
                if blk == 4
                    phasename = {'initialL' 'earlyL' 'lateL' 'finalL'};
                elseif blk == 5
                    phasename = {'initialW' 'earlyW' 'lateW' 'finalW'};
                elseif blk == 6
                    phasename = {'initialS' 'earlyS' 'lateS' 'finalS'};
                end

                for idx = 1:4 % initial, early, late, final
                    y = cat(1,y,abar_in{effcond,blk}(subj,idx));
                    ef = cat(1,ef,efname{effcond});
                    subjL = cat(1,subjL,subj);
                    phase = cat(1,phase,phasename{idx});
                end
            end
        end
    end
end
size(y)
%     anovan(y,{b,ef})
[p,t,stat,term] = anovan(y,{ef,phase,subjL},'random',3,'varnames',{'effort condition','walking task phase','subject'} )

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
