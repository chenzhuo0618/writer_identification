function [Q, descent] = computeMidV(X,P, Weight,lambda)
[n,dim]= size(X);
for i = 1:n,
    Temp = bsxfun(@minus, X, X(i,:)).^2;
    dist = Temp*(Weight(:).^2);
    Ds(i,:) = dist;
end
num = 1 ./ (1 + Ds);
num(1:n+1:end) =  0;
Qcount = sum(num(:));
Q = num./ Qcount;                                               % normalize to get probabilities
Q = max(Q, eps);
% Q = max(num, eps);
stiffnesses =4*(P-Q).*num;
wtemp = zeros(dim,1);
for i = 1:n,
    Temp = bsxfun(@minus, X, X(i,:)).^2;
    wdist = bsxfun(@times, Temp, Weight');
    wtemp = wtemp + sum(bsxfun(@times, stiffnesses(:,i),wdist))';
end
descent =(2*wtemp-0*lambda*Weight);
descent;