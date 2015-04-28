%% DSHDEN 
% shearlet denosing
% 
%% Description
% [RECX,THRESCOEFF]=DSHDEN(X,THR,R,BETA,BASISCHOICE,LEVEL,CG,ERR,ITS).
% shearlet denoising.
% INPUT
%    X      - Noisy image
%
%    thr    - threshold
%
%    R      - oversampling rate, default R = 2;
%
%    beta   - scaling factor, default beta = 4;
%
% basisChoice- weighting basis matrix, see BASISFUNCTION
%
%    level  - decomposition level
%
%    CG     - if CG == 1, use CG iteration to get the inverse
%             else, use Adjoint
%
%    err    - error control in the CG.
%
%    its    - iteration total number
%
% OUTPUT
%
%    recX       - reconstructed image
%
%    ThresCoeff - shearlet coefficient of X.
% 
%% Examples
%    see DENOISEDEMO
%% See also 
% <../ShearletTransform/ShearletTransform_help.html SHEARLETTRANSFORM>,
% <../ShearletTransform/AdjShearletTransform_help.html
% ADJSHEARLETTRANSFORM>,
% <../ShearletTransform/InvShearletTransform_help.html
% INVSHEARLETTRANSFORM>,
% <DenoiseDemo_help.html DENOISEDEMO>
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
