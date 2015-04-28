%% SHEARLETTRANSFORM 
% Digital Shearlet Transform (W sqrt(w) P)X
% W is the windowing, w is the weight operator, and P is the ppft operator
%
%% Desscription
% SHX = SHEARLETTRANSFORM_XZ(X,R,BETA,WEIGHT,LEVEL)
% Input:
%
%     X     - square N*N matrix  N dyadic
%
%     R     - oversamping rate, 2,4,8,16.
%
%     beta  - 2 or 4;
%
%     w     - Wegithing Matrix, size: 2*(R*N+1)*(N+1) must be nonnegative
%
%     level - decomposition level, level =0 means decompose to the lowest possible level
%
% Output:
%
%     ShX shearlet_coeff : shearlet coefficients (cell structure)
%
%% Examples
  tic
  img = imread('barbara.gif');
  img = double(img);
  N   = size(img,1); beta = 4;
  R   = 4; basisChoice  = 5;
  w   = generateW(N,R,basisChoice);
  shX = ShearletTransform(img, R, beta, w, 0);
  toc
%% See also
% <AdjShearletTransform_help.html ADJSHEARLETTRANSFORM>,
% <InvShearletTransform_help.html INVSHEARLETTRANSFORM>,
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <../PPFTs/InvppFTCG_help.html INVPPFTCG>,
% <../Windowing/WindowOnPPGrid_help.html  WINDOWONPPGRID>
% <../Windowing/AdjWindowOnPPGrid_help.html  ADJWINDOWONPPGRID>
% <../Weighting/generateW_help.html  GENERATEW>

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
