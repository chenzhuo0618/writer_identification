function x=AdjppFT(y,R)
%ADJPPFT computing adjoint Pseudo-polar Fourier Transform. 
%   Given an image y of size 2*(Rn+1)*(n+1), compute the adjoint Fourier trasform
%   of this image, which gives an image x of size n-by-n
%
%   X = ADJPPFT(Y,R)
%
%   Examples
%      img  = imread('barbara.gif');
%      img  = double(img);
%      pImg = ppFT(img,2);
%      tImg = AdjppFT(pImg,2);
%
%   See also FRFT, ADJFRFT, PPFT, INVPPFTCG.

%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
%  
%   normalization: deivide by n:June 19th 2008
%   modified for R>2: Nov. 10, 2010 by Xiaosheng Zhuang

if nargin == 1
    R = 2;
end

[K,M,N] = size(y);
x       = zeros(N-1);   % change to N-1
[n,m]   = size(x);

m       = R*n+1;        %
m0      = (R*n+1)*2/R;  % special choice to make use of 1d ifft.
x2      = zeros(m,n);

% prepare for unaliased 1D FFT
v1    = -n/2:n/2-1;
fact1 = exp(-2*pi*i*(R/2)*n*v1/m).';
fact1 = repmat(fact1,1,n);

for sector = 1:2
    
    alpha   = [n*R/2:-1:-n*R/2]*2/(n)/(m0*R/2);
    w       = squeeze(y(sector,:,:));
    
    qhat_zp = AdjfrFT(w.', alpha); % adjoint frFT along one direction
    qhat_zp = qhat_zp.';
    x2      = qhat_zp(:,1:end-1);  
        
    if m0 == (R*n+1)*2/R    % ifft along another direction 
       fact2 = exp(-2*pi*i*[0:R*n]'*(R/2)*n/m);
       fact2 = repmat(fact2,1,n);
       x2    = x2.*fact2;
       x1    = (m)*ifft(x2,[],1);
       x1    = x1((R-1)*n/2+1:(R-1)*n/2+n,:).*fact1;
    else                    % adjoint frFT along another direction
       x1 = AdjfrFT(x2,1/(m0*R/2));
       x1 = x1((R-1)*n/2+1:(R-1)*n/2+n,:);        
    end
    
    if sector == 1
        x = x+x1;
    else
        x = x+x1.';
    end
end

x = x/sqrt(prod(size(y)));

return

