function y=FtCF(x,C)
%FTCF the operator F^*CF applying to a vector x and F is the operator PPFT.
%   Here F denotes the operator of the pseudo-polar transform and
%   C is the weights on the pseudo-polar grid. F^* is the adjoint.
%
%   Y = FTCF(X,C) return y = F^*CF(x), i.e., first apply the pseudo-polar
%   transform to x, then apply the weigting on the resulted image, and
%   the apply the adjoint pseudo-polar transform to the weighted image.
% 
%   Examples
%       n = 10; R = 2;
%       x = randn(n);
%       C = ones(2,R*n+1,n+1);
%       y = FtCF(x,C);
%
%  See also INVFTCF, INVPPFTCG.

%  Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

N = size(C,3)-1;
R =(size(C,2)-1)/N;

y = ppFT(x,R);    % applying the pseudo-polar transform
y = C.*y;         % applying the weighting 
y = AdjppFT(y,R); % applying the adjoint transform

return