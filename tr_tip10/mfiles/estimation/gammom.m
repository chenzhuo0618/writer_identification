function [parmhat] = gammom(x)
% GAMMOM Moment estimation of the Gamma distribution parameters 
%	PARMHAT = GAMMOM(X)
%	Returns AHAT (PARMHAT(1)) and BHAT (PARMHAT(2)) - the estimates of
%	alpha and beta

if min(size(x)) > 1
    error('The first argument in GAMFAST must be a vector.');
end

%x = x(:);
% scaling from gamfit
%n = numel(x);
n = length(x);
%freq = 1;
%scalex = sum(freq.*x) ./ n;
scalex = mean(x);
x = x ./ scalex;
%xbar = 1; % x was scaled to make sumx/n exactly 1.
s2 = sum((x-1).^2)/(n-1);
%s2 = sum(freq.*(x-xbar).^2) ./ n;
%s2 = s2 .* n./(n-1); % unbias
%ahat = xbar.^2 ./ s2;
%bhat = s2 / xbar;
ahat = 1/s2;
bhat = s2;
parmhat = [ahat bhat*scalex];
