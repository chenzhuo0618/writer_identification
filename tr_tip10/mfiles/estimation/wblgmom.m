function parmhat = wblgmom(x)

if min(size(x)) > 1
    error('The first argument in WBLFAST must be a vector.');
end

x = log(x); % so we can use Moment estimation of the Gumbel dist. (Type I extreme val.)
minx = min(x);
maxx = max(x); % get maximum value
rangex = maxx - minx;
x0 = (x - maxx) ./ rangex; % data for further computation
meanx0 = mean(x0);
s2 = 1/(length(x0)-1) * sum((x0 - meanx0).^2);
bhat = (sqrt(6)*sqrt(s2))/pi;
muhat = meanx0 + 0.57722*bhat;
parmhatEV = [(rangex*muhat)+maxx rangex*bhat];
parmhat = [exp(parmhatEV(1)) 1./parmhatEV(2)];
