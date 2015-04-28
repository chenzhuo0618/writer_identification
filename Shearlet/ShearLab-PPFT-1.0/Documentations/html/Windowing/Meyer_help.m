%% MEYER 
% Meyer scaling and Wavelet function
%
%% Description
%  y = Meyer(a,b,x,type)
%    1. 0 < a < b are two parameters, m = sqrt(a*b);
%    2. x =[v1,v2,...] are sampling points of real numbers.
%    3. if type == 'wavelet'
%        y = sin(pi/2*nv((abs(x)-a)/(m-a))) for a <= abs(x) <= m;
%        y = cos(pi/2*nv((abs(x)-m)/(b-m))) for m <= abs(x) <= b;
%        y = 0                             for x otherwise.
%    4. if type == 'scaling'
%        y = 1;                            for abs(x) <=a;
%        y = cos(pi/2*nv((abs(x)-a)/(m-a)));for a < abs(x) <= m;
%        y = 0;                            for x otherwise.
%    5. nv(x) is any function s.t. nv(x)+nv(1-x) = 1 for |x|<=1, e.g.,
%        nv = 0;           for x <= 0;
%        nv = 2*x^2;       for 0 < x < 1/2;
%        nv = 1-2*(1-x)^2; for 1/2 <x< 1;
%        nv = 1          ; for x >=1

%% Examples
      a  = 1/4; b = 4;
      x  = [-4:0.1:4];
      ys = Meyer(a,b,x,'scaling');
      yw = Meyer(a,b,x,'wavelet');
      plot(x,ys,x,yw,x,ys.^2+yw.^2);

%% See also 
% <bumpV_help.html BUMPV>, 
% <nv_help.html NV>, 
% <ParaScale_help.html PARASCALE>, 
% <WindowOnPPGrid_help.html WINDOWONPPGRID>.
% <AdjWindowOnPPGrid_help.html ADJWINDOWONPPGRID>.

%% Copyright
%  Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

%% Upadate History
%  Modified by Xiaosheng Zhuang on Nov. 11, 2010
