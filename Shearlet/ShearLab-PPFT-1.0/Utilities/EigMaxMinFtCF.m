function [lmax,lmin]=EigMaxMinFtCF(W,K,lfile)
%% EIGMAXMINFTCF condition number of P^\star w P using power method
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
%      N = 32; R = 2; Choice = 1;
%      W = generateW(N,R,Choice);
%      [lmax,lmin] = EigMaxMinFtCF(W,N);
%
%% See also PPFT, ADJPPFT, FTCF

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
   


e = inf;
N = size(W,3)-1;
R = (size(W,2)-1)/N;

x = randn(N);
x = x/norm(x(:));

err = 10^-5;
k   =0;
%K=5;
%lmax=0;

if nargin == 3
   fprintf(lfile, 'First the computation of lmax! \n');
end

while e > err && k<K
    y   = FtCF(x,W);    
    k   = k+1;
    lmax= norm(y(:));
    y   = y/norm(y(:));
    e   = norm(y(:)-x(:));
    x   = y;
    %fprintf(lfile, 'k=%5d, lmax=%15.12f, error=%15.10f \n',k,lmax,e);
    disp(['k = ' num2str(k) '; lmax = ' num2str(lmax) '; error = ' num2str(e)]);
end

if nargin == 3
   fprintf(lfile, 'Total Iters = %5d, lmax = %15.12f, error = %15.10f \n',k,lmax,e);
end

e = inf;
x = randn(N);
x = x/norm(x(:));
k = 0;

if nargin == 3
   fprintf(lfile, 'Now the computation of lmin! \n');
end

while e > err & k<K
    y   = InvFtCF(x,K,W);
    k   = k+1;
    lmin= 1/norm(y(:));
    y   = y/norm(y(:));
    e   = norm(y(:)-x(:));
    x   = y;
    
    disp(['k = ' num2str(k) '; lmin = ' num2str(lmin) '; error = ' num2str(e)]);
    %fprintf(lfile, 'k=%5d, lmin=%15.12f, error=%15.10f \n',k,lmin,e);
    %lmax/lmin
end

if nargin == 3
   fprintf(lfile, 'Total Iters = %5d, lmin = %15.12f, error = %15.10f \n',k,lmin,e);
end

return
