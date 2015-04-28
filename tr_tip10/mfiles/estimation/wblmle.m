function [parmhat,info] = wblmle(x, options)
% WBLMLE MLE parameter estimates for Weibull distributed data
%
%       [PARMHAT,X0] = WBLMLE(X, OPTIONS) 
%
%       Returns the maximum likelihood estimate of the shape and scale parameter 
%       of the Weibull distribution given the data in X using the
%       Newton-Raphson numerical root-finding algorithm. In contrast to the
%       WBLMLE routine, this function makes direct use of the Weibull
%       log-likelihood function and its derivative. The starting values
%       for the Newton-Raphson root finding algorithm are computed from
%       moment estimates, given in cohewhit88.
%
%       NOTE: Numerical difficulties can arise in cases where delta < 2.2.
%       Hence, we do not recommend this direct approach for parameter
%       estimation, unless you can ensure delta >= 2.2.
%
% Author: Roland Kwitt, June 2008


if min(size(x)) > 1
    error('The first argument in WBLMLE must be a vector.');
end

if nargin < 2
    options = [];
end
x = x(:);
[beta_start,delta_start] = wblmom(x); % compute starting values
[delta,iterations,deltas] = fzeron('dweibull', delta_start, options, x);
beta = power(1/length(x) * sum(power(x,delta)),1/delta);
parmhat = [beta,delta];
info.iterations = iterations;
info.deltas = deltas;




