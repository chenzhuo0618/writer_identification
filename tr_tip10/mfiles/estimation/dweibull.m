function [f,g] = dweibull(c,x)
% DWEIBULL is computes the first derivative of the log-likelihood function
% of the Weibull distribution w.r.t. alpha (shape) for use in Newton-Raphson.
%   [F,G] = DWEIBULL(C,X) returns the first (F) and second (G) derivative
%   w.r.t alpha of the LL function at the given value of c with data X
%	This is an utility function for WBLMLE

logx  = log(x);
mu = mean(logx);
pxc = power(x,c);
sumpxclogx = sum(pxc.*logx);
sumpxc = sum(pxc);

f = sumpxclogx - mu*sumpxc - 1/c*sumpxc;

%f = sum(power(x,c).*log(x)) - mean(log(x))*sum(power(x,c)) - 1/c * sum(power(x,c));
%g = sum(power(x,c).*power(log(x),2)) - mean(log(x))*sum(power(x,c).*log(x)) + 1/power(c,2)*sum(power(x,c)) - 1/c * sum(power(x,c).*log(x));
%f = sum(pxc.*logx) - mu*sumpxc - 1/c * sumpxc;
g = sum(pxc.*power(logx,2)) - mu * sumpxclogx + 1/c^2 * sumpxc - 1/c * sumpxclogx;



