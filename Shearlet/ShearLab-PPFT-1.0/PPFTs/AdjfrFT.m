function y=AdjfrFT(x,alpha)
%ADJFRFT adjoint fractional FFT, modified code
%
%   Y = ADJFRFT(X,ALPHA) compute the adjoint fractional Fourier transform
%   of X with fraction alpha. This equivalent to Y = FRFT(X,-ALPHA).
%
%   Examples
%        x = randn(5,3);
%        alpha = [1/3,1/2,1/4];
%        y = AdjfrFT(x, alpha);
%
%   See also FRFT, PPFT, ADJPPFT, INVPPFTCG

%  Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

y = frFT(x,-alpha);
  
return
