function [p0,p]=probmont(n,m,N)
if n>m
    p0=0;
    p=0;
    return;
end
i=0:n;

p0=sum((-1).^i*factorial(n)./(factorial(i).*factorial(n-i)).*(1-i/n).^(m));

num=0;
x=0;
%¼ÆËãÄ£Äâ¸ÅÂÊ
for i=1:N
    x=randsample(n,m,'true');
    if numel(unique(x))==n
        num=num+1;
    end
end
p=num/N;