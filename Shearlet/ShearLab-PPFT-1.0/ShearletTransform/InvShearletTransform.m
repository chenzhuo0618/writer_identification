function [X,it,res]=InvShearletTransform(ShX,N,R,beta,w,err,its_Max)
%% INVShearletTransform Inverse of Shearlet Transform.
%
%% Description
% X=INVSHEARLETTRANSFORM(SHX,N,R,BETA,W,ERR,ITS_MAX)
% Input:
%   ShX - shearlet coefficient structure from SHEARLETTRANSFORM
%   N   - original image size N.
%   R   - oversampling rate
%   w   - weighting matrix, see GENERATEW
%   err - error controlled in CG
% itsMax- maximal iteration in CG
%
% Output:
%   X   - image of size N-by-N.
%   it  - total iteration times in CG
%   res - final iteration error in CG iteration
% 
%% Examples
%  tic
%  img = imread('barbara.gif');
%  img = double(img);
%  N   = size(img,1); beta = 4;
%  R   = 4; basisChoice  = 5;
%  w   = generateW(N,R,basisChoice);
%  shX = ShearletTransform(img, R, beta, w, 0);
%  timg= AdjShearletTransform(shX,N,R,beta,w);
%  err = norm(timg-img,'fro')/norm(img,'fro')
%  [timg, its, rerr] = InvShearletTransform(shX,N,R,beta,w,1e-5,3);
%  err = norm(timg-img,'fro')/norm(img,'fro')
%  its, rerr
%  toc
%
%% See also ADJSHEARLETTRANSFORM, SHEARLETTRANSFORM, PPFT, WINDOWONPPGRID, 
%  GENERATEW, ADJPPFT, ADJWINDOWONPPGRID
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck



if (nargin == 1)
    error('Input original image size N. Usage:InvShearletTransform(shX,N,R,beta,W,err,its_Max).');
elseif (nargin == 2)
    R    = 2;
    beta = 4;
    w    = ones(2,R*N+1,N+1);
    err  = 1e-5;
    its_Max = N;
elseif (nargin == 3)    
    beta = 4;
    w    = ones(2,R*N+1,N+1);
    err  = 1e-5;
    its_Max = N;    
elseif (nargin == 4)
    w    = ones(2,R*N+1,N+1);
    err  = 1e-5;
    its_Max = N;  
elseif (nargin == 5)
    err  = 1e-5;
    its_Max = N;  
elseif (nargin == 6)
    its_Max = N;
end


it  = 0;
res = 0;

disp('Inverse Shearlet Transform...');
% Adjoint Windowing on PPGrid
disp('Adjoint Windowing...');
FX = AdjWindowOnPPGrid(ShX,N,R,beta);

% Weighting on PPGrid
disp('Weighting...');
FX = w.^(1/2).*FX;


disp('InvppFTCG...');
[X,it,res] = InvppFTCG(FX,its_Max,w,err,1);

disp('Done with InverseShearlet Transform!');

return;