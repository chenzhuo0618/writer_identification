function [param, info] = ggammle(x, options)

if min(size(x)) > 1
    error('The first argument in GGMLE must be a vector.');
end

if nargin < 2
    options = [];
    options = optimset(options,'TolX',1e-3);
end

% c ... beta in Choy10a
% b ... lambda in Choy10a
% a ... alpha in Choy10a

% set the default scale parameter
defaultscaleparam = 3;
[chat,iterations,deltas] = fzeron('ggammasong', defaultscaleparam, options, x);
xchat = x.^chat;
logx = log(x);
Mn = mean(xchat);
Mndot = mean(xchat.*logx);
Rndot = Mndot/Mn;
Rnzero = mean(logx);
bhat = (chat*(Rndot - Rnzero))^(-1);
ahat = (Mn/bhat)^(1/chat);
lambda = bhat;
param = [ahat chat lambda];
info.iterations = iterations;
info.deltas = deltas;