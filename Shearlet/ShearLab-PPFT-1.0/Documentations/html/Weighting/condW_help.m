%% CONDW 
% condition number for the operator (F*wF - Id)||^2. Here F is the operator PPFT.

%% Description
%  c = CONDW(N,R,BASISCHOICE) return the condition number for the
%  operator (F^*wF-Id) 

%% Examples
     N = 32;  R = 2; Choice = 1;
     c = condW(N,R,Choice)

%% See also 
% <errorW_help.html ERRORW>,
% <errorW_random_help.html ERRORW_RANDOM>,
% <loadW_help.html LOADW>,
% <findWeight_help.html FINDWEIGHTW>,
% <WeightGenerate_help.html WEIGHTGENERATE>,
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <basisFunction_help.html BASISFUNCTION>,
% <../Utilities/EigMaxMinFtCF_help.html EIGMAXMINFTCF>.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
