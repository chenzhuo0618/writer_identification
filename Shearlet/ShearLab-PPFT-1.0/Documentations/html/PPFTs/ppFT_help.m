%% PPFT  
%   Computing the pseudo-polar Fourier Transfrom of an image.
%
%% Description
%   Given a image of size $N$, PPFT computes its pesudo-polar Fourier
%   transform on a grid with Nr pseudo-radius by Na pseudo angles.
%   As of now Nr and Na can only be R*n+1 and n+1 for any integer R>=2.
%   by default R = 2, Nr = 2n+1, and Na = n+1.
%
%   Y = PPFT(X,R) compute the pseudo-polar Fourier transform of X with 
%   oversampling rate R along radial direction. X is matrix of size n-by-n
%   and Y is an image of size 2*(Rn+1)*(n+1)
%
%% Example
      img  = imread('barbara.gif');
      img  = double(img);
      pImg = ppFT(img,2);

%% See also 
% <frFT_help.html FRFT>,
% <adjfrFT_help.html ADJFRFT>, 
% <adjppFT_help.html ADJPPFT>, 
% <InvppFTCG_help.html INVPPFTCG>.

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
%
%% Update History
%   normalization: deivide by n:June 19th 2008
%   Oversmapling R: June 23
%   correct program to match for R > 2: Nov. 9, 2010 by Xiaosheng Zhuang