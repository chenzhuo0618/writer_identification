%% INVPPFTCG 
% the inverse of PPFT USING CG (conjugate gradient) method.
%
%% Description
%  X = INVPPFTCG(Y,K,ERR) return the inverse PPFT using CG in at most K
%  iteration or at precision control by ERR. K
%  
%  [X,ITERS,RSNEW,TSEC]=IINVPPFTCG(Y,K,C,ERR,WEIGHTED); 
%  INPUT: y - input image on ppGrid
%         K - maximal iteration times
%         C - weights on ppGrid
%         err - iteration stop error
%         weighted - if equal to 1, solve P^\star w P X = Y, else solve
%         P^\star w P = C.*Y;
%  OUPUT: x    - image; 
%        iters - iteration times; 
%        rsnew - residual error;
%        tsec  - total running times in seconds;
%
%% Examples
        img = imread('barbara.gif');
        img = double(img(1:64,1:64));
       pImg = ppFT(img,2);
       oImg = InvppFTCG(pImg);
       err  = norm(oImg-img,'fro')/norm(img,'fro')

%% See also 
% <ppFT_help.html PPFT>, 
% <AdjppFT_help.html ADJPPFT>, 
% <FtCF_help.html FTCF>,
% <InvFtCF_help.html INVFTCF>,

%% Copyright
%  Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
