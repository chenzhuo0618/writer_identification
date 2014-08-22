function p=SheepAndCar(n)
for i=1:length(n)
    x=randsample(3,n(i),'ture');
    p(i)=sum(x~=3)/n(i);
end