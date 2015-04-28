function [beta,delta] = wblmom(x)
% WBLMOM Moment estimates of the Weibull distribution parameters (see
% paper)
%	[ALPHA,BETA] = WBLMOM(X,OPTIONS) returns the parameters alpha and beta
%
%   The function finds a numerical solution to the moment matching
%   procedure for Weibull parameter estimation. The first approximate
%   estimate for the numerical solution is taken from a a3-versus-delta
%   table and linear interpolation is used.
%
%   Author: Roland Kwitt, rkwitt@gmx.at, 2009

% Table 3.1 from Cohen A.C. and Whitten, B.J, "Parameter Estimation in
% Probability and Life Span Models", Marcel Dekker, 1988

%a3tbl = [ ...
%    6.61876, 5.43068,  4.59341, 3.97420, 3.49837, ...
%    3.12124, 2.81465, 2.56009, 2.34496, 2.16040, ...
%    2.00000, 1.85904, 1.73397, 1.62204, 1.52113, ...
%    1.42955, 1.34593, 1.26920, 1.19844, 1.13291, ...
%    1.07199, 1.01515, 0.96196, 0.91202, 0.86502, ...
%    0.82068, 0.77874, 0.73899, 0.70124, 0.66533, ...
%    0.63111, 0.48121, 0.35863, 0.25589, 0.16810, ...
%    0.09196, 0.02511, -0.03419, -0.08724, -0.13504, ...
%    -0.17838, -0.25411, -0.37326, -0.46319, -0.53373];

% need this table in reverse order (since interp1q requires mon. increasing
% values)
a3tbl = [-0.5337
   -0.4632
   -0.3733
   -0.2541
   -0.1784
   -0.1350
   -0.0872
   -0.0342
    0.0251
    0.0920
    0.1681
    0.2559
    0.3586
    0.4812
    0.6311
    0.6653
    0.7012
    0.7390
    0.7787
    0.8207
    0.8650
    0.9120
    0.9620
    1.0151
    1.0720
    1.1329
    1.1984
    1.2692
    1.3459
    1.4296
    1.5211
    1.6220
    1.7340
    1.8590
    2.0000
    2.1604
    2.3450
    2.5601
    2.8146
    3.1212
    3.4984
    3.9742
    4.5934
    5.4307
    6.6188];

% deltas
dl = [8:-1:5 4.50:-0.25:2.25 2.0:-0.05:0.5]';
%dl = [0.5:0.05:2.00 2.25:0.25:4.50 5:8];

    mu = mean(x);
    n = length(x);
    %num = 1/n * sum(power(x - mu,3));
    %num = mean(power(x-mu,3));
    xsubmu = x-mu;
    num = mean(xsubmu.*xsubmu.*xsubmu);
    denum = power(1/n*sum(power(x - mu,2)),3/2);
    a3 = num/denum;
    if (a3 > max(a3tbl))
        a3 = max(a3tbl);
    end
    if (a3 < min(a3tbl))
        a3 = min(a3tbl);
    end
    %approxdelta = interp1(a3tbl,dl, a3);
    delta = interp1q(a3tbl,dl,a3);
    % could do root finding 
    % delta = fzero(@(x) momfun(x,a3),approxdelta);
    beta = std(x)/sqrt((Gk(2,delta)-Gk(1,delta)^2));
end

function val = Gk(k, delta)
    val = gamma(1+k/delta);
end

function val = momfun(x,a)
    val = ((Gk(3,x) - 3*Gk(2,x)*Gk(1,x) + 2*Gk(1,x)^3)/power(Gk(2,x)-Gk(1,x)^2,3/2)) - a;
end