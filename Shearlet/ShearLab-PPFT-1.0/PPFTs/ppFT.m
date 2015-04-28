function y=ppFT(x,R,Nr,Na)
%PPFT  computing the pseudo-polar Fourier Transfrom of an image.
%
%   DESCRIPTION
%   Given a image of size $N$, PPFT computes its pesudo-polar Fourier
%   transform on a grid with Nr pseudo-radius by Na pseudo angles.
%   As of now Nr and Na can only be R*n+1 and n+1 for any integer R>=2.
%   by default R = 2, Nr = 2n+1, and Na = n+1.
%
%   Y = PPFT(X,R) compute the pseudo-polar Fourier transform of X with 
%   oversampling rate R along radial direction. X is matrix of size n-by-n
%   and Y is an image of size 2*(Rn+1)*(n+1)
%
%   EXAMPLE
%      img  = imread('barbara.gif');
%      img  = double(img);
%      pImg = ppFT(img,2);
%
%   See also FRFT, ADJFRFT, ADJPPFT, INVPPFTCG.

%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
%   
%   normalization: deivide by n:June 19th 2008
%   Oversmapling R: June 23
%   correct program to match for R > 2: Nov. 9, 2010 by Xiaosheng Zhuang

if nargin == 1
    R = 2;
end

[n,m] = size(x); % x is square

if (rem(n,2)==1)
    disp('size of image should be even. exiting the code ...')
    return
end

if (m~=n)
    disp('Image should be square. exiting the code ...')
    return
end

y  = zeros(2,R*n+1,n+1); % The horizontal and vertical cones
m0 = (R*n+1)*2/R;        % The choice we can utilize fft along one direction.  
m  = R*n+1;              

% prepare for unaliased 1D FFT
v1    = -n/2:n/2-1;
fact1 = exp(2*pi*i*(R/2)*n*v1/m).'; 
fact1 = repmat(fact1,1,n);

for sector = 1:2
    %disp(['PPFT: Sector ' num2str(sector) '...']);
    if sector == 2
        x = x.';
    end
    
    if m0 == (R*n+1)*2/R % unaliased FFT along one direction
       x1    = [zeros((R-1)*n/2,n);x.*fact1; zeros((R-1)*n/2+1,n)];
       x2    = fft(x1,[],1);
       fact2 = exp(2*pi*i*[0:R*n]'*(R/2)*n/m);
       fact2 = repmat(fact2,1,n);
       x2    = x2.*fact2;
    else                 % frFT along one direction
       x1    = [zeros((R-1)*n/2,n); x; zeros((R-1)*n/2+1,n)];
       x2    = frFT(x1,1/(m0*R/2));       
    end
    
    % frFT along another direction
    alpha   = [n*R/2:-1:-n*R/2]*2/(n)/(m0*R/2);
    qhat_zp = [x2 zeros(size(x2,1),1)];
    w       = frFT(qhat_zp.', alpha);
     
    y(sector,:,:) = w.';

end

y = y/sqrt(prod(size(y)));

return


