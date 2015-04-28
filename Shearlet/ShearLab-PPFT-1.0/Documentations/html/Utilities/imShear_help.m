%% IMSHEAR 
% Image shearing with slope s
% 
%% DESCRIPTION
%   IMGOUT = IMSHEAR(I,S)
%    shear a image with slope S.
%   Input
%      I - Image 
%      s - slope
%   Ouput
%      imgOut - Output sheared image
%
%% EXAMPLE
      img = zeros(256);
      img(129,:) = 1;      
      imgS = imShear(img,0.5);
      figure(1);
      subplot(1,2,1), imshow(img);
      subplot(1,2,2), imshow(imgS); 

%% See also 
% <imShear2_help.html IMSHEAR2>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
