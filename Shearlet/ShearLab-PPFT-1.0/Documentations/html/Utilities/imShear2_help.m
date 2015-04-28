%% IMSHEAR2 
% Image shearing with slope s
% 
%% DESCRIPTION
%   IMGOUT = IMSHEAR2(I,S)
%    double the size of the image by 
%    symmetrical zero padding 
%    and then shear the image with slope S.
%   Input
%      I - Image 
%      s - slope
%   Ouput
%      imgOut - Output sheared image with size double
%
%% EXAMPLE
      img = zeros(256);
      img(129,:) = 1;      
      imgS = imShear2(img,0.5);
      figure(1);
      subplot(1,2,1), imshow(img);
      subplot(1,2,2), imshow(imgS); 

%% See also 
% <imShear_help.html IMSHEAR>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
