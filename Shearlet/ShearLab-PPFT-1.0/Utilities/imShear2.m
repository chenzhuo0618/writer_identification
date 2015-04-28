function imgOut = imShear2(I,s)
%% IMSHEAR2 Image shearing with slope s
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
%      img = zeros(256);
%      img(129,:) = 1;      
%      imgS = imShear2(img,0.5);
%      figure(1);
%      subplot(1,2,1), imshow(img);
%      subplot(1,2,2), imshow(imgS); 
%
%% See also IMSHEAR

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

   [m,n] = size(I);
   if m ~= n
       error('Image must be a square!');
   end
   imgIn = zeros(2*n,2*n);
   imgIn(n/2+1:n/2+n,n/2+1:n/2+n) = I;
   imgOut = imShear(imgIn,s);
   return  
        
end

%    imgOut = zeros(2*n,2*n);
%    for i = 1:2*n;
%        for j = 1:2*n;
%            v = round(j-n-1+(i-n-1)*s)+n+1;
%            u = i;
%            if u >= 1 && u <= 2*n && v >= 1 && v <=2*n 
%               imgOut(i,j) = imgIn(u,v);
%            end
%        end   