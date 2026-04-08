function [ex,emse] = fitExpLearning0(error,x0)
%% EXPONENTIAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% contraints
% x0 for testing [-0.4, 0.02, -0.05]
% lower / upper bound
lowerx0 = [-1,-0.02,-1]; upperx0 = [1,1,0.5];
% eval options
options = optimset('MaxFunEvals',1e10);
%% use fminsearch / fmincon
% [xf,min] = fminsearch(@(xf) fitLearn_exp(xf,error),x0,options);
% if max(xf) > 1
    [xf,min] = fmincon(@(xf)fitLearn_exp(xf,error),x0,[],[],[],[],...
        lowerx0,upperx0,[],options);
% end
ex = xf;
emse = min;
%% plot
if 0
    % generate fitted curve
    t = 1:length(error);
    yfit = ex(1) * exp(-ex(2)*t) + ex(3);

    hold on;
    plot(error,'.','MarkerSize',10,'HandleVisibility','off')
    plot(yfit,'DisplayName',['exponential - mse: ' num2str(emse)]')
end
end