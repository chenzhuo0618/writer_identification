%% INVSHEARLETTRANSFORM 
%  Inverse of Shearlet Transform using CG.
%
%% Description
% X=INVSHEARLETTRANSFORM(SHX,N,R,BETA,W)
% Input:
%   ShX - shearlet coefficient structure from SHEARLETTRANSFORM
%
%   N   - original image size N.
%
%   R   - oversampling rate
%
%   w   - weighting matrix, see GENERATEW
%
%   err - error controlled in CG
%
%   itsMax- maximal iteration in CG
%
% Output:
%
%   X   - image of size N-by-N.
%
%   it  - total iteration times in CG
%
%   res - final iteration error in CG iteration
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
  [timg, its, rerr] = InvShearletTransform(shX,N,R,beta,w,1e-5,3);
  err = norm(timg-img,'fro')/norm(img,'fro')
  its, rerr
  toc

%% See also 
% <AdjShearletTransform_help.html ADJSHEARLETTRANSFORM>,
% <ShearletTransform_help.html SHEARLETTRANSFORM>,
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <../PPFTs/InvppFTCG_help.html INVPPFTCG>,
% <../Windowing/WindowOnPPGrid_help.html  WINDOWONPPGRID>
% <../Windowing/AdjWindowOnPPGrid_help.html  ADJWINDOWONPPGRID>
% <../Weighting/generateW_help.html  GENERATEW>

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
