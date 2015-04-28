function ShX = ShearletTransform(X,R,beta,w,level)
%% SHEARLETTRANSFORM Digital Shearlet Transform (W sqrt(w) P)X
% W is the windowing, w is the weight operator, and P is the ppft operator
%
%% Desscription
% SHX = SHEARLETTRANSFORM_XZ(X,R,BETA,WEIGHT,LEVEL)
% Input:
%     X     - square N*N matrix  N dyadic
%     R     - oversamping rate, 2,4,8,16.
%     beta  - 2 or 4;
%     w     - Wegithing Matrix, size: 2*(R*N+1)*(N+1) must be nonnegative
%     level - decomposition level, level =0 means decompose to the lowest possible level
% Output:
%     ShX shearlet_coeff : shearlet coefficients (cell structure)
%
%% Examples
%  tic
%  img = imread('barbara.gif');
%  img = double(img);
%  N   = size(img,1); beta = 4;
%  R   = 4; basisChoice  = 5;
%  w   = generateW(N,R,basisChoice);
%  shX = ShearletTransform(img, R, beta, w, 0);
%  toc
%% See also PPFT, WINDOWONPPGRID, GENERATEW, ADJPPFT, ADJWINDOWONPPGRID,
%% ADJSHEARLETTRANSFORM, INVSHEARLETTRANSFORM
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

N = size(X,1);

if (nargin == 1)
    R    = 2; 
    beta = 4; 
    w    = ones(2,R*N+1,N+1); 
    level= 0;
elseif (nargin == 2)
    beta = 4; 
    w    = ones(2,R*N+1,N+1); 
    level= 0;
elseif (nargin == 3)    
    w    = ones(2,R*N+1,N+1); 
    level= 0;
elseif (nargin == 4)
    level = 0;    
end

disp('Forward Shearlet Transform...');
% compute the ppFT of image with oversampling R
disp('ppFT ...')
FX = ppFT(X,R);


% Weighting on PP Grid.
disp('Weighting ...')
FX = w.^(1/2).*FX;                    % Take a squareroot of w here

% Subband Windowing on PP Grid
disp('Windowing ...')
ShX = WindowOnPPGrid(FX,beta,level);
disp('Done with Forward Shearlet Transform!');
return;