function [mhat,ahat,bhat] = ggdmom(data)
% GGDFAST Approximative estimation of the distribution parameters of the
% GG distribution, mhat,ahat,bhat using the method proposed by Krupinski
%	[MHAT,AHAT,BHAT] = GGDFAST(X)

    % a,b,c determined using non-linear curve fitting (MATLAB) for the
    % candidate function proposed in Krupinski's paper
    a = -0.2667;
    b = -0.4172;
    c = -1.1585;
    N = length(data);
    m1 = 1/N * sum(abs(data));
    m2 = 1/N * sum(data.^2);
    mhat = 0;
    bhat = ((log(m1^2/m2)-a)/b)^(1/c);
    % Numerical Recipes implementation of log(gamma(x))
    %ahat = m1 * exp(mygammalog(1/bhat)-mygammalog(2/bhat));
    ahat = m1 * exp(lngamlt(1/bhat) - lngamlt(2/bhat));
end