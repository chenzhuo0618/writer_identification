function [RecX,ThresCoeff]=dshden(X,thr,R,beta,basisChoice,level,CG,err,its)
%% DSHDEN shearlet denosing
% 
%% Description
% [RECX,THRESCOEFF]=DSHDEN(X,THR,R,BETA,BASISCHOICE,LEVEL,CG,ERR,ITS).
% shearlet denoising.
% INPUT
%    X      - Noisy image
%    thr    - threshold
%    R      - oversampling rate, default R = 2;
%    beta   - scaling factor, default beta = 4;
%basisChoice- weighting basis matrix, see BASISFUNCTION
%    level  - decomposition level
%    CG     - if CG == 1, use CG iteration to get the inverse
%             else, use Adjoint
%    err    - error control in the CG.
%    its    - iteration total number
% OUTPUT
%    recX       - reconstructed image
%    ThresCoeff - shearlet coefficient of X.
% 
%% Examples
%    see DENOISEDEMO
%% See also SHEARLETTRANSFORM, GENERATEW, ADJSHEARLETTRANSFORM,
%% INVSHEARLETTRANSFORM, DENOISEDEMO
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck



% preprocessing
[n,m] = size(X);
if n ~= m   error('image must be a square!');  end
N = n;

if nargin < 2
    error('Input threshold!');    
elseif  nargin == 2    
    R     = 2;    beta  = 4;    basisChoice = 0;
    level = 0;    CG    = 0;    
    err   = 1e-5; its   = N;
elseif nargin == 3
    beta  = 4;    basisChoice = 0;
    level = 0;    CG    = 0;    
    err   = 1e-5; its   = N;
elseif nargin == 4
    basisChoice = 0;
    level = 0;    CG    = 0;    
    err   = 1e-5; its   = N;
elseif nargin == 5
    level = 0;    CG    = 0;    
    err   = 1e-5; its   = N;
elseif nargin == 6
    CG    = 0;    
    err   = 1e-5; its   = N;
elseif nargin == 7
    err   = 1e-5; its   = N;
elseif nargin == 8
    its   = N;
end

% Compute Shearlet coeffcients
w1  = generateW(N,R,basisChoice); 
ShX = ShearletTransform(X,R,beta,w1,level);

% thresholding
ThresCoeff = ShXThres(ShX,N,R,beta,thr,level);

% reconstruction
 w2 = generateW(N,R,basisChoice);
 if CG == 1                                 % using CG     
    [RecX,it,res] = InvShearletTransform(ThresCoeff,N,R,beta,w2,err,its);
    disp(['Iterative Times for Reconstruction (CG) = ' num2str(it)]);
 else                                       % using Adjoint
    RecX = AdjShearletTransform(ThresCoeff,N,R,beta,w2);
 end
 
 
end