%% WINDOWING
% Subband windowing on PPGrid using Meyer functions and Bump functions
%
%% Files
% * <Windowing/AdjWindowOnPPGrid_help.html   AdjWindowOnPPGrid> - adjoint of W operator, adjoint subband windowing  with 2D FFT
% * <Windowing/bumpV_help.html bumpV>             - a bump function s.t. v(x-1)^2+v(x)^2+v(x+1)^2=1 for abs(x)<1
% * <Windowing/Meyer_help.html Meyer>             - Meyer Wavelet of second order
% * <Windowing/nv_help.html nv>              - a function s.t. nv(x)+nv(1-x) = 1 for abs(x)<=1;
% * <Windowing/ParaScale_help.html ParaScale>         - return numbers of tiles for scale based on dilation beta
% * <Windowing/WindowOnPPGrid_help.html WindowOnPPGrid>    - W operator, subband windowing on PPGRID with 2D iFFT

