function W = generateW(N,R,basisChoice)
%% WEIGHTGENERATE generate weight on a pseudo-polar grid
%
%% Description
%  W = WEIGHTGENERATE(N,R,BASISCHOICE) generate a weight matrix on a pseudo-polar
%  grid for an image of size N. basisChoice is the basis parameter in the
%  routine  BASISFUNCTION. R is the oversampling rate.
%  if basisChoice = 0 return a identity matrix
%
%% Examples
%    N = 64; R = 2; Choice = 1;
%    W = generateW(N,R,Choice);
%
%% See also BASISFUNCTION, FINDWEIGHT, LOADW, SAVEW, ERRORW,
%% ERRORW_RANDOM, WEIGHTGENERATE

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

if basisChoice == 0
    W = ones(2,R*N+1,N+1);
    return;
end

P  = basisFunction(N,R,basisChoice); 
w0 = loadW(N,R,basisChoice);
W  = WeightGenerate(N,P,w0);
end