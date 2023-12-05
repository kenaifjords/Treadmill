function [L] = fitLearning(alphabeta,datain)
yhat = nan(length(datain),1);
yhat(1) = 0; % assume step before the split start is symmetrical - start 
    % with no error
for n = 1:length(datain)
    yhat(n+1) = alphabeta(1)*yhat(n) + alphabeta(2)*(0 - yhat(n));
end
error = yhat;
L = sum((datain-error).^2,'omitnan');
end