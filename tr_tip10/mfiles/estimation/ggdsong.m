function [ahat, bhat, info] = ggdsong(x, options)
% GGDSONG Parameter estimation of the distribution parameters of a GGD
% using the method proposed by Song "A Globally Convergent and Consistent
% Method for Estimating the Shape parameter of a Generalized Gaussian
% distribution", IEEE Transaction on Information Theory, vol. 52, number 2,
% pages 510--527, Feb. 2006
%
%	[AHAT,BHAT,INFO] = GGDSONG(X,OPTIONS)
%	Returns the ML estimates of alpha and beta in AHAT, BHAT
%	as well as a structure INFO containing the number of iterations to
%	reach convergence and the absolute value of the estimate differences in two
%	successive iterations; MHAT is zero here;

if min(size(x)) > 1
    error('The first argument in GGMLE must be a vector.');
end

if nargin < 2
    options = [];
end
x = x(:);
absx = abs(x);
[bhat,iterations,deltas] = fzeron('globconv', 3.0, options, absx);
ahat = (bhat * sum(absx .^ bhat) / length(x)) ^ (1 / bhat);
info.iterations = iterations;
info.deltas = deltas;