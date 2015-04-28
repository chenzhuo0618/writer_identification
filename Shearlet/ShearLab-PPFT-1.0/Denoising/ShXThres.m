function ThresCoeff = ShXThres(ShX,N,R,beta,thr,level)
%% SHXTHRES thresholding shearlet coefficients
% 
%% Description
% ThresCoeff = ShXThres(ShX,N,R,beta,thr,level)
% thresholding shearlet coefficients.
% INPUT
%    ShX    - shearlet coefficeints
%    N      - size of original image
%    R      - oversampling rate, default R = 2;
%    beta   - scaling factor, default beta = 4;
%    thr    - threshold
%    level  - decompoistion level
%  OUTPUT
%    ThresCoeff - thresholded shearlet coefficient of X.
% 
%% Examples
%    see DENOISEDEMO
%% See also SHEARLETTRANSFORM, GENERATEW, ADJSHEARLETTRANSFORM,
%% INVSHEARLETTRANSFORM, DENOISEDEMO
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck



JH = ceil(log2(N)/log2(beta));       % highest level 
JL = -ceil(log2(R/2)/log2(beta));    % lowest possible level

if nargin <= 5 level = 0; end

if level > 0 && level <= JH-JL+1   
    JL = JH-level+1;                 % lowest level.
end

ThresCoeff = ShX;
for sector = 1:4
    for scale=JH:-1:JL-1
         Ntile = ParaScale(scale,beta);
         for tile=-Ntile:Ntile
             
%                if abs(tile) == Ntile
%                    thr0 = 2*thr;
%                else
%                    thr0 = thr;
%                end
%                if scale <= 2;
%                    thr0 = thr*(4-scale);
%                else
%                    thr0 = thr;
%                end
%               thr_j = thr*sqrt((JH-scale+1));

              mask = abs(ShX{sector,scale-JL+2,tile+Ntile+1}) > thr; 
              %mask = abs(ShX{sector,scale-JL+2,tile+Ntile+1}) > abs(nShX{sector,scale-JL+2,tile+Ntile+1}); 
              
              ThresCoeff{sector,scale-JL+2,tile+Ntile+1} = ShX{sector,scale-JL+2,tile+Ntile+1}.*mask;
              %ThresCoeff{sector,scale-JL+2,tile+Ntile+1} = ShX{sector,scale-JL+2,tile+Ntile+1}-nShX{sector,scale-JL+2,tile+Ntile+1};
         end;
     end;
 end;
return;
end

