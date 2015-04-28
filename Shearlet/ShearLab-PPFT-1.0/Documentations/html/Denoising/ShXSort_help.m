%% SHXSORT 
% sorting shearlet coefficients
% 
%% Description
% SORTCOEFF = SHXSORT(SHX,N,R,BETA,MODE)
% sorting shearlet coefficients in absolute value in descending order.
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
%    mode   - ascend or descend
%
%  OUTPUT
%
%    SortCoeff - sorted shearlet coefficient of X.
%
%    Index     - index from sort
%% 
%% Examples
%    tic;
%    img = imread('barbara.gif');
%    img = double(img);
%    N   = 512; R = 2; beta = 4;
%    W   = generateW(N,R,1);
%    shX = ShearletTransform(img,R,beta,W,0);
%    sortShX = ShXSort(shX,N,R,beta,'descend');
%    toc;
%
%% See also 
% <../ShearletTransform/ShearletTransform_help.html SHEARLETTRANSFORM>,
% <../ShearletTransform/AdjShearletTransform_help.html
% ADJSHEARLETTRANSFORM>,
% <../ShearletTransform/InvShearletTransform_help.html
% INVSHEARLETTRANSFORM>,
% <DenoiseDemo_help.html DENOISEDEMO>
% <ShxThres_help.html SHXTHRES>
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
