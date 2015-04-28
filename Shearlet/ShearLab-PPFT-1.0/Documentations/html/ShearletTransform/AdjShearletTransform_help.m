%% AdjShearletTransform 
% Adjoint of Shearlet Transform. (W sqrt(w) P)^\star
% 
%% Description
% 
%  X=ADJSHEARLETTRANSFORM(SHX,N,R,BETA,W)
% Input:
%   ShX - shearlet coefficient structure from SHEARLETTRANSFORM
%   N   - original image size N.
%   R   - oversampling rate
%   w   - weighting matrix, see GENERATEW
% Output:
%   X   - image of size N-by-N.
%
%% Examples
  tic
  img = imread('barbara.gif');
  img = double(img);
  N   = size(img,1); beta = 4;
  R   = 4; basisChoice  = 5;
  w   = generateW(N,R,basisChoice);
  shX = ShearletTransform(img, R, beta, w, 0);
  timg= AdjShearletTransform(shX,N,R,beta,w);
  err = norm(timg-img,'fro')/norm(img,'fro')
  toc

%% See also 
% <InvShearletTransform_help.html INVSHEARLETTRANSFORM>,
% <ShearletTransform_help.html SHEARLETTRANSFORM>,
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <../PPFTs/InvppFTCG_help.html INVPPFTCG>,
% <../Windowing/WindowOnPPGrid_help.html  WINDOWONPPGRID>
% <../Windowing/AdjWindowOnPPGrid_help.html  ADJWINDOWONPPGRID>
% <../Weighting/generateW_help.html  GENERATEW>

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
