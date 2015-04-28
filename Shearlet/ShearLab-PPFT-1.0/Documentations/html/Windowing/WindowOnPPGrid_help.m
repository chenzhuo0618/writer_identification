%% WINDOWONPPGRID 
% W operator, subband windowing on PPGRID with 2D iFFT
%
%% Description
%  Y = WINDOWONPPGRID(X,BETA,LEVEL)
%    x: array (2,(R*n)+1,n+1) : (sector,radial,slope) 2 sectors.  
%    beta: 2 or 4; scaling factor 2^j or 4^j.
%    level: decomposition level, default to lowest possible level.
%    R: oversampling rate
%    y: digital shearlet coefficients which is a cell array:   
%       each y{sector,scale,tile} is a complex-valued matrix, 2D FFT
%    sector runs through 4 values
%    scale  runs through J     approx log(N)/log(beta/2) values
%    tile   runs through Ntile approx beta^scale values   [OUCH!]
%
%% Examples
    R    = 4; beta = 4;
    img  = imread('barbara.gif');
    img  = double(img);
    pimg = ppFT(img,R);
    shX  = WindowOnPPGrid(pimg,beta,0);
    size(shX)
    
%% See also 
% <meyer_help.html MEYER>, 
% <bumpV_help.html BUMPV>, 
% <nv_help.html NV>, 
% <ParaScale_help.html PARASCALE>, 
% <AdjWindowOnPPGrid_help.html ADJWINDOWONPPGRID>.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
