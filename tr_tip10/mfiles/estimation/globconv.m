function [f,g] = globconv(c,x)
% GLOBCONV Returns first and second partial derivative of the convex shape
% equation proposed by Song
% This is a utility function of GGDSONG

    n = length(x);
    ax = x;
    lax = log(ax);
    absxc = ax.^c;
    absx2c = absxc.*absxc;
    sumabsxc = sum(absxc);
    psabsxc2 = sumabsxc.*sumabsxc;
    s1 = sum(absx2c);
    
    fnum = 1/n * s1;
    fdenum = 1/n^2 * psabsxc2;
    f = fnum/fdenum - c - 1; 
    
    g1 = sum(absx2c.*lax) / psabsxc2;
    g2 = s1*sum(absxc.*lax)/power(sumabsxc,3);
    g = 2*n*(g1 - g2) - 1;
end


