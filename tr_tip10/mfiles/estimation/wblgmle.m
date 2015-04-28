function [parmhat,info] = wblgmle(x, options)
% WBLMLE MLE parameter estimates for Weibull distributed data
%
%       PARMHAT = WBLGMLE(X, OPTIONS) 
%
%       Returns the maximum likelihood estimate of the shape and scale parameter 
%       of the Weibull distribution given the data in X using the
%       Newton-Raphson numerical root-finding algorithm. The routine
%       expoits the fact that log(X) follows a Gumbel distribution, which
%       allows faster parameter estimation. The ML equations for the
%       parameters are given in "Evans, Hastings, Peacock: Statistical
%       Distributions". 
%       
%       The NR-procedure is based on the MATLAB code of Minh Do, used for
%       estimating the parameters of the Generalized-Gaussian distribution
%	
% Author: Roland Kwitt, June 2008


if min(size(x)) > 1
    error('The first argument in WBLMLE must be a vector.');
end

if nargin < 2
    options = [];
end
x = x(:);
x = log(x); % so we can use ML estimation of the Gumbel dist. (Type I extreme val.)
rangex = range(x); % get range of data
maxx = max(x); % get maximum value
x0 = (x - maxx) ./ rangex; % data for further computation
bhat_start  = (sqrt(6)*std(x0))/pi; % OK
[bhat,iterations,deltas] = fzeron('dev', bhat_start, options, x0);
muhat = bhat .* log(sum(exp(x0./bhat)) ./ length(x0));
parmhatEV = [(rangex*muhat)+maxx rangex*bhat];
parmhat = [exp(parmhatEV(1)) 1./parmhatEV(2)];
info.iterations = iterations;
info.deltas = deltas;
