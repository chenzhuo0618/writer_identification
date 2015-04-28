%% DISPLAYSHX 
%  display shearlet coefficient blocks
%  Use pause, press any key to continue
%% DESCRIPTION
%    DISPLAYSHX(X,R,BETA,PRECOND,LEVEL), 
%    Input
%      X     - image
%      R     - oversampling rate
%      beta  - scaling factor
%      Choice- basisChoice
%      scale - which scale (level)
%      level - decomposition level
%
%% EXAMPLE
      N = 256; R = 8; beta = 4; Choice = 0; level=0;
      x = randn(N);
      displayShX(x,R,beta,Choice,level);

%% See also 
% <ppview_help.html PPVIEW>, 
% <PlotShearletImage_help.html PLOTSHEARLETIMAGE>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

