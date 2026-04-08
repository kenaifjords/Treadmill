function [L] = fitLearn_statespace0(x,data,ideal)
yfit = nan(1,length(data));
yfit(1) = mean(data(1:5));
alpha = x(1); beta = x(2);
for i = 1:length(data)-1
    yfit(i+1) = alpha * yfit(i) + beta * (ideal(i) - yfit(i));
end
L = sum((data - yfit).^2,'omitnan');
end