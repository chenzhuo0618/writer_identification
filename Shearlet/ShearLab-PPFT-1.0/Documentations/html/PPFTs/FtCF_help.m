%% FTCF 
%  the operator F^*CF applying to a vector x and F is the operator PPFT.
%
%% Description
%   Here F denotes the operator of the pseudo-polar transform and
%   C is the weights on the pseudo-polar grid. F^* is the adjoint.
%
%   Y = FTCF(X,C) return y = F^*CF(x), i.e., first apply the pseudo-polar
%   transform to x, then apply the weigting on the resulted image, and
%   the apply the adjoint pseudo-polar transform to the weighted image.
% 
%% Examples
       n = 10; R = 2;
       x = randn(n);
       C = ones(2,R*n+1,n+1);
       y = FtCF(x,C);

%% See also 
% <ppFT_help.html PPFT>, 
% <AdjppFT_help.html ADJPPFT>, 
% <InvFtCF_help.html INVFTCF>,
% <InvppFTCG_help.html INVPPFTCG>.

%% Copyright
%  Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
