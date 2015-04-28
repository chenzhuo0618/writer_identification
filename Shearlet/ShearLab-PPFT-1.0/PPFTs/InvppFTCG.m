function [x,iters,rsnew,tsec]=InvppFTCG(y,K,C,err,weighted)
%INVPPFTCG the inverse of PPFT USING CG (conjugate gradient) method.
%
%  X = INVPPFTCG(Y,K,ERR) return the inverse PPFT using CG in at most K
%  iteration or at precision control by ERR. K
%  
%  [X,ITERS,RSNEW,TSEC]=IINVPPFTCG(Y,K,C,ERR,WEIGHTED); 
%  INPUT: y - input image on ppGrid
%         K - maximal iteration times
%         C - weights on ppGrid
%         err - iteration stop error
%         weighted - if equal to 1, solve P^\star w P X = Y, else solve
%         P^\star w P X = C.*Y;
%  OUPUT: x    - image; 
%        iters - iteration times; 
%        rsnew - residual error;
%        tsec  - total running times in seconds;
%
%  Examples
%        img = imread('barbara.gif');
%        img = double(img(1:64,1:64));
%       pImg = ppFT(img,2);
%       oImg = InvppFTCG(pImg);
%       err  = norm(oImg-img,'fro')/norm(img,'fro')
%
%  See also FTCF, PPFT, ADJPPFT, FRFT, ADJFRFT.
%
%  Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

t1 = tic;

if nargin == 1
    K        = size(y,3)-1;
    C        = ones(size(y)); 
    err      = 1e-5;
    weighted = 0;
elseif nargin <= 2 
    C        = ones(size(y)); 
    err      = 1e-5;
    weighted = 0;
elseif nargin <= 3
    err      = 1e-5;
    weighted = 0;
elseif nargin <= 4;
    weighted = 0;
end

N = size(C,3)-1;
R = (size(C,2)-1)/N;

x = 0;
if weighted == 1
   b = AdjppFT(y,R);
else
   b = AdjppFT(C.*y,R);
end

r = b; %r=b-a*x0
p = r;

rsold = r(:)'*r(:);

for i = 1:K;
    Ap    = FtCF(p,C);              % operator P^\star C P apply to vector p
    alpha = rsold/(p(:)'*Ap(:));
    x     = x + alpha*p;
    r     = r-alpha*Ap;
    rsnew = r(:)'*r(:);
    
    if( norm(rsnew) < err )
        iters = i;
        break;
    end
    
    p     = r+rsnew/rsold*p;
    rsold = rsnew;
end

iters = i;
tsec  = toc(t1);

return




