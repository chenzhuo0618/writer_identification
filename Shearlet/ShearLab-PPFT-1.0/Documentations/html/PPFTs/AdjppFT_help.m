%% ADJPPFT 
% Computing adjoint Pseudo-polar Fourier Transform. 
%
%% Description
%   Given an image y of size 2*(Rn+1)*(n+1), compute the adjoint Fourier trasform
%   of this image, which gives an image x of size n-by-n
%
%   X = ADJPPFT(Y,R)
%
%% Examples
      img  = imread('barbara.gif');
      img  = double(img);
      pImg = ppFT(img,2);
      tImg = AdjppFT(pImg,2);

%% See also 
% <ppFT_help.html PPFT>, 
% <InvppFTCG_help.html INVPPFTCG>,
% <frFT_help.html FRFT>, 
% <AdjfrFT_help.html ADJFRFT>.


%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
%  
%% Update History
%   normalization: deivide by n:June 19th 2008
%   modified for R>2: Nov. 10, 2010 by Xiaosheng Zhuang
