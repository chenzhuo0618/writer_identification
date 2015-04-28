function  y = bumpV(a,b,N)
%% BUMPV a bump function s.t. v(x-1)^2+v(x)^2+v(x+1)^2=1 for abs(x)<1
%
%% Description
%   y = bumpV(a,b,N)
%   a, b are integers; N is smooth order
%   rescale x =[a:b] to t = 2/(b-a)*(x-a)-1 in [-1,1]
%   return V(t) s.t. V(t-1)^2+V(t)^2+V(t+1)^2 =1 for abs(t)<=1;
%
%% Examples
%  a = -10; b = 10;
%  y = bumpV(a,b);
%  plot(a:b,y);
%
%% See also NV, MEYER, PARASCALE, WINDOWONPPGRID, ADJWINDOWONPPGRID


%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

x = [a:b];
t = 2/(b-a)*(x-a)-1;

if nargin == 2
   y = sqrt(nv(t+1) .* (t <= 0)+nv(1-t)  .*(t > 0));
else
   y = sqrt(nv(t+1,N).*(t <= 0)+nv(1-t,N).*(t > 0));
end 

end