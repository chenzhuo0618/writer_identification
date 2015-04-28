function gamma = estcauchy(signal,p)
    t1 = mean(power(abs(signal),p));
    t2 = 1/cos(pi/2*p);
    gamma =power(t1/t2,1/p);
end