%% BUMPV 
% A bump function s.t. v(x-1)^2+v(x)^2+v(x+1)^2=1 for abs(x)<1
%
%% Description
%   y = bumpV(a,b,N)
%   a, b are integers; N is smooth order
%   rescale x =[a:b] to t = 2/(b-a)*(x-a)-1 in [-1,1]
%   return V(t) s.t. V(t-1)^2+V(t)^2+V(t+1)^2 =1 for abs(t)<=1;
%
%% Examples
  a = -10; b = 10;
  y = bumpV(a,b);
  plot(a:b,y);

%% See also 
% <meyer_help.html MEYER>, 
% <nv_help.html NV>, 
% <ParaScale_help.html PARASCALE>, 
% <WindowOnPPGrid_help.html WINDOWONPPGRID>.
% <AdjWindowOnPPGrid_help.html ADJWINDOWONPPGRID>.

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
