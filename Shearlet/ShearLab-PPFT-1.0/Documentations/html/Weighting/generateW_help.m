%% WEIGHTGENERATE 
% generate weight on a pseudo-polar grid
%
%% Description
%  W = WEIGHTGENERATE(N,R,BASISCHOICE) generate a weight matrix on a pseudo-polar
%  grid for an image of size N. basisChoice is the basis parameter in the
%  routine  BASISFUNCTION. R is the oversampling rate.
%
%% Examples
    N = 64; R = 2; Choice = 1;
    W = generateW(N,R,Choice);

%% See also 
% <condW_help.html CONDW>,
% <errorW_random_help.html ERRORW_RANDOM>,
% <loadW_help.html LOADW>,
% <saveW_help.html SAVEW>,
% <WeightGenerate_help.html WEIGHTGENERATE>,
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <findWeight_help.html FINDWEIGHT>,
% <basisFunction_help.html BASISFUNCTION>,
% <fnnls_help.html FNNLS>.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
