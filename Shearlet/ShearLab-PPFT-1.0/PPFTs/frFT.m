function y=frFT(x,alpha)
%FRFT fractional FFT, modified version of Miki Elad's code
%  
%  Y = FRFT(X,ALPHA) 
%      X is a N-by-1 column vector  or an N-by-s matrix
%      if X is a vector, perform FRFT on the vector with fraction alpha
%      if X is a matrix and alpha is a constant vector with the same column
%      size as X, then perform FRFT on each X(:,j)  with fraction
%      alpha(j). When alpha is a constant and X is a matrix, perform FRFT
%      on each X(:,j) with the same fraction alpha.
%
%  ====================================================================
%  Modefied version of Miki Elad's Fractional Fourier Transform, computing 
%  the transform
%
%      y[n]=sum_{k=-N/2}^{N/2-1} x(k)*exp(-i*2*pi*k*n*alpha)  n=-N/2, ...,N/2-1
%
%  So that for alpha=1/N we get the regular FFT, and for alpha=-1/N we get 
%  the regular   IFFT.
%
%  Synopsis: y = frFT(x,alpha)
%
%  Inputs -   x - an N-entry vector to be transformed or an N-by-s matrix
%             alpha - the scaling factor (in the Pseudo-Polar it is in the range [-1/N,+1/N]
%
%  Outputs-   y - the transformed result as an N-entries vector
%
%  Written by Michael Elad on March 20th, 2005.
%  ====================================================================
%  
%  Examples
%         x     = randn(5,3);
%         alpha = [1/3,1/4,1/5];
%         y     = frFT(x,alpha);
%
%  See also ADJFRFT, PPFT, ADJPPFT, INVPPFTCG.

%  Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
%
%  modified by Morteza Shahram on Jan 30, 2008. make the index k symmetric,
%  also change the code to the case where N can be an odd number
%  modified by  Xiaosheng zhuang on Nov. 9, 2010. allowing input x to be an
%  N-by-s matrix. Do the frft on each column


if nargin == 1
    error('Usage: y = frFT(x,alpha)!');
end

if length(alpha) == 1
    alpha = repmat(alpha,1,size(x,2));
elseif length(alpha) ~= size(x,2)
    error('Usage: y = frFT(x,alpha)! length(alpha) must be same as size(x,2)!');
end

alpha = alpha(:).';
[N,s] = size(x);

Factor2 = exp(i*2*pi*(0:1:N-1)'*floor(N/2)*alpha);
x_tilde = x.*Factor2;

n = [0:1:N-1, -N:1:-1]';
Factor = exp(-i*pi*n.^2*alpha);


x_tilde = [x_tilde; zeros(N,s)];
x_tilde = x_tilde.*Factor;

XX = fft(x_tilde,[],1);
YY = fft(conj(Factor),[],1);
y = ifft(XX.*YY,[],1);
y = y.*Factor;
y = y(1:N,:);

k = [-floor(N/2):-floor(N/2)+N-1]';
Factor3 = exp(2*pi*i*k*floor(N/2)*alpha);

y = y.*Factor3;

return;




