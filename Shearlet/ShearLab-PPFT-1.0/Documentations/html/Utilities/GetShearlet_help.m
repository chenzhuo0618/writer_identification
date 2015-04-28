%% GETSHEARLET 
%  what a shearlet look like
%
%% DESCRIPTION
%    [X,Y] = GETSHEARLET(N,R,BETA,SECTOR,SCALE,SHEAR)
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
      [X, Y] = GetShearlet(N,R,beta,sector, scale, shear); 
      figure(1);
      subplot(1,2,1), imagesc(abs(X));
      subplot(1,2,2), imagesc(abs(Y)); 

%% See also 
% <../Windowing/WindowOnPPGrid_help.html WINDOWONPPGRID>,
% <../Windowing/AdjWindowOnPPGrid_help.html ADJWINDOWONPPGRID>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

