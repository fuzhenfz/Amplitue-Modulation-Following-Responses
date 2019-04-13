function F = myfun(para,xdata)

% F = 100./(1+exp(-para(1)*(xdata-para(2))));
% para = [beta(slope)  mu(threshold)   ]

 F = 100*(1-para(3))./(1+exp(-para(1)*(xdata-para(2))));
