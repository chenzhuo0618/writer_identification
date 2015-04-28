%% PHOLDERSMOOTH2D 
%  compute local holder smoothness of a image
% 
%% DESCRIPTION
%  ALPHA = PHOLDERSMOOTH2D(IMG,POINT,RADIUS)
%  comput the holder regularity of an image at point u0=(x0,y0)
%  model: |I(u)-I(u0)|<C|u-u0|^\alpha.
%  use least square fit for log(|I(u)-I(u0)| = logC + alpha *log|u-u0|
%  Input
%      img     - Image 
%      (x0,y0) - location
%       radius - radius
%  Ouput
%      alpha - local holder smoothness
%
%% EXAMPLE
      [X,Y] = GetShearlet(256,8,4,1,3,0);
      alpha = pHolderSmooth2D(X,129,129,3)
      
%% See also 
% <GetShearlet_help.html GETSHEARLET>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

 