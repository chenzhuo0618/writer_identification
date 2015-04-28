function y=nv(x,N)
%% NV a function s.t. nv(x)+nv(1-x) = 1 for |x|<=1;
%
%% Description
%  nv(x) is a function s.t. nv(x)+nv(1-x) = 1 for |x|<=1
%   1. Default.
%        nv = 0;           for x <= 0;
%        nv = 2*x^2;       for 0 < x < 1/2;
%        nv = 1-2*(1-x)^2; for 1/2 <x< 1;
%        nv = 1          ; for x >=1
%  2. for nonnegative integer N.
%        nv(x) in [0,1] is a polynoimal of order 2*N+1:
%        nv(x) = x^{N+1}*(c_0+c_1*x+...+c_N*x^N);
%% Examples
%     x = [-0.02:0.01:1.02];
%     y1 = nv(x,0); y2 = nv(x,2); y3 = nv(x,4);
%     plot(x,y1,x,y2,x,y3);
%
%% See also MEYER, BUMPV, PARASCALE, WINDOWONPPGRID, ADJWINDOWONPPGRID

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

if nargin == 1
   y = zeros(size(x));
   y = y+(x >= 0).*(x <= 0.5).*2.*x.^2;
   y = y+(x >0.5).*(x <= 1  ).*(1-2*(1-x).^2);
   y = y+(x >  1);
   return
end

if nargin == 2 && N < 0
    error('Order parameter N must be nonnegative! Usage: nu(x,N).');
end

if nargin == 2 && N >= 0    
    y  = zeros(size(x));
    for k = [0:N]
        y = y+(x > 0).*(x < 1).*(-1)^k*nchoosek(2*N+1,N-k)*nchoosek(N+k,k).*x.^(N+1+k);
    end
    y = y + (x >=1);
    return
end

end