%% ERRORW_RANDOM 
% Operator norm estimate for  ||F*wF I- I||^2/||I||^2 
% using random image. here F is the operator PPFT.
%
%% Description
%  op = ERRORW_RANDOM(N,R,BASISCHOICE) return the frobenious norm estimate 
%  of the operator (F^*wF-Id) applying to a image I, i.e.,
%          op = \sum_{k=1}^{nTotal} ||(F^*wF-Id)I_k||^2/||I_k||^2.
%  I_k is the random image from routine RAND.
%
%% Examples
     nTotal = 5; N = 32;
     R   = 2; Choice = 1;
     op = errorW_random(N,R,Choice,nTotal)

%% See also 
% <errorW_help.html ERRORW>,
% <saveW_help.html SAVEW>,
% <loadW_help.html LOADW>,
% <findWeight_help.html FINDWEIGHTW>,
% <WeightGenerate_help.html WEIGHTGENERATE>,
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <basisFunction_help.html BASISFUNCTION>,
% <../Utilities/EigMaxMinFtCF_help.html EIGMAXMINFTCF>.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
