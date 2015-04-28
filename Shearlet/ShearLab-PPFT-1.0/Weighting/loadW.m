function w = loadW(N,R,basisChoice)
%% LOADW load weight constants found by FINDWEIGHTS
%
%% Description
% w =  LOADW(N,R,BASISCHOICE) load weight constants from files. N is the
% image size, R is the oversampling rate, basisChoice is the 'Choice'
% parameter in BASISFUNCTION. Return weight constant w is obtained from
% findWeight using lsqnonneq (nonnegative weight constants)
%
%% Examples
%    N = 128; R=4; basisChoice = 1;
%    w = loadw(N,R,basisChoice);
%
%% See also BASISFUNCTION, FINDWEIGHT, WEIGHTGENERATE

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

Wstr = ['WeightN' num2str(N) 'R' num2str(R) 'P' num2str(basisChoice)];
load(Wstr);
w = W(:,3);

return
