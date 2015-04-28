function imgOut = imShear(I,s)
%% IMSHEAR Image shearing with slope s
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
%      img = zeros(256);
%      img(129,:) = 1;      
%      imgS = imShear(img,0.5);
%      figure(1);
%      subplot(1,2,1), imshow(img);
%      subplot(1,2,2), imshow(imgS); 
%
%% See also IMSHEAR2

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck


   [m,n] = size(I);
   if m ~= n
       error('Image must be a square!');
   end
   imgOut = zeros(n,n);
   for i = 1:n;
       for j = 1:n;
           v = round(j-n/2-1+(i-n/2-1)*s)+n/2+1;
           if v < 1 || v > n
              v = mod(v,n);
              if v == 0
                  v = n;
              end
           end
           imgOut(j,i) = I(v,i); 
       end           
end