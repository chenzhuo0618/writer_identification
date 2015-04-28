function [f,g] = ggammasong(beta,x)
    n = length(x);
    logx = log(x);
    slogx = sum(logx);
    xbeta = power(x,beta);
    x2beta = xbeta.^2;
    sxbeta = sum(xbeta);
    xbetalogx = xbeta.*logx;
    sxbetalogx = sum(xbetalogx);

    % Eq. (12) in Song08a
    f = log(mean(x2beta)) - 2*log(mean(xbeta)) - log(1+beta*(sxbetalogx/sxbeta -1/n * slogx));
    
    % first derivative of Eq. (12) w.r.t. to beta
    t1 = 2*sum(x2beta.*logx)/sum(x2beta) - 2*sum(xbetalogx)/sxbeta;
    
    t2 = -1/n *slogx + (sxbetalogx/sxbeta) + beta *(-sxbetalogx^2/sxbeta^2 + ...
        sum(xbeta.*(logx.^2))/sxbeta);
    t3 = 1 - beta*1/n*slogx - beta*sxbetalogx/sxbeta;
    t4 = t2/t3;
    g = t1 - t4; 
end

