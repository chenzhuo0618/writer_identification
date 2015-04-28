function [x,y,ll,kk]=GetppCoordinates(n,R)
%% GETPPCOORDINATES -- Get XY coordinates of pp grid of size n
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
%      N = 32; R = 2;
%      [x,y] = GetppCoordinates(N,R);
%
%% See also PPFT, ADJPPFT, PPVIEW, BASISFUNCTION

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck



if nargin == 1
    R = 2;
end

M = R*n+1;
N = n+1;

k     = -(R/2)*n:(R/2)*n;
l     = -n/2:n/2;
[l,k] = meshgrid(l,k);

x(1,:,:) =-2*l.*k/n;
x(2,:,:) = k;
y(1,:,:) = x(2,:,:);
y(2,:,:) = x(1,:,:);


ll(1,:,:) = l;
ll(2,:,:) = k;
kk(1,:,:) = ll(2,:,:);
kk(2,:,:) = ll(1,:,:);
