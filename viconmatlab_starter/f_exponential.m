function [L] = f_exponential(x,data)

coef = x(1); lrate = x(2); const = x(3);
t = 1:length(data);

yfit = coef * exp (-lrate * t) + const;

L = sum((data - yfit').^2,'omitnan');
end