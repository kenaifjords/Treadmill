function [L] = fitLearn_exp(x,data)

yfit = nan(1,length(data));
yfit(1) = mean(data(1:5));
coef = x(1); rate = x(2); const = x(3);
t = 1:length(data);
yfit = coef * exp(-rate * t) + const; 

L = sum((data - yfit).^2,'omitnan');
end