function F = myfun(para,xdata)

% F = 100./(1+exp(-para(1)*(xdata-para(2))));
% para = [beta(slope)  mu(threshold)   ]

 F = 100*(1-para(3))./(1+exp(-para(1)*(xdata-para(2))));
%  F = para(3)./(1+exp(-para(1)*(xdata-para(2))));
% para = [beta(slope)  mu(threshold)   lamda(1-upperbound)]

% F = 100*(para(4)+(1-para(3)-para(4)))./(1+exp(-para(1)*(xdata-para(2))));
% para = [beta(slope)  mu(threshold)   lamda(1-upperbound) gamma(lowerbound)]

% xdata = [-12 -8 -4 0];
% y = [3.31197 18.69658 47.32906 70.94017];
% L = length(xdata);
% F=0;
% for i=1:L
%   F(i) = y(i)-1/(1+exp(-para(1)*(xdata(i)-para(2))));
% end;
% 在外面程序[aa, resnorm] = Isqnonlin(@myfun,[2,10])
% y用所给数据代替