function [parmhat,info] = gammle(x, options)
% GAMMLE ML estimation of the Gamma distribution parameters alpha and beta
%	[PARMHAT,INFO] = GAMMLE(X,OPTIONS)
%	Returns the ML estimates of alpha and beta in PARMHAT(1) and PARMHAT(2)
%	as well as a structure INFO containing the number of iterations to
%	reach convergence and the absolute value of the estimate differences in two
%	successive iterations

if min(size(x)) > 1
    error('The first argument in GAMMLE must be a vector.');
end

if nargin < 2
    options = [];
end
x = x(:);

% Moment estimate from Kris06
%bhat_start = 4*power(moment(x,2),3)/power(moment(x,3),2);

%n = length(x);
%onedivn = 1/n;
%wbar = onedivn * sum(log(x));
%tbar = onedivn * sum(x);
%M = log(tbar) - wbar;
%bhat_start = 1/(2*M);
bhat_start = power(mean(x)/std(x),2);
x0 = x;
[bhat,iterations,deltas] = fzeron('dgamma', bhat_start, options, x0);
ahat = bhat/mean(x);
parmhat = [bhat 1/ahat];
info.iterations = iterations;
info.deltas = deltas;
