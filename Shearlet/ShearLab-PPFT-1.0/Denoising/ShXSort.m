function [SortCoeff,Index] = ShXSort(ShX,N,R,beta,mode)
%% SHXSORT sorting shearlet coefficients
% 
%% Description
% SORTCOEFF = SHXSORT(SHX,N,R,BETA,MODE)
% sorting shearlet coefficients in absolute value in descending order.
% INPUT
%    ShX    - shearlet coefficeints
%    N      - size of original image
%    R      - oversampling rate, default R = 2;
%    beta   - scaling factor, default beta = 4;
%    mode   - ascend or descend
%  OUTPUT
%    SortCoeff - sorted shearlet coefficient of X.
%    Index     - index from sort
% 
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
%% See also SHEARLETTRANSFORM, GENERATEW, ADJSHEARLETTRANSFORM,
%% INVSHEARLETTRANSFORM, DENOISEDEMO
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

if nargin == 4
    mode = 'descend';
end

JH = ceil(log2(N)/log2(beta));       % highest level 
JL = -ceil(log2(R/2)/log2(beta));    % lowest possible level

JH = ceil(log2(N)/log2(beta));        % highest level 
JL = -floor(log2(R/2)/log2(beta));    % lowest level

ListCoeff = [];
for sector = 1:4
    for scale = JH:-1:JL
         Ntile = ParaScale(scale,beta);
         for tile = -Ntile:Ntile
             LengthVector = prod(size(ShX{sector,scale-JL+2,tile+Ntile+1}));
             ListCoeff    = [ListCoeff reshape(ShX{sector,scale-JL+2,tile+Ntile+1},1,LengthVector)];
         end;   
    end;    
end;  

[SortCoeff, Index] = sort(ListCoeff,mode);

return
end

