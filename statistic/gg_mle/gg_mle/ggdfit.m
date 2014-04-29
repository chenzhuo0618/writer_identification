function argout=ggdfit(feature)
r=feature;

%%disp('Moment matching estimate:');
%%[mu1, alpha1, beta1] = ggmme(r)

disp('Maximum likelihood estimate:');
[mu2, alpha2, beta2] = ggmle(r)


% Compare the estimated PDF's with the histogram
[N, X] = hist(r, 100);

clf;
bar(X, N ./ (X(2) - X(1)) / sum(N));
hold;
%%plot(X, ggpdf(X, mu1, alpha1, beta1), 'b');
plot(X, ggpdf(X, mu2, alpha2, beta2), 'r');

argout.mu=mu2;
argout.alpha=alpha2;
argout.beta=beta2;