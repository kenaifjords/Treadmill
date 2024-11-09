function [L] = fitLearn_statespace(x,data,ideal)
yfit = nan(1,length(data));
yfit(1) = mean(data(1:5));
alpha = x(1); beta = x(2); ssoffset = x(3);
for i = 1:length(data)-1
    yfit(i+1) = alpha * yfit(i) + beta * (ideal(i) - yfit(i));
end
yfit = yfit + ssoffset;
L = sum((data - yfit).^2,'omitnan');
end