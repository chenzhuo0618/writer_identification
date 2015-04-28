function [X,Y] = GetShearlet(N,R,beta,sector,scale,shear)
%% GETSHEARLET what a shearlet look like
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
%      N = 256; R = 8; beta = 4; sector = 1; scale = 3; shear = 0;
%      [X, Y] = GetShearlet(N,R,beta,sector, scale, shear); 
%      figure(1);
%      subplot(1,2,1), imagesc(abs(X));
%      subplot(1,2,2), imagesc(abs(Y)); 
%
%% See also WINDOWONPPGRID

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck


y = ones(2,R*N+1,N+1);
y(1,:,:) = 0;
shX = WindowOnPPGrid(y,beta);

JH = ceil(log2(N)/log2(beta));      
JL = -ceil(log2(R/2)/log2(beta));    % lowest possible level. if R=8 and beta=4, then JL=-1.

if scale > JH || scale < JL
    error(['Scale must be integers in [' num2str(JL) ',' num2str(JH), ']']);
end

for j = JH:-1:JL
    Ntile = ParaScale(j,beta);
    for tile = -Ntile:Ntile 
        if j ~= scale || tile ~= shear
            sect = mod(sector,2);
            shX{sector+1,j-JL+2, tile+Ntile+1}(:,:) = 0;
            shX{sector+3,j-JL+2, tile+Ntile+1}(:,:) = 0;
        end
    end
end

ty = AdjWindowOnPPGrid(shX,N,R,beta);
C  = generateW(N,R,1);
X  = InvppFTCG(ty,N,C,1e-5,0);
Y  = fftshift(fft2(ifftshift(X)));

end