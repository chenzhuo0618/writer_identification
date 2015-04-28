%% EIGMAXMINFTCF 
% condition number of P^\star w P using power method
% 
%% DESCRIPTION
%   [LMAX,LMIN]=EIGMAXMINFTCF(W,K,LFILE)
%   Compute the maximal and minimal eigenvalues of the operator 
%                     P^\star w P
%   P is the pseudo-polar trasnform, see PPFT.
%   w is the weights on PP grid.
%   Input
%        W - the weighting matrix.
%        K - maximimal number of iterations in Power method
%    lfile - file handle. Write the result in a log file
%   Ouput
%        lmax - maximal eigenvalue
%        lmin - minimal eigenvalue
%
%% EXAMPLE
      N = 32; R = 2; Choice = 1;
      W = generateW(N,R,Choice);
      [lmax,lmin] = EigMaxMinFtCF(W,N);

%% See also 
% <../PPFTs/ppFT_help.html PPFT>,
% <../PPFTs/AdjppFT_help.html ADJPPFT>,
% <../PPFTs/FtCF_help.html FTCF>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
   
