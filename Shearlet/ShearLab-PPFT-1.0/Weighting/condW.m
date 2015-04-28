function c = condW(N,R,basisChoice)
%% CONDW condition number for the operator (F*wF - Id)||^2.
% here F is the operator PPFT.
%
%% Description
%  c = CONDW(N,R,BASISCHOICE) return the condition number for the
%  operator (F^*wF-Id) 
%
%% Examples
%     N = 32;  R = 2; Choice = 1;
%     c = condW(N,R,Choice);
%
%% See also ERRORW, LOADW, SAVEW, FINDWEIGHT, WEIGHTGENERATE, PPFT, ADJPPFT,
% BASISFUNCTION, EIGMAXMINFTCF, ERRORW_RANDOM.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

P  = basisFunction(N,R,basisChoice);
w0 = loadW(N,R,basisChoice);
W  = WeightGenerate(N,P,w0);

powerm      = 50;
[lmax,lmin] = EigMaxMinFtCF(W,powerm);  

c = lmax/lmin;

return