%% ADJWINDOWONPPGRID 
% Adjoint W operator, adjoint subband windowing  with 2D FFT
%
%% Description
%  Y = ADJWINDOWONPPGRID(Y,N,R,BETA)
%    x: array (2,(R*n)+1,n+1) : (sector,radial,slope) 2 sectors.  
%    beta: 2 or 4; scaling factor 2^j or 4^j.
%    R: oversampling rate
%    y: digital shearlet coefficients which is a cell array:   
%       each y{sector,scale,tile} is a complex-valued matrix, 2D FFT
%    sector runs through 4 values
%    scale  runs through J     approx log(N)/log(beta/2) values
%    tile   runs through Ntile approx beta^scale values   [OUCH!]

%% Examples
    R    = 4; beta = 4;
    img  = imread('barbara.gif');
    img  = double(img);
    N    = size(img,1);
    pimg = ppFT(img,R);
    shX  = WindowOnPPGrid(pimg,beta,0);
    size(shX)
    tpimg= AdjWindowOnPPGrid(shX,N,R,beta);
    size(tpimg)
    norm(squeeze(tpimg(1,:,:)-pimg(1,:,:)),inf)
    norm(squeeze(tpimg(2,:,:)-pimg(2,:,:)),inf)

%% See also 
% <meyer_help.html MEYER>, 
% <bumpV_help.html BUMPV>, 
% <nv_help.html NV>, 
% <ParaScale_help.html PARASCALE>, 
% <WindowOnPPGrid_help.html WINDOWONPPGRID>.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
