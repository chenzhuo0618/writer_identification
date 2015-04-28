function [f,g] = dev(b,x)
% DGAMMA Derivative of Gumbel PDF w.r.t. sigma
%	[F, G] = DEV(SIGMA, X)
%	Return partial derivative and second order partial derivative
%	This is an utility function for WBLGMLE

    mu = mean(x);
    expxb = exp(-x./b);
    s1 = sum(expxb);
    s2 = sum(x.*expxb);
    f = mu - b - s2/s1;
    %g = 1/b^2*sum(expxb.*pow2(x)) - s1 - 1/b * s2;
    g = 1/b^2*sum(expxb.*pow2(x)) + 1/b*s2 - mu*1/b^2*s2 + s1;
end






