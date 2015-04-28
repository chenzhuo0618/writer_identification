%% PLOTSHEARLETIMAGE 
% display shearlet in time and freq domain
%
%% DESCRIPTION
%    [X,Y] = PLOTSHEARLETIMAGE(N,R,BETA,SECTOR,SCALE,SHEAR,POSITION);
%    Input
%      N     - original image size
%      R     - oversampling rate
%      beta  - scaling factor
%      sector- which sector(1,2,3,4)
%      scale - which scale (level)
%      sher  - shearing parameter
%    Ouput
%      X - shearlet in time domain
%      Y - shearlet in frequency domain
%
%% EXAMPLE
      N = 256; R = 8; beta = 4; sector = 1; scale = 3; shear = 0;
      [X, Y] = PlotShearletImage(N,R,beta,sector, scale, shear); 

%% See also 
% <ppview_help.html PPVIEW>,
% <displayShX_help.html DISPLAYSHX>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
