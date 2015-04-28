function X=AdjShearletTransform(ShX,N,R,beta,w)
%% AdjShearletTransform Adjoint of Shearlet Transform. (W sqrt(w) P)^\star
% 
%% Description
% 
%  X=ADJSHEARLETTRANSFORM(SHX,N,R,BETA,W)
% Input:
%   ShX - shearlet coefficient structure from SHEARLETTRANSFORM
%   N   - original image size N.
%   R   - oversampling rate
%   w   - weighting matrix, see GENERATEW
% Output:
%   X   - image of size N-by-N.
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
%  toc
%
%% See also SHEARLETTRANSFORM, PPFT, WINDOWONPPGRID, GENERATEW, ADJPPFT,
%% ADJWINDOWONPPGRID
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck


if (nargin == 1)
    error('Input original image size N. Usage: AdjShearletTransform(shX,N,R,beta,W).');
elseif (nargin == 2)
    R    = 2;
    beta = 4;
    w    = ones(2,R*N+1,N+1);
elseif (nargin == 3)    
    beta = 4;
    w    = ones(2,R*N+1,N+1);
elseif (nargin == 4)
    W    = ones(2,R*N+1,N+1);
end

disp('Backward Shearlet Transform...');
% Adjoint Windowing on PP Grid
disp('Adjoint Windowing...');
FX = AdjWindowOnPPGrid(ShX,N,R,beta);

% Weighting on PPGrid
disp('Weighting...');
FX = w.^(1/2).*FX;

% Adjoint PPFT
disp('AdjppFT...');
X = AdjppFT(FX,R);

disp('Done with Backward Shearlet Transform!');
return;