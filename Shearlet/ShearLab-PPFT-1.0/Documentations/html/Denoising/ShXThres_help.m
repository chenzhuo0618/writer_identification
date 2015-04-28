%% SHXTHRES 
% thresholding shearlet coefficients 
%% Description
% ThresCoeff = ShXThres(ShX,N,R,beta,thr,level)
% thresholding shearlet coefficients.
% INPUT
%
%    ShX    - shearlet coefficeints
%
%    N      - size of original image
%
%    R      - oversampling rate, default R = 2;
%
%    beta   - scaling factor, default beta = 4;
%
%    thr    - threshold
%
%    level  - decompoistion level
%
%  OUTPUT
%
%    ThresCoeff - thresholded shearlet coefficient of X.
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

