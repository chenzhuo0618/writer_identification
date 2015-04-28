%% LOADW 
% load weight constants found by FINDWEIGHTS
%
%% Description
% w =  LOADW(N,R,BASISCHOICE) load weight constants from files. N is the
% image size, R is the oversampling rate, basisChoice is the 'Choice'
% parameter in BASISFUNCTION. Return weight constant w is obtained from
% findWeight using lsqnonneq (nonnegative weight constants)
%
%% Examples
    N = 128; R=4; basisChoice = 1;
    w = loadw(N,R,basisChoice);

%% See also 
% <condW_help.html CONDW>,
% <errorW_random_help.html ERRORW_RANDOM>,
% <saveW_help.html SAVEW>,
% <findWeight_help.html FINDWEIGHT>,
% <WeightGenerate_help.html WEIGHTGENERATE>,
% <basisFunction_help.html BASISFUNCTION>.
% <fnnls_help.html FNNLS>.
% LSQNONNEG
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
