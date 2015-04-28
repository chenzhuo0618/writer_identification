function alpha = pHolderSmooth2D(img,x0,y0,radius)
%% PHOLDERSMOOTH2D compute local holder smoothness of a image
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
%      [X,Y] = GetShearlet(256,8,4,1,3,0);
%      alpha = pHolderSmooth2D(X,129,129,3)
%      
%% See also GETSHEARLET

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

% 
[n,m] = size(img);
r = round(abs(radius));
ax = max([x0-r,1]); bx = min([x0+r,n]);
ay = max([y0-r,1]); by = min([y0+r,m]);


[gx,gy] = meshgrid(ax:bx,ay:by);
dx = sqrt((gx-x0).^2+(gy-y0).^2);
dx = dx(:);

dy = img(ax:bx,ay:by)-img(x0,y0);
dy = abs(dy(:));

ind1 = (dx > 0);
ind2 = (dy > 0);
ind = ind1.*ind2;
n = sum(ind);
[ind3,ind4] = sort(ind,'descend');
ind = ind4(1:n);
dx = dx(ind);
dy = dy(ind);

A = [ones(length(dx),1),log2(dx)];
y = log2(dy);
x = A\y;
alpha = x(2);
end