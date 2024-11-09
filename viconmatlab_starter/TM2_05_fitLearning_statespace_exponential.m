% TM2_05_fiLearning_statespace_exponential
trimearly = 1; trimi = 5;
normalizeasymmetry = 0;
for subj = 1:subject.n
    for effcond = 1:3
        if effcond > size(F(subj).R,1)
            break
        end
        for blk = 1:subject.nblk
            if blk > size(F(subj).R,2)
                break
            end
            if ismember(blk,[1 2 3 7])
                ss_fit(subj,effcond,blk,:) = NaN(1,4);
                exp_fit(subj,effcond,blk,:) = NaN(1,4);
            else                
                asymm = asym(subj).steplength{effcond,blk};
                if trimearly
                    asymm = asymm(trimi:end);
                end
                if normalizeasymmetry
%                     norm(subj,effcond,blk) = max(abs(smooth(asymm,10)));
                    asymm = asymm./max(abs(smooth(asymm,10)));
                end
                symm = zeros(1, length(asymm)); % perfect symmetry
                if ~ isempty(asymm)
                    % uncomment below if we want to run the analysis on
                    % only the first 200 strides
%                     asymm = asymm(1:200);
                    symm = zeros(1, length(asymm)); % perfect symmetry
%                     figure(subj + 100 * effcond);
%                     % state space with offset
%                     x0 = [1, 0.01, -0.1];
%                     [sso_fit_param, mse] = fitLearning0_withoffset(asymm,x0,symm);
                    % state space
                    x0 = [1, 0.01];
                    [ss_fit_param, mse] = fitLearning0(asymm,x0,symm);
                    ss_fit_param = [ss_fit_param NaN];
                    % exponential fit
                    ex0 = [-0.4, 0.02, -0.05];
%                     figure(subj); hold on;
                    [ex_fit_param, emse] = fitExpLearning0(asymm,ex0);
%                     title(subject.list{subj})
%                     legend
                    ss_fit(subj,effcond,blk,1:3) = ss_fit_param;
                    exp_fit(subj,effcond,blk,1:3) = ex_fit_param;
                    % add initial value (which is the mean of the first 5
                    % stride asym)
                    ss_fit(subj,effcond,blk,4) = mean(asymm(1:5),'omitnan');
                    exp_fit(subj,effcond,blk,4) = mean(asymm(1:5),'omitnan');
                end
            end  
        end
    end
end

%% sort
for ip = 1:4
    % ss
    ss0 = ss_fit(:,:,:,ip);
    curvefit(ip).ss = sortbyEffortVisitorder_digitout(ss0);
    % exp
    ep0 = exp_fit(:,:,:,ip);
    curvefit(ip).ex = sortbyEffortVisitorder_digitout(ep0);
end
% save
save('store_curvefit', 'curvefit')