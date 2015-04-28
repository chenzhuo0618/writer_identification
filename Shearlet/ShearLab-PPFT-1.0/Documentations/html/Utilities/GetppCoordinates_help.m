%% GETPPCOORDINATES  
%  Get XY coordinates of pp grid of size n
% 
%% DESCRIPTION
%   [X,Y,LL,KK]=GETPPCOORDINATES(N,R)
%   Generate coordinate on ppgrid for size N and oversampling R.
%   Input
%      N - Image size
%      R - oversampling Rate
%   Ouput
%      X - x-coordinate of ppgrid
%      Y - y-coordinate of ppgride
%
%% EXAMPLE
      N = 32; R = 2;
      [x,y] = GetppCoordinates(N,R);

%% See also 
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <../Visualization/ppview_help.html PPVIEW>,
% <../Weighting/basisFunction_help.html BASISFUNCTION>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
