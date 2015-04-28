%% FINDWEIGHT 
% find suitable weights on pseudo-polar grids in basis funtions.
%
%% Description
% [W,W0,W1,W2,Q,B,QH] = FINDWEIGHT(P,N,NONNEG) find weights on pseudo-polar
% grid in terms of basis functions, P is generated from the  routine
% basisFuntion(N,R,Choice), N is the original image size,
%
%    NONNEG = 'forceNN1', use fnnls to find nonnegative weights, w = w0;
%    NONNEG = 'forceNN2', use lsqnonneg to find nonnegative weights, w =
%    w2;
%    NONNEG = otherwise, weights can be negative, w = w1.
%
% Q  = qh*qh';w, w0, w1, w2 are obtained by solving the least square problem
% Qw = b; qh is the linear conditions on the weights.
%
%% Examples
    N = 64; R = 2; Choice = 1;
    P = basisFunction(N,R,Choice);
    [w,w0,w1,w2] = findWeight(P,N,'forceNN2');

%% See also 
% <condW_help.html CONDW>,
% <errorW_random_help.html ERRORW_RANDOM>,
% <loadW_help.html LOADW>,
% <saveW_help.html SAVEW>,
% <WeightGenerate_help.html WEIGHTGENERATE>,
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <basisFunction_help.html BASISFUNCTION>.
% <fnnls_help.html FNNLS>.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
