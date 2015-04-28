%% PSNR 
% peak signal-noise ratio
%
%% DESCRIPTION
%    P = PSNR(X,XC);
%    compute the PSNR of an noisy image with respect to its original image.
%          PSNR = 10*log10(max(X)^2/MSE(X-XC));
%    INPUT 
%        X - original image
%       XC - noisy image
%    OUPUT 
%        P - PSNR
%% EXAMPLE
    X = imread('barbara.gif');
    X = double(X);
   nX = randn(size(X))*30;
    Y = X+nX;
    P = PSNR(X,Y)

%% See also 
% <../Denoising_Contents.html DENOISING>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
