%% ERRORW 
% the frobenious error of (F*wF - Id), here F is the operator PPFT.
%
%% Description
%  ERR = ERRORW(IMG,R,BASISCHOICE) return the frobenious norm of the
%  operator (F^*wF-Id) applying to an image I, i.e.,
%          err = ||(F^*wF-Id)I||^2/||I||^2
%
%% Examples
     img = imread('barbara.gif');
     R   = 2; Choice = 1;
     err = errorW(img,R,Choice)

%% See also 
% <condW_help.html CONDW>,
% <errorW_random_help.html ERRORW_RANDOM>,
% <loadW_help.html LOADW>,
% <saveW_help.html SAVEW>,
% <findWeight_help.html FINDWEIGHTW>,
% <WeightGenerate_help.html WEIGHTGENERATE>,
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <basisFunction_help.html BASISFUNCTION>.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
