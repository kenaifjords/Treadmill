function [x,mse] = fitLearning0(error,x0,ideal)
%%
% to get learning rate and forgetting factor
% inputs: error = a vector of error measures for trials / strides during
% the learning block
% x0: initial predictions for the forgeeting factor and learning rate; 
% x0 = [alpha, beta, steady state offset]
% ideal is the absolute truth, the 30 degree rotation, the perfect symmetry
%% STATE SPACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% contraints
% xo for testing: [1 0.001, - 0.1]
% lower / upper bound
lowerx0 = [0.9,0.0,-0.4]; upperx0 = [1,0.2,0];
% eval options
options = optimset('MaxFunEvals',1e10);
%% use fminsearch / fmincon
% [xf,min] = fminsearch(@(xf) fitLearn_mse(xf,error,ideal),x0,options);
[xf,min] = fmincon(@(xf)fitLearn_statespace0(xf,error,ideal),x0,[],[],[],[],...
    lowerx0,upperx0,[],options);
x = xf;
mse = min;
%% plot
if 0
    % generate fitted curve
    yfit(1) = mean(error(1:5),'omitnan');
    
    for i = 1:length(error) - 1
        yfit(i+1) = x(1) * yfit(i) + x(2) * (ideal(i) - yfit(i));
    end

    hold on;
    plot(error,'.','MarkerSize',10,'HandleVisibility','off')
    plot(yfit,'DisplayName',['statespace - mse: ' num2str(mse)])
end
end
