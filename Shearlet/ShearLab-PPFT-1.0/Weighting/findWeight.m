function [w,w0,w1,w2,Q,b,qh] = findWeight(P,N,Nonneg)
%% FINDWEIGHT find suitable weights on pseudo-polar grids in basis funtions.
%
%% Description
% [W,W0,W1,W2,Q,B,QH] = FINDWEIGHT(P,N,NONNEG) find weights on pseudo-polar
% grid in terms of basis functions, P is generated from the  routine
% basisFuntion(N,R,Choice), N is the original image size,
%    NONNEG = 'forceNN1', use fnnls to find nonnegative weights, w = w0
%    NONNEG = 'forceNN2', use lsqnonneg to find nonnegative weights, w = w2
%    NONNEG = otherwise, weights can be negative, w = w1.
% Q  = qh*qh';w, w0, w1, w2 are obtained by solving the least square problem
% Qw = b; qh is the linear conditions on the weights.
%
%% Examples
%    N = 64; R = 2; Choice = 1;
%    P = basisFunction(N,R,Choice);
%    [w,w0,w1,w2] = findWeight(P,N,'forceNN2');
%
%% See also BASISFUNCTION, FNNLS, LSQNONNEG, WEIGHTGENERATE, LOADW

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

d1 = 2;
d3 = N+1;
d2 = size(P,1)/(d1*d3);
R = (d2-1)/N;
LQ = size(P,2);
[x,y] = GetppCoordinates(N,R);

x  = x(:);
y  = y(:);
xx = [x(:) y(:)];

[m,n] = meshgrid(0:N-1,0:N-1);
 m = m(:);
 n = n(:);

 x = x*2*pi/(R*N+1);
 y = y*2*pi/(R*N+1);

 
 qh = zeros(N^2,LQ);

 for i=1:length(m)
   % t=cos(m(i)*x ).*cos( n(i)*y);
    t = cos(m(i)*x+ n(i)*y);
    qh(i,:) = t'* P;
 end
 Q = qh'*qh;

 if rank(Q) < size(Q,2)
     qh = [qh;10*eye(LQ)];
     Q = qh'*qh;
 end
     
 b = sum(P);
 b = b';
 w0 = fnnls(Q,b);
 w1 = Q\b; 
 options.Display = 'notify';
 options.TolX = 1e-15;
 w2 = lsqnonneg(Q,b,options);
 
 if strcmp(Nonneg,'forceNN1')
     w = w0;
 elseif strcmp(Nonneg,'forceNN2')
     w = w2;
 else
     w = w1;
 end
 
end