function x = InvFtCF(y,K,C)
%INVFTCF inverse of FtCF.   
%   Here F denotes the operator of the pseudo-polar transform and
%   C is the weights on the pseudo-polar grid. Ft is F^* -- the adjoint.
%
%   X = INVFTCF(Y,K,C) slove the matrix inverse proble A X = Y with A being
%   the operator F^*CF, where F is the pseudo-polar transform operator, C
%   is the weighting matrix, and F^* is the adjoint of F. Use conjugate
%   gradient method.
% 
%   Examples
%       n  = 20; R = 2;
%       x0 = randn(n);
%       C  = ones(2,R*n+1,n+1);
%       y  = ppFT(x0,R);
%       b  = AdjppFT(y.*C,R);      
%       x  = InvFtCF(b,n,C);
%       err= norm(x-x0,'fro')/norm(x0,'fro')
%
%  See also FTCF, INVPPFTCG.

%  Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

N = size(C,3)-1;
R = (size(C,2)-1)/N;

x0 = 0;
b  = FtCF(y,C); % AdjppFT(W.*ppFT(y,R),R);%A'*randn(15,1);
r  = b;         % r=b-a*x0
w  = -r;

%z1=AdjppFT(W.*ppFT(w,R),R);
z  = FtCF(FtCF(w,C),C); % AdjppFT(W.*ppFT(z1,R),R);%A'*A*w;
a  = (r(:)'*w(:))/(w(:)'*z(:));
x  = x0 + a*w;
B  = 0;

for i = 1:K;
    r = r - a*z;
    % disp([i norm(r)])
    if( norm(r) < 1e-5 )
        break;
    end
    B = (r(:)'*z(:))/(w(:)'*z(:));
    w = -r + B*w;
    %z1=AdjppFT(W.*ppFT(w,R),R);
    z = FtCF(FtCF(w,C),C);%z = FAdjppFT(W.*ppFT(z1,R),R);
    a = (r(:)'*w(:))/(w(:)'*z(:));
    x = x + a*w;

end

return




