% WINDOWING
%
% Files
%   AdjWindowOnPPGrid - W^* operator, adjoint subband windowing  with 2D FFT
%   bumpV             - a bump function s.t. v(x-1)^2+v(x)^2+v(x+1)^2=1 for abs(x)<1
%   Meyer             - Meyer Wavelet of second order
%   nv                - a function s.t. nv(x)+nv(1-x) = 1 for |x|<=1;
%   ParaScale         - return numbers of tiles for scale based on dilation beta
%   WindowOnPPGrid    - W operator, subband windowing on PPGRID with 2D iFFT

