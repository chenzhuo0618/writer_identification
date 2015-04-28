%% INVFTCF 
%   inverse of FtCF.   
%
%% Description 
%   Here F denotes the operator of the pseudo-polar transform and
%   C is the weights on the pseudo-polar grid. Ft is F^* -- the adjoint.
%
%   X = INVFTCF(Y,K,C) slove the matrix inverse proble A X = Y with A being
%   the operator F^*CF, where F is the pseudo-polar transform operator, C
%   is the weighting matrix, and F^* is the adjoint of F. Use conjugate
%   gradient method.
% 
%% Examples
       n  = 20; R = 2;
       x0 = randn(n);
       C  = ones(2,R*n+1,n+1);
       y  = ppFT(x0,R);
       b  = AdjppFT(y.*C,R);      
       x  = InvFtCF(b,n,C);
       err= norm(x-x0,'fro')/norm(x0,'fro')

%% See also 
% <ppFT_help.html PPFT>, 
% <AdjppFT_help.html ADJPPFT>, 
% <FtCF_help.html FTCF>,
% <InvppFTCG_help.html INVPPFTCG>.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck



