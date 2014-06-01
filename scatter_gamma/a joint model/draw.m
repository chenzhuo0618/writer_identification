function draw(in)
bins=50;
[n,xout]=hist(in,bins);
xout=xout/sum(xout);
figure;
bar(xout,n);
hold on;
% m=min(xout);M=max(xout);lenth=(M-m)/bins;
% x=m:lenth:M;
[a,b]=gamfit(n);
y=gamcdf(n,a(1),a(2));
plot(xout,y,'r')

legend('É¢ÉäÏµÊı','gamma')


